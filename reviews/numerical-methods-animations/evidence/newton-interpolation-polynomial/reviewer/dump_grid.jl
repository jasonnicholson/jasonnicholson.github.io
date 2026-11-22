# lagnewt_animations_all.jl
# Generate shared interpolation animations for Lagrange/Newton pages (cases 01..29).
# Output GIFs are saved next to this script via @__DIR__.

using Plots
using SpecialFunctions

gr()

struct InterpCase
    id::String
    formula_label::String
    f::Function
    xlims::Tuple{Float64, Float64}
    node_span::Tuple{Float64, Float64}
    has_span::Bool
end

with_span(id, label, f, xlims, span) = InterpCase(id, label, f, xlims, span, true)
auto_span(id, label, f, xlims) = InterpCase(id, label, f, xlims, (0.0, 0.0), false)

cases = InterpCase[
    with_span("01", "1/(1-x)", x -> 1 / (1 - x), (-1.6, 0.9), (-1.6, 0.9)),
    with_span("02", "1/(1+x)", x -> 1 / (1 + x), (-0.9, 1.6), (-0.9, 1.6)),
    with_span("03", "1/(1-x)^2", x -> 1 / (1 - x)^2, (-1.6, 0.9), (-1.6, 0.9)),
    with_span("04", "sqrt(x)", x -> sqrt(x), (0.0, 10.5), (0.0, 2.0)),
    with_span("05", "sqrt(x)", x -> sqrt(x), (0.0, 10.5), (0.0, 8.0)),
    with_span("06", "sqrt(x)", x -> sqrt(x), (0.0, 10.5), (0.0, 10.0)),
    with_span("07", "1/sqrt(1-x)", x -> 1 / sqrt(1 - x), (-1.6, 0.9), (-1.6, 0.9)),
    with_span("08", "1/(1+10x^2)", x -> 1 / (1 + 10x^2), (-1.5, 1.5), (-1.0, 1.0)),
    with_span("09", "log(x)", x -> log(x), (-0.5, 4.1), (0.02, 2.0)),
    with_span("10", "log(x)", x -> log(x), (-0.5, 4.1), (0.02, 4.0)),
    with_span("11", "log(1+x)", x -> log(1 + x), (-1.5, 1.5), (-0.98, 1.0)),
    auto_span("12", "sin(x)", x -> sin(x), (-3pi, 3pi)),
    auto_span("13", "cos(x)", x -> cos(x), (-3pi, 3pi)),
    auto_span("14", "tan(x)", x -> tan(x), (-pi, pi)),
    auto_span("15", "exp(x)", x -> exp(x), (-2.0, 3.0)),
    auto_span("16", "cos(x)*exp(-x)", x -> cos(x) * exp(-x), (-2.0, 4.0)),
    auto_span("17", "cosh(x)", x -> cosh(x), (-4.0, 4.0)),
    auto_span("18", "atan(x)", x -> atan(x), (-2.2, 2.2)),
    auto_span("19", "asin(x)", x -> asin(x), (-1.5, 1.5)),
    auto_span("20", "besselj(0,x)", x -> besselj(0, x), (-10.2, 10.2)),
    auto_span("21", "besselj(1,x)", x -> besselj(1, x), (-10.2, 10.2)),
    auto_span("22", "normal_pdf(x)", x -> exp(-x^2 / 2) / sqrt(2pi), (-3.0, 3.0)),
    auto_span("23", "normal_cdf(x)", x -> 0.5 + 0.5 * erf(x / sqrt(2.0)), (-3.0, 3.0)),
    with_span("24", "gamma(x)", x -> gamma(x), (-0.2, 5.2), (0.05, 2.0)),
    with_span("25", "gamma(x)", x -> gamma(x), (-0.2, 5.2), (0.05, 4.0)),
    with_span("26", "gamma(x)", x -> gamma(x), (-0.2, 5.2), (0.5, 5.0)),
    with_span("27", "bessely(0,x)", x -> bessely(0, x), (0.0, 22.0), (0.5, 20.0)),
    with_span("28", "bessely(0,x)", x -> bessely(0, x), (0.0, 22.0), (0.5, 10.0)),
    with_span("29", "bessely(0,x)", x -> bessely(0, x), (0.0, 22.0), (0.5, 4.0)),
]

