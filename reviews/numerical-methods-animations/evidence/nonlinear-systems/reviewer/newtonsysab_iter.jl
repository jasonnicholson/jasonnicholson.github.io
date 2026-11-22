# newtonsysab.jl
# Nonlinear Systems animation: Newton's method converging to Solution 2
# System: f1(x,y) = 1 - 4x + 2x^2 - 2y^3 = 0
#         f2(x,y) = -4 + x^4 + 4y + 4y^4 = 0
# Starting near (2, -1), converges to x* ≈ 1.5561, y* ≈ -0.5757
# Produces: newtonsysab.gif

using Plots
using LinearAlgebra
gr()

# --- System definition ---
f1(x, y) = 1 - 4x + 2x^2 - 2y^3
f2(x, y) = -4 + x^4 + 4y + 4y^4
F(p) = [f1(p[1], p[2]), f2(p[1], p[2])]
Jac(x, y) = [4x - 4   -6y^2
             4x^3      4 + 16y^3]

# --- Parameters ---
p0      = [2.0, -1.0]   # starting point near Solution 2
n_iters = 8

xlims = (-0.25, 2.75)
ylims = (-1.50, 1.25)

# --- Pre-compute Newton iterates ---
pts = Vector{Vector{Float64}}(undef, n_iters + 1)
pts[1] = copy(p0)
for k in 1:n_iters
    Jv = Jac(pts[k][1], pts[k][2])
    pts[k+1] = pts[k] - Jv \ F(pts[k])
end

sol = pts[end]
using Printf
for (k,p) in enumerate(pts)
    lab = "x⁽$(k-1)⁾ = ($(round(p[1]; digits=4)), $(round(p[2]; digits=4)))"
    @printf("k=%d  %.15f  %.15f  |F|=%.3e  %s\n", k-1, p[1], p[2], norm(F(p)), lab)
end
