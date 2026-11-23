# pade_animations_all.jl
# Generate Padé approximation animations for legacy Mathews-style cases.
# Output GIFs are saved next to this script via @__DIR__.

using Plots
using SpecialFunctions
using LinearAlgebra

gr()

struct PadeCase
    id::String
    formula_tex::String
    formula_label::String
    f::Function
    c::Float64
    xlims::Tuple{Float64, Float64}
    ylims::Tuple{Float64, Float64}
    max_total::Int
end

cases = PadeCase[
    # Mathews cases 1..27
    PadeCase("01", raw"\sqrt{x}", "sqrt(x)", x -> sqrt(x), 1.0, (0.0, 10.5), (-0.5, 3.5), 10),
    PadeCase("02", raw"\sqrt{x}", "sqrt(x)", x -> sqrt(x), 4.0, (0.0, 10.5), (-0.5, 3.5), 10),
    PadeCase("03", raw"\sqrt{x}", "sqrt(x)", x -> sqrt(x), 5.0, (0.0, 10.5), (0.0, 3.5), 10),
    PadeCase("04", raw"\frac{1}{\sqrt{1-x}}", "1/sqrt(1-x)", x -> 1 / sqrt(1 - x), 0.0, (-1.5, 1.5), (-1.0, 6.0), 10),
    PadeCase("05", raw"\log(x)", "log(x)", x -> log(x), 1.0, (-0.5, 4.1), (-6.0, 2.0), 10),
    PadeCase("06", raw"\log(x)", "log(x)", x -> log(x), 2.0, (-0.5, 4.1), (-6.0, 2.0), 10),
    PadeCase("07", raw"\log(1+x)", "log(1+x)", x -> log(1 + x), 0.0, (-1.5, 1.5), (-4.0, 2.0), 10),
    PadeCase("08", raw"\sin(x)", "sin(x)", x -> sin(x), 0.0, (-3pi, 3pi), (-1.5, 1.5), 10),
    PadeCase("09", raw"\cos(x)", "cos(x)", x -> cos(x), 0.0, (-3pi, 3pi), (-1.5, 1.5), 10),
    PadeCase("10", raw"\sin(x)", "sin(x)", x -> sin(x), pi / 4, (-7pi / 4, 9pi / 4), (-1.5, 1.5), 10),
    PadeCase("11", raw"\cos(x)", "cos(x)", x -> cos(x), pi / 3, (-5pi / 3, 7pi / 3), (-1.5, 1.5), 10),
    PadeCase("12", raw"\tan(x)", "tan(x)", x -> tan(x), 0.0, (-pi, pi), (-10.0, 10.0), 8),
    PadeCase("13", raw"e^x", "exp(x)", x -> exp(x), 0.0, (-2.0, 3.0), (-1.0, 22.0), 10),
    PadeCase("14", raw"e^{-x}\cos(x)", "exp(-x)*cos(x)", x -> exp(-x) * cos(x), 0.0, (-2.0, 4.0), (-4.0, 4.0), 10),
    PadeCase("15", raw"\cosh(x)", "cosh(x)", x -> cosh(x), 0.0, (-4.0, 4.0), (-1.0, 30.0), 10),
    PadeCase("16", raw"\arctan(x)", "atan(x)", x -> atan(x), 0.0, (-2.0, 2.0), (-2.0, 2.0), 10),
    PadeCase("17", raw"\arcsin(x)", "asin(x)", x -> asin(x), 0.0, (-1.5, 1.5), (-2.0, 2.0), 8),
    PadeCase("18", raw"J_0(x)", "besselj(0,x)", x -> besselj(0, x), 0.0, (-10.2, 10.2), (-1.5, 1.5), 10),
    PadeCase("19", raw"J_1(x)", "besselj(1,x)", x -> besselj(1, x), 0.0, (-10.2, 10.2), (-1.5, 1.5), 10),
    PadeCase("20", raw"\frac{1}{\sqrt{2\pi}}e^{-x^2/2}", "normal_pdf(x)", x -> exp(-x^2 / 2) / sqrt(2pi), 0.0, (-3.0, 3.0), (-0.05, 0.45), 10),
    PadeCase("21", raw"\frac{1}{2}+\frac{1}{2}\operatorname{erf}\!\left(\frac{x}{\sqrt{2}}\right)", "normal_cdf(x)", x -> 0.5 + 0.5 * erf(x / sqrt(2.0)), 0.0, (-3.0, 3.0), (-0.1, 1.1), 10),
    PadeCase("22", raw"\Gamma(x)", "gamma(x)", x -> gamma(x), 1.0, (-0.2, 5.2), (-10.0, 35.0), 8),
    PadeCase("23", raw"\Gamma(x)", "gamma(x)", x -> gamma(x), 2.0, (-0.2, 5.2), (-10.0, 35.0), 8),
    PadeCase("24", raw"\Gamma(x)", "gamma(x)", x -> gamma(x), 3.0, (-0.2, 5.2), (-10.0, 45.0), 8),
    PadeCase("25", raw"Y_0(x)", "bessely(0,x)", x -> bessely(0, x), 10.0, (0.0, 22.0), (-2.0, 2.0), 8),
    PadeCase("26", raw"Y_0(x)", "bessely(0,x)", x -> bessely(0, x), 5.0, (0.0, 22.0), (-2.0, 2.0), 8),
    PadeCase("27", raw"Y_0(x)", "bessely(0,x)", x -> bessely(0, x), 2.0, (0.0, 22.0), (-2.0, 2.0), 8),
]

