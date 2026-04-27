# newtoncotesbb.jl
# Newton-Cotes animation: Composite Simpson's Rule (1/3)
# Produces: newtoncotesbb.gif

using Plots
gr()

f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a, b = 0.0, 2.0

n_seq = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20,
         22, 24, 26, 28, 30, 32, 34, 36, 38, 40]

xlims = (0.0, 2.0)
ylims = (0.0, 2.1)
xplot = range(a, b, length=800)

function poly_coeffs(xs, ys)
    A = [xs[i]^(j - 1) for i in 1:length(xs), j in 1:length(xs)]
    return A \ ys
end

eval_poly(c, x) = sum(c[j] * x^(j - 1) for j in eachindex(c))

function simpson_sum(n)
    dx = (b - a) / n
    odd_sum = sum(f(a + i * dx) for i in 1:2:n-1)
    even_sum = n > 2 ? sum(f(a + i * dx) for i in 2:2:n-2) : 0.0
    return (dx / 3) * (f(a) + f(b) + 4 * odd_sum + 2 * even_sum)
end

anim = @animate for n in vcat(0, n_seq)
    plot(size=(630, 480), xlims=xlims, ylims=ylims,
         xlabel="", ylabel="", title="Simpson's Rule",
         legend=false, grid=false, framestyle=:box,
         background_color=:white)

    if n > 0
        dx = (b - a) / n
        for i in 0:2:n-2
            x0 = a + i * dx
            x1 = x0 + dx
            x2 = x0 + 2 * dx

            xs = [x0, x1, x2]
            ys = [f(x0), f(x1), f(x2)]
            c = poly_coeffs(xs, ys)

            xp = range(x0, x2, length=80)
            yp = [eval_poly(c, x) for x in xp]

            plot!(xp, yp; fillrange=0.0, fillalpha=0.65,
                  fillcolor=:lightpink, linecolor=:red, lw=0.8)
        end

        approx = simpson_sum(n)
        annotate!(1.15, 1.88, text("Sample Points = $(n + 1)", :black, 10))
        annotate!(1.15, 1.74, text("Approximation = $(round(approx; digits=6))", :black, 10))
    end

    plot!(xplot, f.(xplot); color=:magenta, lw=2)
end

gif(anim, joinpath(@__DIR__, "newtoncotesbb.gif"); fps=2)
println("Saved: newtoncotesbb.gif")
