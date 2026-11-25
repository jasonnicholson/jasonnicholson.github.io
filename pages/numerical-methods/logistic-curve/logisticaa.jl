# logisticaa.jl
# Logistic Curve animation: data linearization (Mathews' Examples 1, 2 and 4)
# with the guessed limit L swept from 300 to 1200 million in steps of 20,
# pausing at Mathews' L = 800.
# For each L the census data 1900-1990 (millions, X = t - 1900) are
# transformed to Y = ln(L/y - 1), the least squares line Y = AX + B is fitted
# by the normal equations (7), and a = A, c = e^B give the curve
# f(t) = L / (1 + c e^{a (t - 1900)}).
# Top left: the XY-plane, transformed points and least squares line (Mathews
# plots this for L = 800). Top right: the curve with the census points and
# the July 2000 census figure, which is not fitted. Bottom left: the sum of
# squared errors in y, E(L) = sum (y_k - f(t_k))^2, traced as L grows, with
# the true least squares minimum of Example 5 for comparison. Bottom right:
# the prediction f(2000) traced as L grows, with the census figure.
# All arithmetic in 256-bit BigFloat.
# Produces: logisticaa.gif

using Plots
using Printf
using LinearAlgebra
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%#.4g", Float64(x)))   # keeps trailing zeros: 2.000, 252.0
fmtn(x, n) = um(@sprintf("%.*g", n, Float64(x)))

setprecision(BigFloat, 256)

# --- Data (Mathews' Example 1: U.S. population, July of each census year) ---
gif_name = "logisticaa.gif"
years = 1900:10:1990
pop   = [76094000, 92407000, 106461000, 123076741, 132122446,
         152271417, 180671158, 205052174, 227224681, 249464396]
yk = [BigFloat(p) / 10^6 for p in pop]              # millions
Xk = [BigFloat(t - 1900) for t in years]
P2000 = BigFloat(282124631) / 10^6                   # census, July 1, 2000 (Example 3)

# --- Data linearization for a given L ---
function linfit(L)
    L = BigFloat(L)
    Y = [log(L / v - 1) for v in yk]
    n = length(Xk)
    sx, sxx, sy, sxy = sum(Xk), sum(Xk .^ 2), sum(Y), sum(Xk .* Y)
    A = (n * sxy - sx * sy) / (n * sxx - sx^2)       # normal equations (7)
    B = (sy - A * sx) / n
    a, c = A, exp(B)                                 # (6)
    f(t) = L / (1 + c * exp(a * (t - 1900)))
    E = sum((yk[i] - f(years[i]))^2 for i in eachindex(yk))
    return (L=L, Y=Y, A=A, B=B, a=a, c=c, f=f, E=E, f2000=f(2000),
            pct=100 * (P2000 - f(2000)) / P2000)
end

# --- True least squares minimum (Example 5), by Gauss-Newton from L = 800 ---
function gauss_newton(p, iters)
    for _ in 1:iters
        L, c, a = p
        J = zeros(BigFloat, length(Xk), 3); r = zeros(BigFloat, length(Xk))
        for i in eachindex(Xk)
            e = exp(a * Xk[i]); D = 1 + c * e
            J[i, :] = [1 / D, -L * e / D^2, -L * c * Xk[i] * e / D^2]
            r[i] = yk[i] - L / D
        end
        p = p + (J' * J) \ (J' * r)                  # (9)
    end
    return p
end
F800 = linfit(800)
pstar = gauss_newton([F800.L, F800.c, F800.a], 60)
Emin = sum((yk[i] - pstar[1] / (1 + pstar[2] * exp(pstar[3] * Xk[i])))^2 for i in eachindex(Xk))
f2_2000 = pstar[1] / (1 + pstar[2] * exp(pstar[3] * 100))

# --- Sweep ---
Ls     = 300:20:1200
Lmath  = 800
fits   = [linfit(L) for L in Ls]
Lfine  = 300:2:1200
finefits = [linfit(L) for L in Lfine]
Efine  = [Float64(F.E) for F in finefits]
ffine  = [Float64(F.f2000) for F in finefits]
holds  = Dict(1 => 3, findfirst(==(Lmath), Ls) => 10, length(Ls) => 12)

# Windows
Xlims = (-5.0, 95.0); Ylims = (-1.9, 3.0)
tlims = (1895.0, 2005.0); ylims = (55.0, 300.0)
Llims = (290.0, 1210.0)
Elims = (90.0, 800.0)
flims = (245.0, 295.0)
tplot = range(tlims[1], tlims[2], length=300)

println(@sprintf("E_min (true least squares) = %.10f at L = %.8f, c = %.8f, a = %.10f",
                 Emin, pstar[1], pstar[2], pstar[3]))
println(@sprintf("f2(2000) = %.8f", f2_2000))
for F in fits
    @printf("L = %5d: A = %.8f, B = %.8f, c = %.6f, E = %.6f, f(2000) = %.6f, error = %.6f %%, Y in [%.5f, %.5f]\n",
            Int(F.L), F.A, F.B, F.c, F.E, F.f2000, F.pct, minimum(F.Y), maximum(F.Y))
