# bisectionbb.jl
# Bisection Method animation: f(x) = tan(x), interval [1, 2]
# Cautionary case: sign change on [1,2] is due to the asymptote at π/2 ≈ 1.5708,
# not a true root. Bisection converges to the discontinuity.
# Top panel: full view. Bottom panel: zoom on the bracket before the step,
# so the halving stays visible after the bracket is narrower than a pixel
# in the full view.
# Produces: bisectionbb.gif

using Plots
using Printf
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
        titlefontsize = 12,   # full title fits above the plot area
        legend      = :topleft,
        grid        = true,
        framestyle  = :box,
        background_color = :white,
    )

    # Asymptote marker
    vline!(p1, [pi_half]; color=:orange, lw=1, ls=:dash, label="asymptote x = π/2")

    # y = 0 reference
    hline!(p1, [0.0]; color=:black, lw=1, label="")

    # f(x) = tan(x) in two segments
    plot!(p1, xplot_left,  clamp_y.(yplot_left);  color=:magenta, lw=2, label="y = tan(x)")
    plot!(p1, xplot_right, clamp_y.(yplot_right); color=:magenta, lw=2, label="")

    # Current bracket as vertical lines
    vline!(p1, [a_cur, b_cur]; color=:steelblue, lw=1.5, ls=:dash, label="bracket [a, b]")

    # Shaded bracket region
    shade_bracket!(p1, a_cur, b_cur, ylims)

    if frame > 0
        # Previous midpoints as small gray dots
        for k in 1:(frame - 1)
            fv = clamp_y(f(cs[k]))
            scatter!(p1, [cs[k]], [fv]; color=:gray, ms=4, label="", alpha=0.5)
        end
        # Current midpoint (large red dot on curve)
        c_cur = cs[frame]
        fv_cur = clamp_y(f(c_cur))
        scatter!(p1, [c_cur], [fv_cur]; color=:red, ms=8,
                 label="c_$(frame) = $(round(c_cur; digits=6))")
        plot!(p1, [c_cur, c_cur], [0.0, fv_cur]; color=:red, lw=1, ls=:dot, label="")
        scatter!(p1, [c_cur], [0.0]; color=:red, ms=5, marker=:diamond, label="")
    else
        annotate!(p1,
            (a_cur + b_cur) / 2, ylims[2] * 0.85,
            text("Initial bracket [$(a_cur), $(b_cur)]", :center, 9, :steelblue)
        )
    end

    # ---------------- Bottom panel: zoom ----------------
    # Window: the bracket before this step (frame 0: the initial bracket),
    # padded by 10% of its width on each side. The y-range is symmetric,
    # ±1.1 × the largest |f| at the window ends and the midpoint, so the
    # midpoint is drawn at its true (unclamped) value; the curve leaves the
    # panel near the asymptote.
    a_prev = as[max(frame, 1)]
    b_prev = bs[max(frame, 1)]
    w_prev = b_prev - a_prev
    zx = (a_prev - 0.1 * w_prev, b_prev + 0.1 * w_prev)
    xz = range(zx[1], zx[2], length=2000)
    zgap = 0.002 * w_prev
    xz_left  = collect(xz[xz .< pi_half - zgap])
    xz_right = collect(xz[xz .> pi_half + zgap])
    yz_pts = [f(zx[1]), f(zx[2])]
    frame > 0 && push!(yz_pts, f(cs[frame]))
    ymax = 1.1 * maximum(abs.(yz_pts))
    zy = (-ymax, ymax)

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
    vline!(p2, [pi_half]; color=:orange, lw=1, ls=:dash, label="")
    hline!(p2, [0.0]; color=:black, lw=1, label="")
    plot!(p2, xz_left,  f.(xz_left);  color=:magenta, lw=2, label="")
    plot!(p2, xz_right, f.(xz_right); color=:magenta, lw=2, label="")
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

gif(anim, joinpath(@__DIR__, "bisectionbb.gif"); fps=2)
println("Saved: bisectionbb.gif")
