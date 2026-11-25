# projectileaa.jl
# Projectile Motion animation: the arrow of Mathews' Examples 1-4, shot straight
# up at 300 ft/s, under the four drag laws (i)-(iv) of the module:
#     y'' = -32 - (k/m) drag(y'),  y(0) = 0, y'(0) = 300,
# (i) no drag, (ii) k/m = 0.04 times y', (iii) k/m = 1/2048 times y'|y'|,
# (iv) k/m = 1/200 times y' sqrt|y'|.
# Mathews' RK4 for one second-order equation (his Runge2D), [0, 20], n = 100,
# h = 0.2, in double precision. The flights grow in time on one clock, one RK4
# step per frame, in Mathews' window [0, 20] x [0, 1500] (extended a little
# below the ground, shaded, because his RK4 runs on to t = 20 after impact), with
# his colours. The right column is new: the velocity y'(t) and the error of
# each RK4 height against the exact solution, (i)-(iii) in closed form, (iv) a
# fine-step reference computed here, all in 128-bit arithmetic.
# Produces: projectileaa.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))
fmte(x) = um(@sprintf("%.2e", Float64(x)))
# Every text with a computed number is printed as it is drawn, for checking
say(s) = (println("  | ", s); s)

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

setprecision(BigFloat, 128)
const B = BigFloat

# --- Parameters (Mathews' Examples 1-4) ---
gif_name = "projectileaa.gif"
g, V0    = 32, 300
a, b, n  = 0.0, 20.0, 100
h        = (b - a) / n                       # 0.2 in double precision
# Mathews' colours (Mathematica's Graphics`Colors`): Green for (i), Blue for (ii),
# Red for (iii) (his descent curve; he drew its ascent in Magenta) and Purple for
# (iv); his Green (0, 1, 0) is darkened for legibility on white
models = [
    (name="(i) no drag", acc=v -> -g + 0 * v, col=RGB(0, 0.75, 0)),
    (name="(ii) drag 0.04 m v", acc=v -> -g - v / 25, col=RGB(0, 0, 1)),
    (name="(iii) drag m v²/2048", acc=v -> -g - v * abs(v) / 2048, col=RGB(1, 0, 0)),
    (name="(iv) drag 0.005 m |v|^(3/2)", acc=v -> -g - v * sqrt(abs(v)) / 200,
     col=RGB(0.627, 0.125, 0.941)),
]

# --- Mathews' RK4 for Z = (y, v), double precision ---
function rk4(acc)
    F(Z) = (Z[2], acc(Z[2]))
    Y = zeros(n + 1); W = zeros(n + 1)
    Y[1], W[1] = 0.0, Float64(V0)
    for j in 1:n
        Z = (Y[j], W[j])
        k1 = h .* F(Z)
        k2 = h .* F(Z .+ k1 ./ 2)
        k3 = h .* F(Z .+ k2 ./ 2)
        k4 = h .* F(Z .+ k3)
        Y[j+1], W[j+1] = Z .+ (k1 .+ 2 .* k2 .+ 2 .* k3 .+ k4) ./ 6
    end
    return Y, W
end
T = [j * h for j in 0:n]
TB = [j * B(h) for j in 0:n]                 # the times the method's steps reach

# --- Exact solutions (closed forms), 128-bit ---
# (i)
ex1(t) = (300t - 16t^2, 300 - 32t)
# (ii) v = -800 + 1100 e^{-t/25}, y = 27500 - 27500 e^{-t/25} - 800 t
ex2(t) = (27500 - 27500exp(-t / 25) - 800t, -800 + 1100exp(-t / 25))
# (iii) ascent V = 256 tan((tm - t)/8), Y = 2048 ln(cos((tm - t)/8)/cos(tm/8));
# descent U = -256 tanh((t - tm)/8), Z = ymax - 2048 ln cosh((t - tm)/8)
tm3 = 8 * atan(B(75) / 64)
ym3 = 1024 * log(B(9721) / 4096)
ex3(t) = t <= tm3 ? (2048 * log(cos((tm3 - t) / 8) / cos(tm3 / 8)), 256 * tan((tm3 - t) / 8)) :
                    (ym3 - 2048 * log(cosh((t - tm3) / 8)), -256 * tanh((t - tm3) / 8))

