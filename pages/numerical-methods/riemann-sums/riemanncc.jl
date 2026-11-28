# riemanncc.jl
# Riemann Sums animation: Lower Riemann Sum with density increase
# Produces: riemanncc.gif

using Plots
using Printf
gr()

f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a, b = 0.0, 2.0

n_seq = [1, 2, 3, 4, 5, 6, 7, 8, 10, 12, 14, 16,
         20, 24, 28, 32, 40, 48, 56, 64, 72, 88, 104, 120]

xlims = (0.0, 2.0)
ylims = (0.0, 2.1)
xplot = range(a, b, length=800)

# f'(x) for x > 0 (f' grows without bound as x -> 0+)
fp(x) = exp(-x) * ((16 / 3) * x^(-1 / 3) * cos(8 * x^(2 / 3)) - sin(8 * x^(2 / 3)))

# Interior critical points of f in (a, b): sign changes of f' on a fine grid, refined by bisection
function critical_points()
    xs = range(a, b, length=20001)[2:end]
    cps = Float64[]
    for k in 1:length(xs)-1
        lo, hi = xs[k], xs[k+1]
        if sign(fp(lo)) != sign(fp(hi))
            for _ in 1:60
                mid = (lo + hi) / 2
                sign(fp(mid)) == sign(fp(lo)) ? (lo = mid) : (hi = mid)
            end
            push!(cps, (lo + hi) / 2)
        end
    end
    return cps
end
crit = critical_points()

# Minimum of f on [xl, xr]: attained at an endpoint or at an interior critical point
fmin(xl, xr) = minimum(f(x) for x in vcat(xl, xr, filter(c -> xl < c < xr, crit)))

function lower_sum(n)
    dx = (b - a) / n
    return dx * sum(fmin(a + (i - 1) * dx, a + i * dx) for i in 1:n)
end

anim = @animate for n in vcat(0, n_seq)
    plot(size=(630, 480), xlims=xlims, ylims=ylims,
         xlabel="", ylabel="", title="Lower Riemann Sum",
         legend=false, grid=false, framestyle=:box,
         background_color=:white)

    plot!(xplot, f.(xplot); color=:magenta, lw=2)

    if n > 0
        dx = (b - a) / n
        for i in 1:n
            xl = a + (i - 1) * dx
            xr = xl + dx
            h = fmin(xl, xr)
            plot!([xl, xr, xr, xl, xl], [0.0, 0.0, h, h, 0.0];
                  seriestype=:shape, fillcolor=:lightpink, fillalpha=0.65,
                  linecolor=:red, lw=0.7)
        end

        approx = lower_sum(n)
        annotate!(1.15, 1.88, text("Subintervals = $n", :black, 10))
        annotate!(1.15, 1.74, text("Approximation = " * @sprintf("%.6f", approx), :black, 10))
    end
end

gif(anim, joinpath(@__DIR__, "riemanncc.gif"); fps=2)
println("Saved: riemanncc.gif")
