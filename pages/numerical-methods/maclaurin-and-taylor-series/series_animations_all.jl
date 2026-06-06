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
    SeriesCase("m10", "Maclaurin", raw"e^{-x^2/2}", "exp(-x^2/2)", x -> exp(-x^2 / 2), 0.0, (-2.0, 3.0), (-1.0, 1.2), 12),
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
    SeriesCase("t08", "Taylor", raw"\Gamma(x)", "gamma(x)", x -> gamma(x), 2.0, (-0.2, 5.2), (-2.0, 30.0), 8),
    SeriesCase("t09", "Taylor", raw"\Gamma(x)", "gamma(x)", x -> gamma(x), 3.0, (-0.2, 5.2), (-2.0, 30.0), 8),
    SeriesCase("t10", "Taylor", raw"\Gamma(x)", "gamma(x)", x -> gamma(x), 4.0, (-0.2, 5.2), (-2.0, 40.0), 8),
    SeriesCase("t11", "Taylor", raw"J_0(x)", "besselj(0,x)", x -> besselj(0, x), 10.0, (0.0, 22.0), (-1.2, 1.2), 8),
    SeriesCase("t12", "Taylor", raw"J_1(x)", "besselj(1,x)", x -> besselj(1, x), 5.0, (0.0, 22.0), (-1.2, 1.2), 8),
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

function taylor_coeffs(f::Function, c::Float64, n::Int, xlims::Tuple{Float64, Float64})
    # Fit a local polynomial around c using nearby sample points.
    # This avoids deep AD recursion and is robust across special functions.
    need = n + 1
    q = max(n + 2, 8)
    tgrid = collect(-q:q)

    span = xlims[2] - xlims[1]
    h_by_span = max(1e-3, 0.03 * span)
    left_room = c - xlims[1]
    right_room = xlims[2] - c
    h_by_bounds = 0.95 * min(left_room, right_room) / max(q, 1)
    h = max(1e-6, min(h_by_span, h_by_bounds))

    # If center lies at or near a boundary, use a one-sided stencil.
    if left_room <= 1e-8
        tgrid = collect(0:(2q))
    elseif right_room <= 1e-8
        tgrid = collect((-2q):0)
    end

    xs = c .+ h .* tgrid
    ys = [safe_eval(f, x) for x in xs]

    keep = [i for i in eachindex(ys) if isfinite(ys[i])]
    if length(keep) < need
        # Shrink stencil repeatedly if needed.
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

    tt = Float64[tgrid[i] for i in keep]
    yy = Float64[ys[i] for i in keep]
    A = [t^k for t in tt, k in 0:n]
    a = A \ yy

    coeffs = zeros(Float64, n + 1)
    for k in 0:n
        coeffs[k + 1] = a[k + 1] / (h^k)
    end
    return coeffs
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
        for m in 0:div(n, 2)
            k = 2m
            a[k + 1] = (isodd(m) ? -1.0 : 1.0) / (2.0^m * factorial(m))
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
        return taylor_coeffs(case.f, case.c, n, case.xlims)
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

function render_case(case::SeriesCase)
    xplot = collect(range(case.xlims[1], case.xlims[2], length=900))
    ytrue = [safe_eval(case.f, x) for x in xplot]

    coeffs = case.family == "Maclaurin" ? maclaurin_coeffs(case) : taylor_coeffs(case.f, case.c, case.n_terms, case.xlims)

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

        plot!(p, xplot, ytrue; color=:magenta, lw=2.4, label="f(x)")
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
