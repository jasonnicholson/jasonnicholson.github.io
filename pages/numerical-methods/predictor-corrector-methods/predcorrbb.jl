# predcorrbb.jl
# Predictor-Corrector Methods animation: Example 2(a) of the page. On the
# first AB2 step of Example 1 (h = 0.1, from t = 0.1 to t = 0.2), the
# trapezoidal corrector is iterated from the predicted value p_2:
#     y^[s+1] = G(y^[s]),   G(y) = y_1 + (h/2) (f_1 + 1 + y^2),
# a fixed-point iteration whose limit is the solution Y* of the corrector
# equation (the small root of a quadratic). One frame per iterate s = 0..6.
# Left panel: the cobweb diagram of the iteration, drawn relative to Y*
# (axes u = y - Y*), zoomed in at every frame because each correction
# shrinks the distance to Y* by a factor of about h Y* = 0.0203. The exact
# value tan 0.2 is marked while it is inside the window.
# Right panel: on a log scale, the distance |y^[s] - Y*| to the corrector's
# solution, which falls geometrically, and the error |tan 0.2 - y^[s]|,
# which levels off at the trapezoidal rule's own error.
# All values are computed in 256-bit floating point.
# Produces: predcorrbb.gif

using Plots
using Printf
gr()

um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))     # 4 s.f.
const SUPD = Dict(zip("0123456789-", "⁰¹²³⁴⁵⁶⁷⁸⁹⁻"))
sup(k) = join(SUPD[c] for c in string(k))                     # -4 -> "⁻⁴"
function sci(x; d=3)                                          # e.g. −2.130×10⁻⁵
    m, e = split(@sprintf("%.*e", d, Float64(x)), "e")
    return um(m * "×10" * sup(parse(Int, e)))
end
sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))

setprecision(BigFloat, 256)

# --- Parameters (the page's Example 2(a)) ---
gif_name = "predcorrbb.gif"
f(y) = 1 + y^2
h  = BigFloat(1) / 10
smax = 6
y0 = big(0); f0 = f(y0)
p1 = y0 + h * f0                                      # Heun start, as in Example 1
y1 = y0 + h / 2 * (f0 + f(p1)); f1 = f(y1)
p2 = y1 + h / 2 * (3 * f1 - f0)                          # AB2 predictor
c  = y1 + h / 2 * (f1 + 1)                            # G(y) = c + (h/2) y^2
G(y) = c + h / 2 * y^2
a  = h / 2                                            # (h/2) Y^2 - Y + c = 0
Ystar = (1 - sqrt(1 - 4a * c)) / (2a)                 # small root
Yother = (1 + sqrt(1 - 4a * c)) / (2a)
ex2 = tan(2h)

ys = [p2]
for s in 1:smax
    push!(ys, G(ys[end]))
end
u = ys .- Ystar                                       # distance to Y*, all < 0
dex = ex2 .- ys                                       # error against tan 0.2
uex = ex2 - Ystar
@assert abs(G(Ystar) - Ystar) < big(1e-70)
@assert all(u .< 0) && all(diff(ys) .> 0)             # monotone, from below
@assert round(Float64(Ystar), digits=10) == 0.2030668192
@assert ys[1] < ex2 < ys[2]                           # first correction jumps past tan 0.2
@printf("Y* = %.15f  other root = %.6f  tan 0.2 = %.15f  tan0.2 - Y* = %.4e  hY* = %.6f\n",
        Float64(Ystar), Float64(Yother), Float64(ex2), Float64(uex), Float64(h * Ystar))
for s in 0:smax
    @printf("s=%d y=%.15f  y-Y*=%.4e  ratio=%s  tan0.2-y=%.4e\n", s, Float64(ys[s+1]),
            Float64(u[s+1]), s == 0 ? "-" : @sprintf("%.5f", Float64(u[s+1] / u[s])),
            Float64(dex[s+1]))
end

# Cobweb in shifted coordinates: horizontal axis u = y - Y*, vertical G(y) - Y*
Gu(v) = G(Ystar + v) - Ystar                          # = (h/2) v (v + 2Y*)

