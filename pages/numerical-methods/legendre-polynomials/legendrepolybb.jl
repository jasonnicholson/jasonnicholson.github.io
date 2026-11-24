# legendrepolybb.jl
# Legendre Polynomial animation: partial-sum Legendre series approximation of exp(x)cos(πx/2)
# (the function of Mathews' Example 8(b)). Adds one Legendre term per frame; f is neither even
# nor odd, and every coefficient c_0 ... c_8 is nonzero. Shows convergence on [-1, 1]
# Produces: legendrepolybb.gif

using Plots
using LinearAlgebra
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

# --- Gauss-Legendre nodes and weights on [-1, 1] (Golub-Welsch eigenvalue method) ---
function gauss_legendre(m)
    J = SymTridiagonal(zeros(m), [k / sqrt(4k^2 - 1) for k in 1:m-1])
    E = eigen(J)
    return E.values, 2 .* E.vectors[1, :] .^ 2
end

# --- Legendre series coefficient (20-point Gauss-Legendre quadrature) ---
# c_n = (2n+1)/2 * integral_{-1}^{1} f(x)*P_n(x) dx
function legendre_coeff(f, n; npts=20)
    xq, wq = gauss_legendre(npts)
    integral = sum(wq .* f.(xq) .* legendre(n, xq))
    return (2n + 1) / 2 * integral
end

f(x) = exp(x) * cos(π * x / 2)

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
         title="Legendre Series for exp(x)cos(πx/2) — S_$n(x)  (max err = $(round(err, sigdigits=3)))",
         titlefontsize=12, legend=:bottomright, grid=true, framestyle=:box,
         background_color=:white)

    plot!(collect(x), fx; color=:blue, lw=2, label="f(x) = exp(x)cos(πx/2)")
    plot!(collect(x), S;  color=:red,  lw=2, linestyle=:dash,
          label="S_$n(x)")
end

gif(anim, joinpath(@__DIR__, "legendrepolybb.gif"); fps=2)
println("Saved: legendrepolybb.gif")
