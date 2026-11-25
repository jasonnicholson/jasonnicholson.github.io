# pendulumbb.jl
# Pendulum animation: Example 6, the undamped pendulum x'' + 2 sin x = 0
# (x' = y, y' = -2 sin x, omega0 = sqrt 2), the curves chosen on this page.
# Every curve is a Runge-Kutta run (Mathews' Runge2D) with m = 100 steps.
# Part 1: four closed loops from (0, y0), y0 = 2 sqrt(2) k for k = 0.25, 0.5, 0.75, 0.95,
#         each run for exactly one period T = 4 K(k) / omega0.
# Part 2: two rotations from (0, y0), k = 1.25 and 1.5, and the two rotations the other
#         way from (4 pi, -y0), each run for two turns, 2 T_rot = 2 * 2 K(1/k) / (k omega0).
# Part 3: the loops of Part 1 started at (2 pi, y0) and (4 pi, y0), drawn at once.
# Frames are on a common clock t: each run shows its Runge-Kutta points with t_j <= t,
# so the pendulums swing as they would in real time and fall out of step.
# Left: the phase plane with the separatrix y = +-2 sqrt(2) |cos(x/2)| (energy E = 4).
# Top right: the pendulums drawn as rods and bobs at the current angles.
# Bottom right: x(t) of every run in the current part.
# Colours: those of Mathews' Example 7 curves with the same starting speeds
# (red, cyan, green, blue; red, cyan; orange, brown).
# Produces: pendulumbb.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))
fmt4(x) = um(@sprintf("%#.4g", x))

# --- Model (Example 6) ---
w0 = sqrt(2.0)
F(t, z) = [z[2], -2 * sin(z[1])]
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

# Complete elliptic integral of the first kind by the arithmetic-geometric mean
function ellK(k)
    a, b = 1.0, sqrt(1 - k^2)
    for _ in 1:40
        a, b = (a + b) / 2, sqrt(a * b)
    end
    return π / (2a)
end

struct Run
    x::Vector{Float64}; y::Vector{Float64}; T::Float64; h::Float64; c; lab::String
end
function makerun(x0, y0, tend, c, lab)
    Z = rk4(F, 0.0, tend, [x0, y0], m)
    Run(first.(Z), last.(Z), tend, tend / m, c, lab)
end

ccyan = RGB(0.0, 0.72, 0.78)
kl = [0.25, 0.5, 0.75, 0.95]
cl = [:red, ccyan, :green, :blue]
Tl = [4 * ellK(k) / w0 for k in kl]
loops = [makerun(0.0, 2w0 * k, Tl[i], cl[i], "k = $(kl[i]):  y₀ = $(fmt4(2w0 * kl[i])),  T = $(fmt4(Tl[i]))")
         for (i, k) in enumerate(kl)]
kr = [1.25, 1.5]
Tr = [2 * ellK(1 / k) / (k * w0) for k in kr]
rots = [makerun(0.0, 2w0 * kr[1], 2Tr[1], :red, "k = 1.25:  from (0, $(fmt4(2w0 * kr[1])))"),
        makerun(0.0, 2w0 * kr[2], 2Tr[2], ccyan, "k = 1.5:  from (0, $(fmt4(2w0 * kr[2])))"),
        makerun(4π, -2w0 * kr[1], 2Tr[1], :orange, "from (4π, −$(fmt4(2w0 * kr[1])))"),
        makerun(4π, -2w0 * kr[2], 2Tr[2], :brown, "from (4π, −$(fmt4(2w0 * kr[2])))")]
shifted = [makerun(s, 2w0 * k, Tl[i], cl[i], "") for s in (2π, 4π) for (i, k) in enumerate(kl)]

for (i, r) in enumerate(loops)
    @printf("loop k=%.2f: y0=%.6f T=%.6f closure=%.2e max|E-E0|=%.2e x range [%.4f, %.4f]\n",
            kl[i], r.y[1], r.T, max(abs(r.x[end] - r.x[1]), abs(r.y[end] - r.y[1])),
            maximum(abs.(E.(r.x, r.y) .- E(r.x[1], r.y[1]))), extrema(r.x)...)
