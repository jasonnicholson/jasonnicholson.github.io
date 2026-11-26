# numdiffac.jl
# Numerical Differentiation animation: forward difference D2+ of order O(h) at x0 = 1
# (rebuilds Mathews' ForwardDfaa.gif; h values read from its frames)
# Produces: numdiffac.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0;
# "#" keeps trailing zeros, so every label shows four significant figures
fmt(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%#.4g", x)

f(x) = exp(-x) * sin(x)
fp(x) = exp(-x) * (cos(x) - sin(x))

x0 = 1.0
hs = [1.0, 0.95, 0.9, 0.85, 0.8, 0.75, 0.7, 0.65, 0.6, 0.55, 0.5, 0.45, 0.4, 0.35, 0.3, 0.25, 0.2, 0.15, 0.1,
      0.09, 0.08, 0.07, 0.06, 0.05, 0.04, 0.03, 0.02, 0.01, 0.008, 0.006, 0.004, 0.002, 0.001, 0.0005]

xlims = (0.0, 2.1)   # Mathews' window is [0, 2.1] in x
ylims = (-0.1, 0.55)

xplot = range(xlims[1], xlims[2], length=700)
yplot = f.(xplot)
line_x = collect(xlims)

anim = @animate for k in eachindex(hs)
    h = hs[k]
    xr = x0 + h
    @assert xlims[1] <= xr <= xlims[2]

    y0 = f(x0)
    yr = f(xr)

    d2p = (yr - y0) / h   # forward difference D2+(x0, h)
    mtan = fp(x0)
    err = mtan - d2p

    secant_y = y0 .+ d2p .* (line_x .- x0)   # chord through (x0, f(x0)) and (x0+h, f(x0+h))
    tangent_y = y0 .+ mtan .* (line_x .- x0)

    plot(
        xplot,
        yplot;
        color=:black,
        lw=2.5,
        label="f(x) = e^(-x) sin(x)",
        xlabel="x",
        ylabel="y",
        xlims=xlims,
        ylims=ylims,
        grid=true,
        framestyle=:box,
        legend=:topright,
        size=(760, 460),
        background_color=:white,
        top_margin=3Plots.mm,
        title="Forward difference D2+ at x0 = 1,  h = $(h)\nD2+ ≈ $(@sprintf("%.6f", d2p)),  true = $(@sprintf("%.6f", mtan)),  true - D2+ = $(fmt(err))",
    )

    plot!(line_x, secant_y; color=:dodgerblue3, lw=2, ls=:dash, label="forward secant (chord through x0 and x0 + h)")
    plot!(line_x, tangent_y; color=:crimson, lw=2, label="true tangent")
    scatter!([x0, xr], [y0, yr]; color=:darkorange3, ms=6, label="stencil points")
end

gif(anim, joinpath(@__DIR__, "numdiffac.gif"); fps=2)
println("Saved: numdiffac.gif")
