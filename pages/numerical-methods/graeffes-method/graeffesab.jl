# graeffesab.jl
# Graeffe's Method animation: Case 2 — repeated real root
# f₀(x) = x⁴ - 9x³ + 13x² + 45x - 50 = (x-1)(x+2)(x-5)²
# True root magnitudes (sorted descending): {5, 5, 2, 1}
# The double root at x=5 causes linear convergence; simple roots converge quadratically.
# Produces: graeffesab.gif

using Plots
gr()

# --- Polynomial coefficients [c₄, c₃, c₂, c₁, c₀] (highest degree first) ---
# Exact integer arithmetic (BigInt): the largest coefficient of p₈ is ≈ (5·5·2)^256 ≈ 8.6e434,
# beyond the Float64 range (≈1.8e308), so Float64 would give Inf/NaN from m = 8 on.
c0 = big.([1, -9, 13, 45, -50])

# True root magnitudes sorted descending: {5, 5, 2, 1}
true_mags = [5.0, 5.0, 2.0, 1.0]

# --- Graeffe squaring step (degree 4) ---
function graeffe_step(c)
    c4, c3, c2, c1, c0 = c
    d4 = c4^2
    d3 = 2*c4*c2 - c3^2
    d2 = c2^2 + 2*c4*c0 - 2*c3*c1
    d1 = 2*c2*c0 - c1^2
    d0 = c0^2
    return [d4, d3, d2, d1, d0]
end

# --- Separated Root Theorem estimates ---
# After m squarings: |cₙ₋ₖ / cₙ₋ₖ₊₁|^{1/2^m} for k = 1..4
function mag_estimates(c, m)
    ratios = abs.([c[2]/c[1], c[3]/c[2], c[4]/c[3], c[5]/c[4]])
    return Float64.(ratios .^ (1.0 / 2^m))   # estimates are O(1), safe in Float64
end

# --- Pre-compute squaring iterates and estimates ---
n_iters = 10
polys = Vector{Vector{BigInt}}(undef, n_iters + 1)
polys[1] = c0
for i in 1:n_iters
    polys[i+1] = graeffe_step(polys[i])
end

estimates = [mag_estimates(polys[m+1], m) for m in 0:n_iters]

# --- Animation ---
colors = [:steelblue, :steelblue, :crimson, :darkorange]
linestyles = [:solid, :dash, :solid, :solid]
root_labels = ["r₁  (|r₁| = 5, double)", "", "r₃  (|r₃| = 2)", "r₄  (|r₄| = 1)"]

anim = @animate for frame in 0:n_iters
    p = plot(size=(700, 500),
             xlims=(-0.3, n_iters + 0.3), ylims=(0.0, 9.5),
             xlabel="Squaring iteration m", ylabel="Estimated root magnitude |rₖ|",
             title="Graeffe's Method — Repeated Root at x = 5\n" *
                   "f(x) = (x−1)(x+2)(x−5)²,  m = $frame",
             legend=:topright, grid=true, framestyle=:box,
             background_color=:white, dpi=100)

    # True magnitudes as dashed horizontal lines (two overlap at 5)
    for k in [1, 3, 4]
        hline!([true_mags[k]]; color=colors[k], lw=1.5, ls=:dash, label="")
    end
    hline!([5.0]; color=:steelblue, lw=1.5, ls=:dash, label="")

    # Convergence traces
    for k in 1:4
        xs = collect(0:frame)
        ys = [estimates[m+1][k] for m in 0:frame]
        lbl = root_labels[k]
        if lbl == ""
            plot!(xs, ys; color=colors[k], lw=2, marker=:diamond, ms=5,
                  ls=linestyles[k], label="r₂  (|r₂| = 5, double)")
        else
            plot!(xs, ys; color=colors[k], lw=2, marker=:circle, ms=5,
                  ls=linestyles[k], label=lbl)
        end
    end

    # Annotation on last frame about convergence behavior
    if frame == n_iters
        annotate!(n_iters * 0.6, 6.3,
            text("r₁, r₂: linear convergence (double root)\nr₃, r₄: quadratic convergence", 9, :black))
    end
end

gif(anim, joinpath(@__DIR__, "graeffesab.gif"); fps=2)
println("Saved: graeffesab.gif")
