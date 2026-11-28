# legendrepolyaa.jl
# Legendre Polynomial animation: P_0 through P_5 revealed one per frame on [-1, 1]
# Produces: legendrepolyaa.gif

using Plots
gr()

# --- Legendre polynomial via recurrence ---
# P_0 = 1, P_1 = x, P_{n+1} = ((2n+1)*x*P_n - n*P_{n-1}) / (n+1)
function legendre(n::Int, xv::AbstractVector)
    if n == 0
        return ones(length(xv))
    elseif n == 1
        return collect(Float64, xv)
    end
    Pprev2 = ones(length(xv))
    Pprev1 = collect(Float64, xv)
    P = similar(Pprev1)
    for k in 2:n
        @. P = ((2k - 1) * xv * Pprev1 - (k - 1) * Pprev2) / k
        Pprev2 .= Pprev1
        Pprev1 .= P
    end
    return P
end

x = range(-1.0, 1.0, length=500)
n_max = 5
colors = [:blue, :red, :darkgreen, :orange, :purple, :brown]

anim = @animate for n in 0:n_max
    plot(size=(700, 500),
         xlims=(-1.0, 1.0), ylims=(-1.3, 1.3),
         xlabel="x", ylabel="P_n(x)",
         title="Legendre Polynomials P₀ … P_$n",
         legend=:topright, grid=true, framestyle=:box,
         background_color=:white)

    hline!([0.0]; color=:black, lw=0.8, label="")

    for k in 0:n
        Pk = legendre(k, x)
        plot!(collect(x), Pk; color=colors[k + 1], lw=2,
              label="P_$k(x)")
    end
end

gif(anim, joinpath(@__DIR__, "legendrepolyaa.gif"); fps=1)
println("Saved: legendrepolyaa.gif")
