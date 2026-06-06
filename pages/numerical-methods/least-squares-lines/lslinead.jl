# lslinead.jl
# Least Squares Lines animation: Kepler-style constrained power law y = a*x^(3/2)
# Produces: lslinead.gif

using Plots

gr()

x = [57.59, 108.11, 149.57, 227.84]
y = [87.99, 224.70, 365.26, 686.98]
names = ["Mercury", "Venus", "Earth", "Mars"]

fit_kepler_a(xv, yv) = sum((xv .^ 1.5) .* yv) / sum(xv .^ 3)

xlims = (40.0, 240.0)
ylims = (0.0, 750.0)
xplot = range(xlims[1], xlims[2], length=400)
n_pts = length(x)

anim = @animate for k in 1:n_pts
    xv = x[1:k]
    yv = y[1:k]
    a = fit_kepler_a(xv, yv)

    p = plot(size=(640, 420), xlims=xlims, ylims=ylims,
             xlabel="Distance to sun r (million km)",
             ylabel="Orbital period T (days)",
             title="Power Fit: T = a*r^(3/2)",
             legend=:topleft, grid=true, framestyle=:box,
             background_color=:white)

    scatter!(p, x, y; color=:lightgray, ms=4, label="all planets")
    scatter!(p, xv, yv; color=:red, ms=7, label="points used")
    plot!(p, xplot, a .* (xplot .^ 1.5); color=:green, lw=2.5,
          label="fitted power curve")

    for i in 1:k
        annotate!(p, x[i] + 2.5, y[i] + 15.0, text(names[i], 8, :black))
    end

    rss = sum((yv .- a .* (xv .^ 1.5)) .^ 2)
    annotate!(p, 95.0, 720.0,
              text("a = $(round(a; digits=6)), RSS = $(round(rss; digits=4))", 9, :black))

    p
end

gif(anim, joinpath(@__DIR__, "lslinead.gif"); fps=1)
println("Saved: lslinead.gif")
