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
for case in cases[[4, 29]]
    xplot = collect(range(case.xlims[1], case.xlims[2], length=1000))
    ytrue = [safe_eval(case.f, x) for x in xplot]
    span = resolved_span(case)
    _, ys_lo = equal_nodes(case.f, span, 2); _, ys_hi = equal_nodes(case.f, span, 16)
    ylims_f = robust_ylims(ytrue); ynode = vcat(ys_lo, ys_hi)
    lo = min(ylims_f[1], minimum(ynode)); hi = max(ylims_f[2], maximum(ynode)); m = 0.12*(hi-lo); yl = (lo-m, hi+m)
    println("Case ", case.id, " ylims ", yl)
    for n in [2,3,4,5,6,8,10,12,14,16]
        xs, ys = equal_nodes(case.f, span, n); w = barycentric_weights(xs)
        s = [barycentric_eval(x, xs, ys, w) for x in xplot]
        t = Float64.([lagbig(x, xs, ys) for x in xplot])
        bad = findall(abs.(clamp.(s, yl...) .- clamp.(t, yl...)) .> 0.01*(yl[2]-yl[1]))
        isempty(bad) && continue
        signflip = count(i -> sign(s[i]) != sign(t[i]), bad)
        spurious = count(i -> yl[1] <= s[i] <= yl[2], bad)
        println("  deg ", n-1, ": ", length(bad), " wrong plotted pts, x in [", xplot[first(bad)], ", ", xplot[last(bad)], "], sign flips ", signflip, ", script value inside y-window (spurious visible) ", spurious)
        for i in bad[1:max(1, length(bad)÷6):end]
            println("     x=", round(xplot[i], digits=3), "  script=", s[i], "  exact=", t[i])
        end
    end
end
