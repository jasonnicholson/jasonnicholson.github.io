# projectilebb.jl
# Projectile Motion animation: Mathews' Example 3, the arrow shot up at 300 ft/s
# with drag m v^2/2048, y'' = -32 - y'|y'|/2048, y(0) = 0, y'(0) = 300.
# Two closed forms against each other and against RK4:
#   the one-formula solution of the ascent equation v' = -32 - v^2/2048, used by
#   Mathews first for the whole flight (V = 256 tan((tm - t)/8), Y = 2048 ln(...)),
#   which keeps the drag pointing down after the top and has a vertical
#   asymptote at t = tm + 4 pi;
#   the two-piece solution (ascent V, Y up to tm; descent U = -256 tanh((t - tm)/8),
#   Z = ymax - 2048 ln cosh((t - tm)/8) after it), Mathews' graph31 (Magenta) and
#   graph32 (Red);
#   Mathews' RK4 (Runge2D) for the single equation, [0, 20], n = 100, h = 0.2,
#   which switches the sign of the drag by itself.
# The clock runs over [0, 20] (Mathews' plots stop at t = 17, before the
# asymptote; the window is extended to t = 20 to include it, and below the ground
# (shaded) to show where the formulas go after impact).
# Produces: projectilebb.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))
# Every text with a computed number is printed as it is drawn, for checking
say(s) = (println("  | ", s); s)

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

setprecision(BigFloat, 128)
const B = BigFloat

# --- Parameters (Mathews' Example 3) ---
gif_name = "projectilebb.gif"
a, b, n  = 0.0, 20.0, 100
h        = (b - a) / n
acc(v)   = -32 - v * abs(v) / 2048
magenta, red = RGB(1, 0, 1), RGB(1, 0, 0)     # Mathews' graph31 / graph32 colours

# --- Closed forms (valid for real t; T may be Float64 or BigFloat) ---
tm  = 8 * atan(B(75) / 64)                    # top of the flight
ym  = 1024 * log(B(9721) / 4096)              # its height
tas = tm + 4 * B(pi)                          # asymptote of the one-formula V
tw  = 2 * tm                                  # one formula back at y = 0
ti  = tm + 8 * acosh(exp(ym / 2048))          # two-piece impact
Vf(t) = 256 * tan((tm - t) / 8)                               # ascent formula
Yf(t) = 2048 * log(cos((tm - t) / 8) / cos(tm / 8))           # (t < tas)
Uf(t) = -256 * tanh((t - tm) / 8)                             # descent formula
Zf(t) = ym - 2048 * log(cosh((t - tm) / 8))
y2(t) = t <= tm ? Yf(t) : Zf(t)               # two-piece solution
v2(t) = t <= tm ? Vf(t) : Uf(t)

# --- Mathews' RK4, double precision ---
function rk4()
    F(Z) = (Z[2], acc(Z[2]))
    Y = zeros(n + 1); W = zeros(n + 1); W[1] = 300.0
    for j in 1:n
        Z = (Y[j], W[j])
        k1 = h .* F(Z); k2 = h .* F(Z .+ k1 ./ 2); k3 = h .* F(Z .+ k2 ./ 2); k4 = h .* F(Z .+ k3)
        Y[j+1], W[j+1] = Z .+ (k1 .+ 2 .* k2 .+ 2 .* k3 .+ k4) ./ 6
    end
    return Y, W
end
T = [j * h for j in 0:n]
Y, W = rk4()
TB = [j * B(h) for j in 0:n]
EY = [abs(B(Y[i]) - y2(TB[i])) for i in 1:n+1]
EW = [abs(B(W[i]) - v2(TB[i])) for i in 1:n+1]
@printf("tm = %.10f ym = %.8f tw = 2tm = %.10f V(tw) = %.10f tas = %.10f ti = %.10f U(ti) = %.8f\n",
        tm, ym, tw, Vf(tw), tas, ti, Uf(ti))
inair = [i for i in 1:n+1 if TB[i] <= ti]
@printf("RK4 vs two-piece: max |y err| in the air = %.4e (last in-air t = %.1f), max |v err| = %.4e; to t = 20: %.4e\n",
        maximum(EY[inair]), T[inair[end]], maximum(EW[inair]), maximum(EY))
