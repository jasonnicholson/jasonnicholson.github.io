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
println("Solution 2: x = $(round(sol[1], digits=8)), y = $(round(sol[2], digits=8))")

# --- Background implicit curves ---
xg = range(xlims[1], xlims[2], length=400)
yg = range(ylims[1], ylims[2], length=400)
Z1 = [f1(x, y) for y in yg, x in xg]
Z2 = [f2(x, y) for y in yg, x in xg]

title_str = "Newton's Method for Nonlinear Systems\nStarting at (2, -1)"

# --- Animation ---
anim = @animate for frame in 0:n_iters
    plot(size=(640, 620), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y", title=title_str,
         legend=:topright, grid=true, framestyle=:box,
         background_color=:white)

    # Zero curves as contours
    contour!(collect(xg), collect(yg), Z1;
             levels=[0.0], lw=2, lc=:blue, colorbar=false)
    contour!(collect(xg), collect(yg), Z2;
             levels=[0.0], lw=2, lc=:red, colorbar=false)

    # Dummy series for legend
    plot!([], []; color=:blue, lw=2, label="f₁(x,y) = 0")
    plot!([], []; color=:red,  lw=2, label="f₂(x,y) = 0")

    # Iteration path (up to current frame)
    if frame >= 1
        xs_path = [pts[k][1] for k in 1:(frame + 1)]
        ys_path = [pts[k][2] for k in 1:(frame + 1)]
        plot!(xs_path, ys_path;
              color=:steelblue, lw=1.5, marker=:circle,
              ms=5, markercolor=:steelblue, label="iterates")
    end

    # Starting point
    scatter!([pts[1][1]], [pts[1][2]];
             color=:green, ms=8, markershape=:diamond, label="x⁽⁰⁾")

    # Current iterate label
    cur = pts[frame + 1]
    scatter!([cur[1]], [cur[2]];
             color=:red, ms=8,
             label="x⁽$(frame)⁾ = ($(round(cur[1]; digits=4)), $(round(cur[2]; digits=4)))")
end

gif(anim, joinpath(@__DIR__, "newtonsysab.gif"); fps=2)
println("Saved: newtonsysab.gif")
