# series_animations_all.jl
# Generate all Maclaurin (18) and Taylor (13) GIF animations in one run.
# Output GIFs are saved next to this script via @__DIR__.

using Plots
using SpecialFunctions

gr()

struct SeriesCase
    id::String
    family::String
    formula_tex::String
    formula_label::String
    f::Function
    c::Float64
    xlims::Tuple{Float64, Float64}
    ylims::Tuple{Float64, Float64}
    n_terms::Int
end

cases = SeriesCase[
    # --- Maclaurin cases (18) ---
    SeriesCase("m01", "Maclaurin", raw"\frac{1}{1-x}", "1/(1-x)", x -> 1 / (1 - x), 0.0, (-1.5, 1.5), (-6.0, 6.0), 12),
    SeriesCase("m02", "Maclaurin", raw"\frac{1}{1+x}", "1/(1+x)", x -> 1 / (1 + x), 0.0, (-1.5, 1.5), (-6.0, 6.0), 12),
    SeriesCase("m03", "Maclaurin", raw"\frac{1}{(1-x)^2}", "1/(1-x)^2", x -> 1 / (1 - x)^2, 0.0, (-1.5, 1.5), (-1.0, 10.0), 12),
    SeriesCase("m04", "Maclaurin", raw"\frac{1}{\sqrt{1-x}}", "1/sqrt(1-x)", x -> 1 / sqrt(1 - x), 0.0, (-1.5, 1.5), (-1.0, 6.0), 12),
    SeriesCase("m05", "Maclaurin", raw"\frac{1}{1+x^2}", "1/(1+x^2)", x -> 1 / (1 + x^2), 0.0, (-1.5, 1.5), (-0.2, 1.2), 12),
    SeriesCase("m06", "Maclaurin", raw"\log(1+x)", "log(1+x)", x -> log(1 + x), 0.0, (-1.5, 1.5), (-4.0, 2.0), 12),
    SeriesCase("m07", "Maclaurin", raw"\sin(x)", "sin(x)", x -> sin(x), 0.0, (-3pi, 3pi), (-1.5, 1.5), 12),
    SeriesCase("m08", "Maclaurin", raw"\cos(x)", "cos(x)", x -> cos(x), 0.0, (-3pi, 3pi), (-1.5, 1.5), 12),
    SeriesCase("m09", "Maclaurin", raw"\tan(x)", "tan(x)", x -> tan(x), 0.0, (-pi, pi), (-6.0, 6.0), 11),
    SeriesCase("m10", "Maclaurin", raw"e^{x}", "exp(x)", x -> exp(x), 0.0, (-2.0, 3.0), (-2.0, 21.0), 12),
    SeriesCase("m11", "Maclaurin", raw"e^{-x}\cos(x)", "exp(-x)*cos(x)", x -> exp(-x) * cos(x), 0.0, (-2.0, 4.0), (-4.0, 4.0), 12),
    SeriesCase("m12", "Maclaurin", raw"\cosh(x)", "cosh(x)", x -> cosh(x), 0.0, (-4.0, 4.0), (-1.0, 30.0), 12),
    SeriesCase("m13", "Maclaurin", raw"\arctan(x)", "atan(x)", x -> atan(x), 0.0, (-2.0, 2.0), (-2.0, 2.0), 12),
    SeriesCase("m14", "Maclaurin", raw"\arcsin(x)", "asin(x)", x -> asin(x), 0.0, (-1.5, 1.5), (-2.0, 2.0), 12),
    SeriesCase("m15", "Maclaurin", raw"J_0(x)", "besselj(0,x)", x -> besselj(0, x), 0.0, (-10.2, 10.2), (-1.5, 1.5), 10),
    SeriesCase("m16", "Maclaurin", raw"J_1(x)", "besselj(1,x)", x -> besselj(1, x), 0.0, (-10.2, 10.2), (-1.5, 1.5), 10),
    SeriesCase("m17", "Maclaurin", raw"\frac{1}{\sqrt{2\pi}}e^{-x^2/2}", "normal_pdf(x)", x -> exp(-x^2 / 2) / sqrt(2pi), 0.0, (-3.0, 3.0), (-0.05, 0.45), 10),
    SeriesCase("m18", "Maclaurin", raw"\frac{1}{2}+\frac{1}{2}\operatorname{erf}\!\left(\frac{x}{\sqrt{2}}\right)", "normal_cdf(x)", x -> 0.5 + 0.5 * erf(x / sqrt(2.0)), 0.0, (-3.0, 3.0), (-0.1, 1.1), 10),

    # --- Taylor cases (13) ---
    SeriesCase("t01", "Taylor", raw"\sqrt{x}", "sqrt(x)", x -> sqrt(x), 1.0, (0.0, 10.5), (-0.2, 3.5), 10),
    SeriesCase("t02", "Taylor", raw"\sqrt{x}", "sqrt(x)", x -> sqrt(x), 4.0, (0.0, 10.5), (-0.2, 3.5), 10),
    SeriesCase("t03", "Taylor", raw"\sqrt{x}", "sqrt(x)", x -> sqrt(x), 5.0, (0.0, 10.5), (-0.2, 3.5), 10),
    SeriesCase("t04", "Taylor", raw"\log(x)", "log(x)", x -> log(x), 1.0, (-0.5, 4.1), (-4.0, 2.0), 10),
    SeriesCase("t05", "Taylor", raw"\log(x)", "log(x)", x -> log(x), 2.0, (-0.5, 4.1), (-4.0, 2.0), 10),
    SeriesCase("t06", "Taylor", raw"\sin(x)", "sin(x)", x -> sin(x), pi / 4, (-7pi / 4, 9pi / 4), (-1.5, 1.5), 10),
    SeriesCase("t07", "Taylor", raw"\cos(x)", "cos(x)", x -> cos(x), pi / 3, (-5pi / 3, 7pi / 3), (-1.5, 1.5), 10),
    SeriesCase("t08", "Taylor", raw"\Gamma(x)", "gamma(x)", x -> gamma(x), 1.0, (-0.2, 5.2), (-2.0, 30.0), 8),
    SeriesCase("t09", "Taylor", raw"\Gamma(x)", "gamma(x)", x -> gamma(x), 2.0, (-0.2, 5.2), (-2.0, 30.0), 8),
    SeriesCase("t10", "Taylor", raw"\Gamma(x)", "gamma(x)", x -> gamma(x), 3.0, (-0.2, 5.2), (-2.0, 40.0), 8),
    SeriesCase("t11", "Taylor", raw"Y_0(x)", "bessely(0,x)", x -> bessely(0, x), 10.0, (0.0, 22.0), (-1.2, 1.2), 8),
    SeriesCase("t12", "Taylor", raw"Y_0(x)", "bessely(0,x)", x -> bessely(0, x), 5.0, (0.0, 22.0), (-1.2, 1.2), 8),
    SeriesCase("t13", "Taylor", raw"Y_0(x)", "bessely(0,x)", x -> bessely(0, x), 2.0, (0.0, 22.0), (-1.2, 1.2), 8)
]

