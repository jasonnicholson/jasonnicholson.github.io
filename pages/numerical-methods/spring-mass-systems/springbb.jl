# springbb.jl
# Spring-Mass Systems animation: Mathews' Example 5 (one wall, free right end),
#   x'' = -8x + 4y,  sqrt(2) y'' = 4x - 4y   (m1 = 1, m2 = sqrt(2), k1 = k2 = 4).
# Three motions run side by side on the same clock, 0 <= t <= 10*pi (Mathews' window):
#   column 1: the first natural mode,  x = cos(w1 t), y = (1 - sqrt2) x, with the
#             corrected frequency w1 = 2 sqrt(1 + sqrt2) (Mathews printed half of it),
#   column 2: the second natural mode, x = cos(w2 t), y = (1 + sqrt2/2) x,
#             w2 = sqrt(4 - 2 sqrt2),
#   column 3: the combination a1 = a2 = b1 = b2 = 1 (Mathews' choice in Example 6;
#             he plots no combination for Example 5).
# Each column shows the two blocks on their springs (top, new; wall and spring
# lengths schematic) above Mathews' space-time picture: m1 at 2 + x(t), m2 at
# 6 + y(t), time running up the page, his colours and his vertical lines at 2 and 6.
# Right column (new): the combination in the (x, y) plane, inside the
# parallelogram |u1|, |u2| <= sqrt(2) of its two mode components
# u_j = cos(w_j t) + sin(w_j t), and the combination against time.
# The motion is the exact solution (4) of the page; there is no numerical method.
# Produces: springbb.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))
# Closed-form positions are accurate to about 1e-14; smaller magnitudes are exact zeros
fmtv(x) = fmt(abs(x) < 1e-12 ? 0.0 : x)
piticks(T, step) = (collect(step:step:T+1e-9),
                    [k == 1 ? "π" : "$(k)π" for k in round.(Int, collect(step:step:T+1e-9) ./ π)])

# --- Parameters (Example 5) ---
m1, m2, k1, k2, k3 = 1.0, sqrt(2.0), 4.0, 4.0, 0.0
Tend     = 10π                              # Mathews' window [0, 10π]
tickstep = 2π                               # his time ticks
nfr      = 160                              # frames over [0, Tend]
sub      = 16                               # trace samples per frame
fps      = 12
outname  = "springbb.gif"
title_main = "Spring-Mass Systems, Mathews' Example 5 (free right end):  m₁ = 1,  m₂ = √2,  " *
             "k₁ = k₂ = 4  (x″ = −8x + 4y,  √2 y″ = 4x − 4y)"
title1 = "x = cos ω₁t: opposite directions"
title2 = "x = cos ω₂t: same direction"
title3 = "quasi-periodic: never repeats"
lines8 = Tuple{Int,Symbol}[]                # one-wall pictures: lines at 2 and 6 only
CL     = 3.3                                # (x, y) plane: [-CL, CL]²
legpos = :topleft
config_title(t) = "the curve never closes (ω₁/ω₂ = $(fmt(ω1 / ω2)))"
tylims = (-3.2, 3.2)
tmarks = Float64[]
tmarks_label = ""

# --- Natural frequencies from the characteristic equation (9), as a quadratic in s = r² ---
qa = m1 * m2
qb = m1 * (k2 + k3) + m2 * (k1 + k2)
qc = k1 * k2 + k1 * k3 + k2 * k3
disc = sqrt(qb^2 - 4qa * qc)
s1, s2 = (-qb - disc) / (2qa), (-qb + disc) / (2qa)   # s1 < s2 < 0
ω1, ω2 = sqrt(-s1), sqrt(-s2)
ρ1 = (k1 + k2 - m1 * ω1^2) / k2                       # ratios (5)
ρ2 = (k1 + k2 - m1 * ω2^2) / k2
ratio_label(ρ) = isapprox(ρ, 1; atol=1e-12) ? "x" : isapprox(ρ, -1; atol=1e-12) ? "−x" : fmt(ρ) * "x"
line1, line2 = ratio_label(ρ1), ratio_label(ρ2)      # y = ρ_j x in each mode

# --- The three motions (exact solution (4)) ---
mode1(t) = (cos(ω1 * t), ρ1 * cos(ω1 * t))
mode2(t) = (cos(ω2 * t), ρ2 * cos(ω2 * t))
u1(t) = cos(ω1 * t) + sin(ω1 * t)                     # a1 = a2 = 1
u2(t) = cos(ω2 * t) + sin(ω2 * t)                     # b1 = b2 = 1
combo(t) = (u1(t) + u2(t), ρ1 * u1(t) + ρ2 * u2(t))

