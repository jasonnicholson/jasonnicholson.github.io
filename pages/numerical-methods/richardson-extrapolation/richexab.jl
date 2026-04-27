# richexab.jl
# Richardson Extrapolation animation: pointwise convergence rates at x0 = 1
# Produces: richexab.gif

using Plots
gr()

f(x) = exp(-x) * sin(x)
fp(x) = exp(-x) * (cos(x) - sin(x))

d3(x, h) = (f(x + h) - f(x - h)) / (2h)
d5(x, h) = (4d3(x, h / 2) - d3(x, h)) / 3

x0 = 1.0
hs = [0.5, 0.32, 0.2, 0.12, 0.08, 0.05, 0.03, 0.02, 0.01, 0.006, 0.003, 0.0015]

errs3 = [abs(d3(x0, h) - fp(x0)) for h in hs]
errs5 = [abs(d5(x0, h) - fp(x0)) for h in hs]

# Scale guide lines to be near the first data point.
c2 = errs3[1] / hs[1]^2
c4 = errs5[1] / hs[1]^4

anim = @animate for k in eachindex(hs)
    hk = hs[1:k]
    e3k = errs3[1:k]
    e5k = errs5[1:k]

    hguide = range(minimum(hk), maximum(hk), length=200)
    order2 = c2 .* (hguide .^ 2)
    order4 = c4 .* (hguide .^ 4)

    plot(
        hk,
        e3k;
        xaxis=:log,
        yaxis=:log,
        marker=:circle,
        ms=4,
        lw=2,
        color=:steelblue3,
        label="|D3(1,h)-f'(1)|",
        xlabel="h",
        ylabel="Absolute error",
        grid=true,
        framestyle=:box,
        legend=:bottomright,
        size=(760, 460),
        background_color=:white,
        title="Pointwise Richardson Convergence at x0 = 1",
    )

    plot!(hk, e5k; marker=:diamond, ms=4, lw=2, color=:darkorange2, label="|D5(1,h)-f'(1)|")
    plot!(hguide, order2; color=:gray35, lw=1.5, ls=:dash, label="O(h^2) guide")
    plot!(hguide, order4; color=:gray15, lw=1.5, ls=:dot, label="O(h^4) guide")
end

gif(anim, joinpath(@__DIR__, "richexab.gif"); fps=2)
println("Saved: richexab.gif")
