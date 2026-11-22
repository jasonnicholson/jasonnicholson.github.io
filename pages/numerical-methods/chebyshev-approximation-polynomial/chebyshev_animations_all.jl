# chebyshev_animations_all.jl
# Generate Chebyshev-node interpolation animations for cases 01..29.
# Output GIFs are saved next to this script via @__DIR__.

using Plots
using SpecialFunctions

gr()

struct ChebyCase
    id::String
    formula_label::String
    f::Function
    xlims::Tuple{Float64, Float64}
    node_span::Tuple{Float64, Float64}
    has_span::Bool
    max_order::Int
    ylims_from_span::Bool
    poles::Vector{Float64}     # poles of f inside the plotting window (f is broken there)
end

with_span(id, label, f, xlims, span; max_order=15, ylims_from_span=false, poles=Float64[]) =
    ChebyCase(id, label, f, xlims, span, true, max_order, ylims_from_span, poles)
auto_span(id, label, f, xlims; max_order=15) =
    ChebyCase(id, label, f, xlims, (0.0, 0.0), false, max_order, false, Float64[])

cases = ChebyCase[
    with_span("01", "1/(1-x)", x -> 1 / (1 - x), (-1.6, 1.5), (-1.6, 0.9); poles=[1.0]),
    with_span("02", "1/(1+x)", x -> 1 / (1 + x), (-1.5, 1.6), (-0.9, 1.5); poles=[-1.0]),
    with_span("03", "1/(1-x)^2", x -> 1 / (1 - x)^2, (-1.6, 1.5), (-1.5, 0.8); ylims_from_span=true),
    with_span("04", "sqrt(x)", x -> sqrt(x), (0.0, 10.5), (0.0, 2.0)),
    with_span("05", "sqrt(x)", x -> sqrt(x), (0.0, 10.5), (0.0, 8.0)),
    with_span("06", "sqrt(x)", x -> sqrt(x), (0.0, 10.5), (0.0, 10.0)),
    with_span("07", "1/sqrt(1-x)", x -> 1 / sqrt(1 - x), (-1.6, 1.5), (-1.6, 0.9)),
    with_span("08", "1/(1+10x^2)", x -> 1 / (1 + 10x^2), (-1.5, 1.5), (-1.0, 1.0); max_order=31),
    with_span("09", "log(x)", x -> log(x), (-0.5, 4.1), (0.02, 2.0)),
    with_span("10", "log(x)", x -> log(x), (-0.5, 4.1), (0.02, 4.0)),
    with_span("11", "log(1+x)", x -> log(1 + x), (-1.5, 1.5), (-0.98, 1.0)),
    auto_span("12", "sin(x)", x -> sin(x), (-3pi, 3pi)),
    auto_span("13", "cos(x)", x -> cos(x), (-3pi, 3pi)),
    with_span("14", "tan(x)", x -> tan(x), (-pi, pi), (-1.45, 1.45); poles=[-pi / 2, pi / 2]),
    auto_span("15", "exp(x)", x -> exp(x), (-2.0, 3.0)),
    auto_span("16", "cos(x)*exp(-x)", x -> cos(x) * exp(-x), (-2.0, 4.0)),
    auto_span("17", "cosh(x)", x -> cosh(x), (-4.0, 4.0)),
    auto_span("18", "atan(x)", x -> atan(x), (-2.2, 2.2)),
    with_span("19", "asin(x)", x -> asin(x), (-1.5, 1.5), (-1.0, 1.0)),
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

function finite_support(case::ChebyCase)
    xs = collect(range(case.xlims[1], case.xlims[2], length=2200))
    ys = [safe_eval(case.f, x) for x in xs]
    keep = [i for i in eachindex(ys) if isfinite(ys[i])]
    if isempty(keep)
        return case.xlims
    end
    return (xs[first(keep)], xs[last(keep)])
end

function resolved_span(case::ChebyCase)
    # An explicit node interval is used as given (chebyshev_nodes checks that f is
    # finite at every node); only cases without one fall back to the finite support
    # of f on the plotting grid.
    case.has_span && return case.node_span
    return finite_support(case)
end

function chebyshev_nodes(f::Function, span::Tuple{Float64, Float64}, n_nodes::Int)
    a, b = span
    width = b - a
    for attempt in 0:8
        trim = width * 0.01 * attempt
        aa = a + trim
        bb = b - trim
        bb <= aa && continue

        center = 0.5 * (aa + bb)
        radius = 0.5 * (bb - aa)
        xs = [center + radius * cos((2k - 1) * pi / (2n_nodes)) for k in 1:n_nodes]
        sort!(xs)
        ys = [safe_eval(f, x) for x in xs]

        if all(isfinite, ys)
            return xs, ys
        end
    end
    error("Could not build finite Chebyshev nodes")
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

    # Outside the nodes (extrapolation) the denominator of the second barycentric form
    # below cancels badly; the first form l(x) * sum_j w_j y_j / (x - x_j), with
    # l(x) = prod_j (x - x_j), stays accurate there.
    if x < minimum(xs) || x > maximum(xs)
        l = prod(x - xj for xj in xs)
        return l * sum(w[j] * ys[j] / (x - xs[j]) for j in eachindex(xs))
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

# Widen the quantile window so that f over the whole approximation interval, and
# therefore every node, lies inside it.
function window_ylims(case::ChebyCase, span::Tuple{Float64, Float64}, ytrue::Vector{Float64})
    lo, hi = robust_ylims(ytrue)
    fspan = [safe_eval(case.f, x) for x in range(span[1], span[2], length=2001)]
    fspan = [v for v in fspan if isfinite(v)]
    flo, fhi = extrema(fspan)
    pad = 0.05 * (max(hi, fhi) - min(lo, flo))
    return (min(lo, flo - pad), max(hi, fhi + pad))
end

function node_count_sequence(max_order::Int)
    nmax = max_order + 1
    base = [2, 3, 4, 5, 6, 8, 10, 12, 14, 16]

    if nmax <= last(base)
        seq = [n for n in base if n <= nmax]
        if isempty(seq)
            return [2]
        end
        if last(seq) != nmax
            push!(seq, nmax)
        end
        return sort(unique(seq))
    end

    seq = vcat(base, [20, 24, 28, nmax])
    seq = sort(unique([n for n in seq if n <= nmax]))
    if last(seq) != nmax
        push!(seq, nmax)
    end
    return sort(unique(seq))
end

fmt_num(x::Float64) = abs(x - round(x)) < 1e-9 ? string(Int(round(x))) : string(round(x; digits=3))

function render_case(case::ChebyCase)
    xplot = collect(range(case.xlims[1], case.xlims[2], length=1000))
    ytrue = [safe_eval(case.f, x) for x in xplot]

    span = resolved_span(case)
    n_nodes_seq = node_count_sequence(case.max_order)
    n_min = first(n_nodes_seq)
    n_max = last(n_nodes_seq)

    xs_lo, ys_lo = chebyshev_nodes(case.f, span, n_min)
    w_lo = barycentric_weights(xs_lo)
    y_lo = [barycentric_eval(x, xs_lo, ys_lo, w_lo) for x in xplot]

    xs_hi, ys_hi = chebyshev_nodes(case.f, span, n_max)
    w_hi = barycentric_weights(xs_hi)
    y_hi = [barycentric_eval(x, xs_hi, ys_hi, w_hi) for x in xplot]

    # Keep axis limits tied to the target function so extreme polynomial blow-up
    # does not collapse the visual dynamic range. Curves are clamped only to a band
    # one window-height beyond the limits, so where they leave the window they run
    # off the frame instead of along its edge. In cases with poles (01, 02, 14) f is
    # not clamped: it is drawn with a NaN point at each pole, so the curve breaks
    # there and runs off the window instead of joining its two branches.
    # With ylims_from_span (case 03) the quantile window is taken from f on the
    # approximation interval only, so the pole inside the plotting window does not
    # set the y-range.
    yref = case.ylims_from_span ? [safe_eval(case.f, x) for x in range(span[1], span[2], length=1000)] : ytrue
    ylims = window_ylims(case, span, yref)
    band = (ylims[1] - (ylims[2] - ylims[1]), ylims[2] + (ylims[2] - ylims[1]))
    ytrue_clip = [isfinite(y) ? clamp(y, band[1], band[2]) : NaN for y in ytrue]
    xf, yf = xplot, ytrue_clip
    if !isempty(case.poles)
        xf = sort(vcat(xplot, case.poles))
        yf = [x in case.poles ? NaN : safe_eval(case.f, x) for x in xf]
    end

    anim = Animation()
    for n_nodes in n_nodes_seq
        xs, ys_nodes = chebyshev_nodes(case.f, span, n_nodes)
        w = barycentric_weights(xs)
        yinterp = [barycentric_eval(x, xs, ys_nodes, w) for x in xplot]
        yinterp = clamp.(yinterp, band[1], band[2])

        pplot = plot(size=(760, 520),
                     xlims=case.xlims, ylims=ylims,
                     xlabel="x", ylabel="y",
                     title="Chebyshev Case $(case.id): f(x) = $(case.formula_label)\ninterval [$(fmt_num(span[1])), $(fmt_num(span[2]))], n = $(n_nodes) nodes, degree ≤ $(n_nodes - 1)",
                     legend=:outerbottom, legend_columns=3, grid=true, framestyle=:box,
                     background_color=:white, top_margin=3Plots.mm)

        plot!(pplot, xf, yf; color=:magenta, lw=2.5, label="f(x)")
        plot!(pplot, xplot, yinterp; color=:steelblue, lw=2.2, label="interpolant")
        scatter!(pplot, xs, ys_nodes; color=:red, ms=4.5, label="nodes")

        frame(anim, pplot)
    end

    out_name = "cheby$(case.id).gif"
    gif(anim, joinpath(@__DIR__, out_name); fps=2)
    println("Saved: " * out_name)
end

for case in cases
    render_case(case)
end

println("Generated $(length(cases)) GIFs.")
