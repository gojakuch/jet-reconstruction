# EnumX provides scoped enums, which are nicer
using EnumX


"""
    enum RecoStrategy

Scoped enumeration (using EnumX) representing the different strategies for jet reconstruction.

## Fields
- `Best`: The best strategy.
- `N2Plain`: The plain N2 strategy.
- `N2Tiled`: The tiled N2 strategy.
"""
@enumx T = Strategy RecoStrategy Best N2Plain N2Tiled
@enumx T = Strategy RecoStrategy Best N2Plain N2Tiled
const AllJetRecoStrategies = [String(Symbol(x)) for x in instances(RecoStrategy.Strategy)]


"""
    enum T

Scoped enumeration (using EnumX) representing different jet algorithms used in the JetReconstruction module.

## Fields
- `AntiKt`: The Anti-Kt algorithm.
- `Cambridge`: The Cambridge/Aachen algorithm.
- `Kt`: The Inclusive-Kt algorithm.
- `EEKt`: The Generalised e+e- kt algorithm.
- `Durham`: The e+e- kt algorithm, aka Durham.
"""
@enumx T = Algorithm JetAlgorithm AntiKt Cambridge Kt EEKt Durham
const AllJetRecoAlgorithms = [String(Symbol(x)) for x in instances(JetAlgorithm.Algorithm)]


"""
    power2algorithm

A dictionary that maps power values to corresponding jet algorithm used for pp jet reconstruction.
"""
const power2algorithm = Dict(-1 => JetAlgorithm.AntiKt,
    0 => JetAlgorithm.Cambridge,
    1 => JetAlgorithm.Kt)


"""
    Base.tryparse(E::Type{<:Enum}, str::String)

Parser that converts a string to an enum value if it exists, otherwise returns nothing.
"""
Base.tryparse(E::Type{<:Enum}, str::String) =
    let insts = instances(E),
        p = findfirst(==(Symbol(str)) ∘ Symbol, insts)

        p !== nothing ? insts[p] : nothing
    end
