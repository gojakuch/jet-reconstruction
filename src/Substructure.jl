"""
    has_parents(p, clusterseq) -> (boolean, Int64, Int64)

Checks if the jet `p` is a child of two other jets, after clustering 

# Arguments
- `p`: The jet to check.
- `clusterseq`: The cluster sequence object.

# Returns
- (boolean, Int64, Int64): true or false depending on if the jet has a parent or not. If the jet has a parent, returns the indices of the parent jets in the history element. Otherwise, returns -2 (NonexistentParent).
"""
function has_parents(p::PseudoJet, clusterseq::ClusterSequence)
    history = clusterseq.history
    N = p._cluster_hist_index
    p1 = history[N].parent1
    p2 = history[N].parent2

    p1 == p2 == NonexistentParent ? result = false : result = true
    return (result, p1, p2)
end

"""
    deltaR(jet1, jet2) -> Float64

Function to calculate the distance in the y-ϕ plane between two jets `jet1` and `jet2`

# Arguments
- `jet1`: The first jet.
- `jet2`: The second jet.

# Returns
- Float64: The Euclidean distance in the y-ϕ plane for the two jets.
"""
function deltaR(jet1::PseudoJet, jet2::PseudoJet)
    y1, phi1 = rapidity(jet1), phi(jet1)
    y2, phi2 = rapidity(jet2), phi(jet2)

    d_y = y1 - y2
    d_phi = phi1 - phi2
    d_phi = abs(d_phi) > π ? 2π - abs(d_phi) : d_phi

    return sqrt(d_y^2 + d_phi^2)
end

# Function to calculate kt distance between two pseudojets
function kt_distance(jet1::PseudoJet, jet2::PseudoJet)
    p1 = pt2(jet1)
    p2 = pt2(jet2)

    d_R = deltaR(jet1, jet2)
    return min(p1, p2) * d_R^2
end

"""
    recluster(jet, clusterseq, rad, mtd) -> ClusterSequence

Reclusters the constituents of a given jet `jet` with a different clustering method `mtd` and different jet radius `rad`.

# Arguments
- `jet`: The jet whose constituents are to be reclustered.
- `clusterseq`: The cluster sequence from which the original jet is obtained.
- `rad`: The new jet radius.
- `mtd`: The new clustering method.

# Returns
- ClusterSequence: The new cluster sequence.
"""
function recluster(jet::PseudoJet, clusterseq::ClusterSequence; R = 1.0,
                   algorithm = JetAlgorithm.CA)
    cons = constituents(jet, clusterseq)
    new_clusterseq = jet_reconstruct(cons; p = nothing, R = R, algorithm = algorithm,
                                     strategy = RecoStrategy.Best)

    return new_clusterseq
end

function sort_jets!(event_jet_array)
    jet_pt(jet) = pt2(jet)
    sort!(event_jet_array, by = jet_pt, rev = true)
end

# Defining suitable structures to be used for jet grooming and tagging
"""
    struct MassDropTagger

Used for tagging jets that undergo mass drop, a common technique in jet substructure.

Fields:
- mu: Maximum allowed mass ratio for a jet to pass tagging
- y: Minimum kT distance threshold for parent separation
"""

struct MassDropTagger
    mu::Float64
    y::Float64
end

"""
    struct SoftDropTagger

Applies a soft-drop condition on jets, trimming away soft, wide-angle radiation.

Fields:
- zcut: Minimum allowed energy fraction for subjets
- b: Angular exponent controlling soft radiation suppression
- cluster_rad: The new radius that will be used to recluster the components of the jet
"""
struct SoftDropTagger
    zcut::Float64
    b::Float64
    cluster_rad::Float64
end

SoftDropTagger(z::Float64, b::Float64) = SoftDropTagger(z, b, 1.0)

"""
    struct JetFilter

Filters jets based on radius and number of hardest subjets, reducing contamination.

Fields:
- filter_radius: Radius parameter to recluster subjets
- num_hardest_jets: Number of hardest jets to retain in the filtered result
"""

struct JetFilter
    filter_radius::Float64
    num_hardest_jets::Int
end

"""
    struct JetTrim

Trims soft, large-angle components from jets based on fraction and radius.

Fields:
- trim_radius: Radius used for reclustering in trimming
- trim_fraction: Minimum momentum fraction for retained subjets
- recluster_method: Method identifier for reclustering
"""

struct JetTrim
    trim_radius::Float64
    trim_fraction::Float64
    recluster_method::JetAlgorithm.Algorithm
end

"""
    mass_drop(jet, clusterseq, tag) -> PseudoJet

Identifies subjets in a jet that pass the mass drop tagging condition.
The method stops at the first jet satisfying the mass and distance thresholds.

Arguments:
- jet: PseudoJet instance representing the jet to tag
- clusterseq: ClusterSequence with jet clustering history
- tag: MassDropTagger instance providing mass drop parameters

Returns:
- PseudoJet: The jet (or subjet) satisfying the mass drop conditions, if tagging is successful, otherwise a zero-momentum PseudoJet
"""