function draw_frame(s)
    # window: from the previous iterate (or the predictor) to a little past Y*
    uref = s == 0 ? min(u[1], uex) : u[s]
    w  = -uref
    xl = (Float64(uref - big(0.12) * w), Float64(big(0.25) * w))
    yl = xl                                           # equal scales: y = x at 45°
    vv = range(BigFloat(xl[1]), BigFloat(xl[2]), length=300)
    pL = plot(xlims=xl, ylims=yl, aspect_ratio=:equal, framestyle=:box,
              xlabel="y − Y*", ylabel="G(y) − Y*", legend=:bottomright,
              legendfontsize=8, titlefontsize=10, grid=true)
    plot!(pL, collect(xl), collect(xl); color=:green, lw=1.5, label="y = x")
    plot!(pL, Float64.(vv), Float64.(Gu.(vv)); color=:magenta, lw=2,
          label="G(y) = y₁ + (h/2)(f₁ + 1 + y²)")
    # cobweb path up to iterate s
    cx = [Float64(u[1])]; cy = [Float64(u[1])]
    for k in 1:s
        push!(cx, Float64(u[k]), Float64(u[k+1]))
        push!(cy, Float64(u[k+1]), Float64(u[k+1]))
    end
    plot!(pL, cx, cy; color=:steelblue, lw=1.5, label="")
    if xl[1] <= Float64(uex) <= xl[2]
        vline!(pL, [Float64(uex)]; color=:black, ls=:dash, lw=1, label="exact tan 0.2")
    else                                              # legend note only, nothing drawn
        plot!(pL, [NaN], [NaN]; color=:black, ls=:dash, lw=1,
              label="tan 0.2 is off to the left, at y − Y* = $(sci(uex))")
    end
    scatter!(pL, [0.0], [0.0]; color=:black, marker=:star5, ms=7, label="Y* (corrector solved)")
    if s == 0
        scatter!(pL, [Float64(u[1])], [Float64(u[1])]; color=:darkorange,
                 marker=:diamond, ms=7, label="y⁽⁰⁾ = p₂ (predictor)")
    else
        scatter!(pL, [Float64(u[s])], [Float64(u[s])]; color=:gray50, ms=5,
                 label="y⁽$(sup(s-1))⁾")
        scatter!(pL, [Float64(u[s+1])], [Float64(u[s+1])]; color=:royalblue, ms=6,
                 label="y⁽$(sup(s))⁾")
    end
    title!(pL, "s = $s:  y⁽$(sup(s))⁾ = $(@sprintf("%.12f", Float64(ys[s+1]))),  " *
               "y⁽$(sup(s))⁾ − Y* = $(sci(u[s+1]))")

    pR = plot(xlims=(-0.3, smax + 0.3), ylims=(1e-14, 1e-2), yscale=:log10,
              framestyle=:box, xlabel="number of corrections s", ylabel="size",
              legend=:bottomleft, legendfontsize=8, titlefontsize=10, grid=true,
              xticks=0:smax, yticks=10.0 .^ (-14:2:-2))
    hline!(pR, [Float64(abs(uex))]; color=:black, ls=:dash, lw=1,
           label="|tan 0.2 − Y*| = $(sci(abs(uex))) (trapezoid's own error)")
    plot!(pR, 0:s, Float64.(abs.(u[1:s+1])); color=:royalblue, marker=:circle, ms=5,
          lw=1.5, label="|y⁽ˢ⁾ − Y*|  (distance to the corrector's solution)")
    plot!(pR, 0:s, Float64.(abs.(dex[1:s+1])); color=:red, marker=:diamond, ms=5,
          lw=1.5, label="|tan 0.2 − y⁽ˢ⁾|  (error)")
    rstr = s == 0 ? "" : ",  ratio $(@sprintf("%.4g", Float64(u[s+1] / u[s])))"
    title!(pR, "s = $s:  |y⁽$(sup(s))⁾ − Y*| = $(sci(abs(u[s+1])))$rstr,  " *
               "error $(sci(dex[s+1]))")

    plot(pL, pR; layout=grid(1, 2, widths=[0.47, 0.53]), size=(1300, 600),
         plot_title="Iterating the trapezoidal corrector on step 1 → 2 of Example 1 " *
                    "(h = 0.1):  Y* = $(@sprintf("%.12f", Float64(Ystar))),  h·Y* = " *
                    "$(@sprintf("%.4f", Float64(h * Ystar)))",
         plot_titlefontsize=12, left_margin=6Plots.mm, bottom_margin=6Plots.mm,
         background_color=:white)
end

anim = Animation()
for s in 0:smax
    draw_frame(s)
    frame(anim)
end
for _ in 1:2                                          # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: ", gif_name)
