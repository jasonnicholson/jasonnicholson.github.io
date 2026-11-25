# curvaturecc.jl
# Circle of Curvature animation: the osculating circle rolling once around the
# cardioid x = 2 cos t - cos 2t, y = 2 sin t - sin 2t (Mathews' Examples 6 and 7,
# the page's Examples 4 and 5), traversed counterclockwise.
# One frame per t = k pi/24, k = 1, ..., 47; t = 0 (the cusp (1, 0), where the
# speed is 0 and formulas (6)-(7) are 0/0) is left out. Pauses at t = pi/3
# (Mathews' Example 6), t = pi/2, 2pi/3, pi (the page's Example 4) and t = 5pi/3,
# the point (3/2, -sqrt(3)/2) of Example 5 (Mathews' Example 7), where the reversed
# parameterization with parameter pi/3 passes. Each frame shows the point, the unit tangent and
# unit normal, the radius to the center given by formula (7), and the circle of
# radius (6). The centers visited so far trace the evolute, which is the cardioid
# shrunk by the factor 1/3 and turned through half a turn about the origin.
# Window: Mathews' [-3, 2.5] x [-2.75, 2.75] with the left edge moved to -3.25
# so that the point (-3, 0) at t = pi is not on the frame edge.
# Produces: curvaturecc.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmtv(x) = x == 0 ? "0" : um(@sprintf("%#.4g", Float64(x)))     # computed: 4 s.f.

# --- Parameters ---
gif_name = "curvaturecc.gif"
# Functions of s = t/pi, evaluated with sinpi/cospi so that sin(k pi) is exactly 0
X(s)  = 2cospi(s) - cospi(2s);   Y(s)  = 2sinpi(s) - sinpi(2s)
X1(s) = -2sinpi(s) + 2sinpi(2s); Y1(s) = 2cospi(s) - 2cospi(2s)       # d/dt
X2(s) = -2cospi(s) + 4cospi(2s); Y2(s) = -2sinpi(s) + 4sinpi(2s)      # d2/dt2
ks    = 1:47                          # t = k pi / 24
pause = Dict(8 => "Mathews' Ex. 6", 12 => "Example 4", 16 => "Example 4",
             24 => "Example 4", 40 => "Example 5")
hold  = 4
xlims = (-3.25, 2.5)
ylims = (-2.875, 2.875)
title_str = "Osculating circle of the cardioid x = 2cos t − cos 2t, y = 2sin t − sin 2t"

# t = k pi/24 written as a reduced multiple of pi
function tstr(k)
    g = gcd(k, 24); p, q = k ÷ g, 24 ÷ g
    num = p == 1 ? "π" : "$(p)π"
    return q == 1 ? num : "$num/$q"
end

# Formulas (6) and (7): radius and center; signed cross term D = x'y'' - y'x''
function curv(t)                       # t here is s = t/pi
    sp2 = X1(t)^2 + Y1(t)^2
    D = X1(t) * Y2(t) - Y1(t) * X2(t)
    r = sp2^(3 / 2) / abs(D)
    a = X(t) - Y1(t) * sp2 / D
    b = Y(t) + X1(t) * sp2 / D
    s = sqrt(sp2)
    u = (X1(t) / s, Y1(t) / s)
    n = (-Y1(t) / s, X1(t) / s)       # left normal; points to the center since D > 0
    return (; r, a, b, u, n, D)
end
for k in ks
    s = k / 24
    c = curv(s)
    @assert c.D > 0                                              # counterclockwise
    @assert abs(c.r - 8 / 3 * abs(sinpi(s / 2))) < 1e-12         # r = (2/3) sqrt(8 - 8 cos t)
    @assert abs(c.a - (2cospi(s) + cospi(2s)) / 3) < 1e-12       # evolute = -(1/3) p(t + pi)
    @assert abs(c.b - (2sinpi(s) + sinpi(2s)) / 3) < 1e-12
    @assert abs(c.a - (X(s) + c.r * c.n[1])) < 1e-12 && abs(c.b - (Y(s) + c.r * c.n[2])) < 1e-12
end

θ = range(0, 2π, length=721)
tt = range(0, 2, length=721)           # s = t/pi over one turn

function draw(i)
    k = ks[i]
    s = k / 24
    c = curv(s)
    x, y = X(s), Y(s)
    p = plot(xlims=xlims, ylims=ylims, aspect_ratio=:equal, framestyle=:box,
             legend=:outerright, legendfontsize=9, titlefontsize=11, grid=true,
             size=(1000, 680), background_color=:white, xlabel="x", ylabel="y",
             left_margin=5Plots.mm, bottom_margin=3Plots.mm,
             xticks=-3:1:2, yticks=-2:1:2)
    plot!(p, X.(tt), Y.(tt); color=:blue, lw=2, label="cardioid")
    te = (ks[1]:k) ./ 24
    plot!(p, [curv(q).a for q in te], [curv(q).b for q in te]; color=:purple, lw=2.5,
          label="centers so far (evolute)")
    plot!(p, c.a .+ c.r .* cos.(θ), c.b .+ c.r .* sin.(θ); color=:red, lw=2,
          label="osculating circle")
    plot!(p, [x, c.a], [y, c.b]; color=:red, ls=:dash, lw=1.5, label="radius r")
    plot!(p, [x, x + 0.6c.u[1]], [y, y + 0.6c.u[2]]; color=:green, lw=2.5,
          arrow=arrow(:closed, :head, 0.3, 0.25), label="tangent direction (0.6 u)")
    plot!(p, [x, x + 0.6c.n[1]], [y, y + 0.6c.n[2]]; color=:darkorange, lw=2.5,
          arrow=arrow(:closed, :head, 0.3, 0.25), label="normal direction (0.6 n)")
    scatter!(p, [x], [y]; color=:black, ms=5, label="")
    scatter!(p, [c.a], [c.b]; color=:red, ms=5, markerstrokecolor=:darkred, label="")
    tag = haskey(pause, k) ? "  ($(pause[k]))" : ""
    tl = "$title_str\nt = $(tstr(k))$tag:  point ($(fmtv(x)), $(fmtv(y))),  " *
         "r = $(fmtv(c.r)),  center ($(fmtv(c.a)), $(fmtv(c.b)))"
    title!(p, tl)
    return p, tl
end

anim = Animation()
for i in eachindex(ks)
    p, tl = draw(i)
    println("TITLE\t", replace(tl, "\n" => " | "))
    for _ in 1:(haskey(pause, ks[i]) ? 1 + hold : 1)
        frame(anim)
    end
end
gif(anim, joinpath(@__DIR__, gif_name); fps=5)
println("Saved: ", gif_name)
