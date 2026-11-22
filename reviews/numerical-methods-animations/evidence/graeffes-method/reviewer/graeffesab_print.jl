# graeffesab.jl
# Graeffe's Method animation: Case 2 — repeated real root
# f₀(x) = x⁴ - 9x³ + 13x² + 45x - 50 = (x-1)(x+2)(x-5)²
# True root magnitudes (sorted descending): {5, 5, 2, 1}
# The double root at x=5 causes linear convergence; simple roots converge quadratically.
# Produces: graeffesab.gif


# --- Polynomial coefficients [c₄, c₃, c₂, c₁, c₀] (highest degree first) ---
c0 = [1.0, -9.0, 13.0, 45.0, -50.0]

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
    return ratios .^ (1.0 / 2^m)
end

# --- Pre-compute squaring iterates and estimates ---
n_iters = 10
polys = Vector{Vector{Float64}}(undef, n_iters + 1)
polys[1] = c0
for i in 1:n_iters
    polys[i+1] = graeffe_step(polys[i])
end

estimates = [mag_estimates(polys[m+1], m) for m in 0:n_iters]


using Printf
for m in 0:n_iters
    println("m=",m," coeffs=",polys[m+1])
    println("   est=",estimates[m+1])
end
