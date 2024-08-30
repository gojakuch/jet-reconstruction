const large_distance = 16.0 # = 4^2
const large_dij = 1.0e6

@inline function angular_distance(jet1::EEjet, jet2::EEjet)
    # Calculate the angular distance between two jets (1 - cos(θ))
    @muladd 1.0 - nx(jet1) * nx(jet2) - ny(jet1) * ny(jet2) - nz(jet1) * nz(jet2)
end

"""Calculate the dij distance, *given that NN is set correctly*"""
@inline function dij_dist(nndist, jet1::EEjet, jet2::EEjet)
    # Calculate the dij distance between two jets
    nndist * min(energy(jet1)^2, energy(jet2)^2)
end

function get_angular_nearest_neighbours!(cs::ClusterSequence,
                                         clusterseq_index::Vector{Int},
                                         nndist::Vector{Float64},
                                         nndij::Vector{Float64}, nni::Vector{Int})
    jets = cs.jets
    # Get the nearest neighbour for each jet
    @inbounds for i in eachindex(jets)
        @inbounds for j in (i + 1):length(jets)
            this_nndist = angular_distance(jets[clusterseq_index[i]],
                                           jets[clusterseq_index[j]])
            if this_nndist < nndist[i]
                nndist[i] = this_nndist
                nni[i] = j
            end
            if this_nndist < nndist[j]
                nndist[j] = this_nndist
                nni[j] = i
            end
        end
    end
    @inbounds for i in eachindex(jets)
        nndij[i] = dij_dist(nndist[i], jets[clusterseq_index[i]],
                            jets[clusterseq_index[nni[i]]])
    end
end

function update_nn_no_cross!(i, N, cs::ClusterSequence, clusterseq_index, nndist, nndij,
                             nni)
    # Update the nearest neighbour for jet i, w.r.t. all other active jets
    nndist[i] = large_distance
    nni[i] = i
    jets = cs.jets
    @inbounds for j in 1:N
        if j != i
            this_nndist = angular_distance(jets[clusterseq_index[i]],
                                           jets[clusterseq_index[j]])
            if this_nndist < nndist[i]
                nndist[i] = this_nndist
                nni[i] = j
            end
        end
    end
    nndij[i] = dij_dist(nndist[i], jets[clusterseq_index[i]],
                        jets[clusterseq_index[nni[i]]])
end

function update_nn_cross!(i, N, cs::ClusterSequence, clusterseq_index, nndist, nndij, nni)
    # Update the nearest neighbour for jet i, w.r.t. all other active jets
    # also doing the cross check for the other jet
    nndist[i] = large_distance
    nni[i] = i
    jets = cs.jets
    @inbounds for j in 1:N
        if j != i
            this_nndist = angular_distance(jets[clusterseq_index[i]],
                                           jets[clusterseq_index[j]])
            if this_nndist < nndist[i]
                nndist[i] = this_nndist
                nni[i] = j
            end
            if this_nndist < nndist[j]
                nndist[j] = this_nndist
                nni[j] = i
                # j will not be revisited, so update metric distance here
                nndij[j] = dij_dist(nndist[j], jets[clusterseq_index[j]],
                                    jets[clusterseq_index[i]])
            end
        end
    end
    nndij[i] = dij_dist(nndist[i], jets[clusterseq_index[i]],
                        jets[clusterseq_index[nni[i]]])
end

function ee_check_consistency(clusterseq, clusterseq_index, N, nndist, nndij, nni, msg)
    # Check the consistency of the reconstruction state
    for i in 1:N
        if nni[i] > N
            @error "Jet $i has invalid nearest neighbour $(nni[i])"
        end
        for i in 1:N
            jet = clusterseq.jets[clusterseq_index[i]]
            jet_hist = clusterseq.history[jet._cluster_hist_index]
            if jet_hist.child != Invalid
                @error "Jet $i has invalid child $(jet_hist.child)"
            end
        end
    end
    @debug "Consistency check passed at $msg"
end

function ee_genkt_algorithm(particles::Vector{T}; p::Union{Real, Nothing} = -1, R = 4.0,
                            algorithm::Union{JetAlgorithm.Algorithm, Nothing} = nothing,
                            recombine = +) where {T}

    # Check for consistency between algorithm and power
    (p, algorithm) = get_algorithm_power_consistency(p = p, algorithm = algorithm)

    # Integer p if possible
    p = (round(p) == p) ? Int(p) : p

    # For the Durham algorithm, p=1 and R is not used, but nominally set to 4
    if algorithm == JetAlgorithm.Durham
        R = 4.0
    end

    if T == EEjet
        # recombination_particles will become part of the cluster sequence, so size it for
        # the starting particles and all N recombinations
        recombination_particles = copy(particles)
        sizehint!(recombination_particles, length(particles) * 2)
    else
        recombination_particles = EEjet[]
        sizehint!(recombination_particles, length(particles) * 2)
        for i in eachindex(particles)
            push!(recombination_particles,
                  EEjet(px(particles[i]), py(particles[i]), pz(particles[i]),
                        energy(particles[i])))
        end
    end

    # Now call the actual reconstruction method, tuned for our internal EDM
    _ee_genkt_algorithm(particles = recombination_particles; p = 1, R = 4.0,
                        algorithm = algorithm,
                        recombine = recombine)
