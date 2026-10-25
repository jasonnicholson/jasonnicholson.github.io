# numdiffaa.jl
# Numerical Differentiation animation: central difference across [0, pi]
# Produces: numdiffaa.gif

using Plots
gr()

f(x) = exp(-x) * sin(x)
fp(x) = exp(-x) * (cos(x) - sin(x))

central3(x, h) = (f(x + h) - f(x - h)) / (2h)

hs = [0.5, 0.3, 0.2, 0.1, 0.07, 0.05, 0.03, 0.02, 0.01, 0.005, 0.002, 0.001]

xlims = (0.0, pi)
ylims = (-1.0, 1.1)

anim = @animate for k in eachindex(hs)
    h = hs[k]
    xfull = range(xlims[1], xlims[2], length=700)
    xint = range(xlims[1] + h, xlims[2] - h, length=700)

    ytrue = fp.(xfull)
    yapprox = central3.(xint, h)
    maxerr = maximum(abs.(yapprox .- fp.(xint)))

    plot(
        xfull,
        ytrue;
        color=:black,
        lw=2.5,
        label="f'(x)",
        xlabel="x",
        ylabel="Derivative Value",
        xlims=xlims,
        ylims=ylims,
        grid=true,
        framestyle=:box,
        legend=:topright,
        size=(760, 460),
        background_color=:white,
        title="Three-Point Central Difference on [0, pi]  |  h = $(h)  |  max error ≈ $(round(maxerr; digits=6))",
    )

    plot!(xint, yapprox; color=:dodgerblue3, lw=2, label="D3(x,h)")
end

gif(anim, joinpath(@__DIR__, "numdiffaa.gif"); fps=2)
println("Saved: numdiffaa.gif")
