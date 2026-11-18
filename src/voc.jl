# Correlated Knowledge-Gradient, Value of Computation, Refresh-L, and Regret Bounds

"""
    VoCDecision{T<:Real}

Output of a one-batch Value-of-Computation evaluation at a decision state `x_*`.
"""
struct VoCDecision{T<:Real}
    verify::Bool
    voc::T
    information_gain::T
    staleness_penalty::T
    immediate_action_idx::Int
end

"""
    ExcessRiskComponents{T<:Real}

Exact two-term excess-risk decomposition `R(P_hat; P_joint) = stopping_regret + selection_regret`
under the tie-safe rule `select a_1 iff Delta_hat < 0`.
"""
struct ExcessRiskComponents{T<:Real}
    stopping_regret::T
    selection_regret::T
end

total_regret(r::ExcessRiskComponents) = r.stopping_regret + r.selection_regret

"""
    kalman_contrast_weights(
        belief::PredictiveDiscrepancyBelief{T},
        query_indices::AbstractVector{Int},
        contrast::AbstractVector{T},
        batch_size::Int,
    ) -> Vector{T}

Compute linear filter weights `w(P) = (C_{Q,Q} + (1/B) * Omega_{Q,Q})^{-1} C_{Q,delta} c_ell`
mapping batch sample-mean discrepancies `y_bar_{*,Q}` to the posterior delayed cost contrast.
"""
function kalman_contrast_weights(
    belief::PredictiveDiscrepancyBelief{T},
    query_indices::AbstractVector{Int},
    contrast::AbstractVector{T},
    batch_size::Int,
) where {T<:Real}
    batch_size >= 1 || throw(ArgumentError("batch_size must be >= 1"))
    C = Matrix(belief.cov)
    R_B = Matrix(belief.noise_cov)[query_indices, query_indices] ./ T(batch_size)
    C_QQ = C[query_indices, query_indices]
    C_Qd = C[query_indices, :]
    return Symmetric(C_QQ + R_B) \ (C_Qd * contrast)
end

"""
    posterior_contrast_std(
        belief::PredictiveDiscrepancyBelief{T},
        query_indices::AbstractVector{Int},
        contrast::AbstractVector{T},
        batch_size::Int,
    ) -> T

Compute `sigma_post(P) = sqrt(c_ell' * C_{delta, Q}(P) * w(P))`, the predictive standard
deviation of the posterior-mean delayed contrast prior to observing the batch.
"""
function posterior_contrast_std(
    belief::PredictiveDiscrepancyBelief{T},
    query_indices::AbstractVector{Int},
    contrast::AbstractVector{T},
    batch_size::Int,
) where {T<:Real}
    isempty(query_indices) && return zero(T)
    w = kalman_contrast_weights(belief, query_indices, contrast, batch_size)
    C_dQ = Matrix(belief.cov)[:, query_indices]
    var_post = dot(contrast, C_dQ * w)
    return sqrt(max(var_post, zero(T)))
end

"""
    information_gain(belief::PredictiveDiscrepancyBelief, low_fidelity_gaps::AbstractVector, query_indices::AbstractVector{Int}, candidate_indices::AbstractVector{Int}, batch_size::Int)

Compute correlated Information Gain `IG(x_*; P)`. Dispatches `|A_0| == 2` to the exact
closed-form normal linear-loss formula `sigma_post * psi(|m_ell| / sigma_post)` and
`|A_0| >= 3` (e.g., `{a_1, a_2, pi_0}`) to Monte Carlo / Clark evaluation.
"""
function information_gain(
    ::PredictiveDiscrepancyBelief,
    ::AbstractVector,
    ::AbstractVector{Int},
    ::AbstractVector{Int},
    ::Int,
)
    error("Not implemented yet: information_gain (2-option exact psi & multi-option Clark/MC)")
end

"""
    evaluate_voc(belief::PredictiveDiscrepancyBelief, low_fidelity_gaps::AbstractVector, query_indices::AbstractVector{Int}, now_indices::AbstractVector{Int}, delayed_indices::AbstractVector{Int}, batch_size::Int) -> VoCDecision

Evaluate `VoC(x_*; P) = IG(x_*; P) - Delta_delay(x_*)`, triggering verification whenever
`VoC > 0` (including unconditionally when `Delta_delay <= 0` and `IG > 0`).
"""
function evaluate_voc(
    ::PredictiveDiscrepancyBelief,
    ::AbstractVector,
    ::AbstractVector{Int},
    ::AbstractVector{Int},
    ::AbstractVector{Int},
    ::Int,
)
    error("Not implemented yet: evaluate_voc")
end

"""
    evaluate_refresh_voc(belief::PredictiveDiscrepancyBelief, low_fidelity_gaps::AbstractVector, query_indices::AbstractVector{Int}, batch_size::Int) -> VoCDecision

Evaluate incremental batch Value of Computation when fast surrogate `L` is also
refreshed for free at actuation (`refresh-L`).
"""
function evaluate_refresh_voc(::PredictiveDiscrepancyBelief, ::AbstractVector, ::AbstractVector{Int}, ::Int)
    error("Not implemented yet: evaluate_refresh_voc")
end

"""
    excess_risk_decomposition(approx_belief::PredictiveDiscrepancyBelief, true_belief::PredictiveDiscrepancyBelief, low_fidelity_gaps::AbstractVector, query_indices::AbstractVector{Int}, batch_size::Int) -> ExcessRiskComponents

Compute exact stopping and post-verification selection regret under the tie-safe
indicator `1{Delta_hat < 0}` for a two-alternative delayed choice set.
"""
function excess_risk_decomposition(
    ::PredictiveDiscrepancyBelief,
    ::PredictiveDiscrepancyBelief,
    ::AbstractVector,
    ::AbstractVector{Int},
    ::Int,
)
    error("Not implemented yet: excess_risk_decomposition")
end

"""
    filter_weight_perturbation_bound(w_approx::AbstractVector, w_true::AbstractVector, innovation_cov::AbstractMatrix, prior_gap::Real)

Analytical upper bound on post-verification selection regret (Term II) as a
function of filter-weight error `||w(P_hat) - w(P_joint)||`.
"""
function filter_weight_perturbation_bound(::AbstractVector, ::AbstractVector, ::AbstractMatrix, ::Real)
    error("Not implemented yet: filter_weight_perturbation_bound")
end

"""
    queue_memory_ig_bound(payoff_bound::Real, tail_coupling_prob::Real)

Queue-clearing coupling upper bound `IG(ell) <= (2 * M / sqrt(2 * pi)) * Pr(tau_couple > ell)`.
"""
function queue_memory_ig_bound(payoff_bound::T, tail_coupling_prob::T) where {T<:Real}
    payoff_bound >= zero(T) || throw(ArgumentError("payoff_bound must be >= 0"))
    zero(T) <= tail_coupling_prob <= one(T) || throw(ArgumentError("tail_coupling_prob must be in [0, 1]"))
    return (T(2) * payoff_bound / sqrt(T(2) * T(pi))) * tail_coupling_prob
end
