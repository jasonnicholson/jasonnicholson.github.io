# lotkabb.jl
# Lotka-Volterra Model animation: the aside of Mathews' Example 2.
# x' = x - xy, y' = -y + xy from the five starting points (x0, 1),
# x0 = 2.0, 1.8, 1.6, 1.4, 1.2, each solved with the classical fourth-order
# Runge-Kutta method in vector form over [0, 6.6] with m = 50 steps
# (h = 0.132). One step of all five runs per frame, so the five current
# points always belong to the same time t.
# Left: the phase plane in Mathews' window [0, 2] x [0, 2], with his colours
# for the five curves (cyan, red, blue, magenta, green) and his red dot at the
# critical point (1, 1). A dotted line joins the five current points.
# Right (new): the prey x(t) of each run against t, with a diamond at each
# orbit's period T, where x returns to its starting value x0 (its largest).
# Produces: lotkabb.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))       # parameters (exact values)
fmt4(x) = um(@sprintf("%#.4g", x))                     # computed values, 4 s.f.

# --- Model (Example 2: k1 = k2 = k3 = k4 = 1) and Mathews' aside ---
F(t, z) = [z[1] - z[1] * z[2], -z[2] + z[1] * z[2]]
x0s  = [2.0, 1.8, 1.6, 1.4, 1.2]
cols = [:darkturquoise, :red, :blue, :magenta, :green3]   # Mathews' cyan, red, blue, magenta, green
a, b, m = 0.0, 6.6, 50
h = (b - a) / m
ts = [a + j * h for j in 0:m]

# Classical Runge-Kutta method in vector form, formula (7): returns Z_0, ..., Z_m
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

runs = [rk4(F, a, b, [x0, 1.0], m) for x0 in x0s]
X = [first.(Z) for Z in runs]
Y = [last.(Z) for Z in runs]

# --- Reference periods: Runge-Kutta with h = 1e-4, time to the next upward
# crossing of y = 1 (from (x0, 1) with x0 > 1, y rises through 1 at t = 0) ---
function period(z0; h=1e-4)
    z = copy(z0); t = 0.0
    while true
        zn = rk4(F, t, t + h, z, 1)[end]
        if t > 1 && z[2] < 1 <= zn[2]
            lo, hi = 0.0, h
            for _ in 1:60
                mid = (lo + hi) / 2
                rk4(F, t, t + mid, z, 1)[end][2] < 1 ? (lo = mid) : (hi = mid)
            end
            return t + (lo + hi) / 2
        end
        z = zn; t += h
    end
end
Ts = [period([x0, 1.0]) for x0 in x0s]

for (i, x0) in enumerate(x0s)
    @printf("x0 = %.1f: T = %.8f, RK point at t = 6.6: (%.6f, %.6f), distance from start %.4e, max x(t_j) = %.6f at j = %d\n",
            x0, Ts[i], X[i][end], Y[i][end], hypot(X[i][end] - x0, Y[i][end] - 1),
            maximum(X[i]), argmax(X[i]) - 1)
end
@printf("2pi = %.6f\n", 2pi)

# --- Drawing ---
title_str = "Lotka-Volterra (Mathews' Example 2, aside):  x′ = x − xy,  y′ = −y + xy,  " *
            "from (x₀, 1),  Runge-Kutta, m = $m steps of h = $(fmt(h)) on [0, 6.6]"

function draw_frame(j)
    pP = plot(xlims=(0, 2), ylims=(0, 2), aspect_ratio=:equal, framestyle=:box,
              xlabel="x (prey)", ylabel="y (predators)", grid=true,
              legend=:bottomleft, legendfontsize=7, titlefontsize=10)
    for i in eachindex(x0s)
        plot!(pP, X[i][1:j+1], Y[i][1:j+1]; color=cols[i], lw=2, label="")
    end
    plot!(pP, [X[i][j+1] for i in eachindex(x0s)], [Y[i][j+1] for i in eachindex(x0s)];
          color=:gray30, ls=:dot, lw=1.2, label="the five points at the same t")
    for i in eachindex(x0s)
        scatter!(pP, [X[i][j+1]], [Y[i][j+1]]; color=cols[i], ms=5, label="")
    end
    scatter!(pP, [1.0], [1.0]; color=:red, ms=5, markerstrokewidth=0,
             label="critical point (1, 1)")
    title!(pP, "step j = $j:  t = $(fmt(ts[j+1]))")

    pX = plot(xlims=(0, 6.9), ylims=(0, 2.35), framestyle=:box, xlabel="t",
              ylabel="x(t) (prey)", grid=true, legend=:top, legend_columns=2,
              legendfontsize=7, titlefontsize=10, xticks=0:1:6)
    vline!(pX, [6.6]; color=:gray60, ls=:dash, lw=1, label="")
    for i in eachindex(x0s)
        plot!(pX, ts[1:j+1], X[i][1:j+1]; color=cols[i], lw=2,
              label="x₀ = $(fmt(x0s[i])),  T = $(fmt4(Ts[i]))")
        scatter!(pX, [ts[j+1]], [X[i][j+1]]; color=cols[i], ms=3.5, markerstrokewidth=0,
                 label="")
    end
    scatter!(pX, Ts, x0s; color=cols, marker=:diamond, ms=6, markerstrokecolor=:black,
             label="")
    title!(pX, "prey x(t);  ◆ = period T, x back at x₀;  dashed: t = 6.6")

    plot(pP, pX; layout=(1, 2), size=(1200, 560), plot_title=title_str,
         plot_titlefontsize=11, left_margin=4Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white)
end

anim = Animation()
for j in 0:m
    draw_frame(j)
    frame(anim)
end
for _ in 1:17                                          # hold the last frame 3 s
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "lotkabb.gif"); fps=6)
println("Saved: lotkabb.gif")
