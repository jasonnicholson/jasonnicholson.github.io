# fixpointff.jl
# Fixed Point Iteration animation: g(x) = -x^2/4 - x/2 + 4, x0 = 1.5
# Oscillating, does not converge: g'(2) = -3/2, |g'(2)| > 1 so x* = 2 repels and the
# staircase moves away from it, alternating sides; the orbit stays bounded and settles
# onto an attracting 4-cycle ~ {4.25, -2.64, 3.58, -0.99}
# Produces: fixpointff.gif

using Plots
gr()

# --- Parameters ---
g(x) = -x^2 / 4 - x / 2 + 4
x0 = 1.5
n_iters = 16

# window holds the whole true orbit (it stays in [-2.641, 4.250]). Nothing is drawn where
# x > -3.3125 and y < -3.3125: the min of g on the window is g(4.5) = -3.3125, y = x is
# below -3.3125 only for x < -3.3125, and the orbit's min is -2.641. So the legend goes
# bottom-right.
xlims = (-4.5, 4.5)
ylims = (-4.5, 4.5)

title_str = "Fixed Point Iteration: g(x) = −x²/4 − x/2 + 4, x₀ = 1.5"

# --- Pre-compute iterates ---
# xs holds the true iterates. Every g evaluation, cobweb vertex and label uses them;
# nothing is clamped in the computation. Path segments that leave the window are
# clipped by the axes. Only the red marker of an off-scale iterate is drawn clamped,
# just inside the window edge (xlims == ylims, so it stays on y = x), as a hollow
# triangle with an "off-scale" note; its legend label keeps the true value.
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
        legend      = :bottomright,
        grid        = true,
        framestyle  = :box,
        background_color = :white,
    )

    plot!(collect(xlims), collect(xlims); color=:green,   lw=2, label="y = x")
    plot!(xplot, g.(xplot);               color=:magenta, lw=2, label="y = g(x) = −x²/4 − x/2 + 4")

    n_pts = 1 + 2*frame
    if n_pts >= 2
        plot!(cobweb_x[1:n_pts], cobweb_y[1:n_pts]; color=:steelblue, lw=1.5, label="")
    end

    x_cur = xs[frame+1]
    if xlims[1] <= x_cur <= xlims[2]
        scatter!([x_cur], [x_cur]; color=:red, ms=6,
                 label="x_$(frame) = $(round(x_cur; digits=4))")
    else
        # off-scale: draw the marker just inside the window edge (clamped position
        # only), pointing towards the true value, and keep the true value in the label
        up = x_cur > xlims[2]
        inset = 0.03 * (xlims[2] - xlims[1])
        x_draw = up ? xlims[2] - inset : xlims[1] + inset
        scatter!([x_draw], [x_draw]; color=:white, markerstrokecolor=:red,
                 markerstrokewidth=2, ms=9, marker = up ? :utriangle : :dtriangle,
                 label="x_$(frame) = $(round(x_cur; digits=4)) (off-scale, marker at edge)")
        annotate!(x_draw + (up ? -inset : inset), x_draw,
                  text(up ? "off-scale ↑" : "off-scale ↓", 9, :red, up ? :right : :left))
    end
end

gif(anim, joinpath(@__DIR__, "fixpointff.gif"); fps=2)
println("Saved: fixpointff.gif")