function safe_eval(f::Function, x::Float64)
    try
        y = f(x)
        return isfinite(y) ? y : NaN
    catch
        return NaN
    end
end

function finite_support(case::InterpCase)
    xs = collect(range(case.xlims[1], case.xlims[2], length=2200))
    ys = [safe_eval(case.f, x) for x in xs]
    keep = [i for i in eachindex(ys) if isfinite(ys[i])]
    if isempty(keep)
        return case.xlims
    end
    return (xs[first(keep)], xs[last(keep)])
end

function resolved_span(case::InterpCase)
    s = finite_support(case)
    if case.has_span
        a = max(case.node_span[1], s[1])
        b = min(case.node_span[2], s[2])
        if b > a + 1e-8
            return (a, b)
        end
    end
    return s
end

function equal_nodes(f::Function, span::Tuple{Float64, Float64}, n_nodes::Int)
    a, b = span
    width = b - a
    for attempt in 0:8
        # Keep equally-spaced nodes slightly inside the interval so the first
        # few frames do not pin a node at near-singular endpoints.
        trim = width * (0.03 + 0.01 * attempt)
        aa = a + trim
        bb = b - trim
        bb <= aa && continue
        xs = collect(range(aa, bb, length=n_nodes))
        ys = [safe_eval(f, x) for x in xs]
        if all(isfinite, ys)
            return xs, ys
        end
    end
    error("Could not build finite equally-spaced nodes")
end

function barycentric_weights(xs::Vector{Float64})
    n = length(xs)
    w = ones(Float64, n)
    for j in 1:n
        for k in 1:n
            j == k && continue
            w[j] /= (xs[j] - xs[k])
        end
    end
    return w
end

function barycentric_eval(x::Float64, xs::Vector{Float64}, ys::Vector{Float64}, w::Vector{Float64})
    for j in eachindex(xs)
        if abs(x - xs[j]) <= 1e-12
            return ys[j]
        end
    end

    num = 0.0
    den = 0.0
    for j in eachindex(xs)
        t = w[j] / (x - xs[j])
        num += t * ys[j]
        den += t
    end
    return num / den
end

function robust_ylims(vals::Vector{Float64})
    fvals = sort([v for v in vals if isfinite(v)])
    if length(fvals) < 8
        return (-1.0, 1.0)
    end

    n = length(fvals)
    i_lo = clamp(floor(Int, 0.03 * n), 1, n)
    i_hi = clamp(ceil(Int, 0.97 * n), 1, n)
    lo = fvals[i_lo]
    hi = fvals[i_hi]

    if hi <= lo
        c = fvals[clamp(div(n, 2), 1, n)]
        return (c - 1.0, c + 1.0)
    end

    margin = 0.15 * (hi - lo)
    return (lo - margin, hi + margin)
end
# reviewer: dump full plot-grid interpolant (unclamped) per case/degree
open(joinpath(@__DIR__, "lagnewt_grid.txt"), "w") do io
for case in cases
    xplot = collect(range(case.xlims[1], case.xlims[2], length=1000))
    ytrue = [safe_eval(case.f, x) for x in xplot]
    span = resolved_span(case)
    xs_lo, ys_lo = equal_nodes(case.f, span, 2); xs_hi, ys_hi = equal_nodes(case.f, span, 16)
    ylims_f = robust_ylims(ytrue); ynode = vcat(ys_lo, ys_hi)
    lo = min(ylims_f[1], minimum(ynode)); hi = max(ylims_f[2], maximum(ynode)); m = 0.12*max(hi-lo,1e-9)
    println(io, "CASE ", case.id, " ", case.formula_label, " ", lo-m, " ", hi+m)
    for n in [2,3,4,5,6,8,10,12,14,16]
        xs, ys = equal_nodes(case.f, span, n); w = barycentric_weights(xs)
        println(io, "N ", n, " ", join(string.(xs), ","), " ", join(string.(ys), ","))
        println(io, join(string.([barycentric_eval(x, xs, ys, w) for x in xplot]), ","))
        println(io, join(string.(xplot), ","))
    end
end
end
