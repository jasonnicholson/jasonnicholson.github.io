# Evaluate each script's parameter + iteration section (everything before "# --- Backdrop")
# in its own module and print the xs vector the animation draws/labels.
function report(m, s)
    xs = m.xs
    println("== ", s, "  n_iters=", m.n_iters)
    for (k,x) in enumerate(xs)
        println("  x_", k-1, " = ", x, "   label-> ", round(x; digits=4))
    end
    cx, cy = m.cobweb_x, m.cobweb_y
    println("  cobweb length ", length(cx), " start (", cx[1], ",", cy[1], ")")
    for i in 1:m.n_iters
        xv, yv = cx[2i], cy[2i]; xh, yh = cx[2i+1], cy[2i+1]
        println("   seg$i: vert top (", round(xv,digits=5), ",", round(yv,digits=5), ") g(xv)=", round(m.g(xv),digits=5),
                " onCurve=", isapprox(m.g(xv), yv; atol=1e-12), "  horiz end on diag=", xh==yh)
    end
end
for s in ["fixpointaa","fixpointbb","fixpointcc","fixpointdd","fixpointee","fixpointff"]
    src = read(joinpath(@__DIR__, s*".jl"), String)
    src = replace(src, "using Plots" => "", "gr()" => "")
    cut = findfirst("# --- Backdrop", src)
    m = Module()
    Base.include_string(m, src[1:first(cut)-1])
    Base.invokelatest(report, m, s)
end
