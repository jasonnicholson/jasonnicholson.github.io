# aitkencc.jl
# Aitken/Steffensen animation: Example 3
# Newton-Raphson tangent-line animation on f(x) = (x^2 - 2)*sin(x^2 - 2)
# Double root at p = sqrt(2).  Demonstrates slow (linear) convergence.
# Produces: aitkencc.gif

using Plots
gr()

# --- Function and derivative ---
f(x)  = (x^2 - 2) * sin(x^2 - 2)
df(x) = 2x * (sin(x^2 - 2) + (x^2 - 2) * cos(x^2 - 2))

# --- Parameters ---
x0      = 1.0
root    = sqrt(2.0)
n_iters = 16
xlims   = (-0.3, 2.5)
ylims   = (-0.6, 2.2)
title_str = "Newton–Raphson: f(x) = (x²−2)sin(x²−2)  (double root p = √2)"

# --- Pre-compute Newton iterates ---
xs = Vector{Float64}(undef, n_iters + 1)
xs[1] = x0
for i in 1:n_iters
    dfi = df(xs[i])
    if abs(dfi) < 1e-14
        xs[i+1:end] .= xs[i]
        break
    end
    xs[i+1] = xs[i] - f(xs[i]) / dfi
end

# --- Build Newton tangent-line path ---
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

    hline!([0.0]; color=:black, lw=1, label="")
    plot!(xplot, f.(xplot); color=:magenta, lw=2, label="y = f(x)")

    n_pts = 1 + 2 * frame
    if n_pts >= 2
        plot!(path_x[1:n_pts], path_y[1:n_pts];
              color=:steelblue, lw=1.5, label="")
    end

    x_cur = xs[frame + 1]
    err   = abs(x_cur - root)
    scatter!([x_cur], [0.0]; color=:red, ms=6, markershape=:circle,
             label="x_$(frame) = $(round(x_cur; digits=6)),  err = $(round(err; digits=6))")
end

gif(anim, joinpath(@__DIR__, "aitkencc.gif"); fps=2)
println("Saved: aitkencc.gif")
