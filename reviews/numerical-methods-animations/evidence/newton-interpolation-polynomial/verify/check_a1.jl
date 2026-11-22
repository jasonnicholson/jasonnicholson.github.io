include("defs.jl")
setprecision(BigFloat, 512)
function newton_big(xs, ys, x)
    X = BigFloat.(xs); c = BigFloat.(ys); n = length(X)
    for k in 2:n, i in n:-1:k
        c[i] = (c[i]-c[i-1])/(X[i]-X[i-k+1])
    end
    p = c[n]; xb = BigFloat(x)
    for i in n-1:-1:1; p = p*(xb-X[i]) + c[i]; end
    p
end
function ylims_of(case)
    xplot = collect(range(case.xlims[1], case.xlims[2], length=1000))
    ytrue = [safe_eval(case.f, x) for x in xplot]
    span = resolved_span(case)
    xs_lo, ys_lo = equal_nodes(case.f, span, 2); xs_hi, ys_hi = equal_nodes(case.f, span, 16)
    ylims_f = robust_ylims(ytrue)
    ynode = [y for y in vcat(ys_lo, ys_hi) if isfinite(y)]
    lo = min(ylims_f[1], minimum(ynode)); hi = max(ylims_f[2], maximum(ynode))
    m = 0.12*max(hi-lo,1e-9); (lo-m, hi+m), xplot, span
end
for case in cases
    yl, xplot, span = ylims_of(case)
    for n in [2,3,4,5,6,8,10,12,14,16]
        xs, ys = equal_nodes(case.f, span, n); w = barycentric_weights(xs)
        yf = [barycentric_eval(x, xs, ys, w) for x in xplot]
        yt = [Float64(newton_big(xs, ys, x)) for x in xplot]
        cf = clamp.(yf, yl[1], yl[2]); ct = clamp.(yt, yl[1], yl[2])
        d = abs.(cf .- ct); bad = findall(d .> 0.01*(yl[2]-yl[1]))
        if !isempty(bad)
            # sign flips in float vs true
            println("case $(case.id) deg $(n-1): $(length(bad))/1000 plotted pts differ >1% of y-range; first bad x=$(round(xplot[bad[1]],digits=3)); ",
              "max rel err raw=$(maximum(abs.(yf.-yt)./abs.(yt))) ; true |p| at those xs min=$(minimum(abs.(yt[bad]))) ; float sign mismatches=$(count(sign.(yf[bad]).!=sign.(yt[bad])))")
        end
    end
end
# detail for case 04 deg 15 and 29 deg 13/15
for (id,n) in [("04",16),("29",14),("29",16),("29",12)]
    case = first(c for c in cases if c.id==id); yl, xplot, span = ylims_of(case)
    xs, ys = equal_nodes(case.f, span, n); w = barycentric_weights(xs)
    println("\ncase $id deg $(n-1) ylims=$yl nodes [$(xs[1]), $(xs[end])]")
    for x in [3.0, 5.0, 5.75, 8.0, 9.6, 10.4, 12.0, 15.5, 20.0, 22.0]
        x > case.xlims[2] && continue
        num=0.0; den=0.0
        for j in eachindex(xs); t=w[j]/(x-xs[j]); num+=t*ys[j]; den+=t; end
        tb = newton_big(xs, ys, x)
        # exact den = 1/prod(x-xj)
        dent = 1/prod(BigFloat(x).-BigFloat.(xs))
        println("  x=$x float=$(num/den)  true=$(Float64(tb))  den_float=$den den_true=$(Float64(dent))")
    end
end
