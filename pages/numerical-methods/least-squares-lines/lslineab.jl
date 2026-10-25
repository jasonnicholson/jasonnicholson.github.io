# lslineab.jl
# Least Squares Lines animation: compare y-on-x and x-on-y regressions plus intersection
# Produces: lslineab.gif

using Plots

gr()

x = [-1.0, 0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0]
y = [10.0, 9.0, 7.0, 5.0, 4.0, 3.0, 0.0, -1.0]

function fit_y_on_x(xv, yv)
    n = length(xv)
    sx = sum(xv)
    sy = sum(yv)
    sxx = sum(xv .^ 2)
    sxy = sum(xv .* yv)
    a = (n * sxy - sx * sy) / (n * sxx - sx^2)
    b = (sy - a * sx) / n
    return a, b
end

function fit_x_on_y(xv, yv)
    n = length(yv)
    sy = sum(yv)
    sx = sum(xv)
    syy = sum(yv .^ 2)
    sxy = sum(xv .* yv)
    c = (n * sxy - sy * sx) / (n * syy - sy^2)
    d = (sx - c * sy) / n
    return c, d
end

xlims = (-2.0, 7.0)
ylims = (-2.2, 11.3)
xplot = range(xlims[1], xlims[2], length=400)
n_pts = length(x)

anim = @animate for k in 2:n_pts
    xv = x[1:k]
    yv = y[1:k]

    a, b = fit_y_on_x(xv, yv)
    c, d = fit_x_on_y(xv, yv)

    # Convert x = c*y + d to y = alpha*x + beta for comparison in x-y axes.
    alpha = 1 / c
    beta = -d / c

    # Early frames can be nearly singular when both regressions collapse to the same line.
    has_intersection = abs(1 - a * c) > 1e-8
    yi = has_intersection ? (a * d + b) / (1 - a * c) : NaN
    xi = has_intersection ? (c * yi + d) : NaN

    xbar = sum(xv) / k
    ybar = sum(yv) / k

    p = plot(size=(640, 420), xlims=xlims, ylims=ylims,
             xlabel="x", ylabel="y",
             title="Two Least-Squares Lines",
             legend=:topright, grid=true, framestyle=:box,
             background_color=:white)

    scatter!(p, x, y; color=:lightgray, ms=4, label="all data")
    scatter!(p, xv, yv; color=:red, ms=6, label="points used")

    plot!(p, xplot, a .* xplot .+ b; color=:green, lw=2.5,
          label="y on x")
    plot!(p, xplot, alpha .* xplot .+ beta; color=:blue, lw=2.0,
          linestyle=:dash, label="x on y (rearranged)")

    if has_intersection && isfinite(xi) && isfinite(yi)
        scatter!(p, [xi], [yi]; color=:black, marker=:diamond, ms=6,
                 label="line intersection")
    end
    scatter!(p, [xbar], [ybar]; color=:orange, marker=:star5, ms=9,
             label="centroid")

    status = has_intersection ?
             "k=$(k): (xi, yi)=($(round(xi; digits=3)), $(round(yi; digits=3)))" :
             "k=$(k): intersection ill-conditioned"
    annotate!(p, 0.35, 10.6, text(status, 9, :black))

    p
end

gif(anim, joinpath(@__DIR__, "lslineab.gif"); fps=1)
println("Saved: lslineab.gif")
