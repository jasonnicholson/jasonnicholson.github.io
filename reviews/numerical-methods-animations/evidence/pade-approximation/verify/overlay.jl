include(joinpath(@__DIR__, "compare_defs.jl"))
exact = Dict{String,Vector{Float64}}()
for line in eachline(joinpath(@__DIR__, "exactcoefs.txt")); p = split(line); exact[p[1]] = parse.(Float64, p[2:end]); end
function curve(case, a, m, n, xplot)
    p, q = pade_from_series(a, m, n)
    y = [ (d = poly_eval_asc(q, x-case.c); abs(d) < 1e-8 ? NaN : poly_eval_asc(p, x-case.c)/d) for x in xplot]
    clamp.(y, case.ylims...)
end
for (cid, m, n) in [("22",2,5), ("22",6,1), ("23",0,8), ("27",6,1), ("25",7,0)]
    case = cases[parse(Int,cid)]
    xplot = collect(range(case.xlims[1], case.xlims[2], length=900))
    pl = plot(size=(700,520), xlims=case.xlims, ylims=case.ylims, title="Case $cid [$m/$n]: drawn (fit) vs true Padé", legend=:topleft)
    plot!(pl, xplot, [safe_eval(case.f,x) for x in xplot], color=:magenta, lw=2.5, label="f")
    plot!(pl, xplot, curve(case, series_coeffs_analytic(case), m, n, xplot), color=:steelblue, lw=2.1, label="drawn (script)")
    plot!(pl, xplot, curve(case, exact[cid], m, n, xplot), color=:black, lw=1.5, ls=:dash, label="true Padé (exact coeffs)")
    savefig(pl, joinpath(@__DIR__, "overlay_$(cid)_$(m)_$(n).png"))
end
