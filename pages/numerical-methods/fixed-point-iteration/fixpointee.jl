# fixpointee.jl
# Fixed Point Iteration animation: g(x) = x^2/4 + x/2, x0 = 2.5
# Divergent case starting above the fixed point x* = 2
# |g'(2)| = 3/2 > 1, staircase walks rightward away from fixed point and diverges;
# x_3 = 4.5544 already leaves the window, so x_3 and x_4 are shown off-scale
# Produces: fixpointee.gif

using Plots
gr()

# --- Parameters ---
g(x) = x^2 / 4 + x / 2
x0 = 2.5
n_iters = 4   # x_3 = 4.5544 and x_4 = 7.4628 are off-scale

xlims = (0.0, 4.0)
ylims = (0.0, 4.0)

title_str = "Fixed Point Iteration: g(x) = x²/4 + x/2, x₀ = 2.5"

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
        legend      = :topleft,
        grid        = true,
        framestyle  = :box,
        background_color = :white,
    )

    plot!(collect(xlims), collect(xlims); color=:green,   lw=2, label="y = x")
    plot!(xplot, g.(xplot);               color=:magenta, lw=2, label="y = g(x) = x²/4 + x/2")

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

gif(anim, joinpath(@__DIR__, "fixpointee.gif"); fps=2)
println("Saved: fixpointee.gif")
