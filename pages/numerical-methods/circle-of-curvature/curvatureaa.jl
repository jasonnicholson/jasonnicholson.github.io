# curvatureaa.jl
# Circle of Curvature animation: the collocation circle through the three points
# (x - h, f(x - h)), (x, f(x)), (x + h, f(x + h)) of the parabola y = f(x) = x^2,
# for Mathews' list of h values (his Example 5), at two points side by side:
#   left:  x = 0, the page's Example 3 (Mathews' Example 4), limit center (0, 1/2), r = 1/2;
#   right: x = 1/2, Mathews' Example 5, limit center (-1/2, 5/4), r = sqrt(2).
# One frame per h. The collocation circle (red) is drawn with the three points
# (green, as in Mathews' frames); the circle of curvature, its limit as h -> 0,
# is drawn dashed for comparison (Mathews' frames did not draw it).
# The circle through three points is computed by the general circumcircle
# formula in 256-bit arithmetic and checked against the closed forms for this
# parabola, a = x(h^2 - 4x^2), b = (1 + 6x^2 + h^2)/2,
# r^2 = (1 + 4x^2)(1 + (2x - h)^2)(1 + (2x + h)^2)/4.
# Window: Mathews' Example 5 window [-1, 1] x [-0.5, 1.5] for both panels
# (his Example 4 frames are lost). Mathews' h list has no 0.6; it is kept as he gave it.
# Produces: curvatureaa.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))       # exact values
fmtv(x) = x == 0 ? "0" : um(@sprintf("%#.6g", Float64(x)))     # computed: 6 s.f.

setprecision(BigFloat, 256)

# --- Parameters ---
gif_name = "curvatureaa.gif"
f(x) = x^2
# Mathews' Example 5 list of h (no 0.6 in his list)
hs = ["1.0", "0.9", "0.8", "0.7", "0.5", "0.4", "0.3", "0.2", "0.1", "0.08", "0.06",
      "0.04", "0.03", "0.02", "0.01", "0.0075", "0.005", "0.0025", "0.001"]
hb = parse.(BigFloat, hs)
pts = [(x = big(0), name = "Example 3 (Mathews' Example 4):  x = 0"),
       (x = big(1) / 2, name = "Mathews' Example 5:  x = 1/2")]
xlims = (-1.0, 1.0)                 # Mathews' Example 5 window
ylims = (-0.5, 1.5)
hold = 3                            # extra frames on the last h
title_str = "Collocation circle through (x − h, f(x − h)), (x, f(x)), (x + h, f(x + h)) " *
            "on y = x²  →  circle of curvature as h → 0"

# Circle through three points (general circumcircle formula)
function circumcircle(P1, P2, P3)
    (x1, y1), (x2, y2), (x3, y3) = P1, P2, P3
    d = 2 * (x1 * (y2 - y3) + x2 * (y3 - y1) + x3 * (y1 - y2))
    s1, s2, s3 = x1^2 + y1^2, x2^2 + y2^2, x3^2 + y3^2
    a = (s1 * (y2 - y3) + s2 * (y3 - y1) + s3 * (y1 - y2)) / d
    b = (s1 * (x3 - x2) + s2 * (x1 - x3) + s3 * (x2 - x1)) / d
    return a, b, sqrt((x1 - a)^2 + (y1 - b)^2)
end

# Osculating circle of y = x^2 at x: center (x - f'(1 + f'^2)/f'', f + (1 + f'^2)/f'')
osc(x) = (x - 2x * (1 + 4x^2) / 2, x^2 + (1 + 4x^2) / 2, (1 + 4x^2)^(3 // 2) / 2)

circ = [[circumcircle((p.x - h, f(p.x - h)), (p.x, f(p.x)), (p.x + h, f(p.x + h))) for h in hb]
        for p in pts]
for (j, p) in enumerate(pts), (k, h) in enumerate(hb)
    a, b, r = circ[j][k]
    x = p.x
    @assert abs(a - x * (h^2 - 4x^2)) < big"1e-60"
    @assert abs(b - (1 + 6x^2 + h^2) / 2) < big"1e-60"
    @assert abs(r^2 - (1 + 4x^2) * (1 + (2x - h)^2) * (1 + (2x + h)^2) / 4) < big"1e-60"
end
lim = [osc(p.x) for p in pts]
@assert all(abs.(lim[1] .- (0, big(1) / 2, big(1) / 2)) .< big"1e-70")
@assert all(abs.(lim[2] .- (-big(1) / 2, big(5) / 4, sqrt(big(2)))) .< big"1e-70")

θ = range(0, 2π, length=721)
xpl = range(xlims[1], xlims[2], length=401)

function panel(j, k)
    p = pts[j]
    a, b, r = Float64.(circ[j][k])
    al, bl, rl = Float64.(lim[j])
    x0, h = Float64(p.x), Float64(hb[k])
    pl = plot(xlims=xlims, ylims=ylims, aspect_ratio=:equal, framestyle=:origin,
              legend=:bottomright, legendfontsize=8, titlefontsize=10, grid=true,
              xticks=-1:0.5:1, yticks=-0.5:0.5:1.5)
    plot!(pl, xpl, f.(xpl); color=:blue, lw=2, label="y = x²")
    plot!(pl, al .+ rl .* cos.(θ), bl .+ rl .* sin.(θ); color=:gray40, ls=:dash, lw=1.5,
          label="circle of curvature, r = " * (j == 1 ? "1/2" : "√2 = 1.41421"))
    plot!(pl, a .+ r .* cos.(θ), b .+ r .* sin.(θ); color=:red, lw=2,
          label="collocation circle, r = $(fmtv(r))")
    xs3 = [x0 - h, x0, x0 + h]
    scatter!(pl, xs3, f.(xs3); color=:lime, ms=6, markerstrokecolor=:darkgreen,
             label="the 3 points")
    # Points or center outside the window are named, not hidden
    notes = String[]
    for xx in xs3
        if !(xlims[1] <= xx <= xlims[2] && ylims[1] <= f(xx) <= ylims[2])
            push!(notes, "point ($(fmt(xx)), $(fmt(f(xx)))) is off the window")
        end
    end
    if !(xlims[1] <= a <= xlims[2] && ylims[1] <= b <= ylims[2])
        push!(notes, "center ($(fmtv(a)), $(fmtv(b))) is off the window")
    end
    for (i, s) in enumerate(notes)
        annotate!(pl, xlims[1] + 0.05, ylims[2] - 0.08 - 0.12 * (i - 1),
                  text(s, 8, :left, :black))
    end
    t = "$(p.name),  h = $(hs[k] == "1.0" ? "1" : hs[k])\n" *
        "center ($(fmtv(a)), $(fmtv(b))),  r = $(fmtv(r))"
    title!(pl, t)
    for s in notes
        println("NOTE\t", j, "\th = ", hs[k], "\t", s)
    end
    return pl, t
end

anim = Animation()
for k in eachindex(hb)
    (p1, t1), (p2, t2) = panel(1, k), panel(2, k)
    println("TITLE\t1\t", replace(t1, "\n" => " | "))
    println("TITLE\t2\t", replace(t2, "\n" => " | "))
    for _ in 1:(k == length(hb) ? 1 + hold : 1)
        plot(p1, p2; layout=(1, 2), size=(1100, 640),
             plot_title=title_str, plot_titlefontsize=11, background_color=:white,
             left_margin=3Plots.mm)
        frame(anim)
    end
end
gif(anim, joinpath(@__DIR__, gif_name); fps=2)
println("Saved: ", gif_name)
