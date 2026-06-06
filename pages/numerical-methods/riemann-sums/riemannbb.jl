# riemannbb.jl
# Riemann Sums animation: Right Riemann Sum with density increase
# Produces: riemannbb.gif

using Plots
gr()

f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a, b = 0.0, 2.0

n_seq = [1, 2, 3, 4, 5, 6, 7, 8, 10, 12, 14, 16,
         20, 24, 28, 32, 40, 48, 56, 64, 72, 88, 104, 120]

xlims = (0.0, 2.0)
ylims = (0.0, 2.1)
xplot = range(a, b, length=800)

right_sum(n) = ((b - a) / n) * sum(f(a + i * (b - a) / n) for i in 1:n)

anim = @animate for n in vcat(0, n_seq)
    plot(size=(630, 480), xlims=xlims, ylims=ylims,
         xlabel="", ylabel="", title="Right Riemann Sum",
         legend=false, grid=false, framestyle=:box,
         background_color=:white)

    plot!(xplot, f.(xplot); color=:magenta, lw=2)

    if n > 0
        dx = (b - a) / n
        for i in 1:n
            xr = a + i * dx
            xl = xr - dx
            h = f(xr)
            plot!([xl, xr, xr, xl, xl], [0.0, 0.0, h, h, 0.0];
                  seriestype=:shape, fillcolor=:lightpink, fillalpha=0.65,
                  linecolor=:red, lw=0.7)
        end

        approx = right_sum(n)
        annotate!(1.15, 1.88, text("Sample Points = $n", :black, 10))
        annotate!(1.15, 1.74, text("Approximation = $(round(approx; digits=6))", :black, 10))
    end
end

gif(anim, joinpath(@__DIR__, "riemannbb.gif"); fps=2)
println("Saved: riemannbb.gif")