ts = range(0, Tend, length=nfr * sub + 1)
M1 = mode1.(ts); M2 = mode2.(ts); C = combo.(ts)
X1, Y1 = first.(M1), last.(M1)
X2, Y2 = first.(M2), last.(M2)
XC, YC = first.(C), last.(C)

# Residual of the equations of motion (7) along the combination (central differences)
h = 1e-4
res = maximum(abs.([begin
    xpp = (combo(t + h)[1] - 2combo(t)[1] + combo(t - h)[1]) / h^2
    ypp = (combo(t + h)[2] - 2combo(t)[2] + combo(t - h)[2]) / h^2
    x, y = combo(t)
    max(abs(m1 * xpp - (-k1 * x + k2 * (y - x))), abs(m2 * ypp - (-k2 * (y - x) - k3 * y)))
end for t in range(0.1, Tend, length=200)]))
@printf("ω1 = %.10f, ω2 = %.10f, ρ1 = %.10f, ρ2 = %.10f, ω1/ω2 = %.10f\n", ω1, ω2, ρ1, ρ2, ω1 / ω2)
@printf("combination: x in [%.6f, %.6f], y in [%.6f, %.6f] (sampled)\n", extrema(XC)..., extrema(YC)...)
@printf("combination: max |(x, y)(t + 2π) - (x, y)(t)| = %.3e\n",
        maximum(abs.(collect(Iterators.flatten(combo.(ts .+ 2π))) .- collect(Iterators.flatten(C)))))
@printf("max residual of (7) along the combination (finite differences) = %.2e\n", res)
@printf("block separation 4 + y - x: min %.4f (mode 1), %.4f (mode 2), %.4f (combination)\n",
        minimum(4 .+ Y1 .- X1), minimum(4 .+ Y2 .- X2), minimum(4 .+ YC .- XC))

# --- Drawing helpers ---
const XL = (-2.6, 10.6)                     # horizontal range of every space-time column
const WL, WR = -2.2, 10.2                    # schematic walls
const BW = 0.4                              # block width
ymech = 1.16Tend                            # height of the blocks above the picture
BH = 0.075Tend                              # block height

function spring!(p, xa, xb, yc; n=7, amp=0.022Tend, color=:gray30)
    L = xb - xa
    xs = [xa, xa + 0.12L]
    ys = [yc, yc]
    for i in 1:2n
        push!(xs, xa + 0.12L + 0.76L * (i - 0.5) / (2n))
        push!(ys, yc + (isodd(i) ? amp : -amp))
    end
    push!(xs, xa + 0.88L, xb); push!(ys, yc, yc)
    plot!(p, xs, ys; color=color, lw=1.2, label="")
end

function wall!(p, xw, side)
    plot!(p, [xw, xw], [ymech - 1.6BH, ymech + 1.6BH]; color=:black, lw=2.5, label="")
    d = side == :left ? -0.35 : 0.35
    for yh in range(ymech - 1.5BH, ymech + 1.3BH, length=7)
        plot!(p, [xw, xw + d], [yh, yh + 0.3BH]; color=:black, lw=1, label="")
    end
end

block!(p, xc, col, lab) = begin
    plot!(p, Shape([xc - BW/2, xc + BW/2, xc + BW/2, xc - BW/2],
                   [ymech - BH/2, ymech - BH/2, ymech + BH/2, ymech + BH/2]);
          fillcolor=col, linecolor=:black, lw=1, label="")
    annotate!(p, xc, ymech + 0.95BH, text(lab, 8, :black))
end

# One column: blocks on springs (top), space-time picture below, up to sample index i
function column(X, Y, i, cx, cy, lines, title_str)
    p = plot(xlims=XL, ylims=(0, 1.3Tend), framestyle=:box, grid=false, legend=false,
             yticks=piticks(Tend, tickstep), xticks=([2, 6], ["2 + x", "6 + y"]),
             title=title_str, titlefontsize=9, tickfontsize=8)
    for (xl, c) in lines                                  # Mathews' vertical lines
        plot!(p, [xl, xl], [0, Tend]; color=c, lw=1, label="")
    end
    plot!(p, [XL[1], XL[2]], [Tend, Tend]; color=:gray60, lw=0.8, label="")
    t = ts[i]
    plot!(p, [XL[1], XL[2]], [t, t]; color=:gray75, lw=0.8, ls=:dot, label="")
    plot!(p, 2 .+ X[1:i], ts[1:i]; color=cx, lw=1.4, label="")
    plot!(p, 6 .+ Y[1:i], ts[1:i]; color=cy, lw=1.4, label="")
    px, py = 2 + X[i], 6 + Y[i]
    plot!(p, [px, px], [t, ymech - BH/2]; color=cx, lw=0.6, ls=:dot, label="")
    plot!(p, [py, py], [t, ymech - BH/2]; color=cy, lw=0.6, ls=:dot, label="")
    scatter!(p, [px, py], [t, t]; color=[cx, cy], ms=3.5, markerstrokewidth=0, label="")
    wall!(p, WL, :left)
    spring!(p, WL, px - BW/2, ymech)
    spring!(p, px + BW/2, py - BW/2, ymech)
    if k3 > 0
        wall!(p, WR, :right)
        spring!(p, py + BW/2, WR, ymech)
    end
    block!(p, px, cx, "m₁")
    block!(p, py, cy, "m₂")
    return p
