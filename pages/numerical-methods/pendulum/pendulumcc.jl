# pendulumcc.jl
# Pendulum animation: Mathews' Example 7, the damped nonlinear pendulum
# x'' + x'/10 + 2 sin x = 0 (x' = y, y' = -y/10 - 2 sin x), its phase portrait built
# curve by curve with all fourteen of Mathews' curves, his starting points, time
# intervals [0, b], m = 100 Runge-Kutta steps (Runge2D) per curve, his plot windows
# and his colours.
# Part 1: curves 1 to 8 one after another (5 steps per frame).
# Part 2: curves 9 to 12 (curves 1 to 4 started at x0 = 2 pi) together, on a common clock.
# Part 3: Mathews' last figure, curves 5, 6, 7' and 8', together.
# Top: the phase plane, with the level E = 4 of the energy E = y^2/2 + 2(1 - cos x)
# (the energy of the pendulum at rest at the top; a curve with E < 4 can no longer pass
# a top, since E never increases), the rest points (2k pi, 0), the saddles
# ((2k+1) pi, 0), and Mathews' plot window for the current curve (dotted).
# Bottom left: the pendulum, a rod and a bob at the current angle, and the number of
# tops crossed so far. Bottom right: the energy E(t) of the current curves, with the
# time at which it falls below 4 (from a reference run: Runge-Kutta with h = 0.001 and
# bisection on the step length).
# Produces: pendulumcc.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))
fmt4(x) = um(@sprintf("%#.4g", x))

# --- Model (Example 7: g = 32, l = 16) ---
F(t, z) = [z[2], -z[2] / 10 - 2 * sin(z[1])]
E(x, y) = y^2 / 2 + 2 * (1 - cos(x))
m = 100

# Classical Runge-Kutta method in vector form, formula (8): returns Z_0, ..., Z_m
function rk4(F, a, b, z0, m)
    h = (b - a) / m
    Z = [copy(z0)]
    z = copy(z0)
    for j in 0:m-1
        t = a + j * h
        K1 = h * F(t, z)
        K2 = h * F(t + h / 2, z + K1 / 2)
        K3 = h * F(t + h / 2, z + K2 / 2)
        K4 = h * F(t + h, z + K3)
        z = z + (K1 + 2K2 + 2K3 + K4) / 6
        push!(Z, z)
    end
    return Z
end

# Reference: first time E falls below 4 (Inf if never on [0, b]), h = 0.001 with bisection
function trap_time(z0, b; h=1e-3)
    E(z0...) <= 4 + 1e-9 && return 0.0                  # curve 4 starts at E = 4 exactly
    z = copy(z0); t = 0.0
    while t < b
        zn = rk4(F, t, t + h, z, 1)[end]
        if E(zn...) < 4
            lo, hi = 0.0, h
            for _ in 1:60
                mid = (lo + hi) / 2
                E(rk4(F, t, t + mid, z, 1)[end]...) < 4 ? (hi = mid) : (lo = mid)
            end
            return t + (lo + hi) / 2
        end
        z = zn; t += h
    end
    return Inf
end

# Tops crossed by the polygon of Runge-Kutta points up to index j
well(x) = floor(Int, (x + π) / (2π))
tops(x, j) = sum(abs(well(x[i+1]) - well(x[i])) for i in 1:j; init=0)

ccyan = RGB(0.0, 0.72, 0.78)
s2 = sqrt(2.0)
# name, x0, y0, b, colour, Mathews' window (nothing = "All")
spec = [("1", 0.0, s2 / 2, 9.0, :red, ((-2, 2), (-2.2, 2.2))),
        ("2", 0.0, s2, 9.3, ccyan, ((-2, 2), (-2.2, 2.2))),
        ("3", 0.0, 3s2 / 2, 5.2, :green, ((-2, 2), (-2.2, 2.2))),
        ("4", 0.0, 2s2, 6.4, :blue, nothing),
        ("5", 0.0, 5s2 / 2, 19.9, :red, ((0, 22), (-2.5, 4.5))),
        ("6", 0.0, 3s2, 20.2, ccyan, ((0, 22), (-2.5, 4.5))),
        ("7", 6π, -5s2 / 2, 11.0, :orange, ((0, 19), (-4.5, 2.5))),
        ("8", 6π, -3s2, 11.2, :brown, ((-3, 19), (-4.5, 2.5))),
        ("9", 2π, s2 / 2, 9.0, :red, ((2.8, 9.5), (-3, 3))),
        ("10", 2π, s2, 9.3, ccyan, ((2.8, 9.5), (-3, 3))),
        ("11", 2π, 3s2 / 2, 5.2, :green, ((2.8, 9.5), (-3, 3))),
        ("12", 2π, 2s2, 6.4, :blue, ((2.8, 9.5), (-3, 3))),
        ("7′", 6π, -5s2 / 2, 19.9, :magenta, ((0, 19), (-4.5, 2.5))),
        ("8′", 6π, -3s2, 20.2, :green, ((-3, 19), (-4.5, 2.5)))]

