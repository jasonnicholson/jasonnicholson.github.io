# graeffesaa.jl
# Graeffe's Method animation: Case 1 — four distinct real roots
# f₀(x) = x⁴ - 2x³ - 13x² + 14x + 24 = (x+1)(x-2)(x+3)(x-4)
# True root magnitudes (sorted descending): {4, 3, 2, 1}
# Produces: graeffesaa.gif

using Plots
gr()

# --- Polynomial coefficients [c₄, c₃, c₂, c₁, c₀] (highest degree first) ---
c0 = [1.0, -2.0, -13.0, 14.0, 24.0]

# True root magnitudes sorted descending: |r| = {4, 3, 2, 1}
true_mags = [4.0, 3.0, 2.0, 1.0]

# --- Graeffe squaring step (degree 4) ---
# Given p(x) = c₄x⁴ + c₃x³ + c₂x² + c₁x + c₀,
# the squared polynomial q(t) = E(t)² − t·O(t)² has roots rₖ²
# where E(t) = c₄t² + c₂t + c₀  and  O(t) = c₃t + c₁
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
# After m squarings, the m-th polynomial has roots rₖ^{2^m}.
# The coefficient-ratio estimates are |cₙ₋ₖ / cₙ₋ₖ₊₁|^{1/2^m} for k = 1..4.
function mag_estimates(c, m)
    ratios = abs.([c[2]/c[1], c[3]/c[2], c[4]/c[3], c[5]/c[4]])
    return ratios .^ (1.0 / 2^m)
end

# --- Pre-compute squaring iterates and estimates ---
n_iters = 8
polys = Vector{Vector{Float64}}(undef, n_iters + 1)
polys[1] = c0
for i in 1:n_iters
    polys[i+1] = graeffe_step(polys[i])
end

estimates = [mag_estimates(polys[m+1], m) for m in 0:n_iters]

# --- Animation ---
colors = [:steelblue, :crimson, :darkorange, :mediumpurple]
root_labels = ["r₁  (|r₁| = 4)", "r₂  (|r₂| = 3)", "r₃  (|r₃| = 2)", "r₄  (|r₄| = 1)"]

anim = @animate for frame in 0:n_iters
    p = plot(size=(700, 500),
             xlims=(-0.3, n_iters + 0.3), ylims=(0.0, 6.0),
             xlabel="Squaring iteration m", ylabel="Estimated root magnitude |rₖ|",
             title="Graeffe's Method — Distinct Roots\n" *
                   "f(x) = (x+1)(x−2)(x+3)(x−4),  m = $frame",
             legend=:topright, grid=true, framestyle=:box,
             background_color=:white, dpi=100)

    # True magnitudes as dashed horizontal lines
    for k in 1:4
        hline!([true_mags[k]]; color=colors[k], lw=1.5, ls=:dash, label="")
    end

    # Convergence trace for each root up to current frame
    for k in 1:4
        xs = collect(0:frame)
        ys = [estimates[m+1][k] for m in 0:frame]
        plot!(xs, ys; color=colors[k], lw=2, marker=:circle, ms=5, label=root_labels[k])
    end
end

gif(anim, joinpath(@__DIR__, "graeffesaa.gif"); fps=2)
println("Saved: graeffesaa.gif")