ow = [i for i in 1:n+1 if TB[i] < tas]
@printf("RK4 vs one formula at t = 13.8 (step 69): y %.4f vs %.4f, v %.4f vs %.4f\n",
        Y[70], Yf(TB[70]), W[70], Vf(TB[70]))
@printf("RK4 y(20) = %.4f, Z(20) = %.4f; v(20) = %.4f, U(20) = %.4f\n", Y[end], Zf(B(20)),
        W[end], Uf(B(20)))
for tt in (17, 19, 19.4)
    @printf("one formula at t = %g: Y = %.4f V = %.4f\n", tt, Yf(B(tt)), Vf(B(tt)))
end

# --- Windows ---
tlims = (0.0, 20.0)
ylims = (-400.0, 1200.0)                      # Mathews' [0, 17] x [0, 1200], extended
vlims = (-800.0, 320.0)
tview = (tlims[1] - 0.012 * 20, tlims[2])
title_str = "Projectile Motion, Example 3: y′′ = −32 − y′|y′|/2048, y(0) = 0, y′(0) = 300.  " *
            "One formula for the whole flight, two-piece solution, RK4 (n = 100, h = 0.2)"

# Fine time grid for the closed forms (drawing); the one-formula curves stop
# just before the asymptote, where a NaN breaks them explicitly
function fine(t0, t1)
    t1 <= t0 && return Float64[]
    collect(range(t0, t1, length=max(2, ceil(Int, 400 * (t1 - t0) / 20))))
end
function oneformula(f, tau)
    tend = min(tau, Float64(tas))
    tend <= Float64(tm) && return Float64[], Float64[]
    ts = fine(Float64(tm), tend)
    if tau >= Float64(tas)                    # stop short of the pole and break there
        ts = filter(t -> t < Float64(tas) - 1e-6, ts)
        push!(ts, Float64(tas) - 1e-6)
    end
    vals = [Float64(f(B(t))) for t in ts]
    return ts, vals
end

