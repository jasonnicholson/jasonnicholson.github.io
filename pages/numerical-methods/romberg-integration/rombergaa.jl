# rombergaa.jl
# Romberg Integration animation: trapezoidal refinement plus Romberg table
# Produces: rombergaa.gif

using Plots
using Printf
gr()

f(x) = 1 + exp(-x) * sin(8 * x^(2 / 3))
a, b = 0.0, 2.0

m_seq = [2, 3, 5, 9, 17, 33, 65, 129]
n_levels = length(m_seq)

xlims = (0.0, 2.0)
ylims = (0.0, 2.1)
xplot = range(a, b, length=800)

function trapezoid_sum(n)
    dx = (b - a) / n
    interior = n > 1 ? sum(f(a + i * dx) for i in 1:n-1) : 0.0
    return dx * (0.5 * f(a) + interior + 0.5 * f(b))
end

R = fill(NaN, n_levels, n_levels)
for k in 1:n_levels
    n = m_seq[k] - 1
    R[k, 1] = trapezoid_sum(n)
    for j in 2:k
        R[k, j] = R[k, j - 1] + (R[k, j - 1] - R[k - 1, j - 1]) / (4^(j - 1) - 1)
    end
end

anim = @animate for frame in 0:n_levels
    p1 = plot(size=(760, 480), xlims=xlims, ylims=ylims,
              xlabel="", ylabel="", title="Romberg Integration",
              legend=false, grid=false, framestyle=:box,
              background_color=:white)

    if frame > 0
        n = m_seq[frame] - 1
        dx = (b - a) / n
        for i in 0:n-1
            xl = a + i * dx
            xr = xl + dx
            yl = f(xl)
            yr = f(xr)

            plot!(p1, [xl, xr, xr, xl], [0.0, 0.0, yr, yl];
                  seriestype=:shape, fillcolor=:lightpink, fillalpha=0.6,
                  linecolor=:red, lw=0.6)
            plot!(p1, [xl, xr], [yl, yr]; color=:red, lw=0.7)
        end

        annotate!(p1, 1.12, 1.88, text("Sample Points = $(m_seq[frame])", :black, 10))
        annotate!(p1, 1.12, 1.74, text("R[k,k] = $(round(R[frame, frame]; digits=6))", :black, 10))
    end

    plot!(p1, xplot, f.(xplot); color=:magenta, lw=2)

    p2 = plot(xlim=(0.0, 1.0), ylim=(0.0, 1.0), axis=false,
              legend=false, background_color=:white,
              title="Romberg Table")

    annotate!(p2, 0.02, 0.95, text("k   m        R[k,1]       ...      R[k,k]", :black, 8, :left))
    for k in 1:frame
        row_vals = join([@sprintf("%.6f", R[k, j]) for j in 1:k], "  ")
        line = @sprintf("%d   %-3d  %s", k, m_seq[k], row_vals)
        y = 0.90 - 0.09 * k
        annotate!(p2, 0.02, y, text(line, :black, 8, :left))
    end

    plot(p1, p2; layout=@layout([a{0.68w} b{0.32w}]), size=(920, 480))
end

gif(anim, joinpath(@__DIR__, "rombergaa.gif"); fps=2)
println("Saved: rombergaa.gif")
