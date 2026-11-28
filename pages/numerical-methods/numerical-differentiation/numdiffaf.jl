# numdiffaf.jl
# Numerical Differentiation animation: backward difference D3- of order O(h^2) at x0 = 1,
# with the parabola through the three stencil points
# (rebuilds Mathews' BackwardD1faa.gif; h values read from its frames)
# Produces: numdiffaf.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0;
# "#" keeps trailing zeros, so every label shows four significant figures
fmt(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%#.4g", x)

f(x) = exp(-x) * sin(x)
fp(x) = exp(-x) * (cos(x) - sin(x))

x0 = 1.0
hs = [0.5, 0.45, 0.4, 0.35, 0.3, 0.25, 0.2, 0.15, 0.1,
      0.09, 0.08, 0.07, 0.06, 0.05, 0.04, 0.03, 0.02, 0.01, 0.008, 0.006, 0.004, 0.002, 0.001, 0.0005]

xlims = (0.0, 2.1)   # Mathews' window is [0, 2.1] in x
ylims = (-0.1, 0.55)

xplot = range(xlims[1], xlims[2], length=700)
yplot = f.(xplot)
line_x = collect(xlims)

anim = @animate for k in eachindex(hs)
    h = hs[k]
    x1 = x0 - h
    x2 = x0 - 2h
    @assert xlims[1] <= x2 <= xlims[2]

    y0 = f(x0)
    y1 = f(x1)
    y2 = f(x2)

    d3m = (3y0 - 4y1 + y2) / (2h)   # backward difference D3-(x0, h)
    mtan = fp(x0)
    err = mtan - d3m

    # Parabola through the three stencil points, written about x0: its slope at x0 is d3m
    c2 = (y2 - 2y1 + y0) / (2h^2)
    parab_y = y0 .+ d3m .* (xplot .- x0) .+ c2 .* (xplot .- x0) .^ 2
    slope_y = y0 .+ d3m .* (line_x .- x0)   # line through (x0, f(x0)) with slope D3-
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
        title="Backward difference D3- at x0 = 1,  h = $(h)\nD3- ≈ $(@sprintf("%.6f", d3m)),  true = $(@sprintf("%.6f", mtan)),  true - D3- = $(fmt(err))",
    )

    plot!(xplot, parab_y; color=:forestgreen, lw=2, label="parabola through the 3 stencil points")
    plot!(line_x, slope_y; color=:purple, lw=2, ls=:dot, label="line through (x0, f(x0)), slope D3-")
    plot!(line_x, tangent_y; color=:crimson, lw=2, label="true tangent")
    scatter!([x0, x1, x2], [y0, y1, y2]; color=:darkorange3, ms=6, label="stencil points")
end

gif(anim, joinpath(@__DIR__, "numdiffaf.gif"); fps=2)
println("Saved: numdiffaf.gif")
