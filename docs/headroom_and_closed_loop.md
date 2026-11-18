# Pilot Headroom and Closed-Loop Benchmark Notes

## 1. Corridor and Workload Cohort (`saltlake2_400sX200w`)

- **Network**: Coupled two-intersection arterial in Salt Lake City (sites `7241` and `7242`, RESCO v2.0 commit `f1ed9a1`).
- **Source Counts**: `730` daily CSV files covering 2023, each with `288` five-minute bins and `12` integer movement counts (converted to SUMO flows via `csv_to_flo.py`).
- **Screened 07:00--08:00 Cohort**:
  - `217` training dates
  - `29` validation dates
  - `11` eligible dates in the `2023-10-01`--`2023-10-15` development buffer (initial native calibration and pilot diagnostics run on `2023-10-04` and `2023-10-05` at offsets `+300 s` and `+900 s`)
  - `72` locked final-test dates

## 2. Key Pilot Structural Findings

1. **Rollout Horizon Requirement ($T \ge 60\,\mathrm{s}$)**:
   - Entry links carry $\approx 14.4\,\mathrm{s}$ of free-flow travel time; $30\,\mathrm{s}$ native rollouts correlate weakly ($0.33$--$0.38$) with $60\,\mathrm{s}$ realized vehicle-time differences and slightly degrade performance ($-0.34\%$ TTS in closed loop).
   - Extending the rollout horizon to $T = 60\,\mathrm{s}$ raises correlation with $60\,\mathrm{s}$ truth to $0.86$--$0.96$ and yields consistent closed-loop improvements ($+1.53\%$ TTS over `greedy5` across $12/12$ paired units; $+1.65\%$ on the $8$ collision/teleport-free units).
2. **Common Random Numbers (CRN) Precision**:
   - Single-rollout unpaired cost standard deviation is $\approx 94\,\mathrm{veh{\cdot}s}$, whereas paired candidate-minus-baseline noise $\Omega^{1/2}$ drops to $\approx 2.1\,\mathrm{veh{\cdot}s}$ at $30\,\mathrm{s}$ and $\approx 20\,\mathrm{veh{\cdot}s}$ at $60\,\mathrm{s}$ against structural discrepancy spread $\Sigma^{1/2} \approx 105$--$118\,\mathrm{veh{\cdot}s}$. Consequently, small batches ($B = 4$) capture almost all of the $B = 8$ verification gain ($+5.98$ vs. $+6.51\,\mathrm{veh{\cdot}s}$/decision).
3. **Structural Zeros and Empirical Discrepancy Correlations**:
   - Under off-grid post-epoch actuation, structural zeros occur in $36.8\%$ of states for $(a_1, 0)$, $89.0\%$ for $(a_1, \tau_b)$, and $58.9\%$--$60.7\%$ for $(a_2, \tau_b)$, motivating exact deterministic masking $\mathcal{M}_i$.
   - Across non-zero states ($n = 44$ at $T = 60\,\mathrm{s}$), structural discrepancies exhibit strong empirical dependence: cross-action correlation $0.892$ at $\ell = 0$ and $0.752$ at $\tau_b$, and cross-delay correlation $0.797$ for $a_1$ and $0.938$ for $a_2$.

## 3. Reproducible Pilot Artifacts in `data/pilot_evidence/`

- `headroom_summary.txt`: Aggregate statistics from the $435$-state one-step headroom diagnostic.
- `closed_loop_summary.txt`: Paired gain and runtime summary across all $60$ closed-loop episodes ($12$ paired units $\times 5$ controllers: `greedy5`, `MP`, `P1_H30_B4`, `P1_H60_B4`, `LIT_H60_B4`).
- `episodes/*.json`: Per-episode structured telemetry JSON files recording wall-clock batch runtimes, selected candidates, total vehicle time spent, and simulator safety event counters.
