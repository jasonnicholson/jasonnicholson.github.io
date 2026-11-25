# predcorraa.jl
# Predictor-Corrector Methods animation: Example 1 of the page, the AB2
# predictor with the trapezoidal corrector in PECE mode, h = 0.1, on
# y' = 1 + y^2, y(0) = 0 (exact solution tan t), one step per frame.
# Step 1 is the Heun starting step (Euler predictor, trapezoidal corrector).
# Left panel: the predicted value p_n and the corrected value y_n against
# tan t, with a magnified view of the current step (at full scale the two
# values are less than 0.014 apart). Right panel: on a log scale, the error of
# the predictor (tan t_n - p_n), the error of the corrector (y_n - tan t_n),
# Milne's estimate of the local error of the step, -(y_n - p_n)/6, and the
# true local error of the step (one PECE step from the exact values at
# t_{n-2} and t_{n-1}).
# All values are computed in 256-bit floating point; the script checks the
# signs that the legend states and the values printed in the page's table.
# Produces: predcorraa.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x)  = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))     # 4 s.f.
fmt6(x) = x == 0 ? "0" : um(@sprintf("%.6f", Float64(x)))     # 6 decimals (values ~0.1-1.6)
function sci(x)                                               # 4 s.f., e.g. −1.717×10⁻⁴
    m, e = split(@sprintf("%.3e", Float64(x)), "e")
    return um(m * "×10" * sup(parse(Int, e)))
end
const SUPD = Dict(zip("0123456789-", "⁰¹²³⁴⁵⁶⁷⁸⁹⁻"))
sup(k)  = join(SUPD[c] for c in string(k))                    # -4 -> "⁻⁴"
sub(n)  = join(Char(0x2080 + d) for d in reverse(digits(n)))  # 3 -> "₃"

setprecision(BigFloat, 256)

# --- Parameters (the page's Example 1) ---
gif_name = "predcorraa.gif"
f(y) = 1 + y^2                       # f(t, y) = 1 + y^2 does not depend on t
h  = BigFloat(1) / 10
N  = 10
tt = [h * n for n in 0:N]
ex = tan.(tt)                        # exact solution

# --- PECE run: y_1 by Heun, then AB2 predictor + trapezoidal corrector ---
y = zeros(BigFloat, N + 1); p = zeros(BigFloat, N + 1); F = zeros(BigFloat, N + 1)
F[1] = f(y[1])
p[2] = y[1] + h * F[1]                               # Euler predictor
y[2] = y[1] + h / 2 * (F[1] + f(p[2]))               # trapezoidal corrector
F[2] = f(y[2])
for n in 2:N                                         # array index n is t_{n-1}
    p[n+1] = y[n] + h / 2 * (3 * F[n] - F[n-1])         # P: AB2
    y[n+1] = y[n] + h / 2 * (F[n] + f(p[n+1]))       # E, C: trapezoid
    F[n+1] = f(y[n+1])                               # E
end

# True local error of step k (k = 2..N): one PECE step from exact back values
function true_lte(k)
    ym, y0 = ex[k-1], ex[k]                          # tan t_{k-2}, tan t_{k-1}
    pk = y0 + h / 2 * (3 * f(y0) - f(ym))
    ck = y0 + h / 2 * (f(y0) + f(pk))
    return ex[k+1] - ck
end
lte  = [k >= 2 ? true_lte(k) : big(NaN) for k in 0:N]
est  = [k >= 2 ? -(y[k+1] - p[k+1]) / 6 : big(NaN) for k in 0:N]
perr = ex .- p                                        # predictor error, > 0
cerr = ex .- y                                        # corrector error e_n, < 0

# Checks: the page's table values (10 decimals) and the signs the legend states
@assert round(Float64(y[3]), digits=10) == 0.2030455163
@assert round(Float64(y[11]), digits=10) == 1.5663285195
@assert round(Float64(p[11]), digits=10) == 1.5526181985
for k in 1:N
    @assert perr[k+1] > 0 && cerr[k+1] < 0
end
for k in 2:N
    @assert est[k+1] < 0 && lte[k+1] < 0 && abs(est[k+1]) > abs(lte[k+1])
end
for k in 0:N
    @printf("n=%2d p=%.10f y=%.10f tan=%.10f  tan-p=%.4e  e=%.4e", k,
            Float64(p[k+1]), Float64(y[k+1]), Float64(ex[k+1]),
            Float64(perr[k+1]), Float64(cerr[k+1]))
    k >= 2 && @printf("  est=%.4e lte=%.4e ratio=%.4f", Float64(est[k+1]),
                      Float64(lte[k+1]), Float64(est[k+1] / lte[k+1]))
    println()
end

# --- Drawing ---
xlims = (0.0, 1.05)
ylims = (0.0, 1.7)
elims = (1e-4, 3e-2)
tcurve = range(0, 1.05, length=400)
tf = Float64.(tt); pf = Float64.(p); yf = Float64.(y)