function safe_eval(f::Function, x::Float64)
    try
        y = f(x)
        return isfinite(y) ? y : NaN
    catch
        return NaN
    end
end

function binom_real(alpha::Float64, k::Int)
    k == 0 && return 1.0
    p = 1.0
    for j in 0:(k - 1)
        p *= (alpha - j)
    end
    return p / factorial(k)
end

# Exact Taylor coefficients, correctly rounded to Float64 (the same routine is used on the Maclaurin and Laurent pages).
# Self-contained: needs only SpecialFunctions (gamma, digamma, besselj, bessely on BigFloat).
#
# taylor_coeffs_exact(family, c, n; nu=0, alpha=0.5, prec=256) returns a[k+1] = f^(k)(c)/k!
# for k = 0..n, about the Float64 point c taken exactly (BigFloat(c)), computed in
# `prec`-bit BigFloat and then rounded once to Float64.
#
# family   f(x)                 formula used for f^(k)(c)/k!
# :power   x^alpha  (c > 0)     binom(alpha, k) * c^(alpha - k)          (:sqrt = alpha 1/2)
# :log     log(x)   (c > 0)     log(c); (-1)^(k-1) / (k c^k)
# :exp     exp(x)               exp(c) / k!
# :sin     sin(x)               (sin c, cos c, -sin c, -cos c)[k mod 4] / k!
# :cos     cos(x)               (cos c, -sin c, -cos c, sin c)[k mod 4] / k!
# :gamma   Gamma(x) (c > 0)
#          Gamma(c+z) = Gamma(c) exp(sum_m l_m z^m), l_1 = digamma(c),
#          l_m = (-1)^m zeta(m, c) / m (m >= 2, Hurwitz zeta); the exponential is
#          expanded with k g_k = sum_{j=1..k} j l_j g_{k-j}.
# :besselj J_nu(x), integer nu (any real c; c < 0 via J_nu(-x) = (-1)^nu J_nu(x))
# :bessely Y_nu(x), integer nu (c > 0)
#          Z_nu^(k)(c) = 2^-k sum_{j=0..k} (-1)^j binom(k,j) Z_{nu-k+2j}(c),
#          with Z_{-m} = (-1)^m Z_m; Z_m(c) from MPFR (jn / yn).

