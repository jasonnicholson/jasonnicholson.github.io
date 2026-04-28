# maclaurinseriescc.jl
# Taylor Series animation: partial sums of sqrt(x) centered at x=1
# Produces: maclaurinseriescc.gif

using Plots
gr()

# --- Function and parameters ---
f(x) = sqrt(x)
c = 1.0
n_terms = 8

xlims = (0.0, 10.5)
ylims = (0.0, 4.0)

# a_k = f^(k)(c) / k! for f(x)=sqrt(x) at c=1
function taylor_coeff(k)
    if k == 0
        return 1.0
    end
    prod = 1.0
    for j in 0:k-1
        prod *= (0.5 - j)
    end
    return prod / factorial(k)
end

coeffs = [taylor_coeff(k) for k in 0:n_terms]

function partial_sum(x, n)
    s = 0.0
    for k in 0:n
        s += coeffs[k+1] * (x - c)^k
    end
    return s
end

xplot = range(xlims[1] + 1e-3, xlims[2], length=700)
colors = [:blue, :green, :darkorange, :purple, :red, :teal, :brown, :gray, :navy]

anim = @animate for frame in 0:n_terms
    plot(size=(640, 480), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y",
         title="Taylor Series: f(x) = sqrt(x), x0 = 1",
         legend=:topleft, grid=true, framestyle=:box,
         background_color=:white)

    plot!(collect(xplot), f.(xplot); color=:magenta, lw=2.5, label="f(x) = sqrt(x)")

    for k in 0:frame
        yps = clamp.(partial_sum.(xplot, k), ylims[1], ylims[2])
        lab = k == frame ? "T_{$k}(x)" : ""
        plot!(collect(xplot), yps; color=colors[(k % length(colors)) + 1], lw=1.6, label=lab, alpha=k == frame ? 1.0 : 0.35)
    end

    scatter!([c], [f(c)]; color=:red, ms=7, label="")
    annotate!(7.5, 0.25, text("n = $frame", :black, 11))
end

gif(anim, joinpath(@__DIR__, "maclaurinseriescc.gif"); fps=2)
println("Saved: maclaurinseriescc.gif")
