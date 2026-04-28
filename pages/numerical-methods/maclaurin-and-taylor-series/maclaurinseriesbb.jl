# maclaurinseriesbb.jl
# Maclaurin Series animation: partial sums of -log(1-x)
# Produces: maclaurinseriesbb.gif

using Plots
gr()

# --- Function and parameters ---
f(x) = -log(1.0 - x)
c = 0.0
n_terms = 12

xlims = (-0.95, 0.95)
ylims = (-1.2, 3.2)

# S_n(x) = sum_{k=1}^{n} x^k / k
function partial_sum(x, n)
    if n == 0
        return 0.0
    end
    return sum((x^k) / k for k in 1:n)
end

xplot = range(xlims[1], xlims[2], length=700)

colors = [:blue, :green, :darkorange, :purple, :red, :teal, :brown, :gray, :navy]

anim = @animate for frame in 0:n_terms
    plot(size=(640, 480), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y",
         title="Maclaurin Series: f(x) = -log(1-x)",
         legend=:topleft, grid=true, framestyle=:box,
         background_color=:white)

    # True function
    plot!(collect(xplot), f.(xplot); color=:magenta, lw=2.5, label="f(x) = -log(1-x)")
    vline!([-1.0, 1.0]; color=:gray, lw=1, ls=:dash, label="")

    # Successive partial sums (clipped)
    for k in 0:frame
        yps = clamp.(partial_sum.(xplot, k), ylims[1], ylims[2])
        lab = k == frame ? "S_{$k}(x)" : ""
        plot!(collect(xplot), yps; color=colors[(k % length(colors)) + 1], lw=1.6, label=lab, alpha=k == frame ? 1.0 : 0.35)
    end

    # Expansion point
    scatter!([c], [f(c)]; color=:red, ms=7, label="")
    annotate!(-0.85, -1.0, text("n = $frame", :black, 11))
end

gif(anim, joinpath(@__DIR__, "maclaurinseriesbb.gif"); fps=2)
println("Saved: maclaurinseriesbb.gif")