end
for (i, r) in enumerate(rots)
    @printf("rotation %d: start (%.6f, %.6f) 2T_rot=%.6f end (%.6f, %.6f) min|y|=%.5f max|E-E0|=%.2e\n",
            i, r.x[1], r.y[1], r.T, r.x[end], r.y[end], minimum(abs.(r.y)),
            maximum(abs.(E.(r.x, r.y) .- E(r.x[1], r.y[1]))))
end
@printf("linear period 2pi/sqrt2 = %.6f\n", 2π / w0)
@printf("shifted loops: max |x - (x_loop + shift)| = %.2e\n",
        maximum(maximum(abs.(shifted[i + 4(s - 1)].x .- loops[i].x .- 2π * s)) for s in 1:2 for i in 1:4))
@printf("phase-plane y range of all runs: %.4f %.4f; x range %.4f %.4f\n",
        minimum(minimum(r.y) for r in vcat(loops, rots, shifted)),
        maximum(maximum(r.y) for r in vcat(loops, rots, shifted)),
        minimum(minimum(r.x) for r in vcat(loops, rots, shifted)),
        maximum(maximum(r.x) for r in vcat(loops, rots, shifted)))

# Index of the last Runge-Kutta point with t_j <= t
jat(r, t) = min(m, floor(Int, t / r.h + 1e-9))

# --- Drawing ---
title_str = "Pendulum, Example 6:  x″ + 2 sin x = 0  (x′ = y,  y′ = −2 sin x),  " *
            "Runge-Kutta, m = 100 steps per curve"
sx = range(-π, 5π, length=1201)
sep = 2 * sqrt(2) .* abs.(cos.(sx ./ 2))
πticks = ([-π, 0, π, 2π, 3π, 4π, 5π], ["−π", "0", "π", "2π", "3π", "4π", "5π"])

function phase_base()
    p = plot(xlims=(-π, 5π), ylims=(-4.8, 6.0), framestyle=:box, xlabel="x (angle)",
             ylabel="y = x′", grid=true, legend=:top, legend_columns=3, legendfontsize=8,
             titlefontsize=10,
             xticks=πticks)
    plot!(p, sx, sep; color=:gray45, ls=:dash, lw=1.2, label="separatrix E = 4")
    plot!(p, sx, -sep; color=:gray45, ls=:dash, lw=1.2, label="")
    scatter!(p, [0, 2π, 4π], zeros(3); color=:black, ms=3, markerstrokewidth=0,
             label="rest at the bottom")
    scatter!(p, [-π, π, 3π, 5π], zeros(4); color=:gray40, marker=:xcross, ms=5,
             label="rest at the top")
    return p
end

function pend_base()
    p = plot(xlims=(-1.3, 1.3), ylims=(-1.3, 1.3), aspect_ratio=:equal, framestyle=:none,
             legend=:outerbottom, legendfontsize=8, titlefontsize=10, grid=false)
    θc = range(0, 2π, length=200)
    plot!(p, cos.(θc), sin.(θc); color=:gray80, ls=:dot, lw=1, label="")
    plot!(p, [0, 0], [0, -1.2]; color=:gray70, ls=:dash, lw=1, label="")
    return p
end

function rod!(p, x, c, lab)
    plot!(p, [0, sin(x)], [0, -cos(x)]; color=c, lw=2.5, label="")
    scatter!(p, [sin(x)], [-cos(x)]; color=c, ms=8, markerstrokewidth=0, label=lab)
end

