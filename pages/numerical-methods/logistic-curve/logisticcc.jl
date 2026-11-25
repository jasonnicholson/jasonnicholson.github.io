# logisticcc.jl
# Logistic Curve animation: solutions of the logistic differential equation
# of Example 1's fit, y' = r y (1 - y/L) with L = 800 and r = -A = 0.0160987...
# (the unrounded data linearization slope), from t0 = 1900, growing in time
# from 1900 to 2300 in steps of 10 years.
# Starting values y0 = 5, 20, f1(1900) = 78.4243 (the curve f1 of Example 1),
# 200, 400 = L/2, 600, 800 = L, 900 and 1000 million.
# Left: the exact solutions (2), y = L / (1 + c e^{-r (t - 1900)}),
# c = (L - y0)/y0, evaluated in 256-bit BigFloat, with the limit L, the
# inflection level L/2, the census points 1900-1990, and a diamond at each
# inflection point (3), t* = 1900 + ln(c)/r, once the solution reaches it.
# Right (new): the rate y' = r y (1 - y/L), drawn sideways so that y is on the
# same vertical axis as on the left, with the phase line y' = 0, the
# stationary points y = 0 (unstable, open) and y = L (stable, filled), and a
# dot for each solution at its current (y', y).
# Produces: logisticcc.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%#.4g", Float64(x)))   # keeps trailing zeros: 3.220
fmt6(x) = x == 0 ? "0" : um(@sprintf("%.6g", Float64(x)))

setprecision(BigFloat, 256)

# --- Parameters: the logistic equation of Example 1's fit ---
gif_name = "logisticcc.gif"
years = 1900:10:1990
pop   = [76094000, 92407000, 106461000, 123076741, 132122446,
         152271417, 180671158, 205052174, 227224681, 249464396]
yk = [BigFloat(p) / 10^6 for p in pop]              # millions
Xk = [BigFloat(t - 1900) for t in years]
L  = BigFloat(800)
Yk = [log(L / v - 1) for v in yk]                    # data linearization, L = 800
n  = length(Xk)
A  = (n * sum(Xk .* Yk) - sum(Xk) * sum(Yk)) / (n * sum(Xk .^ 2) - sum(Xk)^2)
B  = (sum(Yk) - A * sum(Xk)) / n
r  = -A                                              # growth rate
y0_f1 = L / (1 + exp(B))                             # f1(1900)
t0 = 1900

rate(y) = r * y * (1 - y / L)
c_of(y0) = (L - y0) / y0
ysol(y0, t) = L / (1 + c_of(y0) * exp(-r * (t - t0)))
tstar(y0) = t0 + log(c_of(y0)) / r                   # defined for 0 < y0 < L

# (y0, colour, group); group decides the legend entry
sols = [(BigFloat(5), :steelblue, :below), (BigFloat(20), :steelblue, :below),
        (y0_f1, :black, :f1), (BigFloat(200), :steelblue, :below),
        (BigFloat(400), :purple, :half), (BigFloat(600), :darkgreen, :upper),
        (L, :gray30, :stat), (BigFloat(900), :red, :above), (BigFloat(1000), :red, :above)]
group_lbl = Dict(:below => "y₀ = 5, 20, 200:  0 < y₀ < L/2",
                 :f1    => "y₀ = $(fmt6(y0_f1)):  f₁ of Example 1",
                 :half  => "y₀ = 400 = L/2:  inflection at t₀",
                 :upper => "y₀ = 600:  L/2 < y₀ < L",
                 :stat  => "y₀ = 800 = L:  stationary",
                 :above => "y₀ = 900, 1000:  y₀ > L, decreasing")

tlims = (1895.0, 2300.0); ylims = (-20.0, 1050.0)
flims = (-6.0, 4.5)                                  # rate axis of the right panel
taus  = 1900:10:2300
title_str = "Logistic equation y′ = r y (1 − y/L) of Example 1's fit:  r = $(fmt6(r)) per year,  " *
            "L = 800 million,  t₀ = 1900"

println(@sprintf("r = %.16f, y0_f1 = %.10f, rL/4 = %.10f", r, y0_f1, r * L / 4))
for (y0, _, _) in sols
    s = @sprintf("y0 = %10.5f: y(2000) = %.6f, y(2300) = %.6f", y0, ysol(y0, 2000), ysol(y0, 2300))
    if 0 < y0 < L
        s *= @sprintf(", t* = %.6f", tstar(y0))
    end
    println(s)