function draw_frame(j)
    tau = T[j+1]
    tb = TB[j+1]
    # ---- height ----
    pH = plot(xlims=tview, ylims=(ylims[1], ylims[2] * 1.02), framestyle=:box, xlabel="t (s)",
              ylabel="height y (ft)", xticks=0:5:20, yticks=-400:200:1200, legend=:topright,
              legendfontsize=8, titlefontsize=10, grid=true)
    plot!(pH, Shape([tview[1], tview[2], tview[2], tview[1]], [ylims[1], ylims[1], 0, 0]);
          color=:gray88, linealpha=0, label="y < 0: below the ground")
    tau >= Float64(tas) && vline!(pH, [Float64(tas)]; color=:gray40, ls=:dash, lw=1,
                                  label=say("asymptote t = tₘ + 4π = $(fmt(tas))"))
    # two-piece solution
    ta = fine(0.0, min(tau, Float64(tm)))
    isempty(ta) || plot!(pH, ta, [Float64(Yf(B(t))) for t in ta]; color=magenta, lw=2.5,
                         label="ascent Y (Mathews' graph31)")
    td = fine(Float64(tm), min(tau, Float64(ti)))
    isempty(td) || plot!(pH, td, [Float64(Zf(B(t))) for t in td]; color=red, lw=2.5,
                         label="descent Z (graph32)")
    tp = fine(Float64(ti), tau)
    isempty(tp) || plot!(pH, tp, ydraw.([Float64(Zf(B(t))) for t in tp], Ref(ylims));
                         color=red, lw=1.2, ls=:dash, label="Z past impact")
    # one formula after the top
    ts, ys = oneformula(Yf, tau)
    isempty(ts) || plot!(pH, vcat(ts, NaN), vcat(ydraw.(ys, Ref(ylims)), NaN); color=magenta,
                         lw=1.6, ls=:dashdot, label="one formula Y after the top")
    # RK4
    scatter!(pH, T[1:j+1], ydraw.(Y[1:j+1], Ref(ylims)); color=:white, msc=:black, ms=2.6,
             msw=0.6, label="RK4, h = 0.2")
    # events
    tau >= Float64(tm) && scatter!(pH, [Float64(tm)], [Float64(ym)]; color=magenta, msc=:black,
                                   msw=0.8, ms=6, label=say("top $(fmt(ym)) ft, t = $(fmt(tm))"))
    tau >= Float64(tw) && scatter!(pH, [Float64(tw)], [0.0]; color=magenta, marker=:xcross, ms=7,
                                   label=say("one formula y = 0, t = $(fmt(tw))"))
    tau >= Float64(ti) && scatter!(pH, [Float64(ti)], [0.0]; color=red, marker=:xcross, ms=7,
                                   label=say("impact, t = $(fmt(ti))"))
    yw = tb < tas ? fmt(Yf(tb)) : "undefined"
    title!(pH, say(j == 0 ? "height at t = 0: y = 0" :
               "t = $(fmt(tau)):  RK4 y = $(fmt(Y[j+1])),  two-piece $(fmt(y2(tb))),  one formula $(yw)"))
    if tau > Float64(tm) && tb < tas && Yf(tb) < ylims[1]
        annotate!(pH, 0.4, ylims[1] * 0.75,
                  text(say("↓ one formula below the panel: Y = $(fmt(Yf(tb)))"), 8, :left, magenta))
    end
    if tb > tas
        annotate!(pH, 0.4, ylims[1] * 0.75,
                  text(say("one formula: Y → −∞ at t = $(fmt(tas)); undefined beyond"), 8, :left, magenta))
    end

    # ---- velocity ----
    pV = plot(xlims=tview, ylims=vlims, framestyle=:box, xlabel="t (s)", ylabel="velocity y′ (ft/s)",
              xticks=0:5:20, yticks=-800:100:300, legend=:bottomleft, legendfontsize=8,
              titlefontsize=10, grid=true)
    hline!(pV, [0.0]; color=:black, lw=0.6, label="")
    hline!(pV, [-256.0]; color=red, ls=:dot, lw=1.2, label="terminal velocity −256 = −√(mg/k)")
    tau >= Float64(tas) && vline!(pV, [Float64(tas)]; color=:gray40, ls=:dash, lw=1,
                                  label=say("asymptote t = $(fmt(tas)): one-formula V → −∞"))
    isempty(ta) || plot!(pV, ta, [Float64(Vf(B(t))) for t in ta]; color=magenta, lw=2.5,
                         label="ascent V(t)")
    isempty(td) || plot!(pV, td, [Float64(Uf(B(t))) for t in td]; color=red, lw=2.5,
                         label="descent U(t)")
    isempty(tp) || plot!(pV, tp, [Float64(Uf(B(t))) for t in tp]; color=red, lw=1.2, ls=:dash,
                         label="U past impact")
    ts, vs = oneformula(Vf, tau)
    isempty(ts) || plot!(pV, vcat(ts, NaN), vcat(ydraw.(vs, Ref(vlims)), NaN); color=magenta,
                         lw=1.6, ls=:dashdot, label="one formula V(t) after the top")
    scatter!(pV, T[1:j+1], W[1:j+1]; color=:white, msc=:black, ms=2.6, msw=0.6, label="RK4, h = 0.2")
    tau >= Float64(tw) && scatter!(pV, [Float64(tw)], [Float64(Vf(tw))]; color=magenta,
                                   marker=:xcross, ms=7, label=say("one formula at y = 0: V = $(fmt(Vf(tw)))"))
    tau >= Float64(ti) && scatter!(pV, [Float64(ti)], [Float64(Uf(ti))]; color=red,
                                   marker=:xcross, ms=7, label=say("two-piece impact: U = $(fmt(Uf(ti)))"))
    vw = tb < tas ? fmt(Vf(tb)) : "beyond the asymptote"
    title!(pV, say(j == 0 ? "velocity at t = 0: 300 ft/s" :
               "RK4 v = $(fmt(W[j+1])),  two-piece $(fmt(v2(tb))),  one formula $(vw)"))
    if tau > Float64(tm) && tb < tas && Vf(tb) < vlims[1]
        annotate!(pV, 10.3, -40.0,
                  text(say("↓ one formula below the panel: V = $(fmt(Vf(tb)))"), 8, :left, magenta))
    end

    plot(pH, pV; layout=(1, 2), size=(1400, 620), plot_title=title_str, plot_titlefontsize=11,
         left_margin=6Plots.mm, bottom_margin=5Plots.mm, background_color=:white)
end

anim = Animation()
for j in 0:n
    println("frame j = ", j)
    draw_frame(j)
    frame(anim)
    j == 0 && (frame(anim); frame(anim); frame(anim))      # hold the start
end
for _ in 1:15                                              # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=10)
println("Saved: ", gif_name)
