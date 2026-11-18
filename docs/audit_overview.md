# Technical Audit Overview and Research Design Synthesis

## 1. Executive Summary

This note synthesizes the pre-implementation mathematical, statistical, bibliographic, and empirical pilot checks that shaped the revised research proposal (`proposal/proposal_body.tex`) and the `ComputationDelayedMDP.jl` design:

1. **Statistical Modeling Scope**: A masked, heteroscedastic hierarchical Gaussian discrepancy model fitted via blocked Gibbs sampling and full-covariance structured variational inference (SVI) is well-identified when paired scenario replicates satisfy $R_i \ge 2$ and structural zeros (where $\pi_{a,\ell} \equiv \pi_0$ by identity or legality forfeiture) are explicitly masked via $\mathcal{M}_i$.
2. **Timing Regime Sensitivity**:
   - Under **off-grid post-epoch deliberation** ($\pi_0$ acts at $t_0$, candidate applied at $t_0 + \tau$), phase switches by MaxPressure ($\pi_0$) at $t_0$ deterministically forfeit delayed candidates in $57.5\%$ of states and degrade closed-loop Total Time Spent (TTS) by $-3.39\%$.
   - Under **concurrent precomputation** (computing on state $S_{t_0 - L}$ during the previous control interval), a $B=4$ batch at horizon $T = 60\,\mathrm{s}$ completes in median $1.00\,\mathrm{s}$ (max $1.42\,\mathrm{s}$ inside a $5\,\mathrm{s}$ grid) and improves closed-loop TTS over `greedy5` by **$+1.53\%$** ($95\%$ CI $[0.77\%, 2.30\%]$, winning $12/12$ paired development units).
3. **Stopping Gate vs. Fixed-Budget Allocation**: When single-corridor computation fits comfortably inside a single $5\,\mathrm{s}$ interval ($L \approx 1.0\,\mathrm{s}$), information-age cost is near zero and optimal gating reduces to `always-verify`. Testing an interior stopping decision therefore requires scaling computation lead age $L \in \{1.6, 5, 10, 15\}\,\mathrm{s}$ (e.g., shared multi-intersection compute budgets, larger candidate sets, or longer horizons).

## 2. Summary of Development-Window Pilot Evidence

Evaluated on two development dates (`2023-10-04`, `2023-10-05`) at offsets `+300 s` and `+900 s` ($590\,\mathrm{s}$ windows, $435$ non-forced decision states, $\sim 57{,}000$ native rollouts; mean `greedy5` cost $208.0\,\mathrm{veh{\cdot}s}$ per $5\,\mathrm{s}$ interval):

| One-Step Policy / Benchmark | Advantage vs. Act-Now `greedy5` ($\mathrm{veh{\cdot}s}$ / decision) | Notes |
|---|---:|---|
| Zero-delay split-sample oracle ($\{a_1, a_2, \pi_0\}$) | $+8.39$ $[+5.86, +11.23]$ | Flips `greedy5` in $34.3\%$ of states |
| Zero-delay $H$-verification ($T = 60\,\mathrm{s}, B = 4$) | $+5.98$ $[+3.57, +8.67]$ | $75\%$ of flips improve true cost |
| Zero-delay $H$-verification ($T = 30\,\mathrm{s}, B = 4$) | $-1.66$ $[-5.22, +1.77]$ | $30\,\mathrm{s}$ horizon misranks $60\,\mathrm{s}$ outcomes |
| Precomputed $H$-verification ($L \approx 0.8\,\mathrm{s}, T = 60\,\mathrm{s}, B = 4$) | $+5.19$ $[+2.85, +7.70]$ | Old-state $L$ top-1 matches fresh top-1 in $91.3\%$ |
| Off-grid post-epoch always-verify ($\tau_b = 0.6\,\mathrm{s}$) | $-8.16$ to $-10.34$ | Candidate forfeited in $57.5\%$ of states |
| Off-grid `refresh-L` at $t_0 + 0.6\,\mathrm{s}$ | $-11.41$ $[-15.36, -7.69]$ | Dominated by $t_0$ switch penalty |

Paired charged closed-loop check ($4$ windows $\times 3$ seeds $= 12$ units, zero missed deadlines):

| Closed-Loop Controller | Gain vs. `greedy5` (% TTS) | 95% Paired $t$-CI | Unit Wins |
|---|---:|---|---:|
| Precomputed always-verify ($T = 60\,\mathrm{s}, B = 4$) | **$+1.53\%$** | $[+0.77\%, +2.30\%]$ | $12 / 12$ |
| Precomputed always-verify ($T = 30\,\mathrm{s}, B = 4$) | $-0.34\%$ | $[-1.31\%, +0.62\%]$ | $3 / 12$ |
| Off-grid literal timing ($T = 60\,\mathrm{s}, B = 4$) | $-3.39\%$ | $[-4.09\%, -2.70\%]$ | $0 / 12$ |
| Reactive MaxPressure ($\pi_0$) | $-4.78\%$ | $[-5.64\%, -3.92\%]$ | $0 / 12$ |

*Note*: Because `2023-10-04` and `2023-10-05` informed the choice of $T = 60\,\mathrm{s}$ over $30\,\mathrm{s}$, these figures constitute development-stage evidence to be confirmed on the locked $72$ held-out test dates.

## 3. Pre-Registered Information-Age Gate

Before locking the Tier-3 headline claim, `scripts/run_information_age_gate.jl` evaluates precomputation from $t_0 - L$ across $L \in \{1.6, 5, 10, 15\}\,\mathrm{s}$ on development windows only:

1. **Interior Stopping Criterion**: An ex-ante rule verifies in $20\%$--$80\%$ of states and a split-sample gate improves over both constant rules (`always-verify` and `never-verify`) by $\ge 1.5\,\mathrm{veh{\cdot}s}$ per decision ($\approx 0.5\%$ TTS, exceeding the $\sim 0.4\%$ minimum detectable effect across $72$ test dates).
2. **Covariance Contrast Criterion**: Decisions of Joint VoC and *tuned-scale Factorized VoC* diverge in $\ge 10\%$ of states with resolvable value difference at $72$ test dates.

**Decision Branching**:
- If Criterion 1 fails, Tier 3 focuses on *Bayesian multi-fidelity verification and budget allocation under concurrent precomputation*, reporting stopping collapse explicitly.
- If Criterion 1 passes and Criterion 2 fails, Tier 3 retains VoC gating and reports Joint vs. tuned-scale Factorized VoC as a rigorous mechanistic null contrast.
