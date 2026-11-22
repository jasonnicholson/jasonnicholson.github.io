include("lib.jl")
setprecision(BigFloat, 512)
function lag_big(x, xs, ys)   # Lagrange form in BigFloat with Float64 nodes/values
    X = BigFloat(x); s = big(0.0)
    for i in eachindex(xs)
        L = big(1.0)
        for j in eachindex(xs)
            i==j && continue
            L *= (X - big(xs[j]))/(big(xs[i])-big(xs[j]))
        end
        s += big(ys[i])*L
    end
    s
end
function ylims_for(case)
    xplot = collect(range(case.xlims[1], case.xlims[2], length=1000))
    ytrue = [safe_eval(case.f, x) for x in xplot]
    span = resolved_span(case)
    xs_lo, ys_lo = equal_nodes(case.f, span, 2); xs_hi, ys_hi = equal_nodes(case.f, span, 16)
    yf = robust_ylims(ytrue); ynode=[y for y in vcat(ys_lo,ys_hi) if isfinite(y)]
    lo=min(yf[1],minimum(ynode)); hi=max(yf[2],maximum(ynode)); m=0.12*max(hi-lo,1e-9)
    xplot, span, (lo-m, hi+m)
end
for case in cases
    xplot, span, yl = ylims_for(case)
    for n in [2,3,4,5,6,8,10,12,14,16]
        xs, ys = equal_nodes(case.f, span, n); w = barycentric_weights(xs)
        yb = [barycentric_eval(x, xs, ys, w) for x in xplot]
        ye = [Float64(lag_big(x, xs, ys)) for x in xplot]
        cb = clamp.(yb, yl...); ce = clamp.(ye, yl...)
        d = abs.(cb .- ce); bad = findall(d .> 0.01*(yl[2]-yl[1]))
        if !isempty(bad)
            println("case $(case.id) deg $(n-1): $(length(bad)) of 1000 plotted pts wrong by >1% of y-range; first bad x=$(round(xplot[bad[1]],digits=3)); maxreldiff(unclamped) where bad: ",
              maximum(abs.(yb[bad].-ye[bad])./abs.(ye[bad])), " ; sign flips: ", count(sign.(yb[bad]).!=sign.(ye[bad])))
        end
    end
end
# A4: actual node range per case
println("\nNode ranges (n=16) vs nominal span:")
for case in cases
    span = resolved_span(case)
    xs2,_ = equal_nodes(case.f, span, 2); xs16,_ = equal_nodes(case.f, span, 16)
    println(case.id, " ", case.formula_label, " nominal=", case.has_span ? case.node_span : "auto", " resolved=", round.(span,digits=4), " nodes(n=2)=", round.((xs2[1],xs2[end]),digits=4), " nodes(n=16)=", round.((xs16[1],xs16[end]),digits=4))
end
