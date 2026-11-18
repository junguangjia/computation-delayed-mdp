# Benchmark Data and Audit Evidence

This directory stores lightweight, version-controlled numerical verification outputs and development-window pilot summaries. Large raw SUMO trajectory dumps and `.jsonl` rollout traces are excluded via `.gitignore`.

## Structure

- `math_audit/`
  - `numerical_checks.json`: Verified Monte Carlo benchmarks for the two-alternative correlated KG formula, derivative identity, three-alternative choice-set contrast, non-separable plug-in counterexample, paired-noise vs. single-query covariance shifts, excess-risk decomposition across all $(d, \hat{d}) \in \{0,1\}^2$ cases, linear-interpolation bias under exponential decay, and `refresh-L` complementarity.
  - `zscore_checks.json`: Secondary high-sample Monte Carlo $z$-score validations for correlated KG and excess-risk identities.
- `pilot_evidence/`
  - `headroom_summary.txt`: Summary metrics over $435$ decision states from `2023-10-04` and `2023-10-05` (`+300 s`, `+900 s`) on RESCO v2.0 `saltlake2_400sX200w`.
  - `closed_loop_summary.txt`: Paired closed-loop comparison across $12$ units ($60$ episodes) charging wall-clock deliberation time.
  - `episodes/`: Per-episode JSON summaries (`60` files) for reproducible paired statistical analysis in `ComputationDelayedMDP.jl`.
