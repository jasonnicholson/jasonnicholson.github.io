# lotkaaa.jl
# Lotka-Volterra Model animation: Mathews' Example 2, runs (a) and (b).
# x' = x - xy, y' = -y + xy from (x0, y0) = (2, 1), solved with the classical
# fourth-order Runge-Kutta method in vector form: run (a) forward over
# [0, 3.3] and run (b) backward over [0, -3.3], m = 50 steps each
# (h = +0.066 and -0.066). One Runge-Kutta step of each run per frame.
# Left: the phase plane in Mathews' window [0, 2] x [0, 2], with his colours
# (run (a) magenta, run (b) blue), the exact orbit x y e^(-x-y) = 2/e^3 of
# Example 3 (gray, dashed) and the equilibrium (1, 1) (red dot).
# Top right (new): the populations x(t) and y(t) of both runs against t.
# Bottom right: Mathews' zoom window [0.4, 0.5] x [0.6, 0.8], where the ends
# of the two runs nearly meet, with the exact point halfway round the orbit,
# at t = T/2 = -T/2 (mod T). After the last step the zoom panel closes in on
# the gap between the two ends, in a square window of side 0.008.
# Produces: lotkaaa.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))       # parameters (exact values)
fmt6(x) = um(@sprintf("%#.6g", x))                     # computed values, 6 s.f.
fmt4(x) = um(@sprintf("%#.4g", x))                     # computed values, 4 s.f.
sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))   # 12 -> "₁₂"

# --- Model (Example 2: k1 = k2 = k3 = k4 = 1) ---
F(t, z) = [z[1] - z[1] * z[2], -z[2] + z[1] * z[2]]
V(x, y) = x - log(x) + y - log(y)                     # conserved quantity (4)
z0 = [2.0, 1.0]
m  = 50
a  = 0.0
ba = 3.3                                              # run (a): [0, 3.3]
bb = -3.3                                             # run (b): [0, -3.3]

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

Za = rk4(F, a, ba, z0, m)
Zb = rk4(F, a, bb, z0, m)
ta = [a + j * (ba - a) / m for j in 0:m]
tb = [a + j * (bb - a) / m for j in 0:m]
xa, ya = first.(Za), last.(Za)
xb, yb = first.(Zb), last.(Zb)

# --- Reference: Runge-Kutta with h = 1e-4 for the period and the half-way point ---
# The period is the time from (2, 1) to the next upward crossing of y = 1.
function period_and_half(z0; h=1e-4)
    z = copy(z0); t = 0.0
    while true
        zn = rk4(F, t, t + h, z, 1)[end]
        if t > 1 && z[2] < 1 <= zn[2]                  # upward crossing of y = 1
            lo, hi = 0.0, h                            # bisect on the step length
            for _ in 1:60
                mid = (lo + hi) / 2
                rk4(F, t, t + mid, z, 1)[end][2] < 1 ? (lo = mid) : (hi = mid)
            end
            return t + (lo + hi) / 2
        end
        z = zn; t += h
    end
end
T = period_and_half(z0)
zhalf = rk4(F, 0.0, T / 2, z0, 40000)[end]           # exact point at t = T/2

# --- Exact orbit (Example 3): the level curve V = V(2, 1), found along rays from (1, 1) ---
function level_curve(V, V0, xc, yc, sx, sy; n=3601)
    xs = Float64[]; ys = Float64[]
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
        push!(xs, xc + r * dx); push!(ys, yc + r * dy)
    end
    return xs, ys
end
V0 = V(z0...)
ox, oy = level_curve(V, V0, 1.0, 1.0, 1.0, 1.0)

gap = hypot(xa[end] - xb[end], ya[end] - yb[end])
dV  = maximum(abs.(vcat(V.(xa, ya), V.(xb, yb)) .- V0))

@printf("run (a) end t = %g: (%.8f, %.8f)\n", ta[end], xa[end], ya[end])
@printf("run (b) end t = %g: (%.8f, %.8f)\n", tb[end], xb[end], yb[end])
@printf("gap between the ends = %.6e\n", gap)
@printf("period T = %.10f, T/2 = %.10f, exact point at T/2 = (%.8f, %.8f)\n",
        T, T / 2, zhalf...)
@printf("max |V - V0| over both runs = %.3e\n", dV)
xlimsZ, ylimsZ = (0.4, 0.5), (0.6, 0.8)
inzoom(x, y) = xlimsZ[1] <= x <= xlimsZ[2] && ylimsZ[1] <= y <= ylimsZ[2]
@printf("first step inside the zoom window: (a) j = %d, (b) j = %d\n",
        findfirst(inzoom.(xa, ya)) - 1, findfirst(inzoom.(xb, yb)) - 1)

# --- Drawing ---
ca, cb = :magenta, :blue
title_str = "Lotka-Volterra (Mathews' Example 2):  x′ = x − xy,  y′ = −y + xy,  " *
            "(x₀, y₀) = (2, 1),  Runge-Kutta, m = $m steps of h = ±$(fmt((ba - a) / m))"

