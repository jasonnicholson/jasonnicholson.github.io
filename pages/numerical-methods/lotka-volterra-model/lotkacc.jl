# lotkacc.jl
# Lotka-Volterra Model animation: Mathews' Example 6, foxes and rabbits.
# x' = 2x - 0.01xy (rabbits), y' = -0.8y + 0.0002xy (foxes), x(0) = 5000,
# y(0) = 100, over Mathews' interval [0, 5], solved with the classical
# fourth-order Runge-Kutta method in vector form with m = 100 steps
# (h = 0.05). One step per frame. Mathews' program, step count and graphs for
# this example are lost; the window and m are chosen here.
# Left: the phase plane, with the exact closed orbit (the level curve of the
# conserved quantity V, dashed), the equilibrium (4000, 200) and the lines
# y = 200, where x' = 0, and x = 4000, where y' = 0.
# Right: rabbits x(t) and foxes y(t) against t (Mathews plots them
# separately), with a vertical line at each extreme value once the run has
# passed it, from a reference solution.
# Produces: lotkacc.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))       # parameters (exact values)
fmt4(x) = um(@sprintf("%#.4g", x))                     # computed values, 4 s.f.
fmt5(x) = um(@sprintf("%#.5g", x))                     # computed values, 5 s.f.

# --- Model (Example 6) ---
k1, k2, k3, k4 = 2.0, 0.01, 0.8, 0.0002
F(t, z) = [k1 * z[1] - k2 * z[1] * z[2], -k3 * z[2] + k4 * z[1] * z[2]]
V(x, y) = k4 * x - k3 * log(x) + k2 * y - k1 * log(y)  # conserved quantity (4)
z0 = [5000.0, 100.0]
xe, ye = k3 / k4, k1 / k2                              # equilibrium (4000, 200)
a, b, m = 0.0, 5.0, 100
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

Z  = rk4(F, a, b, z0, m)
xs = first.(Z)
ys = last.(Z)

# --- Reference events: Runge-Kutta with h = 1e-4; a crossing of y = 200 is an
# extreme of x, a crossing of x = 4000 an extreme of y; bisection on the step ---
function crossings(g, z0, tend; h=1e-4)
    out = Tuple{Float64,Vector{Float64}}[]
    z = copy(z0); t = 0.0
    while t < tend
        zn = rk4(F, t, t + h, z, 1)[end]
        if sign(g(z)) != sign(g(zn)) && g(zn) != 0
            lo, hi = 0.0, h
            for _ in 1:60
                mid = (lo + hi) / 2
                sign(g(rk4(F, t, t + mid, z, 1)[end])) == sign(g(z)) ? (lo = mid) : (hi = mid)
            end
            tc = t + (lo + hi) / 2
            push!(out, (tc, rk4(F, t, tc, z, 1)[end]))
        end
        z = zn; t += h
    end
    return out
end
xext = crossings(z -> z[2] - ye, z0, 6.0)              # extremes of the rabbits
yext = crossings(z -> z[1] - xe, z0, 6.0)              # extremes of the foxes
Tper = crossings(z -> z[1] - z0[1], z0, 6.0)           # x = 5000 again (up) after one period
T = first(filter(c -> c[1] > 1 && c[2][2] < ye, Tper))[1]
for (tc, zc) in xext
    @printf("y = 200 crossing (x extreme): t = %.6f, x = %.4f\n", tc, zc[1])
end
for (tc, zc) in yext
    @printf("x = 4000 crossing (y extreme): t = %.6f, y = %.5f\n", tc, zc[2])
end
@printf("period T = %.8f\n", T)
tRmax, xRmax = xext[1][1], xext[1][2][1]
tRmin, xRmin = xext[2][1], xext[2][2][1]
tFmax, yFmax = yext[1][1], yext[1][2][2]
tFmin, yFmin = yext[2][1], yext[2][2][2]
lag = tFmax - tRmax
@printf("fox peak - rabbit peak = %.6f\n", lag)
@printf("RK m = %d end (t = 5): (%.4f, %.6f)\n", m, xs[end], ys[end])
@printf("max |V - V0| along the run = %.3e\n", maximum(abs.(V.(xs, ys) .- V(z0...))))

# --- Exact orbit: the level curve V = V(5000, 100), found along rays from (xe, ye) ---
function level_curve(V, V0, xc, yc, sx, sy; n=3601)
    ox = Float64[]; oy = Float64[]
    for θ in range(0, 2π, length=n)
        dx, dy = sx * cos(θ), sy * sin(θ)
        redge = min(dx < 0 ? xc / -dx : Inf, dy < 0 ? yc / -dy : Inf)
        g(r) = V(xc + r * dx, yc + r * dy) - V0          # increasing in r (V convex)
        lo, hi = 0.0, min(1.0, redge / 2)
        while g(hi) < 0
            lo = hi
            hi = isfinite(redge) ? (hi + redge) / 2 : 2hi
        end
        for _ in 1:200
            mid = (lo + hi) / 2
            g(mid) < 0 ? (lo = mid) : (hi = mid)
        end
        r = (lo + hi) / 2
        push!(ox, xc + r * dx); push!(oy, yc + r * dy)
    end
    return ox, oy
end
ox, oy = level_curve(V, V(z0...), xe, ye, xe, ye)
@printf("orbit ranges: x in [%.2f, %.2f], y in [%.3f, %.3f]\n", extrema(ox)..., extrema(oy)...)

