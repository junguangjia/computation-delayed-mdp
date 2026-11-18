# Technical Documentation

This directory stores pre-implementation mathematical audits, literature positioning maps, and empirical pilot diagnostics supporting the revised research proposal and the `ComputationDelayedMDP.jl` implementation.

## Contents

- [`audit_overview.md`](audit_overview.md): Executive synthesis of mathematical, statistical, and closed-loop design audits, pre-registered information-age gate criteria, and contingency branches.
- [`math_and_identifiability.md`](math_and_identifiability.md): Detailed audit of correlated Knowledge-Gradient equations, two- vs. multi-alternative bounds, masked heteroscedastic covariance identifiability, Kronecker / Ornstein--Uhlenbeck delay structures, and target theorems.
- [`literature_map.md`](literature_map.md): Verification of bibliographic sources across computation-aware MDPs, multi-fidelity simulation discrepancy, correlated Bayesian value of information, and urban traffic benchmarks.
- [`headroom_and_closed_loop.md`](headroom_and_closed_loop.md): Development-window pilot diagnostics (`2023-10-04` and `2023-10-05` on RESCO v2.0 `saltlake2_400sX200w`), horizon sensitivity (`30 s` vs. `60 s`), structural zeros under signal legality, and closed-loop paired benchmarks.
