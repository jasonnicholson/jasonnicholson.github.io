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
    poles::Vector{Float64}  # poles of f inside the window (empty if none)
    legend::Symbol
end

with_span(id, label, f, xlims, span; poles=Float64[], legend=:topleft) =
    InterpCase(id, label, f, xlims, span, true, poles, legend)
auto_span(id, label, f, xlims) = InterpCase(id, label, f, xlims, (0.0, 0.0), false, Float64[], :topleft)

cases = InterpCase[
    # Cases 01-03 and 07 use Mathews' plot windows, which run past the
    # singularity of f at x = 1 (x = -1 in Case 02).
    # Nodes: 01 as in his animation; 02 mirrors 01; 03 as 01; 07 as in his
    # static example linked to animation 7.
    # For 01-03 and 14 (poles given) the y-limits come from f on the node
    # interval, and f is broken at each pole and left to run off the window.
    with_span("01", "1/(1-x)", x -> 1 / (1 - x), (-1.6, 1.5), (-1.5, 0.9); poles=[1.0]),
    with_span("02", "1/(1+x)", x -> 1 / (1 + x), (-1.5, 1.6), (-0.9, 1.5); poles=[-1.0], legend=:topright),
    with_span("03", "1/(1-x)^2", x -> 1 / (1 - x)^2, (-1.6, 1.5), (-1.5, 0.9); poles=[1.0]),
    with_span("04", "sqrt(x)", x -> sqrt(x), (0.0, 10.5), (0.0, 2.0)),
    with_span("05", "sqrt(x)", x -> sqrt(x), (0.0, 10.5), (0.0, 8.0)),
    with_span("06", "sqrt(x)", x -> sqrt(x), (0.0, 10.5), (0.0, 10.0)),
    with_span("07", "1/sqrt(1-x)", x -> 1 / sqrt(1 - x), (-1.6, 1.5), (-1.5, 0.95)),
    with_span("08", "1/(1+10x^2)", x -> 1 / (1 + 10x^2), (-1.5, 1.5), (-1.0, 1.0)),
    with_span("09", "log(x)", x -> log(x), (-0.5, 4.1), (0.02, 2.0)),
    with_span("10", "log(x)", x -> log(x), (-0.5, 4.1), (0.02, 4.0)),
    with_span("11", "log(1+x)", x -> log(1 + x), (-1.5, 1.5), (-0.98, 1.0)),
    auto_span("12", "sin(x)", x -> sin(x), (-3pi, 3pi)),
    auto_span("13", "cos(x)", x -> cos(x), (-3pi, 3pi)),
    # Nodes on [-3, 3], not [-pi, pi]: 5 equally spaced nodes on [-pi, pi]
    # would land on the poles at +-pi/2.
    with_span("14", "tan(x)", x -> tan(x), (-pi, pi), (-3.0, 3.0); poles=[-pi/2, pi/2]),
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
    # A listed node span is used as given (f is finite at both of its ends);
    # otherwise the nodes span the part of the plot window where f is finite.
    case.has_span && return case.node_span
    return finite_support(case)
end

function equal_nodes(f::Function, span::Tuple{Float64, Float64}, n_nodes::Int)
    a, b = span
    width = b - a
    for attempt in 0:8
        # Equally spaced nodes from a to b, endpoints included. Only if f is
        # not finite at some node are the nodes moved inside the interval.
        trim = attempt == 0 ? 0.0 : width * (0.02 + 0.01 * attempt)
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

    # First barycentric form P(x) = l(x) * sum_j w_j y_j / (x - x_j), with
    # l(x) = prod_j (x - x_j). The second form (num/den) loses all accuracy
    # far outside the nodes, where its denominator cancels.
    s = 0.0
    l = 1.0
    for j in eachindex(xs)
        s += w[j] * ys[j] / (x - xs[j])
        l *= (x - xs[j])
    end
    return l * s
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

function render_case(case::InterpCase)
    xplot = collect(range(case.xlims[1], case.xlims[2], length=1000))
    ytrue = [safe_eval(case.f, x) for x in xplot]

    span = resolved_span(case)
    n_nodes_seq = [2, 3, 4, 5, 6, 8, 10, 12, 14, 16]
    n_min = first(n_nodes_seq)
    n_max = last(n_nodes_seq)

    xs_lo, ys_lo = equal_nodes(case.f, span, n_min)
    w_lo = barycentric_weights(xs_lo)
    y_lo = [barycentric_eval(x, xs_lo, ys_lo, w_lo) for x in xplot]

    xs_hi, ys_hi = equal_nodes(case.f, span, n_max)
    w_hi = barycentric_weights(xs_hi)
    y_hi = [barycentric_eval(x, xs_hi, ys_hi, w_hi) for x in xplot]

    # Include the node values of every frame so that every node is drawn.
    has_pole = !isempty(case.poles)
    ylims_f = has_pole ?
        robust_ylims([safe_eval(case.f, x) for x in range(span[1], span[2], length=1000)]) :
        robust_ylims(ytrue)
    ys_all = vcat([equal_nodes(case.f, span, n)[2] for n in n_nodes_seq]...)
    ynode = [y for y in ys_all if isfinite(y)]
    if isempty(ynode)
        ylims = ylims_f
    else
        lo = min(ylims_f[1], minimum(ynode))
        hi = max(ylims_f[2], maximum(ynode))
        m = 0.12 * max(hi - lo, 1e-9)
        ylims = (lo - m, hi + m)
    end
    ytrue_clip = [isfinite(y) ? clamp(y, ylims[1], ylims[2]) : NaN for y in ytrue]
    xf, yf = xplot, ytrue_clip
    if has_pole
        # Unclamped f with a NaN point at each pole, so the curve breaks there
        # instead of drawing a segment along the window edge or across the pole.
        xf = sort(vcat(xplot, case.poles))
        yf = [x in case.poles ? NaN : safe_eval(case.f, x) for x in xf]
    end
    # Small x-margin so that nodes at the ends of the window are drawn whole.
    xpad = 0.02 * (case.xlims[2] - case.xlims[1])
    xaxis = (case.xlims[1] - xpad, case.xlims[2] + xpad)

    anim = Animation()
    for n_nodes in n_nodes_seq
        xs, ys_nodes = equal_nodes(case.f, span, n_nodes)
        w = barycentric_weights(xs)
        yinterp = [barycentric_eval(x, xs, ys_nodes, w) for x in xplot]
        yinterp = clamp.(yinterp, ylims[1], ylims[2])

        pplot = plot(size=(760, 520),
                     xlims=xaxis, ylims=ylims,
                     xlabel="x", ylabel="y",
                     title="Interpolation Case $(case.id): f(x) = $(case.formula_label), degree $(n_nodes - 1)",
                     legend=case.legend, grid=true, framestyle=:box,
                     background_color=:white)

        plot!(pplot, xf, yf; color=:magenta, lw=2.5, label="f(x)")
        plot!(pplot, xplot, yinterp; color=:steelblue, lw=2.2, label="interpolant")
        scatter!(pplot, xs, ys_nodes; color=:red, ms=4.5, label="nodes")

        frame(anim, pplot)
    end

    out_name = "lagnewt$(case.id).gif"
    gif(anim, joinpath(@__DIR__, out_name); fps=2)
    println("Saved: " * out_name)
end

for case in cases
    render_case(case)
end

println("Generated $(length(cases)) GIFs.")
