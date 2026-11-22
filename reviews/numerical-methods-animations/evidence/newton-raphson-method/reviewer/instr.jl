# Evaluate each script's function/parameter/iterate block (everything before "# --- Animation ---")
# in its own module (Plots stubbed), print iterates, and check that each drawn segment
# (xn,f(xn))->(xn1,0) has slope f'(xn) with f' from finite differences of f; report clamping/out-of-range.
using Printf
for s in ["aa","bb","cc","dd","ee","ff"]
    src = read("orig_newton$s.jl", String)
    pre = split(src, "# --- Animation ---")[1]
    pre = replace(pre, "using Plots" => "", "gr()" => "")
    m = Module(Symbol("M"*s))
    Core.eval(m, :(include_string(m, code) = Base.include_string(m, code)))
    Base.include_string(m, pre)
    xs = Core.eval(m, :xs); f0 = Core.eval(m, :f); fp0 = Core.eval(m, :fp); f = x -> Base.invokelatest(f0, x); fp = x -> Base.invokelatest(fp0, x)
    xl = Core.eval(m, :xlims); yl = Core.eval(m, :ylims)
    println("== newton$s  x0=$(xs[1])  xlims=$xl ylims=$yl")
    for k in eachindex(xs)
        x = xs[k]; inx = xl[1] <= x <= xl[2]; iny = yl[1] <= f(x) <= yl[2]
        line = @sprintf("  x%-2d = %.17g  f=%.6g  in_x=%s in_y=%s", k-1, x, f(x), inx, iny)
        if k < length(xs)
            slope_seg = (f(x) - 0.0) / (x - xs[k+1])
            h = 1e-6*max(1,abs(x)); fd = (f(x+h)-f(x-h))/(2h)
            line *= @sprintf("  seg slope=%.8g  fp=%.8g  FD f'=%.8g", slope_seg, fp(x), fd)
        end
        println(line)
    end
end
