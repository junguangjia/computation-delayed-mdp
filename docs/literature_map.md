# Literature Map and Novelty Positioning

## 1. Thematic Positioning Across Prior Work

### A. Metareasoning, Real-Time MDPs, and Learned Computation Budgets
- **Russell & Wefald (1991)** (*Artificial Intelligence*, 49:361--395) and **Hansen & Zilberstein (2001)** (*Artificial Intelligence*, 126:139--157): Foundational metareasoning and dynamic-programming control of anytime algorithms under time-dependent utility.
- **Lin, Kolobov, Kamar, & Horvitz (2015)** (*IJCAI*, pp. 1601--1608): Formalizes thinking as a `NOP` action in an MDP during which the external world continues to drift, stopping via myopic Value of Computation.
- **Ramstedt & Pal (2019)** (*NeurIPS*) and **Derman, Dalal, & Mannor (2021)** (*ICLR*): Real-time and execution-delay MDPs.
- **Findeisen & Allgower (2004)** (*IFAC ADCHEM*): Delay-compensated nonlinear MPC optimizing from the predicted actuation state.
- **Magnino, Marino, Amir, Shishika, & Prorok (2026)** (`arXiv:2610.23662`) and **Muppidi, Darwish, Cope, Henriques, & Foerster (2026)** (*Finding the Time to Think*, `arXiv:2606.26463`): RL-learned computation budgets in evolving environments where planning latency is charged in physical environment time.

*Distinction*: The works above operate on a single planning fidelity using learned or heuristic stopping criteria rather than calibrated multi-fidelity discrepancy beliefs.

### B. Multi-Fidelity Discrepancy, Correlated KG, and Delayed Sampling
- **Kennedy & O'Hagan (2000)** (*Biometrika*, 87(1):1--13) and **Kennedy & O'Hagan (2001)** (*JRSS-B*, 63(3):425--464): Bayesian multi-level computer-code discrepancy (`H` vs. `L`) and model calibration.
- **Frazier, Powell, & Dayanik (2009)** (*INFORMS J. Comput.*, 21(4):599--613): Correlated Knowledge-Gradient policy for correlated normal beliefs.
- **Xie, Frazier, & Chick (2016)** (*Operations Research*, 64(2):542--559): Pairwise sampling (common random numbers) with correlated priors, explaining variance cancellation in differences.
- **Poloczek, Wang, & Frazier (2017)** (`misoKG`, *NeurIPS*, pp. 4288--4298): Multi-information source optimization with GP discrepancy priors and cost-normalized KG acquisition on a static objective.
- **Hay, Russell, Tolpin, & Shimony (2012)** (*UAI*): Bayesian VOI selection of Monte Carlo rollouts on a static root state.
- **Chick & Frazier (2012)** (*Management Science*, 58(3):550--569) and **Chick, Forster, & Pertile (2017)** (*JRSS-B*, 79(5):1439--1462): Sequential sampling economics with discounting and delayed responses on stationary arms.
- **Wen et al. (2021)** (`arXiv:2107.09224`): General decision-theoretic proof that joint predictive distributions are required beyond accurate marginals.

*Specific Gap Addressed*: Combining correlated multi-fidelity VOI / KG with information age and actuation latency where simulation evidence gathered on state $S_{t_0 - L}$ updates beliefs about relative action costs at a *later, evolved execution state* $S_{t_0}$, governed by cross-age and cross-action discrepancy covariance.

### C. Urban Traffic Metamodeling and Benchmarks
- **Osorio & Bierlaire (2013)** (*Operations Research*, 61(6):1333--1345): Analytical queueing-network surrogate combined with microsimulation discrepancy for offline signal optimization.
- **Goodall, Smith, & Park (2013)** (*Transportation Research Record*, 2381:65--72): Rolling-horizon online predictive microsimulation for phase selection.
- **Ault & Sharon (2021)** (*NeurIPS Datasets and Benchmarks*, vol. 1): Core RESCO reinforcement learning traffic signal benchmark suite.
- **Pi-Star Lab (2025)** (*RESCO v2.0*, commit `f1ed9a1`, `2025-10-28`): Source of the `saltlake2_400sX200w` corridor (sites `7241` and `7242`) and 2023 five-minute Utah DOT ATSPM movement counts (`730` daily CSVs).