# --- Drawing ---
cR, cF, cO = :royalblue, :orangered, :purple
xl, yl, ylP = (0.0, 10500.0), (0.0, 400.0), (0.0, 480.0)
title_str = "Lotka-Volterra (Mathews' Example 6):  x′ = 2x − 0.01xy (rabbits),  " *
            "y′ = −0.8y + 0.0002xy (foxes),  (x₀, y₀) = (5000, 100),  Runge-Kutta, m = $m, h = $(fmt(h))"

function draw_frame(j)
    t = ts[j+1]
    pP = plot(xlims=xl, ylims=ylP, framestyle=:box, xlabel="rabbits x", ylabel="foxes y",
              grid=true, legend=:top, legend_columns=2, legendfontsize=7, titlefontsize=10,
              xformatter=v -> @sprintf("%.0f", v))
    hline!(pP, [ye]; color=:gray60, ls=:dot, lw=1.2, label="y = 200: x′ = 0")
    vline!(pP, [xe]; color=:gray30, ls=:dashdot, lw=1, label="x = 4000: y′ = 0")
    plot!(pP, ox, oy; color=:gray55, ls=:dash, lw=1, label="exact orbit (V constant)")
    scatter!(pP, [xe], [ye]; color=:red, ms=4, markerstrokewidth=0,
             label="equilibrium (4000, 200)")
    plot!(pP, xs[1:j+1], ys[1:j+1]; color=cO, lw=2, label="Runge-Kutta, t from 0 to 5")
    scatter!(pP, [z0[1]], [z0[2]]; color=:white, markerstrokecolor=:black, ms=4,
             label="start (5000, 100)")
    scatter!(pP, [xs[j+1]], [ys[j+1]]; color=cO, ms=6, label="")
    title!(pP, j == 0 ? "step j = 0:  t = 0:  (x, y) = (5000, 100)" :
               "step j = $j:  t = $(fmt(t)):  (x, y) = ($(fmt5(xs[j+1])), $(fmt5(ys[j+1])))")

    pR = plot(xlims=(0, 5), ylims=xl, framestyle=:box, ylabel="rabbits x(t)",
              grid=true, legend=:topright, legendfontsize=7, titlefontsize=10,
              yformatter=v -> @sprintf("%.0f", v))
    pF = plot(xlims=(0, 5), ylims=yl, framestyle=:box, xlabel="t", ylabel="foxes y(t)",
              grid=true, legend=:topright, legendfontsize=7, titlefontsize=10)
    hline!(pR, [xe]; color=:gray30, ls=:dashdot, lw=1, label="x = 4000")
    hline!(pF, [ye]; color=:gray60, ls=:dot, lw=1.2, label="y = 200")
    if t >= tRmax
        for p in (pR, pF)
            vline!(p, [tRmax]; color=cR, ls=:dash, lw=1, label="")
        end
        scatter!(pR, [tRmax], [xRmax]; color=cR, marker=:diamond, ms=5, markerstrokecolor=:black,
                 label="rabbit peak $(fmt5(xRmax)) at t = $(fmt4(tRmax))")
        scatter!(pP, [xRmax], [ye]; color=cR, marker=:diamond, ms=5, markerstrokecolor=:black,
                 label="rabbit peak (on y = 200)")
    end
    if t >= tFmax
        for p in (pR, pF)
            vline!(p, [tFmax]; color=cF, ls=:dash, lw=1, label="")
        end
        scatter!(pF, [tFmax], [yFmax]; color=cF, marker=:diamond, ms=5, markerstrokecolor=:black,
                 label="fox peak $(fmt4(yFmax)) at t = $(fmt4(tFmax))")
        scatter!(pP, [xe], [yFmax]; color=cF, marker=:diamond, ms=5, markerstrokecolor=:black,
                 label="fox peak (on x = 4000)")
    end
    if t >= tRmin
        for p in (pR, pF)
            vline!(p, [tRmin]; color=cR, ls=:dash, lw=1, label="")
        end
        scatter!(pR, [tRmin], [xRmin]; color=cR, marker=:utriangle, ms=5,
                 markerstrokecolor=:black, label="rabbit low $(fmt5(xRmin)) at t = $(fmt4(tRmin))")
        scatter!(pP, [xRmin], [ye]; color=cR, marker=:utriangle, ms=5, markerstrokecolor=:black,
                 label="rabbit low (on y = 200)")
    end
    plot!(pR, ts[1:j+1], xs[1:j+1]; color=cR, lw=2, label="")
    plot!(pF, ts[1:j+1], ys[1:j+1]; color=cF, lw=2, label="")
    scatter!(pR, [t], [xs[j+1]]; color=cR, ms=4, markerstrokewidth=0, label="")
    scatter!(pF, [t], [ys[j+1]]; color=cF, ms=4, markerstrokewidth=0, label="")
    title!(pR, t >= tFmax ? "the fox peak comes $(fmt4(lag)) time units after the rabbit peak" :
                            "rabbits (prey)")
    title!(pF, "foxes (predators); their low, at t = $(fmt4(tFmin)), is after t = 5")

    l = @layout [a{0.5w} [b; c]]
    plot(pP, pR, pF; layout=l, size=(1250, 620), plot_title=title_str,
         plot_titlefontsize=10, left_margin=6Plots.mm, bottom_margin=4Plots.mm,
         background_color=:white)
end

anim = Animation()
for j in 0:m
    draw_frame(j)
    frame(anim)
end
for _ in 1:29                                          # hold the last frame 3 s
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "lotkacc.gif"); fps=10)
println("Saved: lotkacc.gif")
