# Mathematical and Statistical Identifiability Audit

## 1. Value-of-Computation Algebra and Choice-Set Cardinality

Let $\boldsymbol\delta = (\delta_{1,0}, \delta_{2,0}, \delta_{1,\ell}, \delta_{2,\ell})^{\mathsf T}$ denote discrepancies over two candidates $\{a_1, a_2\}$ at ages $0$ and $\ell > 0$, where costs are minimized.

- **Kalman Gain and Contrast Variance**: Under Gaussian belief $P$ with prior covariance $C(P)$ and batch observation noise $R_B(P) = \frac{1}{B}\Omega_Q(P)$ on query set $Q$, the posterior expected delayed contrast $\widehat{\Delta}_\ell(\bar{\mathbf{y}}_B; P) = \E_P[g^H_{1,\ell} - g^H_{2,\ell} \mid \bar{\mathbf{y}}_B]$ has linear filter weights
  $$\mathbf{w}(P) = \big(C_{Q,Q}(P) + R_B(P)\big)^{-1} C_{Q,\delta}(P)\,\mathbf{c}_\ell, \qquad \mathbf{c}_\ell = (0, 0, 1, -1)^{\mathsf T},$$
  and prior variance of the posterior mean $\sigma_{\mathrm{post}}^2(P) = \mathbf{c}_\ell^{\mathsf T} C_{\delta,Q}(P)\mathbf{w}(P)$.
- **Two-Alternative Correlated KG Formula**: When the active choice set has cardinality $|\mathcal{A}_0| = 2$,
  $$\operatorname{IG}(P) = \sigma_{\mathrm{post}}(P)\,\psi\!\left(\frac{|m_\ell|}{\sigma_{\mathrm{post}}(P)}\right), \qquad \psi(z) = \varphi(z) - z(1 - \Phi(z)),$$
  with $\frac{d}{d\sigma}[\sigma\psi(|m_\ell|/\sigma)] = \varphi(|m_\ell|/\sigma) > 0$ (verified numerically to $8.1 \times 10^{-11}$; see `data/math_audit/numerical_checks.json`). When $\Delta_{\mathrm{delay}} \le 0$, $\operatorname{VoC}(P) \ge -\Delta_{\mathrm{delay}} \ge 0$, so any $\sigma_{\mathrm{post}}(P) > 0$ triggers verification.
- **Three-or-More Alternatives ($|\mathcal{A}_0| \ge 3$)**: When $a_1, a_2 \ne \pi_0$ so $\mathcal{A}_0 = \{a_1, a_2, \pi_0\}$ includes $\pi_0$ at deterministic zero relative cost, the two-option $\psi$ formula does not apply (e.g., giving $0.268$ vs. true Monte Carlo $\operatorname{IG} = 0.430$ in benchmark test `A0_three_option_IG_MC`). `ComputationDelayedMDP.jl` dispatches $|\mathcal{A}_0| = 2$ to the exact $\psi$ closed form and $|\mathcal{A}_0| \ge 3$ to Monte Carlo / Clark approximation.

## 2. Exact Conditions for Factorized Over- and Under-Computation

1. **Initial-Age Queries ($Q \subseteq \{(1,0), (2,0)\}$)**:
   - Zero cross-age covariance in $P_{\mathrm{fact}}$ immediately yields $\sigma_{\mathrm{post}}(P_{\mathrm{fact}}) = 0$ and stopping regret $(\operatorname{IG}(P_{\mathrm{joint}}) - \Delta_{\mathrm{delay}})_+$.
   - A naive plug-in equating $\boldsymbol\delta_\ell$ with $\boldsymbol\delta_0$ over-computes under **separable temporal decay** $\Sigma_{0,\ell} = \rho(\ell)\Sigma_{0,0}$ with $\Sigma_{\ell,\ell} = \Sigma_{0,0}$ ($|\rho(\ell)| < 1$), where $\sigma_{\mathrm{post}}(P_{\mathrm{joint}}) = |\rho(\ell)|\,\sigma_{\mathrm{post}}(P_{\mathrm{plug}})$. Without separability, valid PSD matrices exist where $\sigma_{\mathrm{post}}(P_{\mathrm{joint}}) > \sigma_{\mathrm{post}}(P_{\mathrm{plug}})$ (`0.0816` vs. `0.0280` in `D_plugin_sigma_true`).
