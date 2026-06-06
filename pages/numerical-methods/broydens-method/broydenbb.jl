# broydenbb.jl
# Broyden's Method animation: convergence to solution 2 near (2.808, -1.665)
# System: f1(x,y) = 1 - 4x + 2x² - 2y² = 0
#         f2(x,y) = -4 + x² + 4y + y² = 0
# Starting point: (2.5, -1.5)
# Produces: broydenbb.gif

using Plots
using LinearAlgebra
gr()

# --- System ---
F(x, y) = [1 - 4x + 2x^2 - 2y^2,
           -4 + x^2 + 4y + y^2]

# Exact Jacobian (used only at step 0)
function Jac(x, y)
    [-4 + 4x   -4y
      2x        4 + 2y]
end

# --- Parameters ---
x0, y0 = 2.5, -1.5
n_iters = 10

xlims = (-1.0, 3.5)
ylims = (-2.5, 2.0)

title_str = "Broyden's Method: solution near (2.808, -1.665)"

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

n_frames = length(iterates) - 1

# --- Backdrop: zero contour curves ---
nx, ny = 400, 400
xg = range(xlims[1], xlims[2], length=nx)
yg = range(ylims[1], ylims[2], length=ny)
Z1 = [1 - 4*xi + 2*xi^2 - 2*yi^2 for yi in yg, xi in xg]
Z2 = [-4 + xi^2 + 4*yi + yi^2    for yi in yg, xi in xg]

# --- Animation ---
anim = @animate for frame in 0:n_frames
    plot(size=(600, 500), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y", title=title_str,
         legend=:topright, grid=true, framestyle=:box,
         background_color=:white)

    # zero contours of f1 and f2
    contour!(xg, yg, Z1; levels=[0.0], color=:blue,  lw=2, colorbar=false,
             label="f₁(x,y) = 0")
    contour!(xg, yg, Z2; levels=[0.0], color=:red,   lw=2, colorbar=false,
             label="f₂(x,y) = 0")

    # iterates up to current frame
    pts = iterates[1:frame+1]
    xs_pts = [p[1] for p in pts]
    ys_pts = [p[2] for p in pts]

    if length(pts) > 1
        plot!(xs_pts, ys_pts; color=:steelblue, lw=1.5, label="")
    end
    scatter!(xs_pts[1:end-1], ys_pts[1:end-1];
             color=:steelblue, ms=4, label="")
    scatter!([xs_pts[end]], [ys_pts[end]];
             color=:red, ms=7,
             label="X_$(frame) = ($(round(xs_pts[end]; digits=4)), $(round(ys_pts[end]; digits=4)))")
end

gif(anim, joinpath(@__DIR__, "broydenbb.gif"); fps=2)
println("Saved: broydenbb.gif")