# Bernoulli numbers B_0..B_N as exact rationals (sum_{j=0}^{m} binom(m+1,j) B_j = 0).
function _bernoulli_numbers(N::Int)
    B = Vector{Rational{BigInt}}(undef, N + 1)
    B[1] = 1 // 1
    for m in 1:N
        s = big(0) // 1
        for j in 0:(m - 1)
            s += binomial(big(m + 1), big(j)) * B[j + 1]
        end
        B[m + 1] = -s / (m + 1)
    end
    return B
end

# Hurwitz zeta(s, a) for integer s >= 2 and BigFloat a > 0, by Euler-Maclaurin summation.
# Shift to A = a + N >= 100 + 2s and use 60 Bernoulli terms; each tail term shrinks by a
# factor of at most ((s + 120) / (2 pi A))^2 < 0.04, so the truncation error is far below
# 2^-256 relative.
function _hurwitz_zeta(s::Int, a::BigFloat)
    s >= 2 || error("_hurwitz_zeta: s must be >= 2")
    a > 0 || error("_hurwitz_zeta: a must be > 0")
    N = max(0, ceil(Int, 100 + 2s - a))
    total = zero(BigFloat)
    for j in 0:(N - 1)
        total += (a + j)^(-s)
    end
    A = a + N
    total += A^(1 - s) / (s - 1) + A^(-s) / 2
    K = 60
    B = _bernoulli_numbers(2K)
    rising = BigFloat(s)            # s (s+1) ... (s+2k-2)
    fact = BigFloat(2)              # (2k)!
    for k in 1:K
        if k > 1
            rising *= (s + 2k - 3) * (s + 2k - 2)
            fact *= (2k - 1) * (2k)
        end
        total += BigFloat(B[2k + 1]) / fact * rising * A^(-s - 2k + 1)
    end
    return total
end

function _bessel_big(kind::Symbol, m::Int, x::BigFloat)
    sgn = (m < 0 && isodd(m)) ? -1 : 1        # Z_{-m} = (-1)^m Z_m
    mm = abs(m)
    if kind === :besselj
        if x < 0                               # J_m(-x) = (-1)^m J_m(x)
            return sgn * (isodd(mm) ? -1 : 1) * besselj(mm, -x)
        end
        return sgn * besselj(mm, x)
    else
        x > 0 || error("bessely needs c > 0")
        return sgn * bessely(mm, x)
    end
end

function taylor_coeffs_exact(family::Symbol, c::Float64, n::Int;
                             nu::Int=0, alpha::Float64=0.5, prec::Int=256)
    n >= 0 || error("order n must be >= 0")
    a = setprecision(BigFloat, prec) do
        cb = BigFloat(c)                       # the Float64 c, exactly
        ab = Vector{BigFloat}(undef, n + 1)
        if family === :power || family === :sqrt
            al = family === :sqrt ? BigFloat(1) / 2 : BigFloat(alpha)
            cb > 0 || error("x^alpha needs c > 0")
            bin = one(BigFloat)
            for k in 0:n
                k > 0 && (bin *= (al - (k - 1)) / k)
                ab[k + 1] = bin * cb^(al - k)
            end
        elseif family === :log
            cb > 0 || error("log needs c > 0")
            ab[1] = log(cb)
            for k in 1:n
                ab[k + 1] = (isodd(k) ? 1 : -1) / (k * cb^k)
            end
        elseif family === :exp
            e = exp(cb)
            for k in 0:n
                ab[k + 1] = e / factorial(big(k))
            end
        elseif family === :sin || family === :cos
            s, co = sin(cb), cos(cb)
            cyc = family === :sin ? (s, co, -s, -co) : (co, -s, -co, s)
            for k in 0:n
                ab[k + 1] = cyc[mod(k, 4) + 1] / factorial(big(k))
            end
        elseif family === :gamma
            (cb <= 0 && isinteger(cb)) && error("Gamma has a pole at c = $c")
            cb > 0 || error("this routine handles Gamma about c > 0 only")
            l = Vector{BigFloat}(undef, n)     # log-Gamma coefficients l_1..l_n
            n >= 1 && (l[1] = digamma(cb))
            for m in 2:n
                l[m] = (iseven(m) ? 1 : -1) * _hurwitz_zeta(m, cb) / m
            end
            ab[1] = gamma(cb)
            for k in 1:n
                s = zero(BigFloat)
                for j in 1:k
                    s += j * l[j] * ab[k - j + 1]
                end
                ab[k + 1] = s / k
            end
        elseif family === :besselj || family === :bessely
            for k in 0:n
                s = zero(BigFloat)
                for j in 0:k
                    s += (isodd(j) ? -1 : 1) * binomial(big(k), big(j)) *
                         _bessel_big(family, nu - k + 2j, cb)
                end
                ab[k + 1] = s / (BigFloat(2)^k * factorial(big(k)))
            end
        else
            error("taylor_coeffs_exact: unknown family $(family)")
        end
        Float64.(ab)                           # one correct rounding per coefficient
    end
    return a
