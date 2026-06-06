# laurent_animations_all.jl
# Generate Laurent-series truncation animations for the same 27 function cases as the Pade page.
# Output GIFs are saved next to this script via @__DIR__.

using Plots
using SpecialFunctions

gr()

struct LaurentCase
    id::String
    formula_label::String
    f::Function
    c::Float64
    xlims::Tuple{Float64, Float64}
    ylims::Tuple{Float64, Float64}
    max_order::Int
end

cases = LaurentCase[
    LaurentCase("01", "sqrt(x)", x -> sqrt(x), 1.0, (0.0, 10.5), (0.0, 3.5), 10),
    LaurentCase("02", "sqrt(x)", x -> sqrt(x), 4.0, (0.0, 10.5), (0.0, 3.5), 10),
    LaurentCase("03", "sqrt(x)", x -> sqrt(x), 5.0, (0.0, 10.5), (0.0, 3.5), 10),
    LaurentCase("04", "1/sqrt(1-x)", x -> 1 / sqrt(1 - x), 0.0, (-1.5, 1.5), (-1.0, 6.0), 10),
    LaurentCase("05", "log(x)", x -> log(x), 1.0, (-0.5, 4.1), (-6.0, 2.0), 10),
    LaurentCase("06", "log(x)", x -> log(x), 2.0, (-0.5, 4.1), (-6.0, 2.0), 10),
    LaurentCase("07", "log(1+x)", x -> log(1 + x), 0.0, (-1.5, 1.5), (-4.0, 2.0), 10),
    LaurentCase("08", "sin(x)", x -> sin(x), 0.0, (-3pi, 3pi), (-1.5, 1.5), 10),
    LaurentCase("09", "cos(x)", x -> cos(x), 0.0, (-3pi, 3pi), (-1.5, 1.5), 10),
    LaurentCase("10", "sin(x)", x -> sin(x), pi / 4, (-7pi / 4, 9pi / 4), (-1.5, 1.5), 10),
    LaurentCase("11", "cos(x)", x -> cos(x), pi / 3, (-5pi / 3, 7pi / 3), (-1.5, 1.5), 10),
    LaurentCase("12", "tan(x)", x -> tan(x), 0.0, (-pi, pi), (-10.0, 10.0), 8),
    LaurentCase("13", "exp(x)", x -> exp(x), 0.0, (-2.0, 3.0), (-1.0, 22.0), 10),
    LaurentCase("14", "exp(-x)*cos(x)", x -> exp(-x) * cos(x), 0.0, (-2.0, 4.0), (-4.0, 4.0), 10),
    LaurentCase("15", "cosh(x)", x -> cosh(x), 0.0, (-4.0, 4.0), (-1.0, 30.0), 10),
    LaurentCase("16", "atan(x)", x -> atan(x), 0.0, (-2.0, 2.0), (-2.0, 2.0), 10),
    LaurentCase("17", "asin(x)", x -> asin(x), 0.0, (-1.5, 1.5), (-2.0, 2.0), 8),
    LaurentCase("18", "besselj(0,x)", x -> besselj(0, x), 0.0, (-10.2, 10.2), (-1.5, 1.5), 10),
    LaurentCase("19", "besselj(1,x)", x -> besselj(1, x), 0.0, (-10.2, 10.2), (-1.5, 1.5), 10),
    LaurentCase("20", "normal_pdf(x)", x -> exp(-x^2 / 2) / sqrt(2pi), 0.0, (-3.0, 3.0), (-0.05, 0.45), 10),
    LaurentCase("21", "normal_cdf(x)", x -> 0.5 + 0.5 * erf(x / sqrt(2.0)), 0.0, (-3.0, 3.0), (-0.1, 1.1), 10),
    LaurentCase("22", "gamma(x)", x -> gamma(x), 1.0, (-0.2, 5.2), (-10.0, 35.0), 8),
    LaurentCase("23", "gamma(x)", x -> gamma(x), 2.0, (-0.2, 5.2), (-10.0, 35.0), 8),
    LaurentCase("24", "gamma(x)", x -> gamma(x), 3.0, (-0.2, 5.2), (-10.0, 45.0), 8),
    LaurentCase("25", "bessely(0,x)", x -> bessely(0, x), 10.0, (0.0, 22.0), (-2.0, 2.0), 8),
    LaurentCase("26", "bessely(0,x)", x -> bessely(0, x), 5.0, (0.0, 22.0), (-2.0, 2.0), 8),
    LaurentCase("27", "bessely(0,x)", x -> bessely(0, x), 2.0, (0.0, 22.0), (-2.0, 2.0), 8),
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

    tt = [tgrid[i] for i in keep]
    yy = [ys[i] for i in keep]
    A = [t^k for t in tt, k in 0:n]
    a = A \ yy

    coeffs = zeros(Float64, n + 1)
    for k in 0:n
        coeffs[k + 1] = a[k + 1] / (h^k)
    end
    return coeffs
end

function series_coeffs(case::LaurentCase)
    n = case.max_order
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

function poly_eval_asc(coeffs::Vector{Float64}, z::Float64)
    v = coeffs[end]
    for i in (length(coeffs) - 1):-1:1
        v = v * z + coeffs[i]
    end
    return v
end

function render_case(case::LaurentCase)
    xplot = collect(range(case.xlims[1], case.xlims[2], length=900))
    ytrue = [safe_eval(case.f, x) for x in xplot]
    ytrue = [isfinite(y) ? clamp(y, case.ylims[1], case.ylims[2]) : NaN for y in ytrue]

    coeffs = series_coeffs(case)
    yc = safe_eval(case.f, case.c)
    anim = Animation()

    for n in 1:case.max_order
        exps = -n:n
        ylaur = Vector{Float64}(undef, length(xplot))

        for i in eachindex(xplot)
            z = xplot[i] - case.c
            # For these reused Padé centers, f is regular at x0, so the
            # principal part vanishes and negative-power Laurent terms are zero.
            ylaur[i] = poly_eval_asc(coeffs[1:(n + 1)], z)
        end
        ylaur = [isfinite(y) ? clamp(y, case.ylims[1], case.ylims[2]) : NaN for y in ylaur]

        pplot = plot(size=(700, 520),
                     xlims=case.xlims, ylims=case.ylims,
                     xlabel="x", ylabel="y",
                     title="Laurent Case $(case.id): f(x) = $(case.formula_label), x0 = $(round(case.c; digits=4))",
                     legend=:topleft, grid=true, framestyle=:box,
                     background_color=:white)

        plot!(pplot, xplot, ytrue; color=:magenta, lw=2.5, label="y = f(x)")
          plot!(pplot, xplot, ylaur; color=:steelblue, lw=2.1,
              label="Laurent orders $(first(exps))..$(last(exps))")

        vline!(pplot, [case.c]; color=:gray50, lw=1.0, ls=:dash, label="")

        if isfinite(yc)
            scatter!(pplot, [case.c], [yc]; color=:red, ms=5, label="")
        end

        frame(anim, pplot)
    end

    out_name = "laurent$(case.id).gif"
    gif(anim, joinpath(@__DIR__, out_name); fps=2)
    println("Saved: " * out_name)
end

for case in cases
    render_case(case)
end

println("Generated $(length(cases)) GIFs.")
