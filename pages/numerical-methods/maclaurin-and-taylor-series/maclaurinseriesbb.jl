# maclaurinseriesbb.jl
# Taylor Series animation: partial sums of sqrt(x) centered at x=1
# Produces: maclaurinseriesbb.gif

using Plots
gr()

# --- Function and parameters ---
f(x) = sqrt(x)
c    = 1.0          # Taylor center
n_terms = 8         # show 0..n_terms partial sums

xlims = (0.0, 10.0)
ylims = (0.0, 4.0)

# --- Taylor coefficients of sqrt(x) at x=1 ---
# f(x) = sum_{k=0}^{n} a_k (x-1)^k
# a_k = (1/2 choose k) * (-1)^(k-1) ... use Pochhammer / falling factorial
# General: d^k/dx^k [x^(1/2)] at x=1 = prod_{j=0}^{k-1} (1/2 - j) = (1/2)_k falling
function taylor_coeff(k)
    if k == 0; return 1.0; end
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

xplot = range(xlims[1]+0.01, xlims[2], length=500)

colors = [:blue, :green, :darkorange, :purple, :red, :teal, :brown, :gray, :navy]

anim = @animate for frame in 0:n_terms
    plot(size=(640, 480), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y",
         title="Taylor Series: f(x) = √x,  c = 1",
         legend=:topleft, grid=true, framestyle=:box,
         background_color=:white)

    # True function
    plot!(collect(xplot), f.(xplot); color=:magenta, lw=2.5, label="f(x) = √x")

    # Successive partial sums (clipped)
    for k in 0:frame
        yps = clamp.(partial_sum.(xplot, k), ylims[1], ylims[2])
        lab = k == frame ? "T_{$k}(x)" : ""
        plot!(collect(xplot), yps; color=colors[k+1], lw=1.5, label=lab, alpha=k == frame ? 1.0 : 0.4)
    end

    # Expansion point
    scatter!([c], [f(c)]; color=:red, ms=7, label="")
    annotate!(5.0, 0.3, text("n = $frame", :black, 11))
end

gif(anim, joinpath(@__DIR__, "maclaurinseriesbb.gif"); fps=2)
println("Saved: maclaurinseriesbb.gif")
