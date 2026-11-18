# ComputationDelayedMDP.jl

**Joint Discrepancy Modeling and Value-of-Computation Control in Evolving Markov Decision Processes**

This repository contains the research proposal, theoretical audit notes, pilot benchmark records, and the pure-Julia package architecture (`ComputationDelayedMDP`) studying when high-fidelity simulation verification pays net of information age and execution delay in real-time Markov decision processes (MDPs).

## Core Research Question

Online controllers in physical systems (such as urban traffic signal control) choose between acting on a fast low-fidelity surrogate ($L$) and running slower high-fidelity simulation batches ($H$) whose wall-clock runtime introduces either **information age** (under concurrent precomputation from state $S_{t_0 - L}$) or **actuation delay and constraint forfeiture** (under post-observation deliberation while a fallback policy $\pi_0$ operates). While accurate marginal predictions are insufficient for decision-making in general (Wen et al., 2021), we characterize which specific cross-delay and cross-action discrepancy covariance entries govern optimal verification, decompose decision regret under approximate beliefs, and evaluate a masked, heteroscedastic Bayesian multi-fidelity framework on empirical traffic workloads in SUMO.

## Repository Layout

```text
computation-delayed-mdp/
├── Project.toml                     # Julia package manifest (ComputationDelayedMDP)
├── src/                             # Julia package source (domain types & interfaces)
│   ├── ComputationDelayedMDP.jl     # Module root & public API exports
│   ├── types.jl                     # MDP, query, paired rollout, & structural-mask types
│   ├── covariance.jl                # Heteroscedastic, Kronecker, & OU delay kernels
│   ├── model.jl                     # Masked Bayesian discrepancy model & posterior structs
│   ├── inference.jl                 # Blocked Gibbs & Full-Covariance SVI interfaces
│   ├── voc.jl                       # Correlated KG / VoC, refresh-L, & regret bounds
│   └── benchmark.jl                 # Date-split protocols, E[y]=0 audit, & gate runners
├── scripts/                         # Julia CLI workflow entrypoints
│   ├── run_zero_discrepancy_audit.jl
│   ├── run_information_age_gate.jl
│   └── run_closed_loop_eval.jl
├── test/                            # Unit & mathematical contract tests
│   └── runtests.jl
├── proposal/                        # Standalone LaTeX research proposal & compiled PDF
│   ├── main.tex
│   ├── preamble.tex
│   ├── proposal_body.tex
│   ├── build.sh
│   └── output/pdf/Proposal_Computation_Delayed_MDP.pdf
├── docs/                            # Technical documentation & pre-implementation audits
│   ├── README.md
│   ├── audit_overview.md
│   ├── math_and_identifiability.md
│   ├── literature_map.md
│   └── headroom_and_closed_loop.md
└── data/                            # Verified numerical checks & dev pilot summaries
    ├── README.md
    ├── math_audit/
    └── pilot_evidence/
```

## Quickstart (Julia)

Requires Julia `>= 1.10`:

```bash
julia --project=. -e 'using Pkg; Pkg.instantiate(); Pkg.test()'
```

Load the package interactively:

```julia
using ComputationDelayedMDP
```

## Building the Proposal PDF

With a standard TeX Live / TinyTeX installation (`pdflatex` with `newtx`, `amsmath`, `booktabs`, `natbib`, and `hyperref`):

```bash
sh proposal/build.sh
```

The compiled four-page PDF is written to `proposal/output/pdf/Proposal_Computation_Delayed_MDP.pdf`.

## License

Released under the [MIT License](LICENSE).
