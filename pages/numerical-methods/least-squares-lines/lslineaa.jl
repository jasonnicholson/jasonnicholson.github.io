# lslineaa.jl
# Least Squares Lines animation: standard unconstrained least-squares line y = b + a*x
# Produces: lslineaa.gif

using Plots

gr()

# Example 1 data from the legacy module
x = [-1.0, 0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
y = [10.0, 9.0, 7.0, 5.0, 4.0, 3.0, 0.0, -1.0]

function fit_unconstrained(xv, yv)
    n = length(xv)
    sx = sum(xv)
    sy = sum(yv)
    sxx = sum(xv .^ 2)
    sxy = sum(xv .* yv)
    a = (n * sxy - sx * sy) / (n * sxx - sx^2)
    b = (sy - a * sx) / n
    return a, b
end

xlims = (-2.0, 7.0)
ylims = (-2.2, 11.3)

xplot = range(xlims[1], xlims[2], length=400)
n_pts = length(x)

anim = @animate for k in 2:n_pts
    xv = x[1:k]
    yv = y[1:k]
    a, b = fit_unconstrained(xv, yv)

    p = plot(size=(640, 420), xlims=xlims, ylims=ylims,
             xlabel="x", ylabel="y",
             title="Least Squares Line: y = b + a*x",
             legend=:topright, grid=true, framestyle=:box,
             background_color=:white)

    scatter!(p, x, y; color=:lightgray, ms=4, label="all data")
    scatter!(p, xv, yv; color=:red, ms=6, label="points used")

    yline = a .* xplot .+ b
    plot!(p, xplot, yline; color=:green, lw=2.5,
          label="fit with first $(k) points")

    # Show vertical residuals for points currently used.
    for i in 1:k
        yh = a * xv[i] + b
        plot!(p, [xv[i], xv[i]], [yv[i], yh]; color=:steelblue, lw=1.2, label="")
    end

    rss = sum((yv .- (a .* xv .+ b)) .^ 2)
    annotate!(p, 0.35, 10.6,
              text("a = $(round(a; digits=4)), b = $(round(b; digits=4)), RSS = $(round(rss; digits=4))", 9, :black))

    p
end

gif(anim, joinpath(@__DIR__, "lslineaa.gif"); fps=1)
println("Saved: lslineaa.gif")
