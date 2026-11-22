# fixpointaa.jl
# Fixed Point Iteration animation: g(x) = sqrt(2x), x0 = 0.1
# Convergent case: |g'(x*)| = 1/2 < 1 at fixed point x* = 2
# Produces: fixpointaa.gif (cobweb/staircase diagram)

using Plots
gr()

# --- Parameters ---
g(x) = sqrt(2x)
x0 = 0.1
n_iters = 12

xlims = (0.0, 4.0)
ylims = (0.0, 4.0)

# --- Pre-compute iteration values ---
xs = Vector{Float64}(undef, n_iters + 1)
xs[1] = x0
for i in 1:n_iters
    xs[i+1] = g(xs[i])
end

# --- Build cobweb path ---
# Path starts at (x0, x0) on the diagonal, then alternates:
#   vertical step:   (xn, xn) → (xn, g(xn))
#   horizontal step: (xn, g(xn)) → (g(xn), g(xn))
cobweb_x = [xs[1]]
cobweb_y = [xs[1]]
for i in 1:n_iters
    xn  = xs[i]
    xn1 = xs[i+1]
    push!(cobweb_x, xn,  xn1)   # vertical then horizontal x-coords
    push!(cobweb_y, xn1, xn1)   # vertical then horizontal y-coords
end
# cobweb has 1 + 2*n_iters points; frame k shows points 1:(1 + 2*k)

# --- Backdrop curves ---
xplot = range(xlims[1], xlims[2], length=400)
gvals = g.(xplot)

# --- Animation ---
anim = @animate for frame in 0:n_iters
    plot(
        size        = (600, 600),
        xlims       = xlims,
        ylims       = ylims,
        xlabel      = "x",
        ylabel      = "y",
        title       = "Fixed Point Iteration: g(x) = √(2x)",
        legend      = :topleft,
        grid        = true,
        framestyle  = :box,
        background_color = :white,
    )

    # y = x diagonal
    plot!(collect(xlims), collect(xlims);
          color = :green, lw = 2, label = "y = x")

    # y = g(x) curve
    plot!(xplot, gvals;
          color = :magenta, lw = 2, label = "y = g(x) = √(2x)")

    # Cobweb path so far
    n_pts = 1 + 2 * frame
    if n_pts >= 2
        plot!(cobweb_x[1:n_pts], cobweb_y[1:n_pts];
              color = :steelblue, lw = 1.5, label = "")
    end

    # Current iterate marker
    x_current = xs[frame + 1]
    label_str = frame == 0 ? "x₀ = $(round(x_current; digits=4))" :
                             "x_$(frame) = $(round(x_current; digits=4))"
    scatter!([x_current], [x_current];
             color = :red, ms = 6, label = label_str)
end

gif(anim, joinpath(@__DIR__, "fixpointaa.gif"); fps = 2)
println("Saved: fixpointaa.gif")