struct Curve
    name::String; x::Vector{Float64}; y::Vector{Float64}; b::Float64; h::Float64
    c; win; ttrap::Float64
end
curves = map(spec) do (n, x0, y0, b, c, win)
    Z = rk4(F, 0.0, b, [x0, y0], m)
    Curve(n, first.(Z), last.(Z), b, b / m, c, win, trap_time([x0, y0], b))
end
cv = Dict(c.name => c for c in curves)

for c in curves
    @printf("curve %-3s b=%5.1f E0=%.4f E(b)=%.4f end=(%.4f, %.4f) tops=%d E<4 from t=%s x[%.3f, %.3f] y[%.3f, %.3f]\n",
            c.name, c.b, E(c.x[1], c.y[1]), E(c.x[end], c.y[end]), c.x[end], c.y[end],
            tops(c.x, m), isfinite(c.ttrap) ? @sprintf("%.4f", c.ttrap) : "never",
            extrema(c.x)..., extrema(c.y)...)
end

jat(c, t) = min(m, floor(Int, t / c.h + 1e-9))

# --- Drawing ---
title_str = "Pendulum, Mathews' Example 7:  x″ + x′/10 + 2 sin x = 0  " *
            "(x′ = y,  y′ = −y/10 − 2 sin x),  Runge-Kutta, m = 100 steps per curve"
sx = range(-3.5, 22.5, length=1601)
sep = 2 * sqrt(2) .* abs.(cos.(sx ./ 2))
πticks = ([-π, 0, π, 2π, 3π, 4π, 5π, 6π, 7π], ["−π", "0", "π", "2π", "3π", "4π", "5π", "6π", "7π"])

function draw(done, faded, current, t, ptitle; groupwin=nothing, etitle=nothing)
    pP = plot(xlims=(-3.5, 22.5), ylims=(-4.8, 6.1), framestyle=:box, xlabel="x (angle)",
              ylabel="y = x′", grid=true, legend=:top, legend_columns=4, legendfontsize=8,
              titlefontsize=10, xticks=πticks)
    plot!(pP, sx, sep; color=:gray45, ls=:dash, lw=1.1, label="E = 4 (energy of the tops)")
    plot!(pP, sx, -sep; color=:gray45, ls=:dash, lw=1.1, label="")
    scatter!(pP, [0, 2π, 4π, 6π], zeros(4); color=:black, ms=3, markerstrokewidth=0,
             label="rest points (2kπ, 0)")
    scatter!(pP, [-π, π, 3π, 5π, 7π], zeros(5); color=:gray40, marker=:xcross, ms=5,
             label="saddles at the tops")
    showwin = groupwin !== nothing || (length(current) == 1 && current[1].win !== nothing)
    showwin && plot!(pP, [NaN], [NaN]; color=:black, ls=:dot, lw=1, label="Mathews' window")
    for c in faded
        plot!(pP, c.x, c.y; color=c.c, lw=1, alpha=0.3, label="")
    end
    for c in done
        plot!(pP, c.x, c.y; color=c.c, lw=1.6, label="")
    end
    for c in current
        if c.win !== nothing && length(current) == 1
            (x1, x2), (y1, y2) = c.win
            plot!(pP, [x1, x2, x2, x1, x1], [y1, y1, y2, y2, y1]; color=c.c, ls=:dot, lw=1.2,
                  label="")
        end
        j = jat(c, t)
        plot!(pP, c.x[1:j+1], c.y[1:j+1]; color=c.c, lw=2.2, label="")
        scatter!(pP, [c.x[j+1]], [c.y[j+1]]; color=c.c, ms=5, markerstrokewidth=0, label="")
    end
    if groupwin !== nothing
        (x1, x2), (y1, y2) = groupwin
        plot!(pP, [x1, x2, x2, x1, x1], [y1, y1, y2, y2, y1]; color=:black, ls=:dot, lw=1.2,
              label="")
    end
    title!(pP, ptitle)

    pD = plot(xlims=(-1.3, 1.3), ylims=(-1.3, 1.3), aspect_ratio=:equal, framestyle=:none,
              legend=:outerright, legendfontsize=8, titlefontsize=10, grid=false)
    θc = range(0, 2π, length=200)
    plot!(pD, cos.(θc), sin.(θc); color=:gray80, ls=:dot, lw=1, label="")
    plot!(pD, [0, 0], [0, -1.2]; color=:gray70, ls=:dash, lw=1, label="")
    for c in current
        j = jat(c, t)
        x = c.x[j+1]
        plot!(pD, [0, sin(x)], [0, -cos(x)]; color=c.c, lw=2.5, label="")
        nt = tops(c.x, j)
        scatter!(pD, [sin(x)], [-cos(x)]; color=c.c, ms=8, markerstrokewidth=0,
                 label="curve $(c.name): $nt top$(nt == 1 ? "" : "s") crossed")
    end
    scatter!(pD, [0.0], [0.0]; color=:black, ms=4, label="")
    title!(pD, "t = $(fmt(t))")

    tmax = maximum(c.b for c in current) <= 10 ? 10.0 : 20.5
    pE = plot(xlims=(0, tmax), ylims=(0, 9.6), framestyle=:box, xlabel="t", ylabel="E",
              grid=true, legend=:topright, legendfontsize=8, titlefontsize=10)
    hline!(pE, [4.0]; color=:gray45, ls=:dash, lw=1.1, label="E = 4")
    for c in current
        j = jat(c, t)
        Ej = E.(c.x[1:j+1], c.y[1:j+1])
        lab = isfinite(c.ttrap) && c.ttrap > 0 ?
              "curve $(c.name): E₀ = $(fmt4(Ej[1])), below 4 from t = $(fmt4(c.ttrap))" :
              "curve $(c.name): E₀ = $(fmt4(Ej[1]))"
        plot!(pE, (0:j) .* c.h, Ej; color=c.c, lw=2, label=lab)
        if isfinite(c.ttrap) && 0 < c.ttrap <= j * c.h
            scatter!(pE, [c.ttrap], [4.0]; color=c.c, marker=:diamond, ms=6,
                     markerstrokewidth=0, label="")
        end
    end
    title!(pE, etitle === nothing ?
               "energy E = y²/2 + 2(1 − cos x), never increasing: E′ = −y²/10" : etitle)

    l = @layout [a{0.58h}; [b{0.42w} c]]
    plot(pP, pD, pE; layout=l, size=(1250, 800), plot_title=title_str,
         plot_titlefontsize=11, left_margin=4Plots.mm, bottom_margin=4Plots.mm,
         background_color=:white)