function mass_drop(jet::PseudoJet, clusterseq::ClusterSequence, tag::MassDropTagger)
    all_jets = clusterseq.jets
    hist = clusterseq.history

    while true
        had_parents, p1, p2 = has_parents(jet, clusterseq)

        if had_parents
            parent1 = all_jets[hist[p1].jetp_index]
            parent2 = all_jets[hist[p2].jetp_index]

            if m2(parent1) < m2(parent2)
                p1, p2 = p2, p1
                parent1, parent2 = parent2, parent1
            end

            if m2(parent1) < m2(jet) * tag.mu^2 &&
               kt_distance(parent1, parent2) > tag.y * m2(jet)
                return jet
            else
                jet = parent1
            end

        else
            return PseudoJet(0.0, 0.0, 0.0, 0.0)
        end
    end
end

"""
    soft_drop(jet, clusterseq, tag) -> PseudoJet

Applies soft-drop grooming to remove soft, wide-angle radiation from jets.
This function reclusters the jet and iteratively checks the soft-drop condition on subjets.

Arguments:
- jet: PseudoJet instance to groom
- clusterseq: ClusterSequence containing jet history
- tag: SoftDropTagger instance with soft-drop parameters

Returns:
- PseudoJet: Groomed jet or zero-momentum PseudoJet if grooming fails
"""

function soft_drop(jet::PseudoJet, clusterseq::ClusterSequence,
                   tag::SoftDropTagger)
    rad = tag.cluster_rad
    new_clusterseq = recluster(jet, clusterseq; R = rad, algorithm = JetAlgorithm.CA)
    new_jet = sort_jets!(inclusive_jets(new_clusterseq; T = PseudoJet))[1]

    all_jets = new_clusterseq.jets
    hist = new_clusterseq.history

    while true
        had_parents, p1, p2 = has_parents(new_jet, new_clusterseq)

        if had_parents
            parent1 = all_jets[hist[p1].jetp_index]
            parent2 = all_jets[hist[p2].jetp_index]

            if m2(parent1) < m2(parent2)
                p1, p2 = p2, p1
                parent1, parent2 = parent2, parent1
            end

            pti = pt2(parent1)^0.5
            ptj = pt2(parent2)^0.5

            if min(pti, ptj) / (pti + ptj) >
               tag.zcut * (deltaR(parent1, parent2) / rad)^tag.b
                return new_jet
            else
                new_jet = parent1
            end

        else
            return PseudoJet(0.0, 0.0, 0.0, 0.0)
        end
    end
end

"""
    jet_filtering(jet, clusterseq, filter) -> PseudoJet

Filters a jet to retain only the hardest subjets based on a specified radius and number.

Arguments:
- jet: PseudoJet instance representing the jet to filter
- clusterseq: ClusterSequence containing jet history
- filter: Filter instance specifying radius and number of subjets

Returns:
- PseudoJet: Filtered jet composed of the hardest subjets

"""
function jet_filtering(jet::PseudoJet, clusterseq::ClusterSequence, filter::JetFilter)
    rad = filter.filter_radius
    new_clusterseq = recluster(jet, clusterseq; R = rad, algorithm = JetAlgorithm.CA)
    reclustered = sort_jets!(inclusive_jets(new_clusterseq; T = PseudoJet))

    n = length(reclustered) <= filter.num_hardest_jets ? length(reclustered) :
        filter.num_hardest_jets
    hard = reclustered[1:n]

    filtered = foldl(+, hard)

    filtered
end

"""
    jet_trimming(jet, clusterseq, trim) -> PseudoJet

Trims a jet by removing subjets with transverse momentum below a specified fraction.

Arguments:
- jet: PseudoJet instance representing the jet to trim
- clusterseq: ClusterSequence containing jet history
- trim: Trim instance specifying trimming parameters

Returns:
- PseudoJet: Trimmed jet composed of retained subjets
"""

function jet_trimming(jet::PseudoJet, clusterseq::ClusterSequence, trim::JetTrim)
    rad = trim.trim_radius
    alg = trim.recluster_method
    frac2 = trim.trim_fraction^2

    new_clusterseq = recluster(jet, clusterseq; R = rad, algorithm = alg)
    reclustered = sort_jets!(inclusive_jets(new_clusterseq; T = PseudoJet))

    hard = Vector{PseudoJet}(undef, 0)
    for item in reclustered
        if pt2(item) >= frac2 * pt2(jet)
            push!(hard, item)
        end
    end
    trimmed = length(hard) != 0 ? foldl(+, hard) : PseudoJet(0.0, 0.0, 0.0, 0.0)

    trimmed
end