function draw_frame(n)
    t_n = tf[n+1]
    pL = plot(xlims=xlims, ylims=ylims, framestyle=:box, xlabel="t", ylabel="y",
              legend=:topleft, legendfontsize=8, titlefontsize=10, grid=true)
    plot!(pL, tcurve, tan.(tcurve); color=:magenta, lw=2, label="y = tan t (exact)")
    plot!(pL, tf[1:n+1], yf[1:n+1]; color=:royalblue, lw=1, label="")
    scatter!(pL, tf[2:n+1], pf[2:n+1]; color=:darkorange, marker=:diamond, ms=5,
             label="predicted pₖ (Euler for k = 1, then AB2)")
    scatter!(pL, tf[1:n+1], yf[1:n+1]; color=:royalblue, ms=4,
             label="corrected yₖ (trapezoidal rule)")
    tstr = n == 10 ? "1" : @sprintf("%.1f", t_n)
    title!(pL, "n = $n:  p$(sub(n)) = $(fmt6(p[n+1])),  y$(sub(n)) = " *
               "$(fmt6(y[n+1])),  tan $tstr = $(fmt6(ex[n+1]))")

    pR = plot(xlims=xlims, ylims=elims, yscale=:log10, framestyle=:box, xlabel="t",
              ylabel="size of error", legend=:topleft, legendfontsize=8,
              titlefontsize=9, grid=true, yticks=[1e-4, 1e-3, 1e-2])
    plot!(pR, tf[2:n+1], Float64.(perr[2:n+1]); color=:darkorange, marker=:diamond,
          ms=5, lw=1, label="tan tₖ − pₖ  (> 0: predictor low)")
    plot!(pR, tf[2:n+1], Float64.(-cerr[2:n+1]); color=:royalblue, marker=:circle,
          ms=4, lw=1, label="yₖ − tan tₖ  (> 0: corrector high)")
    if n >= 2
        plot!(pR, tf[3:n+1], Float64.(-est[3:n+1]); color=:green4, marker=:rect,
              ms=4, lw=1, ls=:dash, label="Milne's estimate (yₖ − pₖ)/6 of the local error")
        plot!(pR, tf[3:n+1], Float64.(-lte[3:n+1]); color=:black, marker=:xcross,
              ms=5, lw=1, ls=:dot, label="true local error of the step")
    end
    # the correction of the current step: from the predictor's error to the corrector's
    plot!(pR, [t_n, t_n], [Float64(perr[n+1]), Float64(-cerr[n+1])]; color=:gray40,
          lw=1.5, label="")
    if n >= 2
        title!(pR, "step $n local error:  Milne's estimate $(sci(est[n+1])),  true " *
                   "$(sci(lte[n+1])),  ratio $(@sprintf("%.3f", Float64(est[n+1] / lte[n+1])))")
    else
        title!(pR, "step 1 (Heun's start): no Milne estimate, Euler and trapezoid differ in order")
    end

    # Magnified view of the current step: at full scale p_n and y_n almost coincide
    lo = min(pf[n+1], yf[n+1], Float64(ex[n+1]))
    hi = max(pf[n+1], yf[n+1], Float64(ex[n+1]))
    span = hi - lo
    ylo, yhi = lo - 0.3span, hi + 0.3span
    slope = 1 + Float64(ex[n+1])^2                   # (tan t)' = sec² t
    dt = (yhi - ylo) / slope / 2                     # tan t crosses the view corner to corner
    mag = (ylims[2] - ylims[1]) / (yhi - ylo)
    tz = range(t_n - dt, t_n + dt, length=200)
    pM = plot(xlims=(t_n - dt, t_n + dt), ylims=(ylo, yhi), framestyle=:box,
              legend=:topleft, legendfontsize=8, titlefontsize=10, grid=true, xlabel="t", ylabel="y",
              xticks=[t_n], xformatter=x -> tstr, yformatter=v -> @sprintf("%.4f", v),
              title="step $n, zoomed ≈$(fmt(round(mag, sigdigits=2)))× in y")
    plot!(pM, tz, tan.(tz); color=:magenta, lw=2, label="")
    plot!(pM, [t_n, t_n], [pf[n+1], yf[n+1]]; color=:gray40, lw=1.5, arrow=true,
          label="correction")
    scatter!(pM, [t_n], [yf[n+1]]; color=:royalblue, ms=6, label="y$(sub(n))")
    scatter!(pM, [t_n], [Float64(ex[n+1])]; color=:magenta, ms=5, markerstrokewidth=0,
             label="tan t$(sub(n))")
    scatter!(pM, [t_n], [pf[n+1]]; color=:darkorange, marker=:diamond, ms=7,
             label="p$(sub(n))")

    plt = plot(pL, pM, pR; layout=grid(1, 3, widths=[0.36, 0.19, 0.45]), size=(1500, 560),
               plot_title="Predictor-corrector, PECE (AB2 predictor, trapezoidal corrector):  " *
                          "y′ = 1 + y²,  y(0) = 0,  h = 0.1",
               plot_titlefontsize=12, left_margin=6Plots.mm, bottom_margin=6Plots.mm,
               top_margin=2Plots.mm, right_margin=4Plots.mm, background_color=:white)
    return plt
end

anim = Animation()
for n in 1:N
    draw_frame(n)
    frame(anim)
end
for _ in 1:2                                         # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: ", gif_name)
