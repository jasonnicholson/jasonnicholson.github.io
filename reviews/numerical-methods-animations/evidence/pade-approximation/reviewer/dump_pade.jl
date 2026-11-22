# pade_animations_all.jl
# Generate Padé approximation animations for legacy Mathews-style cases.
# Output GIFs are saved next to this script via @__DIR__.

#using Plots
using SpecialFunctions
using LinearAlgebra

#gr()

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
    PadeCase("01", raw"\sqrt{x}", "sqrt(x)", x -> sqrt(x), 1.0, (0.0, 10.5), (0.0, 3.5), 10),
    PadeCase("02", raw"\sqrt{x}", "sqrt(x)", x -> sqrt(x), 4.0, (0.0, 10.5), (0.0, 3.5), 10),
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
    end

    return series_coeffs_fit(case.f, c, n, case.xlims)
end

function series_coeffs_fit(f::Function, c::Float64, n::Int, xlims::Tuple{Float64, Float64})
    need = n + 1
    q = max(n + 6, 14)
    tgrid = collect(-q:q)

    local_scale = max(1.0, abs(c))
    h_by_local = 0.01 * local_scale
    left_room = c - xlims[1]
    right_room = xlims[2] - c
    h_by_bounds = 0.45 * min(left_room, right_room) / max(q, 1)
    h = max(1e-5, min(h_by_local, h_by_bounds))

    if left_room <= 1e-8
        tgrid = collect(0:(2q))
    elseif right_room <= 1e-8
        tgrid = collect((-2q):0)
    end

    xs = c .+ h .* tgrid
    ys = [safe_eval(f, x) for x in xs]

    keep = [i for i in eachindex(ys) if isfinite(ys[i])]
    if length(keep) < need
        for _ in 1:6
            h *= 0.5
            xs = c .+ h .* tgrid
            ys = [safe_eval(f, x) for x in xs]
            keep = [i for i in eachindex(ys) if isfinite(ys[i])]
            length(keep) >= need && break
        end
    end

    if length(keep) < need
        coeffs = zeros(Float64, n + 1)
        v0 = safe_eval(f, c)
        coeffs[1] = isfinite(v0) ? v0 : 0.0
        return coeffs
    end

    tt = BigFloat[tgrid[i] for i in keep]
    yy = BigFloat[ys[i] for i in keep]
    hb = BigFloat(h)
    A = [t^k for t in tt, k in 0:n]
    a = A \ yy

    coeffs = zeros(Float64, n + 1)
    for k in 0:n
        coeffs[k + 1] = Float64(a[k + 1] / (hb^k))
    end
    return coeffs
end

function poly_eval_asc(coeffs::Vector{Float64}, z::Float64)
    v = coeffs[end]
    for i in (length(coeffs) - 1):-1:1
        v = v * z + coeffs[i]
    end
    return v
end

function pade_from_series(a::Vector{Float64}, m::Int, n::Int)
    if n == 0
        return a[1:(m + 1)], [1.0]
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

    return p, q
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

# ---- reviewer dump ----
using Printf
open(joinpath(@__DIR__, "script_values.txt"), "w") do io
    for case in cases
        a = series_coeffs_analytic(case)
        which = (series_coeffs_analytic === nothing) ? "" : ""
        println(io, "CASE ", case.id, " c=", repr(case.c), " max_total=", case.max_total, " xlims=", case.xlims, " ylims=", case.ylims, " label=", case.formula_label)
        println(io, "A ", join([repr(x) for x in a], " "))
        for (m, n) in order_pairs(case.max_total)
            sing = false
            if n > 0
                B = zeros(n, n)
                for r in 1:n, j in 1:n
                    idx = m + r - j + 1
                    B[r, j] = idx >= 1 ? a[idx] : 0.0
                end
                rhs = [-a[m + r + 1] for r in 1:n]
                sing = try; B \ rhs; false; catch; true; end
            end
            p, q = pade_from_series(a, m, n)
            println(io, "PQ ", m, " ", n, " ", sing ? "PINV" : "LU", " P ", join([repr(x) for x in p], " "), " Q ", join([repr(x) for x in q], " "))
        end
    end
end
println("done")
