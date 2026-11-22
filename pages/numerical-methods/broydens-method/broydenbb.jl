# broydenbb.jl
# Broyden's Method animation: convergence to the lower-right solution near (1.556, -0.576)
# System (Mathews, Broyden's Method module):
#         f1(x,y) = 1 - 4x + 2x² - 2y³ = 0
#         f2(x,y) = -4 + x⁴ + 4y + 4y⁴ = 0
# Starting point: (1.5, -0.5), as in Mathews' Example 8 comparison run
# Left panel: the zero curves and the iterates. Right panel: ‖F(X_k)‖ on a log scale.
# Produces: broydenbb.gif

using Plots
using LinearAlgebra
using Printf
gr()

# --- System ---
F(x, y) = [1 - 4x + 2x^2 - 2y^3,
           -4 + x^4 + 4y + 4y^4]

# Exact Jacobian (used only at step 0)
function Jac(x, y)
    [-4 + 4x   -6y^2
      4x^3      4 + 16y^3]
end

# --- Parameters ---
x0, y0 = 1.5, -0.5
n_iters = 10

xlims = (-1.75, 2.25)
ylims = (-1.5, 1.25)

title_str = "Broyden's Method: solution near (1.556, -0.576)"

# --- Run Broyden's method ---
function run_broyden(x0, y0, n_iters)
    iterates = Vector{Vector{Float64}}()
    push!(iterates, [x0, y0])

    X_prev = [x0, y0]
    F_prev = F(x0, y0)

    # Step 0: one exact Newton step
    B = Jac(x0, y0)
    X_curr = X_prev - B \ F_prev
    push!(iterates, copy(X_curr))

    # Steps 1..n_iters: quasi-Newton (Broyden) updates
    for k in 1:n_iters
        F_curr = F(X_curr[1], X_curr[2])
        if norm(F_curr) < 1e-12
            break
        end
        s = X_curr - X_prev
        y_vec = F_curr - F_prev
        denom = dot(s, s)
        if denom < 1e-20
            break
        end
        B = B + (y_vec - B * s) * s' / denom   # rank-1 update
        X_next = X_curr - B \ F_curr
        X_prev = X_curr
        F_prev = F_curr
        X_curr = X_next
        push!(iterates, copy(X_curr))
    end
    return iterates
end

iterates = run_broyden(x0, y0, n_iters)
residuals = [norm(F(p[1], p[2])) for p in iterates]   # ‖F(X_k)‖

n_frames = length(iterates) - 1

# --- Backdrop: zero contour curves ---
nx, ny = 400, 400
xg = range(xlims[1], xlims[2], length=nx)
yg = range(ylims[1], ylims[2], length=ny)
Z1 = [1 - 4*xi + 2*xi^2 - 2*yi^3       for yi in yg, xi in xg]
Z2 = [-4 + xi^4 + 4*yi + 4*yi^4        for yi in yg, xi in xg]

# --- Animation ---
anim = @animate for frame in 0:n_frames
    # iterates up to current frame
    pts = iterates[1:frame+1]
    xs_pts = [p[1] for p in pts]
    ys_pts = [p[2] for p in pts]

    # left: zero curves and iterate path
    p1 = plot(xlims=xlims, ylims=ylims, xlabel="x", ylabel="y",
              title=@sprintf("X_%d = (%.4f, %.4f)", frame, xs_pts[end], ys_pts[end]),
              legend=false, grid=true, framestyle=:box)
    contour!(p1, xg, yg, Z1; levels=[0.0], color=:blue, lw=2, colorbar=false)
    contour!(p1, xg, yg, Z2; levels=[0.0], color=:red,  lw=2, colorbar=false)
    if length(pts) > 1
        plot!(p1, xs_pts, ys_pts; color=:steelblue, lw=1.5)
    end
    scatter!(p1, xs_pts[1:end-1], ys_pts[1:end-1]; color=:steelblue, ms=4)
    scatter!(p1, [xs_pts[end]], [ys_pts[end]]; color=:red, ms=7)

    # right: residual norm on a log scale
    ks = 0:frame
    p2 = plot(ks, residuals[1:frame+1]; yscale=:log10,
              xlims=(-0.5, n_frames + 0.5), ylims=(1e-16, 1e1),
              xticks=0:n_frames, yticks=10.0 .^ (-16:2:0),
              xlabel="k", ylabel="||F(X_k)||",
              title=@sprintf("||F(X_%d)|| = %.2e", frame, residuals[frame+1]),
              color=:steelblue, lw=1.5, marker=:circle, ms=4,
              legend=false, grid=true, framestyle=:box)
    scatter!(p2, [frame], [residuals[frame+1]]; color=:red, ms=7)

    plot(p1, p2; layout=(1, 2), size=(1000, 480), plot_title=title_str,
         background_color=:white, left_margin=4Plots.mm, bottom_margin=4Plots.mm)
end

gif(anim, joinpath(@__DIR__, "broydenbb.gif"); fps=2)
println("Saved: broydenbb.gif")
