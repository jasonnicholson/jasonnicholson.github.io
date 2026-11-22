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
for n in 0:n_max
    S = zeros(length(x)); for k in 0:n; S .+= coeffs[k+1] .* legendre(k, x); end
    err = maximum(abs.(S .- fx))
    println("n=$n c=$(coeffs[n+1]) err=$err title=$(round(err, sigdigits=3))")
end
