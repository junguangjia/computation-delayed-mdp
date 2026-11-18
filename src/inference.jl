# Posterior inference interfaces: Blocked Gibbs / MCMC and Full-Covariance SVI

"""
    AbstractPosteriorApproximation

Supertype for fitted posterior representations of `MaskedHeteroscedasticModel`.
"""
abstract type AbstractPosteriorApproximation end

"""
    GibbsPosteriorSamples{T<:Real} <: AbstractPosteriorApproximation

MCMC / blocked Gibbs posterior draws for `(beta, gamma, R, Omega, {delta_i})`.
"""
struct GibbsPosteriorSamples{T<:Real} <: AbstractPosteriorApproximation
    beta_draws::Matrix{T}
    gamma_draws::Matrix{T}
    lengthscale_draws::Vector{T}
    omega_draws::Array{T,3}
end

"""
    FullCovarianceSVIPosterior{T<:Real} <: AbstractPosteriorApproximation

Structured variational posterior `q(beta, gamma, R, Omega) prod_i q(delta_{i, M_i})`
retaining dense `|M_i| x |M_i|` local covariance matrices so coordinate-wise mean-field
does not sever cross-action or cross-age correlations.
"""
struct FullCovarianceSVIPosterior{T<:Real} <: AbstractPosteriorApproximation
    beta_mean::Vector{T}
    beta_cov::Symmetric{T,Matrix{T}}
    gamma_mean::Vector{T}
    gamma_cov::Symmetric{T,Matrix{T}}
    local_means::Vector{Vector{T}}
    local_covs::Vector{Symmetric{T,Matrix{T}}}
    elbo_trace::Vector{T}
end

"""
    GibbsConfig

Configuration parameters for blocked MCMC / Gibbs sampling.
"""
Base.@kwdef struct GibbsConfig
    num_samples::Int = 2000
    num_warmup::Int = 1000
    thin::Int = 1
    seed::Int = 20261117
end

"""
    SVIConfig

Configuration parameters for full-covariance structured variational inference.
"""
Base.@kwdef struct SVIConfig
    max_iters::Int = 500
    rel_tol::Float64 = 1e-6
    learning_rate::Float64 = 1e-2
    seed::Int = 20261117
end

"""
    fit_gibbs(model::MaskedHeteroscedasticModel, states::AbstractVector{<:PairedRolloutState}, config::GibbsConfig)

Run blocked MCMC / Gibbs sampling over masked paired rollout observations.
"""
function fit_gibbs(::MaskedHeteroscedasticModel, ::AbstractVector{<:PairedRolloutState}, ::GibbsConfig=GibbsConfig())
    error("Not implemented yet: fit_gibbs")
end

"""
    fit_svi(model::MaskedHeteroscedasticModel, states::AbstractVector{<:PairedRolloutState}, config::SVIConfig)

Fit full-covariance structured variational inference maximizing the masked ELBO.
"""
function fit_svi(::MaskedHeteroscedasticModel, ::AbstractVector{<:PairedRolloutState}, ::SVIConfig=SVIConfig())
    error("Not implemented yet: fit_svi")
end

"""
    elbo(model::MaskedHeteroscedasticModel, posterior::FullCovarianceSVIPosterior, states::AbstractVector{<:PairedRolloutState})

Evaluate the Evidence Lower Bound (ELBO) on `states`.
"""
function elbo(::MaskedHeteroscedasticModel, ::FullCovarianceSVIPosterior, ::AbstractVector{<:PairedRolloutState})
    error("Not implemented yet: elbo")
end

"""
    posterior_predictive_checks(posterior::AbstractPosteriorApproximation, heldout_states::AbstractVector{<:PairedRolloutState})

Compute held-out log predictive density, empirical interval coverage, and
residuals stratified by congestion, information age, and legality mask structure.
"""
function posterior_predictive_checks(::AbstractPosteriorApproximation, ::AbstractVector{<:PairedRolloutState})
    error("Not implemented yet: posterior_predictive_checks")
end
