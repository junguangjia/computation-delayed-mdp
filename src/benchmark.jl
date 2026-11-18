# Empirical traffic benchmark, Tier-1 zero-discrepancy audit, and pre-registered gate interfaces

"""
    AbstractControlPolicy

Supertype for closed-loop signal controllers compared in Tier 3.
"""
abstract type AbstractControlPolicy end

"""Act immediately on fast surrogate `L` (`greedy5` baseline)."""
struct ActNowSurrogatePolicy <: AbstractControlPolicy end

"""Re-evaluate fast surrogate `L` on fresh state at actuation (`refresh-L` baseline)."""
struct RefreshSurrogatePolicy <: AbstractControlPolicy end

"""Always run precomputed high-fidelity verification batch (`T >= 60 s`)."""
struct AlwaysVerifyPolicy <: AbstractControlPolicy
    batch_size::Int
    horizon_seconds::Float64
    lead_age_seconds::Float64
end

"""Gate verification via `VoC(x_*; P) > 0` under joint or tuned-scale factorized belief."""
struct VoCGatedPolicy{P<:AbstractPosteriorApproximation} <: AbstractControlPolicy
    posterior::P
    use_factorized_belief::Bool
    batch_size::Int
    horizon_seconds::Float64
    lead_age_seconds::Float64
end

"""Trigger verification when fast-model top-2 score margin falls below `threshold` (matched compute rate)."""
struct ActionMarginPolicy <: AbstractControlPolicy
    threshold::Float64
    batch_size::Int
    horizon_seconds::Float64
    lead_age_seconds::Float64
end

"""
    GateCriteria

Pre-registered development-window pass criteria for the information-age gate
across `L in {1.6, 5.0, 10.0, 15.0}` seconds.
"""
Base.@kwdef struct GateCriteria
    min_verify_rate::Float64 = 0.20
    max_verify_rate::Float64 = 0.80
    min_oracle_gain_veh_s::Float64 = 1.50
    min_joint_vs_fact_divergence::Float64 = 0.10
end

"""
    GateEvaluationResult

Outcome of evaluating the pre-registered information-age gate at lead age `L`.
"""
struct GateEvaluationResult
    lead_age_seconds::Float64
    verify_rate::Float64
    oracle_gain_over_constant_veh_s::Float64
    joint_vs_fact_divergence::Float64
    passes_interior_stopping::Bool
    passes_covariance_contrast::Bool
end

"""
    ClosedLoopEpisodeSummary

Telemetry summary for a single charged closed-loop evaluation episode over physical horizon `T`.
"""
struct ClosedLoopEpisodeSummary
    date::Date
    offset_seconds::Int
    seed::Int
    policy_name::String
    total_time_spent_veh_s::Float64
    median_batch_wall_s::Float64
    max_batch_wall_s::Float64
    missed_deadlines::Int
    safety_events::Int
end

"""
    run_zero_discrepancy_audit(states::AbstractVector{<:PairedRolloutState})

Execute Tier-1 same-simulator control (`E[y_{irj}] = 0`) checking empirical bias,
interval coverage, and separation of paired noise `Omega` from structural `Sigma`.
"""
function run_zero_discrepancy_audit(::AbstractVector{<:PairedRolloutState})
    error("Not implemented yet: run_zero_discrepancy_audit")
end

"""
    evaluate_information_age_gate(dev_states::AbstractVector{<:PairedRolloutState}, lead_ages::AbstractVector{<:Real}, criteria::GateCriteria=GateCriteria()) -> Vector{GateEvaluationResult}

Evaluate pre-registered Gate Criteria 1 & 2 on development windows before locking
Tier-3 closed-loop claims.
"""
function evaluate_information_age_gate(
    ::AbstractVector{<:PairedRolloutState},
    ::AbstractVector{<:Real},
    ::GateCriteria=GateCriteria(),
)
    error("Not implemented yet: evaluate_information_age_gate")
end

"""
    evaluate_closed_loop_benchmark(policies::AbstractVector{<:AbstractControlPolicy}, test_dates::AbstractVector{Date}) -> Vector{ClosedLoopEpisodeSummary}

Run charged closed-loop traffic benchmark across the 72 held-out test dates and
compute paired day-level confidence intervals.
"""
function evaluate_closed_loop_benchmark(::AbstractVector{<:AbstractControlPolicy}, ::AbstractVector{Date})
    error("Not implemented yet: evaluate_closed_loop_benchmark")
end
