# simpson38aa.jl
# Simpson's 3/8 Rule animation: reconstructed legacy-style density refinement
# Produces: simpson38aa.gif

using Plots
gr()

f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a, b = 0.0, 2.0

n_seq = [3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36,
         42, 48, 54, 60, 66, 72, 81, 90, 99, 108, 120]

xlims = (0.0, 2.0)
ylims = (0.0, 2.1)
xplot = range(a, b, length=800)

function poly_coeffs(xs, ys)
    A = [xs[i]^(j - 1) for i in 1:length(xs), j in 1:length(xs)]
    return A \ ys
end

eval_poly(c, x) = sum(c[j] * x^(j - 1) for j in eachindex(c))

function simpson38_sum(n)
    dx = (b - a) / n
    sum_3 = sum(f(a + i * dx) for i in 1:n-1 if i % 3 != 0)
    sum_2 = n > 3 ? sum(f(a + i * dx) for i in 3:3:n-3) : 0.0
    return (3 * dx / 8) * (f(a) + f(b) + 3 * sum_3 + 2 * sum_2)
end

anim = @animate for n in vcat(0, n_seq)
    plot(size=(630, 480), xlims=xlims, ylims=ylims,
         xlabel="", ylabel="", title="Simpson's 3/8 Rule\nNumerical Quadrature",
         legend=false, grid=false, framestyle=:box,
         background_color=:white)

    if n > 0
        dx = (b - a) / n
        for i in 0:3:n-3
            x0 = a + i * dx
            x1 = x0 + dx
            x2 = x0 + 2 * dx
            x3 = x0 + 3 * dx

            xs = [x0, x1, x2, x3]
            ys = [f(x0), f(x1), f(x2), f(x3)]
            c = poly_coeffs(xs, ys)

            xp = range(x0, x3, length=90)
            yp = [eval_poly(c, x) for x in xp]

            plot!(xp, yp; fillrange=0.0, fillalpha=0.65,
                  fillcolor=:lightpink, linecolor=:red, lw=0.8)
        end

        approx = simpson38_sum(n)
        annotate!(1.15, 1.88, text("Sample Points = $(n + 1)", :black, 10))
        annotate!(1.15, 1.74, text("Approximation = $(round(approx; digits=6))", :black, 10))
    end

    plot!(xplot, f.(xplot); color=:magenta, lw=2)
end

gif(anim, joinpath(@__DIR__, "simpson38aa.gif"); fps=2)
println("Saved: simpson38aa.gif")
