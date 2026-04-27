# bisectionbb.jl
# Bisection Method animation: f(x) = tan(x), interval [1, 2]
# Cautionary case: sign change on [1,2] is due to the asymptote at π/2 ≈ 1.5708,
# not a true root. Bisection converges to the discontinuity.
# Produces: bisectionbb.gif

using Plots
gr()

# --- Parameters ---
f(x) = tan(x)
a0, b0 = 1.0, 2.0
n_iters = 12

xlims = (0.0, 2.2)
ylims = (-15.0, 15.0)

title_str = "Bisection Method: f(x) = tan(x)  [cautionary case]"

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

# --- Backdrop curve (clip near asymptote to avoid visual spike) ---
xraw = range(xlims[1], xlims[2], length=2000)
# Build segments split at the asymptote π/2
pi_half = π / 2
gap = 0.02   # exclude x within ±gap of asymptote
left_mask  = xraw .< (pi_half - gap)
right_mask = xraw .> (pi_half + gap)

xplot_left  = collect(xraw[left_mask])
yplot_left  = tan.(xplot_left)
xplot_right = collect(xraw[right_mask])
yplot_right = tan.(xplot_right)

# Clip y values to ylims for clean rendering
clamp_y(v) = clamp(v, ylims[1], ylims[2])

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

    # Asymptote marker
    vline!([pi_half]; color=:orange, lw=1, ls=:dash, label="asymptote x = π/2")

    # y = 0 reference
    hline!([0.0]; color=:black, lw=1, label="")

    # f(x) = tan(x) in two segments
    plot!(xplot_left,  clamp_y.(yplot_left);  color=:magenta, lw=2, label="y = tan(x)")
    plot!(xplot_right, clamp_y.(yplot_right); color=:magenta, lw=2, label="")

    # Current bracket as vertical lines
    vline!([a_cur, b_cur]; color=:steelblue, lw=1.5, ls=:dash, label="bracket [a, b]")

    # Shaded bracket region
    bracket_xs = [a_cur, b_cur, b_cur, a_cur, a_cur]
    bracket_ys = [ylims[1], ylims[1], ylims[2], ylims[2], ylims[1]]
    plot!(bracket_xs, bracket_ys; fill=true, fillalpha=0.08, fillcolor=:steelblue,
          lw=0, label="")

    if frame > 0
        # Previous midpoints as small gray dots
        for k in 1:(frame - 1)
            fv = clamp_y(f(cs[k]))
            scatter!([cs[k]], [fv]; color=:gray, ms=4, label="", alpha=0.5)
        end
        # Current midpoint (large red dot on curve)
        c_cur = cs[frame]
        fv_cur = clamp_y(f(c_cur))
        scatter!([c_cur], [fv_cur]; color=:red, ms=8,
                 label="c_$(frame) = $(round(c_cur; digits=6))")
        plot!([c_cur, c_cur], [0.0, fv_cur]; color=:red, lw=1, ls=:dot, label="")
        scatter!([c_cur], [0.0]; color=:red, ms=5, marker=:diamond, label="")
    else
        annotate!(
            (a_cur + b_cur) / 2, ylims[2] * 0.85,
            text("Initial bracket [$(a_cur), $(b_cur)]", :center, 9, :steelblue)
        )
    end
end

gif(anim, joinpath(@__DIR__, "bisectionbb.gif"); fps=2)
println("Saved: bisectionbb.gif")