end

function series_coeffs_analytic(case::PadeCase)
    n = case.max_total
    c = case.c
    a = zeros(Float64, n + 1)
    lbl = case.formula_label

    if lbl == "sqrt(x)"
        for k in 0:n
            a[k + 1] = binom_real(0.5, k) * c^(0.5 - k)
        end
        return a
    elseif lbl == "1/sqrt(1-x)" && c == 0.0
        for k in 0:n
            a[k + 1] = binomial(2k, k) / (4.0^k)
        end
        return a
    elseif lbl == "log(x)"
        a[1] = log(c)
        for k in 1:n
            a[k + 1] = ((-1.0)^(k - 1)) / (k * c^k)
        end
        return a
    elseif lbl == "log(1+x)" && c == 0.0
        a[1] = 0.0
        for k in 1:n
            a[k + 1] = ((-1.0)^(k + 1)) / k
        end
        return a
    elseif lbl == "sin(x)" && c == 0.0
        # exact zeros at even k (sin(k*pi/2) in Float64 leaves 1e-17 noise there)
        return taylor_coeffs_exact(:sin, c, n)
    elseif lbl == "cos(x)" && c == 0.0
        return taylor_coeffs_exact(:cos, c, n)
    elseif lbl == "sin(x)"
        for k in 0:n
            a[k + 1] = sin(c + k * pi / 2) / factorial(k)
        end
        return a
    elseif lbl == "cos(x)"
        for k in 0:n
            a[k + 1] = cos(c + k * pi / 2) / factorial(k)
        end
        return a
    elseif lbl == "tan(x)" && c == 0.0
        # tan(x) = x + x^3/3 + 2x^5/15 + 17x^7/315 + ...
        tan_coeff = Dict(1 => 1.0, 3 => 1.0 / 3.0, 5 => 2.0 / 15.0, 7 => 17.0 / 315.0, 9 => 62.0 / 2835.0)
        for (k, v) in tan_coeff
            if k <= n
                a[k + 1] = v
            end
        end
        return a
    elseif lbl == "exp(x)"
        for k in 0:n
            a[k + 1] = exp(c) / factorial(k)
        end
        return a
    elseif lbl == "exp(-x)*cos(x)" && c == 0.0
        z = complex(-1.0, 1.0)
        for k in 0:n
            a[k + 1] = real(z^k) / factorial(k)
        end
        return a
    elseif lbl == "cosh(x)" && c == 0.0
        for m in 0:div(n, 2)
            k = 2m
            a[k + 1] = 1.0 / factorial(k)
        end
        return a
    elseif lbl == "atan(x)" && c == 0.0
        for m in 0:div(n - 1, 2)
            k = 2m + 1
            a[k + 1] = ((-1.0)^m) / k
        end
        return a
    elseif lbl == "asin(x)" && c == 0.0
        for m in 0:div(n - 1, 2)
            k = 2m + 1
            a[k + 1] = factorial(2m) / (4.0^m * factorial(m)^2 * (2m + 1))
        end
        return a
    elseif lbl == "besselj(0,x)" && c == 0.0
        for m in 0:div(n, 2)
            k = 2m
            a[k + 1] = ((-1.0)^m) / (4.0^m * factorial(m)^2)
        end
        return a
    elseif lbl == "besselj(1,x)" && c == 0.0
        for m in 0:div(n - 1, 2)
            k = 2m + 1
            a[k + 1] = ((-1.0)^m) / (2.0^(2m + 1) * factorial(m) * factorial(m + 1))
        end
        return a
    elseif lbl == "normal_pdf(x)" && c == 0.0
        c0 = 1.0 / sqrt(2pi)
        for m in 0:div(n, 2)
            k = 2m
            a[k + 1] = c0 * ((-1.0)^m) / (2.0^m * factorial(m))
        end
        return a
    elseif lbl == "normal_cdf(x)" && c == 0.0
        a[1] = 0.5
        c0 = 1.0 / sqrt(2pi)
        for m in 0:div(n - 1, 2)
            k = 2m + 1
            a[k + 1] = c0 * ((-1.0)^m) / (2.0^m * factorial(m) * (2m + 1))
        end
        return a
    elseif lbl == "gamma(x)"
        return taylor_coeffs_exact(:gamma, c, n)
    elseif lbl == "bessely(0,x)"
        return taylor_coeffs_exact(:bessely, c, n; nu=0)
    end

    error("no Taylor coefficients for $(lbl) about $(c)")
