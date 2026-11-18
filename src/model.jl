# Masked heteroscedastic hierarchical Gaussian discrepancy model & predictive beliefs

"""
    SeparatedDiscrepancyPriors{T<:Real}

Prior specification separating regression weights, log-scale coefficients, and
correlation structure so priors do not shrink correlations toward zero (`P_fact`)
as isotropic inverse-Wishart priors do.
"""
struct SeparatedDiscrepancyPriors{T<:Real}
    beta_mean::Vector{T}
    beta_cov::Symmetric{T,Matrix{T}}
    gamma_mean::Vector{T}
    gamma_cov::Symmetric{T,Matrix{T}}
    action_corr_eta::T
    lengthscale_logmean::T
    lengthscale_logstd::T
    omega_df::T
    omega_scale::Symmetric{T,Matrix{T}}
end

"""
    MaskedHeteroscedasticModel{T<:Real,C<:AbstractDiscrepancyCovariance}

Hierarchical Bayesian double-difference model on active coordinates `M_i`:
`delta_i | beta, Sigma(x_i) ~ N(X_i * beta, Sigma(x_i))`,
`y_{ir, M_i} | delta_i, Omega ~ N(P_i * delta_i, P_i * Omega * P_i')`.
"""
struct MaskedHeteroscedasticModel{T<:Real,C<:AbstractDiscrepancyCovariance}
    grid::CoordinateGrid
    priors::SeparatedDiscrepancyPriors{T}
    covariance_template::C
end

"""
    PredictiveDiscrepancyBelief{T<:Real}

Gaussian pre-query belief at a test state `x_*` over discrepancy vector `delta_*`
together with paired single-replicate simulation noise covariance `Omega_*`.
"""
struct PredictiveDiscrepancyBelief{T<:Real}
    mean::Vector{T}
    cov::Symmetric{T,Matrix{T}}
    noise_cov::Symmetric{T,Matrix{T}}
    is_factorized::Bool
end

"""
    marginal_matched_belief(
        belief::PredictiveDiscrepancyBelief{T};
        retain_shared_baseline_noise::Bool=true,
    ) -> PredictiveDiscrepancyBelief{T}

Construct the marginal-matched factorized counterpart `P_fact` with identical
pre-query marginal means and variances `diag(Sigma_*)`. By default, `retain_shared_baseline_noise=true`
preserves the paired baseline noise covariance `Omega_*` induced by common `pi_0` differencing.
"""
function marginal_matched_belief(
    belief::PredictiveDiscrepancyBelief{T};
    retain_shared_baseline_noise::Bool=true,
) where {T<:Real}
    diag_cov = Symmetric(Matrix(Diagonal(diag(belief.cov))))
    noise = retain_shared_baseline_noise ? belief.noise_cov : Symmetric(Matrix(Diagonal(diag(belief.noise_cov))))
    return PredictiveDiscrepancyBelief{T}(copy(belief.mean), diag_cov, noise, true)
end

"""
    posterior_predictive_belief(posterior, state::PairedRolloutState) -> PredictiveDiscrepancyBelief

Induce the predictive discrepancy distribution at a held-out state `x_*`.
"""
function posterior_predictive_belief(::Any, ::PairedRolloutState)
    error("Not implemented yet: posterior_predictive_belief")
end
