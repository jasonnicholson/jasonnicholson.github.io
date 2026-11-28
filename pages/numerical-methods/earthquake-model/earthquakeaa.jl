# earthquakeaa.jl
# Earthquake Model animation: Mathews' Example 2. The six-floor building of
# Example 1 (k/m = 8) shaken by the ground motion e cos(wt) with w = 2.1 rad/s
# and e = 0.075 ft. The forced solution X(t) = v cos(wt), where v solves
# (w^2 I + a) v = -e w^2 b (the matrix Mathews' code builds), is the motion of
# the floors relative to the ground when X(0) = v and X'(0) = 0.
# Left (new): the building in fixed coordinates. The ground is at e cos(wt) and
# floor i at e cos(wt) + X_i(t) = (v_i + e) cos(wt); a gray bar shows the range
# of each floor and of the ground. Right: Mathews' plot, floor i drawn at
# x = i + X_i(t) for 0 <= t <= 10 with time on the vertical axis, his colours
# (Blue, Red, Brown, Magenta, Green, Orange, with his Green darkened for
# legibility) and the rest lines x = 1, ..., 6 (his Cyan, darkened), grown in
# time, with a dot at the current time on each curve.
# Produces: earthquakeaa.gif

using Plots
using Printf
using LinearAlgebra
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))

# --- Parameters (Mathews' Examples 1 and 2) ---
gif_name = "earthquakeaa.gif"
n, c   = 6, 8.0                                      # floors, k/m = 10000/1250
w, e   = 2.1, 0.075                                  # earthquake frequency (rad/s), amplitude (ft)
A      = Matrix(SymTridiagonal([fill(-2c, n - 1); -c], fill(c, n - 1)))
b      = ones(n)
v      = (w^2 * I + A) \ (-e * w^2 * b)              # floor amplitudes relative to the ground
vabs   = v .+ e                                      # amplitudes in fixed coordinates
mcol   = [RGB(0, 0, 1), RGB(1, 0, 0), RGB(0.647, 0.165, 0.165), RGB(1, 0, 1),
          RGB(0, 0.75, 0), RGB(1, 0.5, 0)]           # Blue, Red, Brown, Magenta, Green, Orange
rest_col = RGB(0, 0.7, 0.7)                          # Mathews' Cyan, darkened
ts     = (0:100) ./ 10                               # frame times 0, 0.1, ..., 10 s
xlimL  = (-0.42, 0.42)
xlimR  = (0.5, 6.5)
title_str = "Earthquake model, Example 2:  ground motion e cos(ωt), ω = 2.1 rad/s, e = 0.075 ft;  " *
            "forced solution X(t) = v cos(ωt)"

println("v = ", v)
println("v + e = ", vabs)
println("residual = ", maximum(abs.((w^2 * I + A) * v .+ e * w^2 * b)))

frame_title(t) = "t = $(fmt(t)) s:  ground at e cos(ωt) = $(fmt(e * cos(w * t))) ft"

function draw_frame(t)
    ct = cos(w * t)
    # Left: the building in fixed coordinates
    pL = plot(xlims=xlimL, ylims=(-0.5, 6.6), framestyle=:box, grid=true,
              xlabel="horizontal position (ft), fixed coordinates",
              yticks=(0:6, ["ground"; ["floor $i" for i in 1:n]]),
              legend=:bottomleft, legendfontsize=8, titlefontsize=10)
    vline!(pL, [0.0]; color=:gray40, ls=:dot, lw=1, label="rest position")
    for i in 0:n
        r = i == 0 ? e : abs(vabs[i])
        plot!(pL, [-r, r], [i, i]; color=:gray80, lw=7, label=i == 0 ? "range of each level" : "")
    end
    xs = [e * ct; vabs .* ct]
    plot!(pL, xs, 0:n; color=:gray30, lw=2, label="columns")
    scatter!(pL, [e * ct], [0]; color=:black, marker=:rect, ms=9, label="ground")
    for i in 1:n
        scatter!(pL, [xs[i+1]], [i]; color=mcol[i], marker=:rect, ms=9, msw=0, label="")
    end
    title!(pL, frame_title(t))

    # Right: Mathews' plot x = i + X_i(t), time vertical, grown up to t
    # Drawn view: Mathews' time interval [0, 10] plus a small margin at each end, so
    # that the dots at t = 0 and t = 10 show in full
    pR = plot(xlims=xlimR, ylims=(-0.15, 10.15), framestyle=:box, grid=true,
              xlabel="x = i + Xᵢ(t)  (ft)", ylabel="t (s)", xticks=1:6, yticks=0:2:10,
              legend=false, titlefontsize=10)
    vline!(pR, 1:n; color=rest_col, lw=1)
    tt = range(0, t, length=max(2, round(Int, 200t) + 1))
    for i in 1:n
        plot!(pR, i .+ v[i] .* cos.(w .* tt), tt; color=mcol[i], lw=1.8)
        scatter!(pR, [i + v[i] * ct], [t]; color=mcol[i], ms=4, msw=0)
    end
    title!(pR, "Mathews' plot, relative to the ground (rest lines x = 1, …, 6)")

    plot(pL, pR; layout=(1, 2), size=(1100, 560), plot_title=title_str,
         plot_titlefontsize=11, left_margin=4Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white)
end

for (j, t) in enumerate(ts)
    println("FRAME ", j - 1, " | ", frame_title(t))
end

anim = Animation()
for t in ts
    draw_frame(t)
    frame(anim)
end
for _ in 1:10                                        # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=10)
println("Saved: ", gif_name)
