# bisectionaa.jl
# Bisection Method animation: f(x) = x^3 + 4x^2 - 10, interval [1, 2]
# True root ≈ 1.3652. Each frame advances one bisection step.
# Top panel: full view. Bottom panel: zoom on the bracket before the step,
# so the halving stays visible after the bracket is narrower than a pixel
# in the full view.
# Produces: bisectionaa.gif

using Plots
using Printf
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

# Shaded bracket region between x = a and x = b over the y-range ys
function shade_bracket!(p, a, b, ys)
    plot!(p, [a, b, b, a, a], [ys[1], ys[1], ys[2], ys[2], ys[1]]; fill=true,
          fillalpha=0.08, fillcolor=:steelblue, lw=0, label="")
end

# --- Animation ---
anim = @animate for frame in 0:n_iters
    a_cur = as[frame + 1]
    b_cur = bs[frame + 1]

    # ---------------- Top panel: full view ----------------
    p1 = plot(
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
    hline!(p1, [0.0]; color=:black, lw=1, label="")

    # f(x) curve
    plot!(p1, xplot, f.(xplot); color=:magenta, lw=2, label="y = f(x) = x³ + 4x² − 10")

    # Current bracket as vertical lines
    vline!(p1, [a_cur, b_cur]; color=:steelblue, lw=1.5, ls=:dash, label="bracket [a, b]")

    # Shaded bracket region
    shade_bracket!(p1, a_cur, b_cur, ylims)

    if frame > 0
        # Previous midpoints as small gray dots on curve
        for k in 1:(frame - 1)
            scatter!(p1, [cs[k]], [f(cs[k])]; color=:gray, ms=4, label="", alpha=0.5)
        end
        # Current midpoint (large red dot on curve)
        c_cur = cs[frame]
        scatter!(p1, [c_cur], [f(c_cur)]; color=:red, ms=8,
                 label="c_$(frame) = $(round(c_cur; digits=6))")
        # Vertical drop from curve to x-axis
        plot!(p1, [c_cur, c_cur], [0.0, f(c_cur)]; color=:red, lw=1, ls=:dot, label="")
        # Midpoint on x-axis
        scatter!(p1, [c_cur], [0.0]; color=:red, ms=5, marker=:diamond, label="")
    else
        # Frame 0: just annotate the initial bracket
        annotate!(p1,
            (a_cur + b_cur) / 2, ylims[2] * 0.85,
            text("Initial bracket [$(a_cur), $(b_cur)]", :center, 9, :steelblue)
        )
    end

    # ---------------- Bottom panel: zoom ----------------
    # Window: the bracket before this step (frame 0: the initial bracket),
    # padded by 10% of its width on each side.
    a_prev = as[max(frame, 1)]
    b_prev = bs[max(frame, 1)]
    w_prev = b_prev - a_prev
    zx = (a_prev - 0.1 * w_prev, b_prev + 0.1 * w_prev)
    xz = range(zx[1], zx[2], length=400)
    yz_pts = frame > 0 ? [f(a_prev), f(cs[frame]), f(b_prev)] : [f(a_prev), f(b_prev)]
    ylo = min(minimum(f.(xz)), minimum(yz_pts), 0.0)
    yhi = max(maximum(f.(xz)), maximum(yz_pts), 0.0)
    zy = (ylo - 0.1 * (yhi - ylo), yhi + 0.1 * (yhi - ylo))

    zoom_title = frame == 0 ?
        "Zoom: initial bracket [$(a_prev), $(b_prev)]" :
        "Zoom: step $(frame) halves [a, b] of width $(w_prev)"

    p2 = plot(
        xlims       = zx,
        ylims       = zy,
        xlabel      = "x",
        ylabel      = "y",
        title       = zoom_title,
        titlefontsize = 11,
        legend      = :topleft,
        grid        = true,
        framestyle  = :box,
        background_color = :white,
        xrotation   = 20,
        # Fixed-width y tick labels (sign, 3 significant figures, exponent), so the
        # left edge shared by both panels does not move from frame to frame.
        yformatter  = y -> @sprintf("%+.2e", y),
    )
    hline!(p2, [0.0]; color=:black, lw=1, label="")
    plot!(p2, xz, f.(xz); color=:magenta, lw=2, label="")
    if frame > 0
        vline!(p2, [a_prev, b_prev]; color=:gray, lw=1.5, ls=:dash,
               label="[a, b] before step $(frame)")
    end
    vline!(p2, [a_cur, b_cur]; color=:steelblue, lw=1.5, ls=:dash,
           label=frame > 0 ? "[a, b] after step $(frame)" : "bracket [a, b]")
    shade_bracket!(p2, a_cur, b_cur, zy)
    if frame > 0
        c_cur = cs[frame]
        plot!(p2, [c_cur, c_cur], [0.0, f(c_cur)]; color=:red, lw=1, ls=:dot, label="")
        scatter!(p2, [c_cur], [f(c_cur)]; color=:red, ms=7, label="")
        scatter!(p2, [c_cur], [0.0]; color=:red, ms=5, marker=:diamond, label="")
    end

    plot(p1, p2; layout=grid(2, 1, heights=[0.55, 0.45]), size=(600, 980),
         left_margin=9Plots.mm)
end

gif(anim, joinpath(@__DIR__, "bisectionaa.gif"); fps=2)
println("Saved: bisectionaa.gif")
