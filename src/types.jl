# Core domain types for computation-delayed and information-age MDPs

"""
    AbstractTimingRegime

Supertype for deliberation timing protocols in evolving MDPs.
"""
abstract type AbstractTimingRegime end

"""
    PrecomputedTiming{T<:Real} <: AbstractTimingRegime

Concurrent precomputation regime: deliberation for epoch `t0` starts at `t0 - lead_age`
from state `S_{t0 - lead_age}` while the previous interval executes, and applies the
selected legal action at `t0`.
"""
struct PrecomputedTiming{T<:Real} <: AbstractTimingRegime
    lead_age::T
    epoch_step::T
    horizon::T
end

"""
    PostEpochDelayTiming{T<:Real} <: AbstractTimingRegime

Off-grid post-epoch deliberation regime: fallback policy `pi_0` acts at `t0` and
governs `[t0, t0 + delay)`, after which the candidate action is requested through
signal-legality constraints.
"""
struct PostEpochDelayTiming{T<:Real} <: AbstractTimingRegime
    delay::T
    horizon::T
end

"""
    DelayedActionPair{A,T<:Real}

Single coordinate `j = (a_j, ell_j)` pairing candidate action `action` with
information age or actuation delay `age_or_delay`.
"""
struct DelayedActionPair{A,T<:Real}
    action::A
    age_or_delay::T
end

"""
    CoordinateGrid{A,T<:Real}

Ordered grid of `K` candidate action--age pairs evaluated at each saved state.
"""
struct CoordinateGrid{A,T<:Real}
    pairs::Vector{DelayedActionPair{A,T}}
end

Base.length(g::CoordinateGrid) = length(g.pairs)

"""
    StructuralMask

Ex-ante deterministic mask `M_i subseteq {1, ..., K}` identifying active coordinates
where candidate policy `pi_{a_j, ell_j}` is not structurally identical to `pi_0`.
"""
struct StructuralMask
    active_indices::Vector{Int}
    total_dim::Int

    function StructuralMask(active_indices::Vector{Int}, total_dim::Int)
        total_dim >= 1 || throw(ArgumentError("total_dim must be >= 1"))
        issorted(active_indices) || throw(ArgumentError("active_indices must be sorted ascending"))
        all(1 <= idx <= total_dim for idx in active_indices) ||
            throw(ArgumentError("active_indices out of bounds 1:$total_dim"))
        length(unique(active_indices)) == length(active_indices) ||
            throw(ArgumentError("active_indices must be unique"))
        return new(active_indices, total_dim)
    end
end

"""
    mask_projection(mask::StructuralMask, ::Type{T}=Float64) -> Matrix{T}

Construct the row-selection matrix `P_i in {0, 1}^{|M_i| x K}` extracting active
coordinates from a full `K`-dimensional discrepancy vector.
"""
function mask_projection(mask::StructuralMask, ::Type{T}=Float64) where {T<:Real}
    m = length(mask.active_indices)
    P = zeros(T, m, mask.total_dim)
    for (row, col) in enumerate(mask.active_indices)
        P[row, col] = one(T)
    end
    return P
end

"""
    PairedRolloutState{T<:Real}

Paired multi-fidelity evaluation record for a single saved traffic state `i`
with `R_i >= 2` common-random-number scenario repetitions across `K` grid points.

Fields:
- `state_id`: unique state identifier.
- `date`: calendar date (used to enforce strict date-level data splits).
- `mean_features`: `K x p` regression design matrix `X_i`.
- `scale_features`: `K x q` log-scale heteroscedastic design matrix `Z_i`.
- `low_fidelity_gaps`: length-`K` fast surrogate cost gaps `g^L_i`.
- `double_differences`: `R_i x K` matrix of paired outcomes `y_{irj}`.
- `mask`: ex-ante `StructuralMask` identifying non-zero coordinates `M_i`.
- `runtimes`: measured wall-clock batch runtimes (seconds).
"""
struct PairedRolloutState{T<:Real}
    state_id::String
    date::Date
    mean_features::Matrix{T}
    scale_features::Matrix{T}
    low_fidelity_gaps::Vector{T}
    double_differences::Matrix{T}
    mask::StructuralMask
    runtimes::Vector{T}
end

"""
    DateSplitManifest

Pinned date-level partition preventing temporal or within-day state leakage across
training, validation, development-gate, and locked final-test splits.
"""
struct DateSplitManifest
    train_dates::Vector{Date}
    val_dates::Vector{Date}
    dev_dates::Vector{Date}
    test_dates::Vector{Date}
end

"""
    validate_splits(manifest::DateSplitManifest) -> Bool

Verify that all four date splits are pairwise disjoint.
"""
function validate_splits(manifest::DateSplitManifest)::Bool
    sets = (
        Set(manifest.train_dates),
        Set(manifest.val_dates),
        Set(manifest.dev_dates),
        Set(manifest.test_dates),
    )
    for u in 1:length(sets), v in (u + 1):length(sets)
        isempty(intersect(sets[u], sets[v])) || return false
    end
    return true
end