# Newton on a closed form, for the impact times of (ii) and (iii)
function newton(f, fp, t)
    for _ in 1:100
        dt = f(t) / fp(t); t -= dt
        abs(dt) < B(10)^-35 && break
    end
    return t
end
tm1, ym1, ti1 = B(300) / 32, B(1406.25), B(300) / 16
tm2 = 25 * log(B(11) / 8); ym2 = ex2(tm2)[1]
ti2 = newton(t -> ex2(t)[1], t -> ex2(t)[2], B(17))
ti3 = tm3 + 8 * acosh(exp(ym3 / 2048))

# (iv): no closed form. Reference = RK4 with the fine step h/2000 in 128-bit
# arithmetic, with the apex v = 0 located inside its step (by bisection on the
# substep length) and the step split there, because v sqrt|v| is not smooth at
# v = 0; the impact y = 0 is located the same way.
function ref4()
    acc(v) = -g - v * sqrt(abs(v)) / 200
    F(Z) = (Z[2], acc(Z[2]))
    step(Z, s) = begin
        k1 = s .* F(Z); k2 = s .* F(Z .+ k1 ./ 2); k3 = s .* F(Z .+ k2 ./ 2); k4 = s .* F(Z .+ k3)
        Z .+ (k1 .+ 2 .* k2 .+ 2 .* k3 .+ k4) ./ 6
    end
    function locate(Z, s, comp)              # substep sigma in (0, s) with comp(step) = 0
        lo, hi = B(0), s
        for _ in 1:140
            mid = (lo + hi) / 2
            (step(Z, mid)[comp] > 0) ? (lo = mid) : (hi = mid)
        end
        return (lo + hi) / 2
    end
    sub = 2000
    s = B(h) / sub
    Z = (B(0), B(V0)); t = B(0)
    YR = [B(0)]; WR = [B(V0)]
    tm = ym = ti = vi = nothing
    for j in 1:n, i in 1:sub
        Zn = step(Z, s)
        if tm === nothing && Zn[2] <= 0                  # apex inside this step
            σ = locate(Z, s, 2)
            Za = step(Z, σ)
            tm, ym = t + σ, Za[1]
            Zn = step((Za[1], B(0)), s - σ)              # v = 0 exactly at the apex
        end
        if ti === nothing && tm !== nothing && Zn[1] <= 0 # impact inside this step
            σ = locate(Z, s, 1)
            Zi = step(Z, σ)
            ti, vi = t + σ, Zi[2]
        end
        Z = Zn; t = j * B(h) - (sub - i) * s
        i == sub && (push!(YR, Z[1]); push!(WR, Z[2]))
    end
    return YR, WR, tm, ym, ti, vi
end
YR4, WR4, tm4, ym4, ti4, vi4 = ref4()

runs = map(enumerate(models)) do (m, md)
    Y, W = rk4(md.acc)
    if m == 4
        YX, WX = YR4, WR4
        tm, ym, ti, vi = tm4, ym4, ti4, vi4
    else
        ex = (ex1, ex2, ex3)[m]
        YX = [ex(t)[1] for t in TB]; WX = [ex(t)[2] for t in TB]
        tm, ym, ti = ((tm1, ym1, ti1), (tm2, ym2, ti2), (tm3, ym3, ti3))[m]
        vi = ex(ti)[2]
    end
    E = abs.(B.(Y) .- YX)
    (md..., Y=Y, W=W, YX=YX, E=E, tm=tm, ym=ym, ti=ti, vi=vi)
end
for r in runs
    inair = [i for i in 1:n+1 if r.YX[i] >= 0]
    @printf("%-30s top t = %.9f y = %.6f; impact t = %.9f v = %.6f; RK4 y(20) = %.4f v(20) = %.4f; max error in air = %s (t = %.1f), max error to t = 20 = %s\n",
            r.name, Float64(r.tm), Float64(r.ym), Float64(r.ti), Float64(r.vi), r.Y[end], r.W[end],
            fmte(maximum(r.E[inair])), T[inair[argmax(r.E[inair])]], fmte(maximum(r.E)))
    @printf("    exactly zero errors at %d of %d points; smallest nonzero error %s\n",
            count(iszero, r.E), n + 1, fmte(minimum(filter(!iszero, r.E[2:end]))))