end

# Parallelogram |u1| <= √2, |u2| <= √2 in the (x, y) plane: u1 (1, ρ1) + u2 (1, ρ2)
corner(s, r) = (s * √2 + r * √2, s * √2 * ρ1 + r * √2 * ρ2)
par = [corner(1, 1), corner(1, -1), corner(-1, -1), corner(-1, 1), corner(1, 1)]
xr = range(-CL, CL, length=2)

function config(i)
    t = ts[i]
    p = plot(xlims=(-CL, CL), ylims=(-CL, CL), aspect_ratio=:equal, framestyle=:box,
             xlabel="x", ylabel="y", grid=true, legend=legpos, legendfontsize=6,
             title=config_title(t) * "\n(x, y) = ($(fmtv(XC[i])), $(fmtv(YC[i])))",
             titlefontsize=9, tickfontsize=8)
    plot!(p, first.(par), last.(par); color=:gray55, ls=:dash, lw=1,
          label="|u₁|, |u₂| ≤ √2")
    plot!(p, xr, ρ1 .* xr; color=:red, ls=:dot, lw=1, label="mode 1 line")
    plot!(p, xr, ρ2 .* xr; color=:magenta, ls=:dot, lw=1, label="mode 2 line")
    plot!(p, XC[1:i], YC[1:i]; color=:purple, lw=1.3, label="")
    scatter!(p, [XC[1]], [YC[1]]; color=:black, marker=:diamond, ms=4,
             label="start")
    scatter!(p, [XC[i]], [YC[i]]; color=:purple, ms=5, markerstrokewidth=0, label="")
    return p
end

function timeplot(i)
    p = plot(xlims=(0, Tend), ylims=tylims, framestyle=:box, xlabel="t",
             grid=true, legend=:outertop, legend_columns=isempty(tmarks) ? 2 : 3, legendfontsize=7,
             xticks=piticks(Tend, tickstep),
             titlefontsize=9, tickfontsize=8)
    if !isempty(tmarks)
        vline!(p, tmarks; color=:gray50, ls=:dash, lw=0.8, label=tmarks_label)
    end
    plot!(p, ts[1:i], XC[1:i]; color=:magenta, lw=1.4, label="x(t)")
    plot!(p, ts[1:i], YC[1:i]; color=:cyan, lw=1.4, label="y(t)")
    return p
end

function draw_frame(k)
    i = k * sub + 1
    t = ts[i]
    # Mathews' colours: mode 1 red/blue with lines magenta/cyan, mode 2 and the
    # combination magenta/cyan with lines red/blue; black line at 8 as he drew it
    c1 = column(X1, Y1, i, :red, :blue, [(2, :magenta), (6, :cyan), lines8...],
                "Mode 1: ω₁ = $(fmt(ω1)), y = $(line1)\n$(title1)")
    c2 = column(X2, Y2, i, :magenta, :cyan, [(2, :red), (6, :blue), lines8...],
                "Mode 2: ω₂ = $(fmt(ω2)), y = $(line2)\n$(title2)")
    c3 = column(XC, YC, i, :magenta, :cyan, [(2, :red), (6, :blue)],
                "Combination a₁ = a₂ = b₁ = b₂ = 1\n$(title3)")
    l = @layout [a{0.22w} b{0.22w} c{0.22w} [d; e]]
    plot(c1, c2, c3, config(i), timeplot(i); layout=l, size=(1200, 680),
         plot_title=title_main * ",   t = $(@sprintf("%.2f", t))", plot_titlefontsize=11,
         left_margin=3Plots.mm, bottom_margin=3Plots.mm, background_color=:white)
end

anim = Animation()
for k in 0:nfr
    draw_frame(k)
    frame(anim)
end
for _ in 1:round(Int, 1.5fps)                 # hold the last frame 1.5 s
    frame(anim)
end
gif(anim, joinpath(@__DIR__, outname); fps=fps)
println("Saved: ", outname)
