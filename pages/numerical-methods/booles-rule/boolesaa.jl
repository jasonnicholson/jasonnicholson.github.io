# boolesaa.jl
# Boole's Rule animation: full-interval density refinement
# Produces: boolesaa.gif

using Plots
gr()

f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a, b = 0.0, 2.0

n_seq = [4, 8, 12, 16, 20, 24, 28, 32, 36, 40,
         44, 48, 52, 56, 60, 64, 72, 80, 88, 96,
         104, 112, 120]

xlims = (0.0, 2.0)
ylims = (0.0, 2.1)
xplot = range(a, b, length=800)

function poly_coeffs(xs, ys)
    A = [xs[i]^(j - 1) for i in 1:length(xs), j in 1:length(xs)]
    return A \ ys
end

eval_poly(c, x) = sum(c[j] * x^(j - 1) for j in eachindex(c))

function boole_sum(n)
    dx = (b - a) / n
    total = 0.0
    for i in 0:4:n-4
        x0 = a + i * dx
        x1 = x0 + dx
        x2 = x0 + 2 * dx
        x3 = x0 + 3 * dx
        x4 = x0 + 4 * dx
        total += (2 * dx / 45) * (7 * f(x0) + 32 * f(x1) + 12 * f(x2) + 32 * f(x3) + 7 * f(x4))
    end
    return total
end

anim = @animate for n in vcat(0, n_seq)
    plot(size=(630, 480), xlims=xlims, ylims=ylims,
         xlabel="", ylabel="", title="Boole's Rule\nNumerical Quadrature",
         legend=false, grid=false, framestyle=:box,
         background_color=:white)

    if n > 0
        dx = (b - a) / n
        for i in 0:4:n-4
            x0 = a + i * dx
            x1 = x0 + dx
            x2 = x0 + 2 * dx
            x3 = x0 + 3 * dx
            x4 = x0 + 4 * dx

            xs = [x0, x1, x2, x3, x4]
            ys = [f(x0), f(x1), f(x2), f(x3), f(x4)]
            c = poly_coeffs(xs, ys)

            xp = range(x0, x4, length=100)
            yp = [eval_poly(c, x) for x in xp]

            plot!(xp, yp; fillrange=0.0, fillalpha=0.65,
                  fillcolor=:lightpink, linecolor=:red, lw=0.8)
        end

        approx = boole_sum(n)
        annotate!(1.15, 1.88, text("Sample Points = $(n + 1)", :black, 10))
        annotate!(1.15, 1.74, text("Approximation = $(round(approx; digits=6))", :black, 10))
    end

    plot!(xplot, f.(xplot); color=:magenta, lw=2)
end

gif(anim, joinpath(@__DIR__, "boolesaa.gif"); fps=2)
println("Saved: boolesaa.gif")
