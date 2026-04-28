# maclaurinseriesaa.jl
# Maclaurin Series animation: partial sums of 1/(1+x^2) = sum (-1)^k x^(2k)
# Produces: maclaurinseriesaa.gif

using Plots
gr()

# --- Function and parameters ---
f(x) = 1.0 / (1.0 + x^2)
c = 0.0
n_terms = 12

xlims = (-1.5, 1.5)
ylims = (-0.6, 1.4)

# S_n(x) = sum_{k=0}^{n} (-1)^k x^(2k)
partial_sum(x, n) = sum(((-1.0)^k) * x^(2k) for k in 0:n)

xplot = range(xlims[1], xlims[2], length=700)

colors = [:blue, :green, :darkorange, :purple, :red, :teal, :brown, :gray, :navy]

anim = @animate for frame in 0:n_terms
    plot(size=(640, 480), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y",
         title="Maclaurin Series: f(x) = 1/(1+x^2)",
         legend=:topleft, grid=true, framestyle=:box,
         background_color=:white)

    plot!(collect(xplot), f.(xplot); color=:magenta, lw=2.5, label="f(x) = 1/(1+x^2)")
    vline!([-1.0, 1.0]; color=:gray, lw=1, ls=:dash, label="")

    # Successive partial sums
    for k in 0:frame
        yps = clamp.(partial_sum.(xplot, k), ylims[1], ylims[2])
        lab = k == frame ? "S_{$k}(x)" : ""
        plot!(collect(xplot), yps; color=colors[(k % length(colors)) + 1], lw=1.6, label=lab, alpha=k == frame ? 1.0 : 0.35)
    end

    # Expansion point
    scatter!([c], [f(c)]; color=:red, ms=7, label="")
    annotate!(-1.4, -0.45, text("n = $frame", :black, 11))
end

gif(anim, joinpath(@__DIR__, "maclaurinseriesaa.gif"); fps=2)
println("Saved: maclaurinseriesaa.gif")
