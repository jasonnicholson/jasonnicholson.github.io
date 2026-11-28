# vanderpolcc.jl
# van der Pol System animation: Mathews' Example 6, mu = 4, the relaxation
# oscillation. The system x' = y, y' = -x + 4 (1 - x^2) y is solved with the
# fourth-order Runge-Kutta method in vector form over 0 <= t <= 60 with
# n = 6000 steps (h = 0.01), from the page's start (0, 3) and from (0, 0.5);
# both are inside the cycle for mu = 4. Mathews' interval, start and plot for
# this example are lost. 0.2 time units per frame.
# Left: the phase plane with the limit cycle (computed separately), the curve
# y' = 0, that is y = x / (mu (1 - x^2)), and the lines x = -1 and x = 1.
# Right: x(t) and y(t) against t, with the located maxima of x and, on one
# turn of the cycle, the slow drift of x from its maximum down to 1 and the
# fast fall from 1 to -1.
# Produces: vanderpolcc.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))
fmtn(x, n) = x == 0 ? "0" : um(@sprintf("%#.*g", n, x))

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

mu = 4.0
F(z) = [z[2], -z[1] + mu * (1 - z[1]^2) * z[2]]

# One step of the Runge-Kutta method of order 4, formula (5), of size s
function rkstep(F, z, s)
    K1 = s * F(z)
    K2 = s * F(z + K1 / 2)
    K3 = s * F(z + K2 / 2)
    K4 = s * F(z + K3)
    return z + (K1 + 2K2 + 2K3 + K4) / 6
end

# Runge2D: n steps of size h = (b - a)/n from z0; returns Z_0, ..., Z_n
function rk4(F, a, b, z0, n)
    h = (b - a) / n
    Z = [copy(z0)]
    for j in 1:n
        push!(Z, rkstep(F, Z[end], h))
    end
    return Z
end

# Times where g(Z) changes sign from positive to nonpositive along a computed
# run, located by bisection on the size of one Runge-Kutta step from Z_j.
function events(F, g, Z, a, h)
    out = Tuple{Float64,Vector{Float64}}[]
    for j in 1:length(Z)-1
        if g(Z[j]) > 0 && g(Z[j+1]) <= 0
            lo, hi = 0.0, h
            for _ in 1:60
                mid = (lo + hi) / 2
                g(rkstep(F, Z[j], mid)) > 0 ? (lo = mid) : (hi = mid)
            end
            s = (lo + hi) / 2
            push!(out, (a + (j - 1) * h + s, rkstep(F, Z[j], s)))
        end
    end
    return out
end
ymaxev(z) = z[2]                  # y falls through 0 with x > 0: a maximum of x
xone(z)   = z[1] - 1              # x falls through 1
xmone(z)  = z[1] + 1              # x falls through -1
fall(z)   = -F(z)[2]              # y' rises through 0: a minimum of y (largest |y| below the axis)

# --- Example 6: the two runs ---
a, b, n = 0.0, 60.0, 6000
h = (b - a) / n
ts = [a + j * h for j in 0:n]
Zo = rk4(F, a, b, [0.0, 3.0], n)
Zi = rk4(F, a, b, [0.0, 0.5], n)
xo, yo, xi, yi = first.(Zo), last.(Zo), first.(Zi), last.(Zi)
mo = events(F, ymaxev, Zo, a, h)
mi = events(F, ymaxev, Zi, a, h)
println("outside run, maxima of x: ", join([@sprintf("t = %.4f x = %.6f", m[1], m[2][1]) for m in mo], "; "))
println("inside run,  maxima of x: ", join([@sprintf("t = %.4f x = %.6f", m[1], m[2][1]) for m in mi], "; "))
@printf("end points: outside (%.6f, %.6f), inside (%.6f, %.6f)\n", xo[end], yo[end], xi[end], yi[end])

# One turn of the cycle on the run from (0, 3), from its second maximum of x
t2, z2 = mo[2]
t1 = first(filter(e -> e[1] > t2, events(F, xone, Zo, a, h)))[1]
tm1 = first(filter(e -> e[1] > t2, events(F, xmone, Zo, a, h)))[1]
slow, fast = t1 - t2, tm1 - t1
@printf("run (0,3): second max at t = %.4f, x = %.6f; x = 1 at t = %.4f; x = -1 at t = %.4f\n",
        t2, z2[1], t1, tm1)