end

function draw_frame(tau)
    tg = collect(range(t0, tau, length=max(2, round(Int, (tau - t0) * 2) + 1)))
    pL = plot(xlims=tlims, ylims=ylims, framestyle=:box, grid=true, xlabel="year t",
              ylabel="y (millions)", xticks=1900:50:2300, yticks=0:100:1000,
              legend=:outerbottom, legend_columns=3, legendfontsize=8, titlefontsize=10)
    hline!(pL, [Float64(L)]; color=:gray30, ls=:dash, lw=1, label="")
    hline!(pL, [Float64(L) / 2]; color=:purple, ls=:dot, lw=1, label="inflection level y = L/2 = 400")
    scatter!(pL, collect(years), Float64.(yk); color=:orange, ms=3, msw=0,
             label="census 1900–1990")
    seen = Set{Symbol}()
    for (y0, col, grp) in sols
        lbl = grp in seen ? "" : group_lbl[grp]
        push!(seen, grp)
        plot!(pL, tg, Float64.(ysol.(y0, tg)); color=col, lw=grp == :f1 ? 2.6 : 1.8, label=lbl)
        scatter!(pL, [tau], [Float64(ysol(y0, tau))]; color=col, ms=4, msw=0, label="")
    end
    scatter!(pL, [NaN], [NaN]; color=:white, markerstrokecolor=:gray30, msw=2,
             marker=:diamond, ms=7, label="inflection points (t*, L/2)")
    for (y0, col, grp) in sols
        if 0 < y0 < L && y0 <= L / 2 && tstar(y0) <= tau
            scatter!(pL, [Float64(tstar(y0))], [Float64(L) / 2]; color=:white,
                     markerstrokecolor=col, msw=2, marker=:diamond, ms=7, label="")
        end
    end
    title!(pL, "t = $tau:  exact solutions (2) from t₀ = 1900")

    yv = range(0.0, ylims[2], length=400)             # physical range y >= 0 only
    pR = plot(xlims=flims, ylims=ylims, framestyle=:box, grid=true,
              xlabel="rate y′ (millions per year)", ylabel="y (millions)",
              yticks=0:100:1000, legend=:outerbottom, legend_columns=2, legendfontsize=8, titlefontsize=10,
              title="rate y′ = r y (1 − y/L): largest $(fmt(r * L / 4)) at y = L/2")
    vline!(pR, [0.0]; color=:black, lw=1, label="phase line y′ = 0")
    plot!(pR, Float64.(rate.(yv)), collect(yv); color=:magenta, lw=2, label="y′ = r y (1 − y/L)")
    hline!(pR, [Float64(L) / 2]; color=:purple, ls=:dot, lw=1, label="")
    scatter!(pR, [Float64(r * L / 4)], [Float64(L) / 2]; color=:purple, marker=:diamond, ms=6,
             label="maximum rL/4 = $(fmt(r * L / 4))")
    scatter!(pR, [0.0], [0.0]; color=:white, markerstrokecolor=:black, msw=1.5, ms=6,
             label="y = 0 (unstable)")
    scatter!(pR, [0.0], [Float64(L)]; color=:black, ms=6, label="y = L = 800 (stable)")
    for yy in (200.0, 600.0)                         # y increases between 0 and L
        scatter!(pR, [0.0], [yy]; color=:steelblue, marker=:utriangle, ms=7, label="")
    end
    scatter!(pR, [0.0], [950.0]; color=:red, marker=:dtriangle, ms=7, label="")
    for (y0, col, grp) in sols
        y = ysol(y0, tau)
        scatter!(pR, [Float64(rate(y))], [Float64(y)]; color=col, ms=5, msw=0, label="")
    end

    plot(pL, pR; layout=@layout([a{0.66w} b]), size=(1250, 700), plot_title=title_str,
         plot_titlefontsize=12, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white)
end

anim = Animation()
for tau in taus
    draw_frame(tau)
    for _ in 1:(tau == first(taus) ? 4 : tau == last(taus) ? 14 : 1)
        frame(anim)
    end
end
gif(anim, joinpath(@__DIR__, gif_name); fps=5)
println("Saved: ", gif_name)
