#!/usr/bin/env julia
# Tier 3 entrypoint: Charged closed-loop benchmark across the 72 held-out test dates

using ComputationDelayedMDP

function main()
    println("[ComputationDelayedMDP] Tier-3 Charged Closed-Loop Evaluation (72 Held-Out Test Dates)")
    println("Baselines: ActNowSurrogatePolicy (greedy5), RefreshSurrogatePolicy (refresh-L),")
    println("           AlwaysVerifyPolicy (T >= 60 s), VoCGatedPolicy (Joint & tuned-scale Factorized),")
    println("           and compute-rate-matched ActionMarginPolicy.")
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
