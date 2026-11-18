#!/usr/bin/env julia
# Tier 2 pre-registered gate entrypoint: Information-age sweep L in {1.6, 5.0, 10.0, 15.0} s

using ComputationDelayedMDP

const DEFAULT_LEAD_AGES = [1.6, 5.0, 10.0, 15.0]

function main()
    criteria = GateCriteria()
    println("[ComputationDelayedMDP] Pre-Registered Information-Age Gate")
    println("  Lead ages (s): ", DEFAULT_LEAD_AGES)
    println("  Target verify-rate window: [", criteria.min_verify_rate, ", ", criteria.max_verify_rate, "]")
    println("  Min oracle gain (veh*s/decision): ", criteria.min_oracle_gain_veh_s)
    println("  Min Joint vs. tuned-scale Factorized divergence: ", criteria.min_joint_vs_fact_divergence)
end

if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
