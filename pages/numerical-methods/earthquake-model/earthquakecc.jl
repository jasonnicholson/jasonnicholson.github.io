# earthquakecc.jl
# Earthquake Model animation: Mathews' Example 3 against the period of the
# earthquake. For the building of Example 1 shaken by e cos(wt), e = 0.075 ft,
# the largest floor amplitude g = max_i |v_i|, where (w^2 I + a) v = -e w^2 b,
# is traced against the period p = 2 pi / w as p grows, one frame per
# p = 0.65, 0.70, ..., 11 s.
# Left: Mathews' first period graph, w in [0.5, 10] (p from 2 pi/10 = 0.6283 s
# up to the right edge of the window), window [0, 11] x [0, 3], his Orange.
# Right: his second graph, w in [1.5, 10] (p up to 2 pi/1.5 = 4.189 s), window
# [0, 4] x [0, 2], his Red; it holds the five resonances with periods below
# 3.2 s. Both: the natural periods P_j (closed form) as dashed asymptotes, the
# curve broken at every P_j, the level g = 0.3 ft (four times the ground
# amplitude), and the bands of periods where g >= 0.3 ft shaded as the trace
# passes them (band edges by bisection on g = 0.3). Where g is above a window
# the curve leaves its top edge and the current point is a triangle on the
# edge, with the true value in the title.
# Produces: earthquakecc.gif

using Plots
using Printf
using LinearAlgebra
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))
pstr(k) = @sprintf("%.2f", k / 100)                  # p = k/100 exactly, as a decimal

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

# --- Parameters (Mathews' Examples 1 and 3) ---
gif_name = "earthquakecc.gif"
n, c   = 6, 8.0
e      = 0.075
level  = 0.3                                         # 4e
A      = Matrix(SymTridiagonal([fill(-2c, n - 1); -c], fill(c, n - 1)))
b      = ones(n)
wj     = [2sqrt(c) * sin((2j - 1) * pi / (2(2n + 1))) for j in 1:n]
Pj     = 2pi ./ wj
ks     = 65:5:1100                                   # frame p = k/100 s
winL   = ((0.0, 11.0), (0.0, 3.0)); wrangeL = (0.5, 10.0)   # Mathews' Orange graph
winR   = ((0.0, 4.0), (0.0, 2.0));  wrangeR = (1.5, 10.0)   # Mathews' Red graph
colL, colR = RGB(1, 0.5, 0), RGB(1, 0, 0)
title_str = "Earthquake model, Example 3:  largest floor amplitude g against the period " *
            "p = 2π/ω of the earthquake,  e = 0.075 ft"

g(w) = maximum(abs.((w^2 * I + A) \ (-e * w^2 * b)))
gp(p) = g(2pi / p)

# Bands g >= 0.3 around each natural period: bisection on g(p) = 0.3 between the
# natural period and the halfway points to its neighbours
function bisect(f, lo, hi)
    flo = f(lo)
    for _ in 1:200
        mid = (lo + hi) / 2
        (mid == lo || mid == hi) && break
        fm = f(mid)
        if sign(fm) == sign(flo)
            lo, flo = mid, fm
        else
            hi = mid
        end
    end
    return (lo + hi) / 2
end
Ps = sort(Pj)                                         # increasing periods
# Brackets: halfway points between neighbouring natural periods (g < 0.3 there,
# checked below), and far ends
mids = [(Ps[i] + Ps[i+1]) / 2 for i in 1:n-1]
lefts = [0.62; mids]; rights = [mids; 13.0]
for x in [0.62; mids; 13.0]
    @assert gp(x) < level
end
bands = [(bisect(p -> gp(p) - level, lefts[i], Ps[i]), bisect(p -> gp(p) - level, Ps[i], rights[i]))
         for i in 1:n]
for (i, (lo, hi)) in enumerate(bands)
    @printf("band around P = %.6f: [%.6f, %.6f], width %.6f\n", Ps[i], lo, hi, hi - lo)
