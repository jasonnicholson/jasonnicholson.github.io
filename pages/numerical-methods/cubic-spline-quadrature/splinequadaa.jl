# splinequadaa.jl
# Cubic Spline Quadrature animation: full-interval density refinement
# Produces: splinequadaa.gif

using Plots
gr()

f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a, b = 0.0, 2.0

m_seq = collect(3:2:41)

xlims = (0.0, 2.0)
ylims = (0.0, 2.1)
xplot = range(a, b, length=800)

function natural_spline_M(xs, ys)
    n = length(xs)
    if n <= 2
        return zeros(n)
    end

    h = [xs[i + 1] - xs[i] for i in 1:n-1]
    dl = [h[i] for i in 2:n-2]
    d = [2 * (h[i] + h[i + 1]) for i in 1:n-2]
    du = [h[i + 1] for i in 1:n-3]

    rhs = [6 * ((ys[i + 2] - ys[i + 1]) / h[i + 1] - (ys[i + 1] - ys[i]) / h[i]) for i in 1:n-2]

    for i in 2:n-2
        m = dl[i - 1] / d[i - 1]
        d[i] -= m * du[i - 1]
        rhs[i] -= m * rhs[i - 1]
    end

    M_inner = zeros(n - 2)
    M_inner[end] = rhs[end] / d[end]
    for i in n-3:-1:1
        M_inner[i] = (rhs[i] - du[i] * M_inner[i + 1]) / d[i]
    end

    return vcat(0.0, M_inner, 0.0)
end

function spline_eval(xq, xs, ys, M)
    idx = searchsortedlast(xs, xq)
    idx = clamp(idx, 1, length(xs) - 1)

    x0 = xs[idx]
    x1 = xs[idx + 1]
    h = x1 - x0

    a0 = (x1 - xq) / h
    b0 = (xq - x0) / h

    return a0 * ys[idx] + b0 * ys[idx + 1] +
           ((a0^3 - a0) * M[idx] + (b0^3 - b0) * M[idx + 1]) * (h^2 / 6)
end

function spline_integral(xs, ys, M)
    total = 0.0
    for i in 1:length(xs)-1
        h = xs[i + 1] - xs[i]
        total += h * (ys[i] + ys[i + 1]) / 2 - h^3 * (M[i] + M[i + 1]) / 24
    end
    return total
end

anim = @animate for m in vcat(0, m_seq)
    plot(size=(630, 480), xlims=xlims, ylims=ylims,
         xlabel="", ylabel="", title="Natural Cubic Spline Quadrature",
         legend=false, grid=false, framestyle=:box,
         background_color=:white)

    if m > 0
        xs = collect(range(a, b, length=m))
        ys = f.(xs)
        M = natural_spline_M(xs, ys)

        sx = collect(range(a, b, length=800))
        sy = [spline_eval(xv, xs, ys, M) for xv in sx]

        plot!(sx, sy; fillrange=0.0, fillalpha=0.65,
              fillcolor=:lightpink, linecolor=:red, lw=0.9)
        scatter!(xs, ys; color=:red, ms=2.5)

        approx = spline_integral(xs, ys, M)
        annotate!(1.15, 1.88, text("Sample Points = $m", :black, 10))
        annotate!(1.15, 1.74, text("Approximation = $(round(approx; digits=6))", :black, 10))
    end

    plot!(xplot, f.(xplot); color=:magenta, lw=2)
end

gif(anim, joinpath(@__DIR__, "splinequadaa.gif"); fps=2)
println("Saved: splinequadaa.gif")
