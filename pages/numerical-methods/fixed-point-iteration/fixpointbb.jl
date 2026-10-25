# fixpointbb.jl
# Fixed Point Iteration animation: g(x) = sqrt(2x), x0 = 3.8
# Convergent case starting above the fixed point: staircase descends to x* = 2
# Produces: fixpointbb.gif

using Plots
gr()

# --- Parameters ---
g(x) = sqrt(2x)
x0 = 3.8
n_iters = 12

xlims = (0.0, 4.0)
ylims = (0.0, 4.0)

title_str = "Fixed Point Iteration: g(x) = √(2x), x₀ = 3.8"

# --- Pre-compute iterates ---
xs = Vector{Float64}(undef, n_iters + 1)
xs[1] = x0
for i in 1:n_iters
    xs[i+1] = g(xs[i])
end

# --- Cobweb path ---
cobweb_x = [xs[1]]
cobweb_y = [xs[1]]
for i in 1:n_iters
    push!(cobweb_x, xs[i],   xs[i+1])
    push!(cobweb_y, xs[i+1], xs[i+1])
end

# --- Backdrop ---
xplot = range(xlims[1], xlims[2], length=400)

# --- Animation ---
anim = @animate for frame in 0:n_iters
    plot(
        size        = (600, 600),
        xlims       = xlims,
        ylims       = ylims,
        xlabel      = "x",
        ylabel      = "y",
        title       = title_str,
        legend      = :topleft,
        grid        = true,
        framestyle  = :box,
        background_color = :white,
    )

    plot!(collect(xlims), collect(xlims); color=:green,   lw=2, label="y = x")
    plot!(xplot, g.(xplot);               color=:magenta, lw=2, label="y = g(x) = √(2x)")

    n_pts = 1 + 2*frame
    if n_pts >= 2
        plot!(cobweb_x[1:n_pts], cobweb_y[1:n_pts]; color=:steelblue, lw=1.5, label="")
    end

    x_cur = xs[frame+1]
    scatter!([x_cur], [x_cur]; color=:red, ms=6,
             label="x_$(frame) = $(round(x_cur; digits=4))")
end

gif(anim, joinpath(@__DIR__, "fixpointbb.gif"); fps=2)
println("Saved: fixpointbb.gif")
