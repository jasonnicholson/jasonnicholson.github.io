# curvaturebb.jl
# Circle of Curvature animation: the osculating circle rolling along the parabola
# y = f(x) = x^2 (the page's Examples 1 and 2, Mathews' Examples 1, 3 and 5).
# One frame per point x = k/20, k = -20, ..., 20, with a pause at x = 0
# (Example 1), x = 1/2 (Mathews' Examples 3 and 5: his Example 3 states the point
# (1, 1) but his solution works at (1/2, 1/4)) and x = 1 (Example 2). Each frame
# shows the point (x, f(x)), the tangent line, the unit tangent u and unit
# normal n of equation (2), the radius from the point to the center of
# curvature (a, b) of equations (3)-(4), and the osculating circle of radius
# rho = (1 + f'^2)^(3/2) / f''. The centers visited so far trace the evolute
# (a, b) = (-4x^3, 1/2 + 3x^2) of the parabola.
# The window is chosen here (no Mathews original): it holds every center;
# the larger circles run past its edge.
# Produces: curvaturebb.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))       # exact values (x = k/20)
fmtv(x) = x == 0 ? "0" : um(@sprintf("%#.4g", Float64(x)))     # computed: 4 s.f.

# --- Parameters ---
gif_name = "curvaturebb.gif"
f(x)   = x^2
df(x)  = 2x
d2f(x) = 2
ks    = -20:20                       # x = k/20
pause = Dict(0 => "Example 1", 10 => "Mathews' Examples 3 and 5", 20 => "Example 2")
hold  = 4                            # extra frames at each pause
xlims = (-5.0, 5.0)
ylims = (-1.5, 6.5)
title_str = "Osculating circle of y = x² and the evolute traced by its center"

# Unit tangent, unit normal (equation (2)), radius and center (equations (1), (3), (4)).
# x is the exact rational k//20, so the center (a, b) is computed exactly and
# converted to Float64 once. Labels print that Float64 with %#.4g, so an exact
# decimal tie rounds up or down by its Float64 value (b(0.95) = 3.2075 -> 3.208,
# b(0.55) = 1.4075 -> 1.407); either way the label is a correct 4-s.f. rounding.
function curv(x::Rational)
    s = sqrt(Float64(1 + df(x)^2))
    u = (1 / s, Float64(df(x)) / s)
    n = (-Float64(df(x)) / s, 1 / s)
    rho = s^3 / d2f(x)
    a = Float64(x - df(x) // d2f(x) - df(x)^3 // d2f(x))
    b = Float64(f(x) + 1 // d2f(x) + df(x)^2 // d2f(x))
    return (; u, n, rho, a, b)
end
# The center is the point moved a distance rho along n, and lies on the evolute
for k in ks
    x = k // 20
    c = curv(x)
    @assert abs(c.a - (x + c.rho * c.n[1])) < 1e-12 && abs(c.b - (f(x) + c.rho * c.n[2])) < 1e-12
    @assert abs(c.a + 4x^3) < 1e-12 && abs(c.b - (0.5 + 3x^2)) < 1e-12
end

θ = range(0, 2π, length=721)
xpl = range(-sqrt(ylims[2]), sqrt(ylims[2]), length=401)

function draw(i)
    k = ks[i]
    c = curv(k // 20)
    x = k / 20
    p = plot(xlims=xlims, ylims=ylims, aspect_ratio=:equal, framestyle=:box,
             legend=:outerright, legendfontsize=9, titlefontsize=11, grid=true,
             size=(1000, 660), background_color=:white, xlabel="x", ylabel="y",
             left_margin=5Plots.mm, bottom_margin=3Plots.mm)
    plot!(p, xpl, f.(xpl); color=:blue, lw=2, label="y = x²")
    # evolute traced by the centers so far
    xe = ks[1:i] ./ 20
    plot!(p, -4 .* xe .^ 3, 0.5 .+ 3 .* xe .^ 2; color=:purple, lw=2.5,
          label="centers so far (evolute)")
    plot!(p, c.a .+ c.rho .* cos.(θ), c.b .+ c.rho .* sin.(θ); color=:red, lw=2,
          label="osculating circle")
    # tangent line
    plot!(p, [x - 2c.u[1], x + 2c.u[1]], [f(x) - 2c.u[2], f(x) + 2c.u[2]];
          color=:gray50, lw=1, label="tangent line")
    plot!(p, [x, c.a], [f(x), c.b]; color=:red, ls=:dash, lw=1.5, label="radius ρ")
    plot!(p, [x, x + c.u[1]], [f(x), f(x) + c.u[2]]; color=:green, lw=2.5,
          arrow=arrow(:closed, :head, 0.4, 0.3), label="unit tangent u")
    plot!(p, [x, x + c.n[1]], [f(x), f(x) + c.n[2]]; color=:darkorange, lw=2.5,
          arrow=arrow(:closed, :head, 0.4, 0.3), label="unit normal n")
    scatter!(p, [x], [f(x)]; color=:black, ms=5, label="")
    scatter!(p, [c.a], [c.b]; color=:red, ms=5, markerstrokecolor=:darkred, label="")
    tag = haskey(pause, k) ? "  ($(pause[k]))" : ""
    xs = k == 10 ? "1/2" : fmt(x)
    t = "$title_str\nx = $xs$tag:  ρ = $(fmtv(c.rho)),  center ($(fmtv(c.a)), $(fmtv(c.b)))"
    title!(p, t)
    return p, t
end

anim = Animation()
for i in eachindex(ks)
    p, t = draw(i)
    println("TITLE\t", replace(t, "\n" => " | "))
    for _ in 1:(haskey(pause, ks[i]) ? 1 + hold : 1)
        frame(anim)
    end
end
gif(anim, joinpath(@__DIR__, gif_name); fps=5)
println("Saved: ", gif_name)
