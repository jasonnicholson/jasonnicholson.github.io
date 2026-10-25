# richexaa.jl
# Richardson Extrapolation animation: D3 vs D5 on [0, pi]
# Produces: richexaa.gif

using Plots
gr()

f(x) = exp(-x) * sin(x)
fp(x) = exp(-x) * (cos(x) - sin(x))

d3(x, h) = (f(x + h) - f(x - h)) / (2h)
d5(x, h) = (4d3(x, h / 2) - d3(x, h)) / 3

hs = [0.5, 0.32, 0.2, 0.12, 0.08, 0.05, 0.03, 0.02, 0.01]
xlims = (0.0, pi)
ylims = (-1.0, 1.1)

anim = @animate for h in hs
    xfull = range(xlims[1], xlims[2], length=800)
    xint = range(xlims[1] + h, xlims[2] - h, length=700)

    ytrue = fp.(xfull)
    y3 = d3.(xint, h)
    y5 = d5.(xint, h)

    err3 = maximum(abs.(y3 .- fp.(xint)))
    err5 = maximum(abs.(y5 .- fp.(xint)))

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
        title="Richardson Extrapolation on [0, pi]  |  h = $(h)",
    )

    plot!(xint, y3; color=:steelblue3, lw=2, ls=:dash, label="D3(x,h)")
    plot!(xint, y5; color=:darkorange2, lw=2, label="D5(x,h) = (4D3(x,h/2)-D3(x,h))/3")

    annotate!(
        0.14,
        -0.88,
        text("max|error D3| ≈ $(round(err3; digits=6))   max|error D5| ≈ $(round(err5; digits=6))", 10, :left, :black),
    )
end

gif(anim, joinpath(@__DIR__, "richexaa.gif"); fps=2)
println("Saved: richexaa.gif")