2. **Direct Delayed Queries ($Q \subseteq \{(1,\ell), (2,\ell)\}$)**:
   - Double-differencing builds shared baseline noise $-\varepsilon_{r0}$ into every coordinate, inducing positive off-diagonal entries in $\Omega$. Retaining paired noise structure, in the small-noise / large-$B$ limit ($R_B \to 0$), $P_{\mathrm{fact}}$ overstates $\sigma_{\mathrm{post}}$ iff $\Sigma_{12} > 0$; at small $B$, strong positive noise correlation can reverse the ordering (`0.913` vs. `0.632` in `E_a`).
   - Under a **single-action query** $Q = \{(1,\ell)\}$ with observation noise variance $r_1$, $\sigma_{\mathrm{post}}(P_{\mathrm{joint}}) = |\Sigma_{11} - \Sigma_{12}|/\sqrt{\Sigma_{11} + r_1}$ whereas $\sigma_{\mathrm{post}}(P_{\mathrm{fact}}) = \Sigma_{11}/\sqrt{\Sigma_{11} + r_1}$. Thus $P_{\mathrm{fact}}$ **over-computes** iff $0 < \Sigma_{12} < 2\Sigma_{11}$, and **under-computes** when $\Sigma_{12} < 0$ or $\Sigma_{12} > 2\Sigma_{11}$.

## 3. Excess-Risk Identity, Refresh-L Interaction, and Covariance Structure

- **Tie-Safe Excess-Risk Identity**: Using the strict indicator $a_1 \iff \widehat{\Delta}_\ell < 0$, the two-term decomposition of $\mathcal{R}(\widehat{P}; P_{\mathrm{joint}})$ matches Monte Carlo across all four $(d(P_{\mathrm{joint}}), d(\widehat{P})) \in \{0,1\}^2$ regimes (`F_prop2_max_abs_diff = 0.0029` at $N = 4 \times 10^5$) and avoids double-counting ties at $m_\ell = 0, \sigma_{\mathrm{post}}(\widehat{P}) = 0$.
- **Interaction with `refresh-L`**: Re-evaluating fast surrogate $L$ on fresh state removes $L$'s state-propagation error over $[0, \ell)$. Numerically (`H_refresh_rows`), batch verification and `refresh-L` act as *substitutes* at small prior margin ($|m_\ell| = 0$: standalone `0.282` vs. incremental `0.117`) but as *complements* at moderate/large prior margin ($|m_\ell| = 1.0$: standalone `0.025` vs. incremental `0.058`).
- **Covariance Parameterization**:
  - Unstructured $K \times K$ covariance requires $33{,}930$ parameters at $K = 260$ and suffers homoscedastic threshold collapse as $n \to \infty$ ($\Sigma_\star \to \widehat{\Sigma}$, allowing a per-pair tuned-scale factorized rule to mimic Joint VoC on direct queries).
  - Naive linear interpolation between delay grid points under an exponential decay $\exp(-\tau/\vartheta)$ understates midpoint variance (`0.717` of truth) and overstates correlation with $\tau = 0$ (`0.847` vs. true `0.659`), biasing toward over-computation.
  - We therefore adopt: (i) ex-ante structural zero masking $\mathcal{M}_i$, (ii) state-dependent heteroscedastic scales $\Sigma(x_i) = D(x_i) R D(x_i)$, and (iii) Kronecker / Ornstein--Uhlenbeck temporal correlation $[R_{\mathcal{L}}]_{uv} = \exp(-|\ell_u - \ell_v|/\vartheta)$ with separated scale and correlation priors.

## 4. Target Structural Theorems

1. **Filter-Weight Perturbation Bound**: Bound post-verification selection regret in terms of $\|\mathbf{w}(\widehat{P}) - \mathbf{w}(P_{\mathrm{joint}})\|$ and covariance approximation error $\|\widehat{\Sigma}(x) - \Sigma(x)\|_{\mathrm{op}}$.
2. **Queue-Memory Coupling Bound & Decorrelating Stopping Boundary**: Under shared exogenous arrivals with queue-clearing coupling time $\tau_{\mathrm{couple}}$ under $\pi_0$, bound $\operatorname{IG}(\ell) \le \frac{2M}{\sqrt{2\pi}}\Pr(\tau_{\mathrm{couple}} > \ell)$ and characterize monotonicity of the continuous-time stopping boundary under OU decorrelation $e^{-t/\vartheta}$ (recovering Chick & Frazier, 2012 as $\vartheta \to \infty$).
