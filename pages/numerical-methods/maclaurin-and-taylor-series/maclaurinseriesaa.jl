# maclaurinseriesaa.jl
# Maclaurin Series animation: partial sums of 1/(1-x) = sum x^n
# Produces: maclaurinseriesaa.gif

using Plots
gr()

# --- Function and parameters ---
f(x) = 1.0 / (1.0 - x)
c    = 0.0          # Maclaurin = Taylor centered at 0
n_terms = 9         # show 0..n_terms partial sums

xlims = (-1.5, 1.5)
ylims = (-1.0, 10.0)

# --- Partial sum function: S_n(x) = sum_{k=0}^{n} x^k ---
partial_sum(x, n) = sum(x^k for k in 0:n)

xplot = range(-0.98, 0.98, length=600)
xplot_all = range(xlims[1], xlims[2], length=600)

colors = [:blue, :green, :darkorange, :purple, :red, :teal, :brown, :gray, :navy]

anim = @animate for frame in 0:n_terms
    plot(size=(640, 480), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y",
         title="Maclaurin Series: f(x) = 1/(1−x)",
         legend=:topleft, grid=true, framestyle=:box,
         background_color=:white)

    # True function (clipped to ylims)
    yclip = clamp.(f.(xplot), ylims[1], ylims[2])
    plot!(collect(xplot), yclip; color=:magenta, lw=2.5, label="f(x) = 1/(1−x)")

    # Convergence radius boundary
    vline!([-1.0, 1.0]; color=:gray, lw=1, ls=:dash, label="")

    # Successive partial sums
    for k in 0:frame
        yps = clamp.(partial_sum.(xplot_all, k), ylims[1], ylims[2])
        lab = k == frame ? "S_{$k}(x)" : ""
        plot!(collect(xplot_all), yps; color=colors[k+1], lw=1.5, label=lab, alpha=k == frame ? 1.0 : 0.4)
    end

    # Expansion point
    scatter!([c], [f(c)]; color=:red, ms=7, label="")
    annotate!(0.2, -0.5, text("n = $frame", :black, 11))
end

gif(anim, joinpath(@__DIR__, "maclaurinseriesaa.gif"); fps=2)
println("Saved: maclaurinseriesaa.gif")
