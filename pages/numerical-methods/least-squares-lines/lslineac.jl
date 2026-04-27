# lslineac.jl
# Least Squares Lines animation: constrained fit through origin y = a*x
# Produces: lslineac.gif

using Plots

gr()

x = [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0]
y = [2.0, 3.0, 5.0, 6.0, 8.0, 9.0, 11.0, 12.0]

fit_through_origin(xv, yv) = sum(xv .* yv) / sum(xv .^ 2)

xlims = (0.0, 9.0)
ylims = (0.0, 13.0)
xplot = range(xlims[1], xlims[2], length=400)
n_pts = length(x)

anim = @animate for k in 1:n_pts
    xv = x[1:k]
    yv = y[1:k]
    a = fit_through_origin(xv, yv)

    p = plot(size=(640, 420), xlims=xlims, ylims=ylims,
             xlabel="x", ylabel="y",
             title="Modified Least-Squares Line: y = a*x",
             legend=:topleft, grid=true, framestyle=:box,
             background_color=:white)

    scatter!(p, x, y; color=:lightgray, ms=4, label="all data")
    scatter!(p, xv, yv; color=:red, ms=6, label="points used")
    plot!(p, xplot, a .* xplot; color=:magenta, lw=2.5,
          label="fit through origin")

    for i in 1:k
        yh = a * xv[i]
        plot!(p, [xv[i], xv[i]], [yv[i], yh]; color=:steelblue, lw=1.2, label="")
    end

    rss = sum((yv .- a .* xv) .^ 2)
    annotate!(p, 1.0, 12.2,
              text("a = $(round(a; digits=5)), RSS = $(round(rss; digits=4))", 9, :black))

    p
end

gif(anim, joinpath(@__DIR__, "lslineac.gif"); fps=1)
println("Saved: lslineac.gif")