function draw_frame(j; close=false)
    # Phase plane, Mathews' window
    pP = plot(xlims=(0, 2), ylims=(0, 2), aspect_ratio=:equal, framestyle=:box,
              xlabel="x (prey)", ylabel="y (predators)", grid=true,
              legend=:bottomleft, legendfontsize=7, titlefontsize=10)
    plot!(pP, ox, oy; color=:gray55, ls=:dash, lw=1, label="exact orbit x y e⁻ˣ⁻ʸ = 2/e³")
    plot!(pP, [0.4, 0.5, 0.5, 0.4, 0.4], [0.6, 0.6, 0.8, 0.8, 0.6]; color=:black,
          lw=0.8, label="zoom window (bottom right)")
    plot!(pP, xa[1:j+1], ya[1:j+1]; color=ca, lw=2, marker=:circle, ms=1.8,
          markerstrokewidth=0, label="(a) t from 0 to 3.3")
    plot!(pP, xb[1:j+1], yb[1:j+1]; color=cb, lw=2, marker=:circle, ms=1.8,
          markerstrokewidth=0, label="(b) t from 0 to −3.3")
    scatter!(pP, [1.0], [1.0]; color=:red, ms=4, markerstrokewidth=0,
             label="equilibrium (1, 1)")
    scatter!(pP, [xa[j+1]], [ya[j+1]]; color=ca, ms=6, label="")
    scatter!(pP, [xb[j+1]], [yb[j+1]]; color=cb, ms=6, label="")
    title!(pP, j == 0 ? "step j = 0:  t = 0" : "step j = $j:  t = ±$(fmt(ta[j+1]))")

    # Populations against t (new)
    pT = plot(xlims=(-3.5, 3.5), ylims=(0, 2.2), framestyle=:box, xlabel="t",
              ylabel="population", grid=true, legend=:bottom, legend_columns=2,
              legendfontsize=7, titlefontsize=10)
    vline!(pT, [0.0]; color=:gray70, lw=1, label="")
    plot!(pT, [NaN], [NaN]; color=:black, lw=1.5, label="x(t) prey")
    plot!(pT, [NaN], [NaN]; color=:black, lw=1.5, ls=:dash, label="y(t) predators")
    plot!(pT, ta[1:j+1], xa[1:j+1]; color=ca, lw=1.8, label="")
    plot!(pT, ta[1:j+1], ya[1:j+1]; color=ca, lw=1.8, ls=:dash, label="")
    plot!(pT, tb[1:j+1], xb[1:j+1]; color=cb, lw=1.8, label="")
    plot!(pT, tb[1:j+1], yb[1:j+1]; color=cb, lw=1.8, ls=:dash, label="")
    scatter!(pT, [ta[j+1], ta[j+1], tb[j+1], tb[j+1]], [xa[j+1], ya[j+1], xb[j+1], yb[j+1]];
             color=[ca, ca, cb, cb], ms=3.5, markerstrokewidth=0, label="")
    title!(pT, j == 0 ? "Z₀ = (2, 1) for both runs" :
               "(a) Z$(sub(j)) = ($(fmt6(xa[j+1])), $(fmt6(ya[j+1])))    " *
               "(b) Z$(sub(j)) = ($(fmt6(xb[j+1])), $(fmt6(yb[j+1])))")

    # Mathews' zoom window; after the last step, a closer square window
    xlZ, ylZ = close ? (zhalf[1] .+ (-0.004, 0.004), zhalf[2] .+ (-0.004, 0.004)) :
                       (xlimsZ, ylimsZ)
    pZ = plot(xlims=xlZ, ylims=ylZ, framestyle=:box, xlabel="x", ylabel="y",
              grid=true, legend=:topright, legendfontsize=7, titlefontsize=10)
    plot!(pZ, ox, oy; color=:gray40, ls=:dash, lw=1, label="exact orbit")
    plot!(pZ, xa[1:j+1], ya[1:j+1]; color=ca, lw=2, marker=:circle, ms=2.5,
          markerstrokewidth=0, label="")
    plot!(pZ, xb[1:j+1], yb[1:j+1]; color=cb, lw=2, marker=:circle, ms=2.5,
          markerstrokewidth=0, label="")
    if j == m
        scatter!(pZ, [xa[end]], [ya[end]]; color=ca, ms=close ? 6 : 4,
                 label="(a) end ($(fmt6(xa[end])), $(fmt6(ya[end])))")
        scatter!(pZ, [xb[end]], [yb[end]]; color=cb, ms=close ? 6 : 4,
                 label="(b) end ($(fmt6(xb[end])), $(fmt6(yb[end])))")
    end
    scatter!(pZ, [zhalf[1]], [zhalf[2]]; color=:black, marker=:xcross, ms=close ? 7 : 5,
             label="exact point at t = T/2 = $(fmt4(T / 2))")
    if close
        title!(pZ, "closer zoom: the ends are $(fmt4(gap)) apart (3.3 < T/2)")
    elseif j == m
        title!(pZ, "Mathews' zoom window [0.4, 0.5] × [0.6, 0.8]: the ends")
    else
        title!(pZ, "Mathews' zoom window [0.4, 0.5] × [0.6, 0.8]")
    end

    l = @layout [a{0.46w} [b; c]]
    plot(pP, pT, pZ; layout=l, size=(1200, 620), plot_title=title_str,
         plot_titlefontsize=11, left_margin=4Plots.mm, bottom_margin=4Plots.mm,
         background_color=:white)
end

anim = Animation()
for j in 0:m
    draw_frame(j)
    frame(anim)
end
for _ in 1:5                                           # hold the last step 1 s
    frame(anim)
end
draw_frame(m; close=true)                              # then the closer zoom, 3 s
for _ in 1:18
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "lotkaaa.gif"); fps=6)
println("Saved: lotkaaa.gif")
