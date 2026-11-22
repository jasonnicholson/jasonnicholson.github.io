# richexaa.jl
# Richardson Extrapolation animation: D3 vs D5 on [0, pi]
# Produces: richexaa.gif

using Plots
using Printf
gr()

f(x) = exp(-x) * sin(x)
fp(x) = exp(-x) * (cos(x) - sin(x))

d3(x, h) = (f(x + h) - f(x - h)) / (2h)
d5(x, h) = (4d3(x, h / 2) - d3(x, h)) / 3

hs = [0.5, 0.32, 0.2, 0.12, 0.08, 0.05, 0.03, 0.02, 0.01]
xlims = (0.0, pi)
ylims = (-1.0, 1.1)

anim = @animate for h in hs
    # D3 and D5 are evaluated on all of [0, pi] (f is defined outside it), as in
    # Mathews' Example 2(b), so the title's interval and the max errors agree.
    xfull = range(xlims[1], xlims[2], length=800)

    ytrue = fp.(xfull)
    y3 = d3.(xfull, h)
    y5 = d5.(xfull, h)

    err3 = maximum(abs.(y3 .- ytrue))
    err5 = maximum(abs.(y5 .- ytrue))

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

    plot!(xfull, y3; color=:steelblue3, lw=2, ls=:dash, label="D3(x,h)")
    plot!(xfull, y5; color=:darkorange2, lw=2, label="D5(x,h) = (4D3(x,h/2)-D3(x,h))/3")

    annotate!(
        0.14,
        -0.88,
        text(@sprintf("max|error D3| ≈ %.2e   max|error D5| ≈ %.2e", err3, err5), 10, :left, :black),
    )
end

gif(anim, joinpath(@__DIR__, "richexaa.gif"); fps=2)
println("Saved: richexaa.gif")
