# Does the first (modified Lagrange) barycentric form fix the far-extrapolation breakdown?
include(joinpath(@__DIR__, "instr_defs.jl"))
setprecision(256)
lagbig(x, xs, ys) = sum(big(ys[i]) * prod((big(x) - big(xs[j])) / (big(xs[i]) - big(xs[j])) for j in eachindex(xs) if j != i) for i in eachindex(xs))
function first_form(x, xs, ys, w)
    for j in eachindex(xs); x == xs[j] && return ys[j]; end
    prod(x .- xs) * sum(w[j] * ys[j] / (x - xs[j]) for j in eachindex(xs))
end
for k in (4, 29)
    case = cases[k]; span = resolved_span(case)
    xplot = collect(range(case.xlims[1], case.xlims[2], length=1000))
    for n in (14, 16)
        xs, ys = equal_nodes(case.f, span, n); w = barycentric_weights(xs)
        ex = [Float64(lagbig(x, xs, ys)) for x in xplot]
        s2 = [barycentric_eval(x, xs, ys, w) for x in xplot]
        s1 = [first_form(x, xs, ys, w) for x in xplot]
        rel(a) = maximum(abs.(a .- ex) ./ max.(1, abs.(ex)))
        println("case ", case.id, " deg ", n-1, ": max rel err second form (script) = ", rel(s2), " ; first form = ", rel(s1),
                " ; sign mismatches second form = ", count(sign.(s2) .!= sign.(ex)))
    end
end
