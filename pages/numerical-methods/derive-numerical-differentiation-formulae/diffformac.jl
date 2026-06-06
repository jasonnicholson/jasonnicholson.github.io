# diffformac.jl
# Derive Numerical Differentiation Formulae animation: second derivative profiles
# Produces: diffformac.gif

using Plots
gr()

f(x) = exp(-x) * sin(x)
fpp(x) = -2exp(-x) * cos(x)

d2_3(x, h) = (f(x + h) - 2f(x) + f(x - h)) / h^2
d2_5(x, h) = (-f(x + 2h) + 16f(x + h) - 30f(x) + 16f(x - h) - f(x - 2h)) / (12h^2)

hs = [0.35, 0.25, 0.18, 0.12, 0.08, 0.05, 0.03, 0.02, 0.01, 0.005, 0.002]

xlims = (0.0, pi)
ylims = (-2.1, 0.2)

anim = @animate for h in hs
    xtrue = range(xlims[1], xlims[2], length=900)
    # Use x in [2h, pi-2h] so both 3-point and 5-point stencils are valid.
    xinner = range(xlims[1] + 2h, xlims[2] - 2h, length=700)

    ytrue = fpp.(xtrue)
    y3 = d2_3.(xinner, h)
    y5 = d2_5.(xinner, h)

    err3 = maximum(abs.(y3 .- fpp.(xinner)))
    err5 = maximum(abs.(y5 .- fpp.(xinner)))

    plot(
        xtrue,
        ytrue;
        color=:black,
        lw=2.5,
        label="f''(x)",
        xlims=xlims,
        ylims=ylims,
        xlabel="x",
        ylabel="Second derivative value",
        grid=true,
        framestyle=:box,
        legend=:topright,
        size=(760, 460),
        background_color=:white,
        title="Second-derivative formulas on [0, pi]  |  h = $(h)",
    )

    plot!(xinner, y3; color=:steelblue3, lw=2, ls=:dash, label="3-point d2")
    plot!(xinner, y5; color=:darkgreen, lw=2, label="5-point d2")

    annotate!(
        0.08,
        -1.95,
        text("max|error 3-point| ≈ $(round(err3; digits=8))   max|error 5-point| ≈ $(round(err5; digits=8))", 10, :left, :black),
    )
end

gif(anim, joinpath(@__DIR__, "diffformac.gif"); fps=2)
println("Saved: diffformac.gif")