end
@printf("fine grid: min E = %.6f at L = %d; all E > E_min: %s\n",
        minimum(Efine), Lfine[argmin(Efine)], all(F -> F.E > Emin, finefits))

function draw_frame(j)
    F = fits[j]
    Lstr = string(Int(F.L))
    # Top left: XY-plane
    p1 = plot(xlims=Xlims, ylims=Ylims, framestyle=:box, grid=true,
              xlabel="X = t − 1900", ylabel="Y = ln(L/y − 1)", legend=:bottomleft,
              legendfontsize=8, titlefontsize=10,
              title="XY-plane:  least squares line Y = AX + B,  A = $(fmtn(F.A, 7)),  B = $(fmtn(F.B, 7))")
    Xl = [Xlims[1], Xlims[2]]
    plot!(p1, Xl, Float64.(F.A .* Xl .+ F.B); color=:blue, lw=2, label="Y = AX + B")
    scatter!(p1, Float64.(Xk), Float64.(F.Y); color=:black, ms=4.5,
             label="transformed census points (Xₖ, Yₖ)")

    # Top right: the curve
    p2 = plot(xlims=tlims, ylims=ylims, framestyle=:box, grid=true, xlabel="year t",
              ylabel="population (millions)", legend=:topleft, legendfontsize=8,
              titlefontsize=10,
              title="f(t) = $Lstr / (1 + $(fmtn(F.c, 5)) exp($(fmtn(F.a, 5)) (t − 1900)))")
    plot!(p2, tplot, Float64.(F.f.(tplot)); color=:blue, lw=2, label="fitted curve f(t)")
    scatter!(p2, collect(years), Float64.(yk); color=:black, ms=4.5,
             label="census 1900–1990 (fitted)")
    scatter!(p2, [2000], [Float64(P2000)]; color=:white, markerstrokecolor=:red, msw=2,
             marker=:star5, ms=12, label="census 2000 = 282.1 (not fitted)")
    scatter!(p2, [2000], [Float64(F.f2000)]; color=:blue, marker=:diamond, ms=5,
             label="prediction f(2000) = $(fmt(F.f2000))")
    annotate!(p2, 1999, 100, text("error in 2000: $(fmt(F.pct)) %", 9, :right, :black))
    annotate!(p2, 1999, 80, text("E = Σ (yₖ − f(tₖ))² = $(fmt(F.E))", 9, :right, :black))

    # Bottom left: E(L)
    shown = Lfine .<= F.L
    p3 = plot(xlims=Llims, ylims=Elims, yscale=:log10, framestyle=:box, grid=true,
              xlabel="guessed limit L (millions)", ylabel="E (millions²)",
              yticks=([100, 150, 200, 300, 500, 700], ["100", "150", "200", "300", "500", "700"]),
              legend=:topright, legendfontsize=8, titlefontsize=10,
              title="sum of squared errors in y:  E = $(fmt(F.E)) at L = $Lstr")
    hline!(p3, [Float64(Emin)]; color=:darkgreen, ls=:dash, lw=1.5,
           label="true least squares minimum $(fmt(Emin)) (Example 5)")
    plot!(p3, Lfine[shown], Efine[shown]; color=:blue, lw=2, label="data linearization")
    vline!(p3, [Lmath]; color=:gray55, ls=:dot, lw=1, label="Mathews' L = 800")
    scatter!(p3, [Float64(F.L)], [Float64(F.E)]; color=:blue, ms=5, label="")

    # Bottom right: f(2000)
    p4 = plot(xlims=Llims, ylims=flims, framestyle=:box, grid=true,
              xlabel="guessed limit L (millions)", ylabel="f(2000) (millions)",
              legend=:bottomright, legendfontsize=8, titlefontsize=10,
              title="prediction for 2000:  f(2000) = $(fmt(F.f2000)) at L = $Lstr")
    hline!(p4, [Float64(P2000)]; color=:red, lw=1.5, label="census 2000 = 282.1246")
    hline!(p4, [Float64(f2_2000)]; color=:darkgreen, ls=:dash, lw=1.5,
           label="true least squares f₂(2000) = $(fmt(f2_2000))")
    plot!(p4, Lfine[shown], ffine[shown]; color=:blue, lw=2, label="data linearization")
    vline!(p4, [Lmath]; color=:gray55, ls=:dot, lw=1, label="Mathews' L = 800")
    scatter!(p4, [Float64(F.L)], [Float64(F.f2000)]; color=:blue, ms=5, label="")

    plot(p1, p2, p3, p4; layout=(2, 2), size=(1200, 860),
         plot_title="Logistic curve by data linearization, U.S. census 1900–1990:  L = $Lstr million" *
                    (F.L == Lmath ? "  (Mathews' choice)" : ""),
         plot_titlefontsize=13, left_margin=5Plots.mm, bottom_margin=4Plots.mm,
         background_color=:white)
end

anim = Animation()
for j in eachindex(fits)
    draw_frame(j)
    for _ in 1:(1 + get(holds, j, 0))
        frame(anim)
    end
end
gif(anim, joinpath(@__DIR__, gif_name); fps=5)
println("Saved: ", gif_name)