end
# terminal velocities of the descent equations: -mg/k, -sqrt(mg/k), -(mg/k)^(2/3)
vterm = [nothing, -B(800), -B(256), -(B(32) * 200)^(B(2) / 3)]
@printf("terminal velocities: %.6f %.6f %.6f\n", vterm[2], vterm[3], vterm[4])

# --- Windows ---
tlims = (0.0, 20.0)                         # Mathews' window [0, 20] x [0, 1500]
ylims = (-250.0, 1500.0)                    # extended below the ground (shaded)
vlims = (-400.0, 320.0)
elims = (1e-15, 1e-1)
tticks = 0:5:20
tview = (tlims[1] - 0.012 * 20, tlims[2])
title_str = "Projectile Motion I: the arrow of Mathews' Examples 1–4, y′′ = −32 − (k/m)·drag(y′), " *
            "y(0) = 0, y′(0) = 300, RK4 with n = 100, h = 0.2"

logdraw(e) = max(Float64(e), elims[1] / 10)

# Split a polyline at the ground (y = 0), so that the part past impact can be dashed
function split_ground(T, Y, ti)
    i = findfirst(t -> t > ti, T)
    i === nothing && return (T, Y), (Float64[], Float64[])
    # the line from the last in-air step to the first step past impact, cut at
    # the exact impact time (drawing only)
    yi = Y[i-1] + (Y[i] - Y[i-1]) * (ti - T[i-1]) / (T[i] - T[i-1])
    return (vcat(T[1:i-1], ti), vcat(Y[1:i-1], yi)), (vcat(ti, T[i:end]), vcat(yi, Y[i:end]))
end

