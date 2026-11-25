# pendulumaa.jl
# Pendulum animation: Mathews' Examples 1, 3 and 4, the damped linear pendulum
# x'' + x'/10 + 2x = 0 against the damped nonlinear pendulum
# x'' + x'/10 + 2 sin x = 0, both from x(0) = 1, x'(0) = 2 on [0, 20], solved with
# the classical fourth-order Runge-Kutta method for the system x' = y, y' = f(t, x, y)
# (Mathews' Runge2D) with m = 100 steps, h = 0.2. One step of both runs per frame.
# Left: the two pendulums drawn as a rod and a bob at the computed angles x_j
# (linear blue, nonlinear red: Mathews' colours for the analytic linear solution of
# Example 2 and the Runge-Kutta nonlinear solution of Example 3).
# Top right: x_j against t_j, the comparison of Example 4, with each zero of the
# solutions marked when it is passed (linear zeros from the exact solution of
# Example 2, nonlinear zeros from a reference run, Runge-Kutta with h = 0.001 and
# the crossing refined by bisection).
# Bottom right: the phase plane (x, y) with the level E = 4 of the energy
# E = y^2/2 + 2(1 - cos x), the energy of the nonlinear pendulum at rest at the top.
# Produces: pendulumaa.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))
fmt4(x) = um(@sprintf("%#.4g", x))
sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))

# --- Models (Examples 1 and 3) ---
Flin(t, z) = [z[2], -z[2] / 10 - 2 * z[1]]
Fnl(t, z)  = [z[2], -z[2] / 10 - 2 * sin(z[1])]
E(x, y) = y^2 / 2 + 2 * (1 - cos(x))                  # energy of the nonlinear model
z0 = [1.0, 2.0]
a, b, m = 0.0, 20.0, 100

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

Zl = rk4(Flin, a, b, z0, m)
Zn = rk4(Fnl, a, b, z0, m)
ts = [a + j * (b - a) / m for j in 0:m]
xl, yl = first.(Zl), last.(Zl)
xn, yn = first.(Zn), last.(Zn)

# --- Zeros of the solutions ---
# Linear: exact solution x(t) = A e^(-t/20) cos(ωt + δ) of Example 2
ω = sqrt(799) / 20
δ = -atan(41 / sqrt(799))
zl = [(π / 2 + k * π - δ) / ω for k in 0:20]
zl = filter(t -> 0 < t <= b, zl)
# Nonlinear: reference run with h = 0.001, each sign change refined by bisection
function zeros_ref(F, z0, b; h=1e-3)
    zs = Float64[]; z = copy(z0); t = 0.0
    while t < b - h / 2
        zn = rk4(F, t, t + h, z, 1)[end]
        if sign(z[1]) != sign(zn[1])
            lo, hi = 0.0, h
            for _ in 1:60
                mid = (lo + hi) / 2
                sign(rk4(F, t, t + mid, z, 1)[end][1]) == sign(z[1]) ? (lo = mid) : (hi = mid)
            end
            push!(zs, t + (lo + hi) / 2)
        end
        z = zn; t += h
    end
    return zs
end
zn = zeros_ref(Fnl, z0, b)
halfn = diff(zn)

@printf("linear zeros (%d): %s\n", length(zl), join([@sprintf("%.4f", t) for t in zl], " "))
@printf("nonlinear zeros (%d): %s\n", length(zn), join([@sprintf("%.4f", t) for t in zn], " "))
@printf("nonlinear half-swings: %s\n", join([@sprintf("%.4f", d) for d in halfn], " "))
@printf("linear half-swing pi/omega = %.6f\n", π / ω)
@printf("RK4 x ranges: linear [%.5f, %.5f], nonlinear [%.5f, %.5f]\n",
        extrema(xl)..., extrema(xn)...)
@printf("RK4 y ranges: linear [%.5f, %.5f], nonlinear [%.5f, %.5f]\n",
        extrema(yl)..., extrema(yn)...)
@printf("nonlinear energy E0 = %.6f, E at t = 20 (RK4) = %.6f, energy nonincreasing on grid: %s\n",
        E(xn[1], yn[1]), E(xn[end], yn[end]), all(diff(E.(xn, yn)) .<= 0))
@printf("x(20): linear %.6f, nonlinear %.6f\n", xl[end], xn[end])

# --- Drawing ---
cl, cn = :blue, :red
deg(x) = x * 180 / π
title_str = "Pendulum, Examples 1, 3 and 4:  linear x″ + x′/10 + 2x = 0 (blue),  " *
            "nonlinear x″ + x′/10 + 2 sin x = 0 (red)\n" *
            "x(0) = 1,  x′(0) = 2,  Runge-Kutta method with m = 100 steps of h = 0.2"
sx = range(-π, π, length=401)
sep = 2 * sqrt(2) .* abs.(cos.(sx ./ 2))               # E = 4:  y = ±2√2 |cos(x/2)|
halfstr = join([@sprintf("%.3f", d) for d in halfn], ", ")

