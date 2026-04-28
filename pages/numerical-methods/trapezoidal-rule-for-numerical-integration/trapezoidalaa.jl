# trapezoidalaa.jl
# Trapezoidal Rule animation: legacy-style density refinement
# Produces: trapezoidalaa.gif

using Plots
gr()

f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a, b = 0.0, 2.0

n_seq = [1, 2, 3, 4, 5, 6, 7, 8, 10, 12, 14, 16,
         18, 20, 24, 28, 32, 40, 48, 56, 72, 96, 120]

xlims = (0.0, 2.0)
ylims = (0.0, 2.1)
xplot = range(a, b, length=800)

function trapezoid_sum(n)
    dx = (b - a) / n
    interior = n > 1 ? sum(f(a + i * dx) for i in 1:n-1) : 0.0
    return dx * (0.5 * f(a) + interior + 0.5 * f(b))
end

anim = @animate for n in vcat(0, n_seq)
    plot(size=(630, 480), xlims=xlims, ylims=ylims,
         xlabel="", ylabel="", title="Trapezoidal Rule\nNumerical Quadrature",
         legend=false, grid=false, framestyle=:box,
         background_color=:white)

    if n > 0
        dx = (b - a) / n
        for i in 0:n-1
            xl = a + i * dx
            xr = xl + dx
            yl = f(xl)
            yr = f(xr)

            plot!([xl, xr, xr, xl], [0.0, 0.0, yr, yl];
                  seriestype=:shape, fillcolor=:lightpink, fillalpha=0.65,
                  linecolor=:red, lw=0.7)
            plot!([xl, xr], [yl, yr]; color=:red, lw=0.8)
        end

        approx = trapezoid_sum(n)
        annotate!(1.15, 1.88, text("Sample Points = $(n + 1)", :black, 10))
        annotate!(1.15, 1.74, text("Approximation = $(round(approx; digits=6))", :black, 10))
    end

    plot!(xplot, f.(xplot); color=:magenta, lw=2)
end

gif(anim, joinpath(@__DIR__, "trapezoidalaa.gif"); fps=2)
println("Saved: trapezoidalaa.gif")