function draw_frame(j)
    tau = T[j+1]
    idx = 1:j+1
    # Height
    pH = plot(xlims=tview, ylims=(ylims[1], ylims[2] * 1.02), framestyle=:box, xlabel="t (s)",
              ylabel="height y (ft)", xticks=tticks, yticks=0:250:1500, legend=:outerbottom,
              legendfontsize=8, titlefontsize=10, grid=true)
    plot!(pH, Shape([tview[1], tview[2], tview[2], tview[1]], [ylims[1], ylims[1], 0, 0]);
          color=:gray88, linealpha=0, label="y < 0: below the ground, the arrow has landed")
    for r in runs
        (Ta, Ya), (Tb, Yb) = split_ground(T[idx], r.Y[idx], Float64(r.ti))
        plot!(pH, Ta, Ya; color=r.col, lw=2,
              label=say(@sprintf("%s:  top %s ft at t = %s s,  impact at t = %s s", r.name,
                                 fmt(r.ym), fmt(r.tm), fmt(r.ti))))
        isempty(Tb) || plot!(pH, Tb, ydraw.(Yb, Ref(ylims)); color=r.col, lw=1.2, ls=:dash, label="")
        scatter!(pH, [T[j+1]], [ydraw(r.Y[j+1], ylims)]; color=r.col, ms=4, msw=0, label="")
        tau >= r.tm && scatter!(pH, [Float64(r.tm)], [Float64(r.ym)]; color=r.col, ms=6,
                                marker=:circle, msc=:black, msw=0.8, label="")
        tau >= r.ti && scatter!(pH, [Float64(r.ti)], [0.0]; color=r.col, ms=7,
                                marker=:xcross, label="")
    end
    scatter!(pH, [NaN], [NaN]; color=:white, msc=:black, msw=0.8, ms=6, label="top of the flight (closed form; (iv) reference)")
    scatter!(pH, [NaN], [NaN]; color=:black, marker=:xcross, ms=7, label="impact (closed form; (iv) reference)")
    plot!(pH, [NaN], [NaN]; color=:gray30, lw=1.2, ls=:dash,
          label="RK4 past impact (Mathews' run continues to t = 20)")
    below = [r for r in runs if r.Y[j+1] < ylims[1]]
    if !isempty(below)
        annotate!(pH, 0.4, ylims[1] * 0.5,
                  text(say("below the panel at t = $(fmt(tau)) s: " *
                           join(["$(split(r.name)[1]) y = $(fmt(r.Y[j+1]))" for r in below], ",  ")),
                       8, :left, :gray25))
    end
    title!(pH, say("height y(t): RK4 steps up to t = $(fmt(tau)) s (Mathews' window and colours)"))

    # Velocity
    pV = plot(xlims=tview, ylims=vlims, framestyle=:box, xlabel="t (s)", ylabel="velocity y′ (ft/s)",
              xticks=tticks, yticks=-400:100:300, legend=:bottomleft, legendfontsize=7,
              titlefontsize=10, grid=true)
    hline!(pV, [0.0]; color=:black, lw=0.6, label="")
    hline!(pV, [Float64(vterm[3])]; color=runs[3].col, ls=:dot, lw=1.2,
           label="terminal −256 (iii)")
    hline!(pV, [Float64(vterm[4])]; color=runs[4].col, ls=:dot, lw=1.2,
           label=say("terminal $(fmt(vterm[4])) (iv); (ii): −800, off the panel"))
    for r in runs
        (Ta, Wa), (Tb, Wb) = split_ground(T[idx], r.W[idx], Float64(r.ti))
        plot!(pV, Ta, Wa; color=r.col, lw=2, label="")
        isempty(Tb) || plot!(pV, Tb, Wb; color=r.col, lw=1.2, ls=:dash, label="")
        scatter!(pV, [T[j+1]], [r.W[j+1]]; color=r.col, ms=4, msw=0, label="")
        tau >= r.tm && scatter!(pV, [Float64(r.tm)], [0.0]; color=r.col, ms=5, msc=:black,
                                msw=0.8, label="")
        tau >= r.ti && scatter!(pV, [Float64(r.ti)], [Float64(r.vi)]; color=r.col, ms=7,
                                marker=:xcross, label="")
    end
    landed = [r for r in runs if tau >= r.ti]
    title!(pV, say(isempty(landed) ? "velocity y′(t)" :
               "velocity; impact: " * join([fmt(r.vi) for r in landed], ", ") * " ft/s"))

    # Error
    pE = plot(xlims=tview, ylims=elims, yscale=:log10, framestyle=:box, xlabel="t (s)",
              ylabel="|yⱼ − y(tⱼ)| (ft)", xticks=tticks, yticks=10.0 .^ (-15:2:-1),
              legend=:topleft, legendfontsize=7, titlefontsize=10, grid=true)
    for r in runs
        ii = filter(>(1), collect(idx))              # error is 0 at t = 0
        isempty(ii) && continue
        pos = [i for i in ii if r.YX[i] >= 0]
        neg = [i for i in ii if r.YX[i] < 0]
        isempty(pos) || plot!(pE, T[pos], logdraw.(r.E[pos]); color=r.col, lw=1.6, label="")
        if !isempty(neg)
            jj = isempty(pos) ? neg : vcat(pos[end], neg)
            plot!(pE, T[jj], logdraw.(r.E[jj]); color=r.col, lw=1.0, ls=:dot, label="")
        end
    end
    plot!(pE, [NaN], [NaN]; color=:gray30, lw=1.6, label="in the air")
    plot!(pE, [NaN], [NaN]; color=:gray30, lw=1.0, ls=:dot, label="past impact")
    inair(r) = [i for i in 2:j+1 if r.YX[i] >= 0]
    mx = [isempty(inair(r)) ? 0.0 : Float64(maximum(r.E[inair(r)])) for r in runs]
    title!(pE, say(j == 0 ? "RK4 height error (log scale)" :
               "max error in the air (i)–(iv): " * join([fmte(e) for e in mx], ", ") * " ft"))

    l = @layout [a{0.56w} grid(2, 1)]
    plot(pH, pV, pE; layout=l, size=(1400, 760), plot_title=title_str, plot_titlefontsize=12,
         left_margin=6Plots.mm, bottom_margin=4Plots.mm, background_color=:white)
end

for j in 0:n
    below = [(r.name, r.Y[j+1]) for r in runs if r.Y[j+1] < ylims[1]]
    isempty(below) || println("t = ", fmt(T[j+1]), " below the panel: ", below)
end

anim = Animation()
for j in 0:n
    println("frame j = ", j)
    draw_frame(j)
    frame(anim)
    j == 0 && (frame(anim); frame(anim); frame(anim))     # hold the start
end
for _ in 1:15                                             # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=10)
println("Saved: ", gif_name)
