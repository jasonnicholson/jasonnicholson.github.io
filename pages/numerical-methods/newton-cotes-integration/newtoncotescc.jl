# newtoncotescc.jl
# Newton-Cotes animation: Composite Simpson's 3/8 Rule
# Produces: newtoncotescc.gif

using Plots
gr()

f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a, b = 0.0, 2.0

n_seq = [3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36,
         39, 42, 45, 48, 54, 60, 66, 72, 84, 96, 108, 120]

xlims = (-0.03, 2.03)   # small margin so the end sample points are not clipped
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
         xlabel="", ylabel="", title="Simpson's 3/8 Rule",
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

        # Panel dividers at every panel boundary x_{3k}, k = 0..n/3 (as in the legacy GIF)
        for i in 0:3:n
            xk = a + i * dx
            plot!([xk, xk], [0.0, f(xk)]; color=:red, lw=0.8)
        end

        approx = simpson38_sum(n)
        annotate!(1.15, 1.88, text("Sample Points = $(n + 1)", :black, 10))
        annotate!(1.15, 1.74, text("Approximation = $(round(approx; digits=6))", :black, 10))
    end

    plot!(xplot, f.(xplot); color=:magenta, lw=2)

    if n > 0
        # Sample points x_i = a + i*dx, i = 0..n, drawn on top (as in the legacy GIF)
        xnodes = [a + i * dx for i in 0:n]
        scatter!(xnodes, f.(xnodes); color=:red, markersize=3, markerstrokewidth=0)
    end
end

gif(anim, joinpath(@__DIR__, "newtoncotescc.gif"); fps=2)
println("Saved: newtoncotescc.gif")
