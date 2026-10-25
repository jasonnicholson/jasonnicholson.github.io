# legendrepolybb.jl
# Legendre Polynomial animation: partial-sum Legendre series approximation of cos(πx/2)
# Adds one Legendre term per frame, showing convergence on [-1, 1]
# Produces: legendrepolybb.gif

using Plots
gr()

# --- Legendre polynomial via recurrence ---
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

# --- Legendre series coefficient (Gauss-Legendre quadrature with many points) ---
# c_n = (2n+1)/2 * integral_{-1}^{1} f(x)*P_n(x) dx
function legendre_coeff(f, n; npts=1000)
    # Trapezoid rule on [-1, 1]
    xq = range(-1.0, 1.0, length=npts)
    h  = 2.0 / (npts - 1)
    integrand = f.(xq) .* legendre(n, xq)
    integral  = h * (sum(integrand) - 0.5 * (integrand[1] + integrand[end]))
    return (2n + 1) / 2 * integral
end

f(x) = cos(π * x / 2)

x = range(-1.0, 1.0, length=500)
fx = f.(x)

n_max = 8
coeffs = [legendre_coeff(f, n) for n in 0:n_max]

anim = @animate for n in 0:n_max
    # Partial sum S_n = sum_{k=0}^{n} c_k * P_k(x)
    S = zeros(length(x))
    for k in 0:n
        S .+= coeffs[k + 1] .* legendre(k, x)
    end

    err = maximum(abs.(S .- fx))

    plot(size=(700, 500),
         xlims=(-1.0, 1.0), ylims=(-1.3, 1.3),
         xlabel="x", ylabel="y",
         title="Legendre Series for cos(πx/2) — $(n+1) term$(n==0 ? "" : "s")  (max err = $(round(err, sigdigits=3)))",
         legend=:topright, grid=true, framestyle=:box,
         background_color=:white)

    plot!(collect(x), fx; color=:blue, lw=2, label="f(x) = cos(πx/2)")
    plot!(collect(x), S;  color=:red,  lw=2, linestyle=:dash,
          label="S_$n(x)")
end

gif(anim, joinpath(@__DIR__, "legendrepolybb.gif"); fps=2)
println("Saved: legendrepolybb.gif")