function draw(part, t; final=false)
    runs = part == 1 ? loops : rots
    pP = phase_base()
    if part >= 2
        for r in loops
            plot!(pP, r.x, r.y; color=r.c, lw=1.2, alpha=0.5, label="")
        end
    end
    if final
        for r in shifted
            plot!(pP, r.x, r.y; color=r.c, lw=1.5, label="")
        end
    end
    for r in runs
        j = jat(r, t)
        plot!(pP, r.x[1:j+1], r.y[1:j+1]; color=r.c, lw=2, label="")
        final || scatter!(pP, [r.x[j+1]], [r.y[j+1]]; color=r.c, ms=5, markerstrokewidth=0, label="")
    end
    if part == 1
        title!(pP, "four closed loops around (0, 0), each run for one period")
    elseif !final
        title!(pP, "rotations over the tops, two turns each, in both directions")
    else
        title!(pP, "and the loops of Part 1 started at (2π, y₀) and (4π, y₀)")
    end

    pD = pend_base()
    for r in runs
        j = jat(r, t)
        rod!(pD, r.x[j+1], r.c, part == 1 ? "x = $(fmt4(r.x[j+1]))" * (j == m ? " (one period)" : "") :
                                "turns: $(fmt4(abs(r.x[j+1] - r.x[1]) / (2π)))")
    end
    scatter!(pD, [0.0], [0.0]; color=:black, ms=4, label="")
    title!(pD, "t = $(fmt(t))")

    if part == 1
        pT = plot(xlims=(0, 7.6), ylims=(-2.8, 2.8), framestyle=:box, xlabel="t", ylabel="x",
                  grid=true, legend=:outerright, legendfontsize=8, titlefontsize=10)
        hline!(pT, [0.0]; color=:gray60, lw=1, label="")
        vline!(pT, [2π / w0]; color=:gray40, ls=:dot, lw=1.2,
               label="linear period 2π/√2 = $(fmt4(2π / w0))")
        for r in runs
            j = jat(r, t)
            plot!(pT, (0:j) .* r.h, r.x[1:j+1]; color=r.c, lw=2, label=r.lab)
            j == m && scatter!(pT, [r.T], [r.x[end]]; color=r.c, marker=:diamond, ms=6,
                               markerstrokewidth=0, label="")
        end
        title!(pT, "x(t): the larger the swing, the longer the period (◆ = one period)")
    else
        pT = plot(xlims=(0, 4.6), ylims=(-0.6, 4π + 0.6), framestyle=:box, xlabel="t",
                  ylabel="x", grid=true, legend=:outerright, legendfontsize=8, titlefontsize=10,
                  yticks=([0, π, 2π, 3π, 4π], ["0", "π", "2π", "3π", "4π"]))
        hline!(pT, [π, 3π]; color=:gray40, ls=:dot, lw=1.2, label="tops x = π, 3π")
        for r in runs
            j = jat(r, t)
            plot!(pT, (0:j) .* r.h, r.x[1:j+1]; color=r.c, lw=2, label=r.lab)
        end
        title!(pT, "x(t): over the top twice, slowest at the tops (2T_rot = " *
                   "$(fmt4(rots[1].T)) and $(fmt4(rots[2].T)))")
    end

    l = @layout [[a{0.6w} b]; c{0.36h}]
    plot(pP, pD, pT; layout=l, size=(1250, 760), plot_title=title_str,
         plot_titlefontsize=11, left_margin=4Plots.mm, bottom_margin=4Plots.mm,
         background_color=:white)
end

dt = 0.1
anim = Animation()
t1 = collect(0:dt:ceil(maximum(Tl) / dt) * dt)
for t in t1
    draw(1, t); frame(anim)
end
for _ in 1:12
    frame(anim)                                        # hold 1.5 s
end
t2 = collect(0:dt:ceil(maximum(r.T for r in rots) / dt) * dt)
for t in t2
    draw(2, t); frame(anim)
end
for _ in 1:8
    frame(anim)
end
draw(2, t2[end]; final=true)
for _ in 1:24
    frame(anim)                                        # hold 3 s
end
gif(anim, joinpath(@__DIR__, "pendulumbb.gif"); fps=8)
println("Saved: pendulumbb.gif")