function safe_eval(f::Function, x::Float64)
    try
        y = f(x)
        return isfinite(y) ? y : NaN
    catch
        return NaN
    end
end

# Exact Taylor coefficients, correctly rounded to Float64 (same routine as the Padé approximation page).
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

# Taylor (x0 != 0) cases: function family for taylor_coeffs_exact, and nu for Bessel cases.
const taylor_family = Dict(
    "t01" => (:sqrt, 0), "t02" => (:sqrt, 0), "t03" => (:sqrt, 0),
    "t04" => (:log, 0), "t05" => (:log, 0),
    "t06" => (:sin, 0), "t07" => (:cos, 0),
    "t08" => (:gamma, 0), "t09" => (:gamma, 0), "t10" => (:gamma, 0),
    "t11" => (:bessely, 0), "t12" => (:bessely, 0), "t13" => (:bessely, 0),
)

function taylor_case_coeffs(case::SeriesCase)
    haskey(taylor_family, case.id) || error("no Taylor coefficients for case $(case.id)")
    fam, nu = taylor_family[case.id]
    return taylor_coeffs_exact(fam, case.c, case.n_terms; nu=nu)
end

function maclaurin_coeffs(case::SeriesCase)
    n = case.n_terms
    a = zeros(Float64, n + 1)

    if case.id == "m01"
        for k in 0:n
            a[k + 1] = 1.0
        end
    elseif case.id == "m02"
        for k in 0:n
            a[k + 1] = isodd(k) ? -1.0 : 1.0
        end
    elseif case.id == "m03"
        for k in 0:n
            a[k + 1] = k + 1
        end
    elseif case.id == "m04"
        for k in 0:n
            a[k + 1] = binomial(2k, k) / (4.0^k)
        end
    elseif case.id == "m05"
        for m in 0:div(n, 2)
            k = 2m
            a[k + 1] = isodd(m) ? -1.0 : 1.0
        end
    elseif case.id == "m06"
        a[1] = 0.0
        for k in 1:n
            a[k + 1] = (isodd(k) ? 1.0 : -1.0) / k
        end
    elseif case.id == "m07"
        for m in 0:div(n - 1, 2)
            k = 2m + 1
            a[k + 1] = (isodd(m) ? -1.0 : 1.0) / factorial(k)
        end
    elseif case.id == "m08"
        for m in 0:div(n, 2)
            k = 2m
            a[k + 1] = (isodd(m) ? -1.0 : 1.0) / factorial(k)
        end
    elseif case.id == "m09"
        # tan(x) coefficients through x^11
        tan_coeff = Dict(
            1 => 1.0,
            3 => 1.0 / 3.0,
            5 => 2.0 / 15.0,
            7 => 17.0 / 315.0,
            9 => 62.0 / 2835.0,
            11 => 1382.0 / 155925.0,
        )
        for (k, v) in tan_coeff
            if k <= n
                a[k + 1] = v
            end
        end
    elseif case.id == "m10"
        for k in 0:n
            a[k + 1] = 1.0 / factorial(k)
        end
    elseif case.id == "m11"
        z = complex(-1.0, 1.0)
        for k in 0:n
            a[k + 1] = real(z^k) / factorial(k)
        end
    elseif case.id == "m12"
        for m in 0:div(n, 2)
            k = 2m
            a[k + 1] = 1.0 / factorial(k)
        end
    elseif case.id == "m13"
        for m in 0:div(n - 1, 2)
            k = 2m + 1
            a[k + 1] = (isodd(m) ? -1.0 : 1.0) / k
        end
    elseif case.id == "m14"
        for m in 0:div(n - 1, 2)
            k = 2m + 1
            a[k + 1] = factorial(2m) / (4.0^m * factorial(m)^2 * (2m + 1))
        end
    elseif case.id == "m15"
        for m in 0:div(n, 2)
            k = 2m
            a[k + 1] = (isodd(m) ? -1.0 : 1.0) / (4.0^m * factorial(m)^2)
        end
    elseif case.id == "m16"
        for m in 0:div(n - 1, 2)
            k = 2m + 1
            a[k + 1] = (isodd(m) ? -1.0 : 1.0) / (2.0^(2m + 1) * factorial(m) * factorial(m + 1))
        end
    elseif case.id == "m17"
        c0 = 1.0 / sqrt(2pi)
        for m in 0:div(n, 2)
            k = 2m
            a[k + 1] = c0 * (isodd(m) ? -1.0 : 1.0) / (2.0^m * factorial(m))
        end
    elseif case.id == "m18"
        a[1] = 0.5
        c0 = 1.0 / sqrt(2pi)
        for m in 0:div(n - 1, 2)
            k = 2m + 1
            a[k + 1] = c0 * (isodd(m) ? -1.0 : 1.0) / (2.0^m * factorial(m) * (2m + 1))
        end
    else
        error("no Maclaurin coefficients for case $(case.id)")
    end

    return a
