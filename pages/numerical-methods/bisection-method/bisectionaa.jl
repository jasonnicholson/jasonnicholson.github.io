# bisectionaa.jl
# Bisection Method animation: f(x) = x^3 + 4x^2 - 10, interval [1, 2]
# True root ≈ 1.3688. Each frame advances one bisection step.
# Produces: bisectionaa.gif

using Plots
gr()

# --- Parameters ---
f(x) = x^3 + 4x^2 - 10
a0, b0 = 1.0, 2.0
n_iters = 12

xlims = (-1.0, 2.2)
ylims = (-12.0, 16.0)

title_str = "Bisection Method: f(x) = x³ + 4x² − 10"

# --- Pre-compute bisection steps ---
as = Vector{Float64}(undef, n_iters + 1)
bs = Vector{Float64}(undef, n_iters + 1)
cs = Vector{Float64}(undef, n_iters)
as[1] = a0
bs[1] = b0
for i in 1:n_iters
    c = (as[i] + bs[i]) / 2
    cs[i] = c
    if f(as[i]) * f(c) < 0
        as[i+1] = as[i]
        bs[i+1] = c
    else
        as[i+1] = c
        bs[i+1] = bs[i]
    end
end

# --- Backdrop curve ---
xplot = range(xlims[1], xlims[2], length=500)

# --- Animation ---
anim = @animate for frame in 0:n_iters
    a_cur = as[frame + 1]
    b_cur = bs[frame + 1]

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

    # y = 0 reference
    hline!([0.0]; color=:black, lw=1, label="")

    # f(x) curve
    plot!(xplot, f.(xplot); color=:magenta, lw=2, label="y = f(x) = x³ + 4x² − 10")

    # Current bracket as vertical lines
    vline!([a_cur, b_cur]; color=:steelblue, lw=1.5, ls=:dash, label="bracket [a, b]")

    # Shaded bracket region
    bracket_xs = [a_cur, b_cur, b_cur, a_cur, a_cur]
    bracket_ys = [ylims[1], ylims[1], ylims[2], ylims[2], ylims[1]]
    plot!(bracket_xs, bracket_ys; fill=true, fillalpha=0.08, fillcolor=:steelblue,
          lw=0, label="")

    if frame > 0
        # Previous midpoints as small gray dots on curve
        for k in 1:(frame - 1)
            scatter!([cs[k]], [f(cs[k])]; color=:gray, ms=4, label="", alpha=0.5)
        end
        # Current midpoint (large red dot on curve)
        c_cur = cs[frame]
        scatter!([c_cur], [f(c_cur)]; color=:red, ms=8,
                 label="c_$(frame) = $(round(c_cur; digits=6))")
        # Vertical drop from curve to x-axis
        plot!([c_cur, c_cur], [0.0, f(c_cur)]; color=:red, lw=1, ls=:dot, label="")
        # Midpoint on x-axis
        scatter!([c_cur], [0.0]; color=:red, ms=5, marker=:diamond, label="")
    else
        # Frame 0: just annotate the initial bracket
        annotate!(
            (a_cur + b_cur) / 2, ylims[2] * 0.85,
            text("Initial bracket [$(a_cur), $(b_cur)]", :center, 9, :steelblue)
        )
    end
end

gif(anim, joinpath(@__DIR__, "bisectionaa.gif"); fps=2)
println("Saved: bisectionaa.gif")
