using Test
using Dates
using LinearAlgebra
using ComputationDelayedMDP

@testset "ComputationDelayedMDP.jl Skeleton & Mathematical Contracts" begin
    @testset "StructuralMask & DateSplitManifest invariants" begin
        mask = StructuralMask([2, 4], 4)
        P = mask_projection(mask)
        @test size(P) == (2, 4)
        @test P * [10.0, 20.0, 30.0, 40.0] == [20.0, 40.0]
        @test_throws ArgumentError StructuralMask([3, 1], 4)

        manifest = DateSplitManifest(
            [Date(2023, 1, 1)],
            [Date(2023, 6, 1)],
            [Date(2023, 10, 4)],
            [Date(2023, 11, 1)],
        )
        @test validate_splits(manifest)

        leaky = DateSplitManifest(
            [Date(2023, 10, 4)],
            [Date(2023, 6, 1)],
            [Date(2023, 10, 4)],
            [Date(2023, 11, 1)],
        )
        @test !validate_splits(leaky)
    end

    @testset "Lemma 1 covariance contracts (cross-age & separable scaling)" begin
        S00 = [1.0 0.4; 0.4 1.2]
        rho = 0.6
        C_sep = Symmetric([S00 (rho .* S00); (rho .* S00) S00])
        C_plug = Symmetric([S00 S00; S00 S00])
        Omega = Symmetric(Matrix(0.3I, 4, 4))

        joint_belief = PredictiveDiscrepancyBelief(zeros(4), C_sep, Omega, false)
        plug_belief = PredictiveDiscrepancyBelief(zeros(4), C_plug, Omega, false)
        fact_belief = marginal_matched_belief(joint_belief)

        contrast = [0.0, 0.0, 1.0, -1.0]
        q_init = [1, 2]

        @test posterior_contrast_std(fact_belief, q_init, contrast, 4) == 0.0
        s_joint = posterior_contrast_std(joint_belief, q_init, contrast, 4)
        s_plug = posterior_contrast_std(plug_belief, q_init, contrast, 4)
        @test isapprox(s_joint / s_plug, abs(rho); atol=1e-12)
    end

    @testset "Lemma 1 single-action query contrast std" begin
        # Sigma11 = 1.0, Sigma12 = 0.8 in (0, 2*Sigma11) => P_fact overstates sigma_post
        Sig_delay = [1.0 0.8; 0.8 1.0]
        C = Symmetric([Matrix(1.0I, 2, 2) zeros(2, 2); zeros(2, 2) Sig_delay])
        Omega = Symmetric(Matrix(0.1I, 4, 4))

        joint_belief = PredictiveDiscrepancyBelief(zeros(4), C, Omega, false)
        fact_belief = marginal_matched_belief(joint_belief; retain_shared_baseline_noise=false)

        contrast = [0.0, 0.0, 1.0, -1.0]
        s_joint = posterior_contrast_std(joint_belief, [3], contrast, 1)
        s_fact = posterior_contrast_std(fact_belief, [3], contrast, 1)
        @test s_fact > s_joint
        @test isapprox(s_joint, abs(1.0 - 0.8) / sqrt(1.0 + 0.1); atol=1e-12)
    end

    @testset "Queue-memory coupling bound" begin
        val = queue_memory_ig_bound(10.0, 0.25)
        @test isapprox(val, (20.0 / sqrt(2 * pi)) * 0.25; atol=1e-12)
    end
end