end

function partial_sum(coeffs::Vector{Float64}, c::Float64, x::Float64, n::Int)
    dx = x - c
    s = coeffs[1]
    p = 1.0
    for k in 1:n
        p *= dx
        s += coeffs[k + 1] * p
    end
    return s
end

# Break the f(x) line between adjacent samples that jump from beyond one y-limit to beyond
# the other (a pole lies between them), so no vertical segment is drawn through the pole.
function break_at_poles(x::Vector{Float64}, y::Vector{Float64}, ylims::Tuple{Float64, Float64})
    lo, hi = ylims
    xs, ys = Float64[], Float64[]
    for i in eachindex(x)
        if i > 1 && isfinite(y[i - 1]) && isfinite(y[i]) &&
           ((y[i - 1] > hi && y[i] < lo) || (y[i - 1] < lo && y[i] > hi))
            push!(xs, (x[i - 1] + x[i]) / 2)
            push!(ys, NaN)
        end
        push!(xs, x[i])
        push!(ys, y[i])
    end
    return xs, ys
end

function render_case(case::SeriesCase)
    xplot = collect(range(case.xlims[1], case.xlims[2], length=900))
    ytrue = [safe_eval(case.f, x) for x in xplot]
    xtrue, ytrue_plot = break_at_poles(xplot, ytrue, case.ylims)

    coeffs = case.family == "Maclaurin" ? maclaurin_coeffs(case) : taylor_case_coeffs(case)

    sums = [[partial_sum(coeffs, case.c, x, k) for x in xplot] for k in 0:case.n_terms]
    sums = [clamp.(ys, case.ylims[1], case.ylims[2]) for ys in sums]

    # MATLAB-like frame cadence: one discrete frame per order, slower playback.
    fps = 1

    yc = safe_eval(case.f, case.c)
    anim = Animation()

    function draw_frame(y_prev::Vector{Float64}, y_cur::Vector{Float64}, order_text::String)
        title_str = "$(case.family) $(uppercase(case.id)): f(x) = $(case.formula_label), x0 = $(round(case.c; digits=4))"
        p = plot(size=(700, 520),
                 xlims=case.xlims, ylims=case.ylims,
                 xlabel="x", ylabel="y", title=title_str,
                 legend=:topleft, grid=true, framestyle=:box,
                 background_color=:white)

        plot!(p, xtrue, ytrue_plot; color=:magenta, lw=2.4, label="f(x)")
        plot!(p, xplot, y_prev; color=:gray55, lw=1.6, alpha=0.65, label="previous order")
        plot!(p, xplot, y_cur; color=:steelblue, lw=2.4, alpha=1.0, label="current order")

        if isfinite(yc)
            scatter!(p, [case.c], [yc]; color=:red, ms=6, label="")
        end

        annotate!(p,
                  case.xlims[1] + 0.05 * (case.xlims[2] - case.xlims[1]),
                  case.ylims[1] + 0.06 * (case.ylims[2] - case.ylims[1]),
                  text(order_text, :black, 10))

        frame(anim, p)
    end

    for k in 0:case.n_terms
        y_prev = k == 0 ? sums[1] : sums[k]
        y_cur = sums[k + 1]
        draw_frame(y_prev, y_cur, "order = $(k)")
    end

    out_name = "series_$(case.id).gif"
    gif(anim, joinpath(@__DIR__, out_name); fps=fps)
    println("Saved: " * out_name)
end

for case in cases
    render_case(case)
end

println("Generated $(length(cases)) GIFs.")