end

winstr(c) = c.win === nothing ? "All" :
            "[$(fmt(c.win[1][1])), $(fmt(c.win[1][2]))] × [$(fmt(c.win[2][1])), $(fmt(c.win[2][2]))]"
ystr = Dict("1" => "√2/2", "2" => "√2", "3" => "3√2/2", "4" => "2√2", "5" => "5√2/2",
            "6" => "3√2", "7" => "−5√2/2", "8" => "−3√2")
xstr(c) = c.x[1] == 0 ? "0" : c.x[1] ≈ 2π ? "2π" : "6π"

anim = Animation()
# Part 1: curves 1 to 8 one after another
for i in 1:8
    c = curves[i]
    pt = "curve $(c.name): start ($(xstr(c)), $(ystr[c.name])), [0, $(fmt(c.b))], " *
         "h = $(fmt(c.h)),  Mathews' window $(winstr(c))"
    for k in 0:20
        draw(curves[1:i-1], Curve[], [c], 5k * c.h, pt); frame(anim)
    end
    for _ in 1:5
        frame(anim)
    end
end
# Part 2: curves 9 to 12 together on a common clock
grp = curves[9:12]
pt = "curves 9 to 12: curves 1 to 4 started at x₀ = 2π, Mathews' window [2.8, 9.5] × [−3, 3]"
for t in 0:0.3:9.3
    draw(curves[1:8], Curve[], grp, t, pt; groupwin=((2.8, 9.5), (-3, 3))); frame(anim)
end
for _ in 1:8
    frame(anim)
end
# Part 3: Mathews' last figure, curves 5, 6, 7′ and 8′
grp = [cv["5"], cv["6"], cv["7′"], cv["8′"]]
pt = "Mathews' last figure: curves 5, 6, 7′ (= 7 on [0, 19.9]) and 8′ (= 8 on [0, 20.2]), " *
     "each other curve faded"
et = "energy E: 7′ and 8′ are 5 and 6 reflected through (3π, 0), with the same energies"
for t in 0:0.5:20.0
    draw(Curve[], curves[1:12], grp, t, pt; etitle=et); frame(anim)
end
draw(Curve[], curves[1:12], grp, 20.2, pt; etitle=et)
for _ in 1:30
    frame(anim)                                        # hold 3 s
end
gif(anim, joinpath(@__DIR__, "pendulumcc.gif"); fps=10)
println("Saved: pendulumcc.gif")