end

function poly_eval_asc(coeffs::Vector{Float64}, z::Float64)
    v = coeffs[end]
    for i in (length(coeffs) - 1):-1:1
        v = v * z + coeffs[i]
    end
    return v
end

# Linearised [m/n] construction: q0 = 1, Toeplitz system for q1..qn, then p from q*a.
# Returns p, q and the Toeplitz matrix B (empty when n = 0).
function pade_linear(a::Vector{Float64}, m::Int, n::Int)
    if n == 0
        return a[1:(m + 1)], [1.0], zeros(Float64, 0, 0)
    end

    B = zeros(Float64, n, n)
    rhs = zeros(Float64, n)
    for r in 1:n
        k = m + r
        rhs[r] = -a[k + 1]
        for j in 1:n
            idx = k - j + 1
            B[r, j] = idx >= 1 ? a[idx] : 0.0
        end
    end

    qtail = try
        B \ rhs
    catch
        pinv(B) * rhs
    end
    q = [1.0; qtail]

    p = zeros(Float64, m + 1)
    for i in 0:m
        s = 0.0
        for j in 0:min(i, n)
            s += q[j + 1] * a[i - j + 1]
        end
        p[i + 1] = s
    end

    return p, q, B
end

# Singular test: on this table, regular systems have cond(B) <= 1.6e11 and exactly
# singular ones (in floating point) have cond(B) >= 4.7e16.
is_singular(B::Matrix{Float64}) = !isempty(B) && cond(B) > 1e14

# Degree of a coefficient vector (ascending powers); -1 for the zero polynomial.
function poly_degree(v::Vector{Float64})
    tol = 1e-12 * maximum(abs, v)
    for i in length(v):-1:1
        abs(v[i]) > tol && return i - 1
    end
    return -1
end

# true when q(z) f(z) - p(z) = O(z^(K+1)): coefficients 0..K vanish (exact zeros stay
# zero; rounding noise below 1e-10 of the size of the terms counts as zero).
function contact_ok(a::Vector{Float64}, p::Vector{Float64}, q::Vector{Float64}, K::Int)
    for k in 0:K
        s = 0.0
        mag = 0.0
        for j in 0:min(k, length(q) - 1)
            t = q[j + 1] * a[k - j + 1]
            s += t
            mag += abs(t)
        end
        if k < length(p)
            s -= p[k + 1]
            mag += abs(p[k + 1])
        end
        abs(s) <= 1e-10 * mag || return false
    end
    return true
end