@printf("slow drift max -> 1: %.5f, fast fall 1 -> -1: %.5f\n", slow, fast)
Prun = mo[end][1] - mo[end-1][1]
@printf("run (0,3): time between its last two maxima %.5f\n", Prun)

# --- Limit cycle: Runge-Kutta with h = 1e-3 from (2, 0) for 200 time units,
# then two successive maxima of x located as above; one period sampled ---
hc = 1e-3
Zc = rk4(F, 0.0, 200.0, [2.0, 0.0], 200_000)
Zc = rk4(F, 0.0, 25.0, Zc[end], 25_000)
mc = events(F, ymaxev, Zc, 0.0, hc)
P = mc[2][1] - mc[1][1]
xmaxc = mc[2][2][1]
Zcyc = rk4(F, 0.0, P, [xmaxc, 0.0], 20_000)
cx, cy = first.(Zcyc), last.(Zcyc)
ev1 = events(F, xone, Zcyc, 0.0, P / 20_000)[1][1]
evm1 = events(F, xmone, Zcyc, 0.0, P / 20_000)[1][1]
pk = events(F, fall, Zcyc, 0.0, P / 20_000)
pk = first(filter(e -> abs(e[2][1]) < 1.5, pk))   # the y minimum during the fast fall
@printf("cycle: P = %.6f, half period %.6f, max x = %.6f, closure %.1e\n", P, P / 2, xmaxc,
        hypot(cx[end] - xmaxc, cy[end]))
@printf("cycle: max -> x = 1 takes %.5f, x = 1 -> -1 takes %.5f\n", ev1, evm1 - ev1)
@printf("cycle: largest |y| = %.6f at x = %.6f\n", -pk[2][2], pk[2][1])
ypk, xpk = -pk[2][2], pk[2][1]

# --- Drawing ---
cO, cI = :magenta, :dodgerblue
xl, yl = (-2.6, 2.6), (-7.2, 7.2)
xn = collect(range(xl[1], xl[2], length=1041))       # step 0.005: x = -1 and x = 1 are grid points
yn = [abs(abs(x) - 1) < 1e-12 ? NaN : ydraw(x / (mu * (1 - x^2)), yl) for x in xn]
@printf("nullcline grid: NaN at %s\n", string(xn[isnan.(yn)]))
title_str = "van der Pol (Mathews' Example 6):  μ = 4,  x′ = y,  y′ = −x + 4(1 − x²) y,  " *
            "Runge-Kutta, h = 0.01,  0 ≤ t ≤ 60"

