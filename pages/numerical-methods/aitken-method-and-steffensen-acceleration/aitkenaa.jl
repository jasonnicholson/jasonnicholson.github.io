# aitkenaa.jl
# Aitken/Steffensen animation: Example 1
# Newton-Raphson tangent-line animation on f(x) = x^3 - 3x + 2
# Double root at p = 1.  Demonstrates slow (linear) convergence.
# Produces: aitkenaa.gif

using Plots
gr()

# --- Function and derivative ---
f(x)  = x^3 - 3x + 2
df(x) = 3x^2 - 3

# --- Parameters ---
x0      = 2.0
root    = 1.0
n_iters = 18
xlims   = (-0.3, 2.6)
ylims   = (-0.8, 5.5)
title_str = "Newton–Raphson: f(x) = x³ − 3x + 2  (double root p = 1)"

# --- Pre-compute Newton iterates ---
xs = Vector{Float64}(undef, n_iters + 1)
xs[1] = x0
for i in 1:n_iters
    xs[i+1] = xs[i] - f(xs[i]) / df(xs[i])
end

# --- Build Newton tangent-line path ---
# Pattern: (x_i, 0) → (x_i, f(x_i)) → (x_{i+1}, 0) → ...
# path_x[1] = x0, path_y[1] = 0
# then pairs: vertical up, tangent down
path_x = [xs[1]]
path_y = [0.0]
for i in 1:n_iters
    push!(path_x, xs[i],   xs[i+1])
    push!(path_y, f(xs[i]), 0.0)
end

# --- Backdrop ---
xplot = range(xlims[1], xlims[2], length=500)

# --- Animation ---
anim = @animate for frame in 0:n_iters
    plot(size=(680, 560), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y", title=title_str,
         legend=:topleft, grid=true, framestyle=:box,
         background_color=:white)

    # y = 0 axis marker
    hline!([0.0]; color=:black, lw=1, label="")

    # Function curve
    plot!(xplot, f.(xplot); color=:magenta, lw=2, label="y = f(x)")

    # Draw Newton path up to current frame
    n_pts = 1 + 2 * frame
    if n_pts >= 2
        plot!(path_x[1:n_pts], path_y[1:n_pts];
              color=:steelblue, lw=1.5, label="")
    end

    # Current iterate marker
    x_cur = xs[frame + 1]
    err   = abs(x_cur - root)
    scatter!([x_cur], [0.0]; color=:red, ms=6, markershape=:circle,
             label="x_$(frame) = $(round(x_cur; digits=6)),  err = $(round(err; digits=6))")
end

gif(anim, joinpath(@__DIR__, "aitkenaa.gif"); fps=2)
println("Saved: aitkenaa.gif")
