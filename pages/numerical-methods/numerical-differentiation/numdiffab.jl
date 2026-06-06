# numdiffab.jl
# Numerical Differentiation animation: secant-to-tangent at x0 = 1
# Produces: numdiffab.gif

using Plots
gr()

f(x) = exp(-x) * sin(x)
fp(x) = exp(-x) * (cos(x) - sin(x))

x0 = 1.0
hs = [0.6, 0.4, 0.25, 0.15, 0.1, 0.07, 0.05, 0.03, 0.02, 0.01, 0.005, 0.001]

xlims = (0.0, pi)
ylims = (-0.1, 0.55)

xplot = range(xlims[1], xlims[2], length=700)
yplot = f.(xplot)

anim = @animate for k in eachindex(hs)
    h = hs[k]
    xl = x0 - h
    xr = x0 + h

    if xl < xlims[1] || xr > xlims[2]
        continue
    end

    yl = f(xl)
    yr = f(xr)
    y0 = f(x0)

    msec = (yr - yl) / (2h)
    mtan = fp(x0)

    line_x = range(x0 - 0.9, x0 + 0.9, length=200)
    secant_y = y0 .+ msec .* (line_x .- x0)
    tangent_y = y0 .+ mtan .* (line_x .- x0)

    plot(
        xplot,
        yplot;
        color=:black,
        lw=2.5,
        label="f(x) = e^{-x} sin(x)",
        xlabel="x",
        ylabel="y",
        xlims=xlims,
        ylims=ylims,
        grid=true,
        framestyle=:box,
        legend=:topright,
        size=(760, 460),
        background_color=:white,
        title="Derivative at x0 = 1  |  h = $(h)  |  secant ≈ $(round(msec; digits=6)), true = $(round(mtan; digits=6))",
    )

    plot!(line_x, secant_y; color=:dodgerblue3, lw=2, ls=:dash, label="central secant slope")
    plot!(line_x, tangent_y; color=:crimson, lw=2, label="true tangent")
    scatter!([xl, x0, xr], [yl, y0, yr]; color=:darkorange3, ms=6, label="stencil points")
end

gif(anim, joinpath(@__DIR__, "numdiffab.gif"); fps=2)
println("Saved: numdiffab.gif")
