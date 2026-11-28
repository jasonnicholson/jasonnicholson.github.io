# predcorrcc.jl
# Predictor-Corrector Methods animation: Example 2(b) of the page. The run of
# Example 1 (AB2 predictor, trapezoidal corrector, h = 0.1, y' = 1 + y^2,
# y(0) = 0, exact tan t, y_1 from one Heun step) is repeated in the modes
# P(EC)^m E for m = 0 (PE, AB2 alone), 1 (PECE), 2, 3, 4, and finally with
# the trapezoidal rule solved exactly (the small root of a quadratic at every
# step). One mode per frame.
# Left panel: the error e_n = tan t_n - y_n along the run for each mode shown
# so far. Right panel, log scale, against m: the size of the error at t = 1
# and the distance of y_10 from the exactly solved trapezoidal rule's y_10.
# All values are computed in 256-bit floating point.
# Produces: predcorrcc.gif

using Plots
using Printf
gr()

um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))     # 4 s.f.
const SUPD = Dict(zip("0123456789-", "⁰¹²³⁴⁵⁶⁷⁸⁹⁻"))
sup(k) = join(SUPD[c] for c in string(k))
function sci(x; d=3)                                          # e.g. −8.921×10⁻³
    m, e = split(@sprintf("%.*e", d, Float64(x)), "e")
    return um(m * "×10" * sup(parse(Int, e)))
end

setprecision(BigFloat, 256)

# --- Parameters (the page's Example 2(b)) ---
gif_name = "predcorrcc.gif"
f(y) = 1 + y^2
h  = BigFloat(1) / 10
N  = 10
tt = [h * n for n in 0:N]
ex = tan.(tt)

# m = 0, 1, 2, ...: P(EC)^m E;  m = -1: trapezoidal rule solved exactly
function run(m)
    y = zeros(BigFloat, N + 1); F = zeros(BigFloat, N + 1)
    F[1] = f(y[1])
    p1 = y[1] + h * F[1]                              # Heun start
    y[2] = y[1] + h / 2 * (F[1] + f(p1)); F[2] = f(y[2])
    for n in 2:N
        if m < 0                                      # (h/2) Y^2 - Y + c = 0, small root
            c = y[n] + h / 2 * (F[n] + 1)
            Y = 2c / (1 + sqrt(1 - 2h * c))           # = (1 - sqrt(1 - 2hc)) / h
        else
            Y = y[n] + h / 2 * (3 * F[n] - F[n-1])    # P
            for _ in 1:m
                Y = y[n] + h / 2 * (F[n] + f(Y))      # E, C
            end
        end
        y[n+1] = Y
        F[n+1] = f(Y)                                 # final E
    end
    return y
end

ms     = [0, 1, 2, 3, 4, -1]
names  = ["PE, AB2 alone", "PECE", "P(EC)²E", "P(EC)³E", "P(EC)⁴E", "trapezoid solved exactly"]
evals  = ["1 evaluation", "2 evaluations", "3 evaluations", "4 evaluations", "5 evaluations",
          "quadratic formula at each step"]
colors = [:darkorange, :royalblue, :purple, :teal, :olive, :black]
runs   = [run(m) for m in ms]
errs   = [ex .- y for y in runs]                      # e_n = tan t_n - y_n
e10    = [e[end] for e in errs]
dtrap  = [abs(y[end] - runs[end][end]) for y in runs] # distance from exact trapezoid

@assert round(Float64(runs[2][end]), digits=10) == 1.5663285195
@assert round(Float64(runs[end][end]), digits=10) == 1.5730717208
# solved trapezoid really satisfies the trapezoidal rule at every step
yt = runs[end]
for n in 2:N
    @assert abs(yt[n+1] - yt[n] - h / 2 * (f(yt[n]) + f(yt[n+1]))) < big(1e-70)
end
for (k, m) in enumerate(ms)
    @printf("%-26s y10 = %.10f  e10 = %.6e  |y10 - trap| = %.4e\n", names[k],
            Float64(runs[k][end]), Float64(e10[k]), Float64(dtrap[k]))
end

# --- Drawing ---
tf = Float64.(tt)
xpos = [0, 1, 2, 3, 4, 5.5]                           # "∞" set apart on the axis

function draw_frame(j)
    pL = plot(xlims=(0, 1.05), ylims=(-0.02, 0.055), framestyle=:box, xlabel="t",
              ylabel="error  eₙ = tan tₙ − yₙ", legend=:topleft, legendfontsize=8,
              titlefontsize=10, grid=true)
    hline!(pL, [0.0]; color=:gray50, lw=1, label="")
    for k in 1:j
        plot!(pL, tf, Float64.(errs[k]); color=colors[k], marker=:circle,
              ms=k == j ? 4 : 3, lw=k == j ? 2.5 : 1.2, alpha=k == j ? 1.0 : 0.6,
              label="$(names[k]):  e₁₀ = $(sci(e10[k]))")
    end
    title!(pL, "$(names[j]) ($(evals[j])$(j < 6 ? " per step" : "")):  y₁₀ = " *
               "$(@sprintf("%.10f", Float64(runs[j][end])))")

    pR = plot(xlims=(-0.5, 6.0), ylims=(1e-6, 1e-1), yscale=:log10, framestyle=:box,
              xlabel="corrections per step m", ylabel="size at t = 1",
              legend=:bottomleft, legendfontsize=8, titlefontsize=10, grid=true,
              xticks=(xpos, ["0", "1", "2", "3", "4", "∞"]), yticks=10.0 .^ (-6:-1))
    hline!(pR, [Float64(abs(e10[end]))]; color=:black, ls=:dash, lw=1,
           label="|e₁₀| of the trapezoid solved exactly = $(sci(abs(e10[end])))")
    plot!(pR, xpos[1:j], Float64.(abs.(e10[1:j])); color=:red, marker=:diamond, ms=6,
          lw=1.5, label="|e₁₀| = |tan 1 − y₁₀|  (error)")
    kk = [k for k in 1:min(j, 5)]                     # distance is 0 for the trapezoid itself
    plot!(pR, xpos[kk], Float64.(dtrap[kk]); color=:royalblue, marker=:circle, ms=5,
          lw=1.5, label="|y₁₀ − y₁₀ of the trapezoid solved exactly|")
    title!(pR, j < 6 ? "m = $(ms[j]):  |e₁₀| = $(sci(abs(e10[j]))),  distance to the " *
                       "trapezoid's y₁₀ = $(sci(dtrap[j]))" :
                       "m = ∞:  |e₁₀| = $(sci(abs(e10[j])))")

    plot(pL, pR; layout=(1, 2), size=(1300, 560),
         plot_title="Number of corrections, h = 0.1:  y′ = 1 + y²,  y(0) = 0,  " *
                    "tan 1 = $(@sprintf("%.10f", Float64(ex[end])))",
         plot_titlefontsize=12, left_margin=6Plots.mm, bottom_margin=6Plots.mm,
         background_color=:white)
end

anim = Animation()
for j in eachindex(ms)
    draw_frame(j)
    frame(anim)
end
for _ in 1:2                                          # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: ", gif_name)
