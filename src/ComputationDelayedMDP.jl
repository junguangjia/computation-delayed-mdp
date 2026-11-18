"""
    ComputationDelayedMDP

Julia package defining domain abstractions, masked heteroscedastic discrepancy
models, inference interfaces, correlated Value-of-Computation (VoC) decision
rules, and benchmark protocols for Markov decision processes under information
age and computation delay.
"""
module ComputationDelayedMDP

using Dates
using LinearAlgebra
using Printf
using Random
using Statistics

include("types.jl")
include("covariance.jl")
include("model.jl")
include("inference.jl")
include("voc.jl")
include("benchmark.jl")

# Domain & data types
export AbstractTimingRegime, PrecomputedTiming, PostEpochDelayTiming
export DelayedActionPair, CoordinateGrid, StructuralMask, mask_projection
export PairedRolloutState, DateSplitManifest, validate_splits

# Covariance parameterizations
export AbstractDelayKernel, OrnsteinUhlenbeckDelayKernel, DiscreteDelayCorrelation
export AbstractDiscrepancyCovariance, HeteroscedasticKroneckerCovariance, DiagonalFactorizedCovariance
export marginal_scales, correlation_matrix, covariance_matrix

# Discrepancy model & predictive beliefs
export SeparatedDiscrepancyPriors, MaskedHeteroscedasticModel, PredictiveDiscrepancyBelief
export marginal_matched_belief, posterior_predictive_belief

# Posterior inference interfaces
export AbstractPosteriorApproximation, GibbsPosteriorSamples, FullCovarianceSVIPosterior
export GibbsConfig, SVIConfig
export fit_gibbs, fit_svi, elbo, posterior_predictive_checks

# Value-of-Computation & theoretical bounds
export VoCDecision, ExcessRiskComponents
export kalman_contrast_weights, posterior_contrast_std
export information_gain, evaluate_voc, evaluate_refresh_voc
export excess_risk_decomposition, filter_weight_perturbation_bound, queue_memory_ig_bound

# Benchmark & gate interfaces
export AbstractControlPolicy, ActNowSurrogatePolicy, RefreshSurrogatePolicy
export AlwaysVerifyPolicy, VoCGatedPolicy, ActionMarginPolicy
export GateCriteria, GateEvaluationResult, ClosedLoopEpisodeSummary
export run_zero_discrepancy_audit, evaluate_information_age_gate, evaluate_closed_loop_benchmark

end # module ComputationDelayedMDP
