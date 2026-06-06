# diffformab.jl
# Derive Numerical Differentiation Formulae animation: five-point first derivative
# Produces: diffformab.gif

using Plots
gr()

f(x) = exp(-x) * sin(x)
fp(x) = exp(-x) * (cos(x) - sin(x))

d1_3(x, h) = (f(x + h) - f(x - h)) / (2h)
d1_5(x, h) = (f(x - 2h) - 8f(x - h) + 8f(x + h) - f(x + 2h)) / (12h)

x0 = 1.0
hs = [0.35, 0.25, 0.18, 0.12, 0.08, 0.05, 0.03, 0.02, 0.01, 0.005, 0.002]

xlims = (0.0, pi)
ylims = (-0.1, 0.55)
xplot = range(xlims[1], xlims[2], length=700)

anim = @animate for h in hs
    xs = [x0 - 2h, x0 - h, x0, x0 + h, x0 + 2h]
    ys = f.(xs)

    approx3 = d1_3(x0, h)
    approx5 = d1_5(x0, h)
    exact = fp(x0)

    line_x = range(x0 - 0.9, x0 + 0.9, length=200)
    l3 = f(x0) .+ approx3 .* (line_x .- x0)
    l5 = f(x0) .+ approx5 .* (line_x .- x0)
    lt = f(x0) .+ exact .* (line_x .- x0)

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
        title="Five-point formula: f'(x0) ≈ [f(x0-2h)-8f(x0-h)+8f(x0+h)-f(x0+2h)]/(12h)",
    )

    scatter!(xs, ys; color=:darkorange3, ms=6, label="five-point stencil")
    plot!(line_x, l3; color=:steelblue3, lw=1.8, ls=:dash, label="three-point estimate")
    plot!(line_x, l5; color=:darkgreen, lw=2, label="five-point estimate")
    plot!(line_x, lt; color=:crimson, lw=2, label="true tangent")

    annotate!(
        0.08,
        -0.07,
        text(
            "h=$(h),  |err3|≈$(round(abs(approx3 - exact); digits=6)),  |err5|≈$(round(abs(approx5 - exact); digits=6))",
            10,
            :left,
            :black,
        ),
    )
end

gif(anim, joinpath(@__DIR__, "diffformab.gif"); fps=2)
println("Saved: diffformab.gif")
