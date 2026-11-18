# Structured cross-age / cross-delay and heteroscedastic covariance interfaces

"""
    AbstractDelayKernel

Supertype for temporal correlation kernels across information ages or actuation delays.
"""
abstract type AbstractDelayKernel end

"""
    OrnsteinUhlenbeckDelayKernel{T<:Real} <: AbstractDelayKernel

Continuous-time exponential decorrelation kernel `k(ell_u, ell_v) = exp(-|ell_u - ell_v| / lengthscale)`,
avoiding the upward correlation bias of naive linear interpolation across delay grids.
"""
struct OrnsteinUhlenbeckDelayKernel{T<:Real} <: AbstractDelayKernel
    lengthscale::T
    function OrnsteinUhlenbeckDelayKernel{T}(lengthscale::T) where {T<:Real}
        lengthscale > zero(T) || throw(ArgumentError("lengthscale must be > 0"))
        return new{T}(lengthscale)
    end
end
OrnsteinUhlenbeckDelayKernel(ℓ::T) where {T<:Real} = OrnsteinUhlenbeckDelayKernel{T}(ℓ)

"""
    DiscreteDelayCorrelation{T<:Real} <: AbstractDelayKernel

Explicit positive-definite correlation matrix over a finite discrete set of delay levels.
"""
struct DiscreteDelayCorrelation{T<:Real} <: AbstractDelayKernel
    levels::Vector{T}
    corr::Symmetric{T,Matrix{T}}
end

"""
    AbstractDiscrepancyCovariance

Supertype for structural discrepancy covariance specifications `Sigma(x_i)`.
"""
abstract type AbstractDiscrepancyCovariance end

"""
    HeteroscedasticKroneckerCovariance{T<:Real,K<:AbstractDelayKernel} <: AbstractDiscrepancyCovariance

State-dependent covariance `Sigma(x_i) = D(x_i) (R_A kron R_L) D(x_i)` with
`D(x_i) = diag(exp(Z_i * gamma))`, preventing asymptotic homoscedastic threshold collapse.
"""
struct HeteroscedasticKroneckerCovariance{T<:Real,K<:AbstractDelayKernel} <: AbstractDiscrepancyCovariance
    log_scale_weights::Vector{T}
    action_corr::Symmetric{T,Matrix{T}}
    delay_kernel::K
end

"""
    DiagonalFactorizedCovariance{T<:Real} <: AbstractDiscrepancyCovariance

Marginal-matched factorized baseline `Sigma_fact(x_i) = diag(exp(2 * Z_i * gamma))`
with optional per-pair tuned scale multipliers.
"""
struct DiagonalFactorizedCovariance{T<:Real} <: AbstractDiscrepancyCovariance
    log_scale_weights::Vector{T}
    scale_multipliers::Vector{T}
end

"""
    marginal_scales(cov::AbstractDiscrepancyCovariance, scale_features::AbstractMatrix)

Compute state-dependent marginal standard deviations `diag(D(x_i))` from `Z_i`.
"""
function marginal_scales(cov::HeteroscedasticKroneckerCovariance{T}, scale_features::AbstractMatrix{T}) where {T<:Real}
    return exp.(scale_features * cov.log_scale_weights)
end

function marginal_scales(cov::DiagonalFactorizedCovariance{T}, scale_features::AbstractMatrix{T}) where {T<:Real}
    return cov.scale_multipliers .* exp.(scale_features * cov.log_scale_weights)
end

"""
    correlation_matrix(cov::AbstractDiscrepancyCovariance, grid::CoordinateGrid)

Assemble the `K x K` structural correlation matrix `R` over `grid`.
"""
function correlation_matrix(::AbstractDiscrepancyCovariance, ::CoordinateGrid)
    error("Not implemented yet: correlation_matrix assembly over CoordinateGrid")
end

"""
    covariance_matrix(cov::AbstractDiscrepancyCovariance, scale_features::AbstractMatrix, grid::CoordinateGrid)

Assemble the full `K x K` state-conditional discrepancy covariance `Sigma(x_i)`.
"""
function covariance_matrix(::AbstractDiscrepancyCovariance, ::AbstractMatrix, ::CoordinateGrid)
    error("Not implemented yet: covariance_matrix assembly")
end