end

function _ee_genkt_algorithm(; particles::Vector{EEjet}, p = 1, R = 4.0,
                             algorithm::JetAlgorithm.Algorithm = JetAlgorithm.Durham,
                             recombine = +)
    # Bounds
    N::Int = length(particles)

    # R squared
    R2 = R^2

    # Constant factor for the dij metric and the beam distance function
    if algorithm == JetAlgorithm.Durham
        dij_factor = 2.0
    elseif algorithm == JetAlgorithm.EEKt
        if R < π
            dij_factor = 1 / (1 - cos(R))
        else
            dij_factor = 3 + cos(R)
        end
    else
        throw(ArgumentError("Algorithm $algorithm not supported for e+e-"))
    end
    # # We add a reverse normalisation factor for the beam distance to ensure that
    # # the comparison with dij is correct
    # beam_distance_alg(algorithm, jet::EEjet) = algorithm == JetAlgorithm.Durham ?
    #                                            large_distance : jet.E^2p / dij_factor
    # beam_distance(jet::EEjet) = beam_distance_alg(algorithm, jet)

    # Optimised compact arrays for determining the next merge step We make sure
    # these arrays are type stable - have seen issues where, depending on the
    # values returned by the methods, they can become unstable and performance
    # degrades
    nndist::Vector{Float64} = Vector{Float64}(undef, N) # distances 
    fill!(nndist, large_distance)
    nndij::Vector{Float64} = Vector{Float64}(undef, N)  # dij metric distance
    nni::Vector{Int} = collect(1:N) # Nearest neighbour index

    # Maps index from the compact array to the clusterseq jet vector
    clusterseq_index::Vector{Int} = collect(1:N)

    # Setup the initial history and get the total energy
    history, Qtot = initial_history(particles)

    clusterseq = ClusterSequence(algorithm, p, R, RecoStrategy.N2Plain, particles, history,
                                 Qtot)

    # Run over initial pairs of jets to find nearest neighbours
    get_angular_nearest_neighbours!(clusterseq, clusterseq_index, nndist, nndij, nni)

    # ee_check_consistency(clusterseq, clusterseq_index, N, nndist, nndij, nni, "Start")

    # Now we can start the main loop
    iter = 0
    while N != 0
        iter += 1
        dij_min, ijetA = fast_findmin(nndij, N)
        ijetB = nni[ijetA]
        if ijetB < ijetA
            ijetA, ijetB = ijetB, ijetA
        end
        # Normalise the dij_min
        dij_min *= dij_factor

        if ijetA != ijetB

            # Source "history" for merge
            hist_jetA = clusterseq.jets[clusterseq_index[ijetA]]._cluster_hist_index
            hist_jetB = clusterseq.jets[clusterseq_index[ijetB]]._cluster_hist_index

            # Recombine jetA and jetB into the next jet
            merged_jet = recombine(clusterseq.jets[clusterseq_index[ijetA]],
                                   clusterseq.jets[clusterseq_index[ijetB]])
            merged_jet._cluster_hist_index = length(clusterseq.history) + 1

            # Now add the jet to the sequence, and update the history
            push!(clusterseq.jets, merged_jet)
            add_step_to_history!(clusterseq, minmax(hist_jetA, hist_jetB)...,
                                 merged_jet._cluster_hist_index,
                                 dij_min)

            # Update the compact arrays, reusing the JetA slot
            nndist[ijetA] = large_distance
            nndij[ijetA] = large_dij
            nni[ijetA] = ijetA
            clusterseq_index[ijetA] = merged_jet._cluster_hist_index
        else
            add_step_to_history!(clusterseq,
                                 clusterseq.jets[clusterseq_index[ijetA]]._cluster_hist_index,
                                 BeamJet, Invalid, dij_min)
        end

        # Squash step - copy the final jet's compact data into the jetB slot
        if ijetB != N
            nndist[ijetB] = nndist[N]
            nndij[ijetB] = nndij[N]
            nni[ijetB] = nni[N]
            clusterseq_index[ijetB] = clusterseq_index[N]
        end

        # Now number of active jets is decreased by one
        N -= 1

        # Update nearest neighbours step
        for i in 1:N
            # First, if any jet's NN was the old index N, it's now ijetB
            if (ijetB != N + 1) && (nni[i] == N + 1)
                nni[i] = ijetB
            else
                # Otherwise, if the jet had ijetA or ijetB as their NN, we need to update them
                if (nni[i] == ijetA) || (nni[i] == ijetB)
                    update_nn_no_cross!(i, N, clusterseq, clusterseq_index, nndist,
                                        nndij, nni)
                end
            end
        end

        # Finally, we need to update the nearest neighbours for the new jet, checking both ways
        update_nn_cross!(ijetA, N, clusterseq, clusterseq_index, nndist, nndij, nni)

        # ee_check_consistency(clusterseq, clusterseq_index, N, nndist, nndij, nni,
        #                      "iteration $iter")
    end

    # Return the final cluster sequence structure
    clusterseq
end