function draw_frame(j; final=false)
    t = ts[j+1]
    # Pendulums: pivot at the origin, rod of length 1, angle measured from the downward vertical
    pP = plot(xlims=(-1.3, 1.3), ylims=(-1.3, 1.3), aspect_ratio=:equal, framestyle=:none,
              legend=:outerbottom, legendfontsize=8, titlefontsize=10, grid=false)
    θc = range(0, 2π, length=200)
    plot!(pP, cos.(θc), sin.(θc); color=:gray80, ls=:dot, lw=1, label="")
    plot!(pP, [0, 0], [0, -1.2]; color=:gray70, ls=:dash, lw=1, label="")
    for (x, c, lab) in ((xl[j+1], cl, "linear  x = $(fmt4(xl[j+1])) rad = $(fmt4(deg(xl[j+1])))°"),
                        (xn[j+1], cn, "nonlinear  x = $(fmt4(xn[j+1])) rad = $(fmt4(deg(xn[j+1])))°"))
        plot!(pP, [0, sin(x)], [0, -cos(x)]; color=c, lw=3, label="")
        scatter!(pP, [sin(x)], [-cos(x)]; color=c, ms=11, markerstrokewidth=0, label=lab)
    end
    scatter!(pP, [0.0], [0.0]; color=:black, ms=4, label="")
    title!(pP, "step j = $j:  t = $(fmt(t))")

    # x(t), Example 4's comparison
    nzl = count(<=(t), zl); nzn = count(<=(t), zn)
    pT = plot(xlims=(0, 20.4), ylims=(-2.3, 2.5), framestyle=:box, xlabel="t", ylabel="x",
              grid=true, legend=:topright, legendfontsize=8, titlefontsize=10)
    hline!(pT, [0.0]; color=:gray60, lw=1, label="")
    plot!(pT, ts[1:j+1], xl[1:j+1]; color=cl, lw=2, label="linear: $nzl zero$(nzl == 1 ? "" : "s") so far")
    plot!(pT, ts[1:j+1], xn[1:j+1]; color=cn, lw=2, label="nonlinear: $nzn zero$(nzn == 1 ? "" : "s") so far")
    nzl > 0 && scatter!(pT, zl[1:nzl], zeros(nzl); color=cl, marker=:diamond, ms=5,
                        markerstrokewidth=0, label="")
    nzn > 0 && scatter!(pT, zn[1:nzn], zeros(nzn); color=cn, marker=:utriangle, ms=5,
                        markerstrokewidth=0, label="")
    scatter!(pT, [t, t], [xl[j+1], xn[j+1]]; color=[cl, cn], ms=5, markerstrokewidth=0, label="")
    if final
        title!(pT, "time between zeros: linear $(@sprintf("%.3f", π / ω)) every time;  " *
                   "nonlinear $halfstr", titlefontsize=9)
    else
        title!(pT, "x(t): the nonlinear pendulum swings wider at first, and more slowly")
    end

    # Phase plane
    pZ = plot(xlims=(-π, π), ylims=(-3.1, 3.1), framestyle=:box, xlabel="x (angle)",
              ylabel="y = x′", grid=true, legend=:outerright, legendfontsize=8, titlefontsize=10,
              xticks=([-π, -π/2, 0, π/2, π], ["−π", "−π/2", "0", "π/2", "π"]))
    plot!(pZ, sx, sep; color=:gray50, ls=:dash, lw=1, label="E = 4 (top)")
    plot!(pZ, sx, -sep; color=:gray50, ls=:dash, lw=1, label="")
    plot!(pZ, xl[1:j+1], yl[1:j+1]; color=cl, lw=1.5, label="linear")
    plot!(pZ, xn[1:j+1], yn[1:j+1]; color=cn, lw=1.5, label="nonlinear")
    scatter!(pZ, [xl[j+1]], [yl[j+1]]; color=cl, ms=5, markerstrokewidth=0, label="")
    scatter!(pZ, [xn[j+1]], [yn[j+1]]; color=cn, ms=5, markerstrokewidth=0, label="")
    title!(pZ, "phase plane:  nonlinear energy E = y²/2 + 2(1 − cos x) = $(fmt4(E(xn[j+1], yn[j+1]))) < 4")

    l = @layout [a{0.33w} [b; c]]
    plot(pP, pT, pZ; layout=l, size=(1200, 670), plot_title=title_str,
         plot_titlefontsize=11, plot_titlevspan=0.08, left_margin=4Plots.mm, bottom_margin=4Plots.mm,
         background_color=:white)
end

anim = Animation()
for j in 0:m
    draw_frame(j)
    frame(anim)
end
draw_frame(m; final=true)                              # hold the last step, 3 s
for _ in 1:24
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "pendulumaa.gif"); fps=8)
println("Saved: pendulumaa.gif")