function draw_frame(j)
    t = ts[j+1]
    pP = plot(xlims=xl, ylims=yl, framestyle=:box, xlabel="x", ylabel="y = x′", grid=true,
              legend=:outerbottom, legend_columns=2, legendfontsize=7, titlefontsize=9,
              xticks=-2:1:2, yticks=-6:2:6)
    hline!(pP, [0]; color=:black, lw=0.6, label="")
    vline!(pP, [0]; color=:black, lw=0.6, label="")
    vline!(pP, [-1, 1]; color=:gray50, ls=:dot, lw=1, label="x = ±1")
    plot!(pP, xn, yn; color=:darkorange, lw=1.5, label="y′ = 0:  y = x / (4(1 − x²))")
    plot!(pP, xo[1:j+1], yo[1:j+1]; color=cO, lw=1.5, label="from (0, 3)")
    plot!(pP, xi[1:j+1], yi[1:j+1]; color=cI, lw=1.5, label="from (0, 0.5)")
    plot!(pP, cx, cy; color=:black, ls=:dash, lw=1.2, label="limit cycle")
    scatter!(pP, [xpk, -xpk], [-ypk, ypk]; color=:black, marker=:star5, ms=6,
             label="largest |y| on the cycle, $(fmtn(ypk, 4)), at x = ∓$(fmtn(abs(xpk), 4))")
    scatter!(pP, [xo[j+1]], [yo[j+1]]; color=cO, ms=5, label="")
    scatter!(pP, [xi[j+1]], [yi[j+1]]; color=cI, ms=5, label="")
    title!(pP, "t = $(@sprintf("%.1f", t)):  from (0, 3) at ($(fmt(xo[j+1])), $(fmt(yo[j+1]))),  " *
               "from (0, 0.5) at ($(fmt(xi[j+1])), $(fmt(yi[j+1])))")

    pX = plot(xlims=(0, 60), ylims=(-2.6, 3.6), framestyle=:box, ylabel="x(t)", grid=true,
              legend=:top, legend_columns=3, legendfontsize=7, titlefontsize=9,
              yticks=-2:1:2, xticks=0:10:60)
    pY = plot(xlims=(0, 60), ylims=(-7.2, 7.2), framestyle=:box, xlabel="t", ylabel="y(t) = x′(t)",
              grid=true, legend=false, titlefontsize=9, yticks=-6:2:6, xticks=0:10:60)
    if t >= tm1
        for p in (pX, pY)
            vspan!(p, [t2, t1]; color=:gold, alpha=0.25, label="")
            vspan!(p, [t1, tm1]; color=:red, alpha=0.25, label="")
        end
    end
    hline!(pX, [-1, 1]; color=:gray50, ls=:dot, lw=1, label="")
    hline!(pX, [0]; color=:black, lw=0.6, label="")
    hline!(pY, [0]; color=:black, lw=0.6, label="")
    plot!(pX, ts[1:j+1], xo[1:j+1]; color=cO, lw=1.5, label="from (0, 3)")
    plot!(pX, ts[1:j+1], xi[1:j+1]; color=cI, lw=1.5, label="from (0, 0.5)")
    plot!(pY, ts[1:j+1], yo[1:j+1]; color=cO, lw=1.5)
    plot!(pY, ts[1:j+1], yi[1:j+1]; color=cI, lw=1.5)
    ko = count(m -> m[1] <= t, mo)
    ki = count(m -> m[1] <= t, mi)
    scatter!(pX, [m[1] for m in mo[1:ko]], [m[2][1] for m in mo[1:ko]]; color=cO,
             marker=:diamond, ms=4, markerstrokecolor=:black, markerstrokewidth=0.5,
             label="maxima of x")
    scatter!(pX, [m[1] for m in mi[1:ki]], [m[2][1] for m in mi[1:ki]]; color=cI,
             marker=:diamond, ms=4, markerstrokecolor=:black, markerstrokewidth=0.5, label="")
    scatter!(pX, [t, t], [xo[j+1], xi[j+1]]; color=[cO, cI], ms=4, markerstrokewidth=0, label="")
    scatter!(pY, [t, t], [yo[j+1], yi[j+1]]; color=[cO, cI], ms=4, markerstrokewidth=0)
    if ko == 0
        title!(pX, "x(t)")
    elseif ko == 1
        title!(pX, "first maximum of x from (0, 3): $(fmtn(mo[1][2][1], 4)) at t = $(fmtn(mo[1][1], 4))")
    else
        title!(pX, "maxima of x from (0, 3): $(fmtn(mo[1][2][1], 4)), then $(fmtn(mo[2][2][1], 4)) " *
                   "from t = $(fmtn(t2, 4)) on (the cycle's largest x)")
    end
    title!(pY, t >= tm1 ?
           "one turn: x drifts from $(fmtn(z2[1], 4)) to 1 in $(fmtn(slow, 3)) (yellow), " *
           "falls from 1 to −1 in $(fmtn(fast, 3)) (red)" :
           "y(t): spikes during the fast parts of the cycle")

    l = @layout [a{0.46w} [b; c]]
    plot(pP, pX, pY; layout=l, size=(1250, 650), plot_title=title_str,
         plot_titlefontsize=10, left_margin=5Plots.mm, right_margin=3Plots.mm,
         bottom_margin=4Plots.mm, background_color=:white)
end

anim = Animation()
for j in 0:20:n
    draw_frame(j)
    frame(anim)
end
for _ in 1:44                                          # hold the last frame about 3 s
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "vanderpolcc.gif"); fps=15)
println("Saved: vanderpolcc.gif")
