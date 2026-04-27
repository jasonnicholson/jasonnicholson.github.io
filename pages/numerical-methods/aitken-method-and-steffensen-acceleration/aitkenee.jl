# aitkenee.jl
# Aitken/Steffensen animation: Example 5
# Newton-Raphson tangent-line animation on f(x) = x^6 - 7x^4 + 15x^2 - 9
# f(x) = (x^2 - 1)(x^2 - 3)^2 — double root at p = sqrt(3).
# Demonstrates slow (linear) convergence of Newton at a multiple root.
# Produces: aitkenee.gif

using Plots
gr()

# --- Function and derivative ---
f(x)  = x^6 - 7x^4 + 15x^2 - 9
df(x) = 6x^5 - 28x^3 + 30x

# --- Parameters ---
x0      = 1.5
root    = sqrt(3.0)
n_iters = 18
xlims   = (0.6, 2.6)
ylims   = (-2.5, 4.5)
title_str = "Newton–Raphson: f(x) = x⁶−7x⁴+15x²−9  (double root p = √3)"

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

gif(anim, joinpath(@__DIR__, "aitkenee.gif"); fps=2)
println("Saved: aitkenee.gif")
