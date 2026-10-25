# diffformaa.jl
# Derive Numerical Differentiation Formulae animation: three-point first derivative
# Produces: diffformaa.gif

using Plots
gr()

f(x) = exp(-x) * sin(x)
fp(x) = exp(-x) * (cos(x) - sin(x))

d1_3(x, h) = (f(x + h) - f(x - h)) / (2h)

x0 = 1.0
hs = [0.6, 0.4, 0.25, 0.15, 0.1, 0.07, 0.05, 0.03, 0.02, 0.01, 0.005, 0.001]

xlims = (0.0, pi)
ylims = (-0.1, 0.55)
xplot = range(xlims[1], xlims[2], length=700)

anim = @animate for h in hs
    xl = x0 - h
    xr = x0 + h
    y0 = f(x0)
    yl = f(xl)
    yr = f(xr)

    approx = d1_3(x0, h)
    exact = fp(x0)

    line_x = range(x0 - 0.9, x0 + 0.9, length=200)
    line_y = y0 .+ approx .* (line_x .- x0)
    tan_y = y0 .+ exact .* (line_x .- x0)

    plot(
        xplot,
        f.(xplot);
        color=:black,
        lw=2.5,
        label="f(x)",
        xlabel="x",
        ylabel="y",
        xlims=xlims,
        ylims=ylims,
        grid=true,
        framestyle=:box,
        legend=:topright,
        size=(760, 460),
        background_color=:white,
        title="Three-point formula: f'(x0) ≈ (f(x0+h)-f(x0-h))/(2h),  h = $(h)",
    )

    plot!(line_x, line_y; color=:dodgerblue3, lw=2, ls=:dash, label="formula slope")
    plot!(line_x, tan_y; color=:crimson, lw=2, label="true tangent")
    scatter!([xl, x0, xr], [yl, y0, yr]; color=:darkorange3, ms=6, label="x0-h, x0, x0+h")

    annotate!(0.1, -0.07, text("approx = $(round(approx; digits=6)), exact = $(round(exact; digits=6))", 10, :left, :black))
end

gif(anim, joinpath(@__DIR__, "diffformaa.gif"); fps=2)
println("Saved: diffformaa.gif")