end

# Fine curves (parametrised by p), broken at every natural period
function curve(wrange, pmax)
    p = collect(range(2pi / wrange[2], min(2pi / wrange[1], pmax), length=20001))
    y = gp.(p)
    for P in Ps
        if p[1] < P < p[end]
            i = findfirst(>(P), p)
            insert!(p, i, P); insert!(y, i, NaN)
        end
    end
    return p, y
end
pcL, gcL = curve(wrangeL, 11.5)
pcR, gcR = curve(wrangeR, 4.5)

frame_title(p) = (gv = gp(p);
    "p = $(pstr(round(Int, 100p))) s (ω = $(fmt(2pi / p)) rad/s):  g = $(fmt(gv)) ft" *
    (gv > winL[2][2] ? (p <= winR[1][2] ? ", above both windows" : ", above the left window") :
     gv > winR[2][2] && p <= winR[1][2] ? ", above the right window" : ""))

function panel(win, wrange, pc, gc, col, p, lbl)
    # Drawn view: Mathews' window plus a small margin on the right, so that the
    # current point on the right edge shows in full
    view = (win[1][1], win[1][2] + 0.015 * (win[1][2] - win[1][1]))
    pl = plot(xlims=view, ylims=win[2], framestyle=:box, grid=true,
              xlabel="period p (s)", ylabel="g  (ft)", legend=:outerbottom, legend_columns=2,
              legendfontsize=8, titlefontsize=10)
    # Legend entries are the same in every frame (drawn items carry no label)
    plot!(pl, Shape([NaN], [NaN]); color=col, alpha=0.15, linealpha=0,
          label="periods with g ≥ 0.3 ft (so far)")
    for (lo, hi) in bands
        lo <= p || continue
        hi_now = min(hi, p)
        if lo < win[1][2]
            plot!(pl, Shape([lo, hi_now, hi_now, lo], [win[2][1], win[2][1], win[2][2], win[2][2]]);
                  color=col, alpha=0.15, linealpha=0, label="")
        end
    end
    vline!(pl, Ps; color=:gray50, ls=:dash, lw=1, label="natural periods P₁, …, P₆")
    hline!(pl, [level]; color=:gray30, ls=:dot, lw=1, label="g = 0.3 ft = 4e")
    idx = [i for i in eachindex(pc) if pc[i] <= p]
    plot!(pl, pc[idx], ydraw.(gc[idx], Ref(win[2])); color=col, lw=1.8, label=lbl)
    scatter!(pl, [NaN], [NaN]; color=:black, ms=5, label="current p (▲: g above the window)")
    if p <= 2pi / wrange[1] && p <= win[1][2]
        gv = gp(p)
        if gv <= win[2][2]
            scatter!(pl, [p], [gv]; color=:black, ms=5, label="")
        else
            scatter!(pl, [p], [win[2][2]]; color=:black, marker=:utriangle, ms=7, label="")
        end
    end
    return pl
end

function draw_frame(k)
    p = k / 100
    pL = panel(winL, wrangeL, pcL, gcL, colL, p, "g, Mathews' ω ∈ [0.5, 10]")
    title!(pL, frame_title(p))
    pR = panel(winR, wrangeR, pcR, gcR, colR, p, "g, Mathews' ω ∈ [1.5, 10]")
    title!(pR, p <= 4 ? "Mathews' zoom on the five shorter natural periods" :
                        "zoom complete: the trace has passed p = 4 s")
    plot(pL, pR; layout=(1, 2), size=(1150, 590), plot_title=title_str,
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white)
end

println("P_j = ", Pj)
for (f, k) in enumerate(ks)
    println("FRAME ", f - 1, " | ", frame_title(k / 100))
end

anim = Animation()
for k in ks
    draw_frame(k)
    frame(anim)
end
for _ in 1:15                                        # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=12)
println("Saved: ", gif_name)
