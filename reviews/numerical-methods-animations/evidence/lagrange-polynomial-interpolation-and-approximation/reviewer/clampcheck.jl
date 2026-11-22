# Compare the plotted (clamped) interpolant from the script's Float64 barycentric formula with
# the clamped Lagrange form evaluated in BigFloat (256 bits) on the same nodes, at all 1000 plot points.
include(joinpath(@__DIR__, "instr_defs.jl"))
setprecision(256)
function lagbig(x, xs, ys)
    X = big(x); s = big(0.0)
    for i in eachindex(xs)
        L = big(1.0)
        for j in eachindex(xs); j == i && continue; L *= (X - big(xs[j])) / (big(xs[i]) - big(xs[j])); end
        s += big(ys[i]) * L
    end
    s
end
for case in cases
    xplot = collect(range(case.xlims[1], case.xlims[2], length=1000))
    ytrue = [safe_eval(case.f, x) for x in xplot]
    span = resolved_span(case)
    _, ys_lo = equal_nodes(case.f, span, 2); _, ys_hi = equal_nodes(case.f, span, 16)
    ylims_f = robust_ylims(ytrue); ynode = vcat(ys_lo, ys_hi)
    lo = min(ylims_f[1], minimum(ynode)); hi = max(ylims_f[2], maximum(ynode)); m = 0.12*(hi-lo); yl = (lo-m, hi+m)
    worst = 0.0; flips = 0
    for n in [2,3,4,5,6,8,10,12,14,16]
        xs, ys = equal_nodes(case.f, span, n); w = barycentric_weights(xs)
        a = clamp.([barycentric_eval(x, xs, ys, w) for x in xplot], yl...)
        b = clamp.(Float64.([lagbig(x, xs, ys) for x in xplot]), yl...)
        worst = max(worst, maximum(abs.(a .- b)) / (yl[2]-yl[1]))
        flips += count(abs.(a .- b) .> 0.01*(yl[2]-yl[1]))
    end
    println(case.id, "  max |clamped script - clamped BigFloat Lagrange| / y-range = ", worst, "   points differing by >1% of y-range: ", flips)
end