# Reduced (Frobenius) form of the [L/M] entry: the unique p/q, deg p <= L, deg q <= M,
# with z^d (q f - p) = O(z^(L+M+1)) for some d <= min(L - deg p, M - deg q). It is the
# top-left entry [deg p / deg q] of the Pade-table block that contains [L/M].
function reduced_pade(a::Vector{Float64}, L::Int, M::Int)
    for s in 0:(L + M), l in 0:min(L, s)
        mu = s - l
        mu <= M || continue
        p, q, B = pade_linear(a, l, mu)
        is_singular(B) && continue
        dp = poly_degree(p)
        dq = poly_degree(q)
        d = dp < 0 ? M - dq : min(L - dp, M - dq)
        d >= 0 || continue
        contact_ok(a, p, q, L + M - d) || continue
        return p[1:(max(dp, 0) + 1)], q[1:(dq + 1)], max(dp, 0), dq
    end
    error("no reduced Pade form found for [$L/$M]")
end

# Returns p, q and a label suffix. When the Toeplitz system is singular and has no
# solution, no [m/n] with Q(x0) = 1 matches f through order m+n; the frame then shows
# the block's reduced approximant and the legend says so.
function pade_from_series(a::Vector{Float64}, m::Int, n::Int)
    p, q, B = pade_linear(a, m, n)
    is_singular(B) || return p, q, ""
    pr, qr, l, mu = reduced_pade(a, m, n)
    if l <= m && mu <= n && contact_ok(a, pr, qr, m + n)
        return p, q, ""            # consistent: the [m/n] approximant exists
    end
    return pr, qr, " = [$(l)/$(mu)] (degenerate)"
end

function order_pairs(max_total::Int)
    pairs = Tuple{Int, Int}[]
    for total in 0:max_total
        for m in 0:total
            n = total - m
            push!(pairs, (m, n))
        end
    end
    return pairs
end

function render_case(case::PadeCase)
    xplot = collect(range(case.xlims[1], case.xlims[2], length=900))
    ytrue = [safe_eval(case.f, x) for x in xplot]

    pairs = order_pairs(case.max_total)
    coeffs = series_coeffs_analytic(case)

    anim = Animation()
    yc = safe_eval(case.f, case.c)

    for (m, n) in pairs
        p, q, note = pade_from_series(coeffs, m, n)
        ypad = Vector{Float64}(undef, length(xplot))

        for i in eachindex(xplot)
            z = xplot[i] - case.c
            den = poly_eval_asc(q, z)
            if abs(den) < 1e-8
                ypad[i] = NaN
            else
                ypad[i] = poly_eval_asc(p, z) / den
            end
        end

        # Limit off-scale values to one y-span beyond the axes, not to the axes,
        # so the curve leaves the frame instead of running along its edge.
        yspan = case.ylims[2] - case.ylims[1]
        ypad = clamp.(ypad, case.ylims[1] - yspan, case.ylims[2] + yspan)

        pplot = plot(size=(700, 520),
                     xlims=case.xlims, ylims=case.ylims,
                     xlabel="x", ylabel="y",
                     title="Pad\u00e9 Case $(case.id): f(x) = $(case.formula_label), x0 = $(round(case.c; digits=4))",
                     legend=:topleft, grid=true, framestyle=:box,
                     background_color=:white)

        plot!(pplot, xplot, ytrue; color=:magenta, lw=2.5, label="y = f(x) = $(case.formula_label)")
        plot!(pplot, xplot, ypad; color=:steelblue, lw=2.1, label="Pad\u00e9 [$(m)/$(n)]$(note)")

        if isfinite(yc)
            scatter!(pplot, [case.c], [yc]; color=:red, ms=5, label="")
        end

        frame(anim, pplot)
    end

    out_name = "pade$(case.id).gif"
    gif(anim, joinpath(@__DIR__, out_name); fps=2)
    println("Saved: " * out_name)
end

for case in cases
    render_case(case)
end

println("Generated $(length(cases)) GIFs.")
