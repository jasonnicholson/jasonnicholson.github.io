# Instrumented copy of rungekuttaaa.jl compute section (no rendering)
using Printf
f(t, y) = 1.0 - t * cbrt(y)
function rk4(f, t0, y0, T, n; verbose=false)
    h = (T - t0)/n
    ts = zeros(n+1); ys = zeros(n+1); ts[1]=t0; ys[1]=y0
    minstage = Inf
    for i in 1:n
        t = ts[i]; y = ys[i]
        k1 = h * f(t,       y)
        k2 = h * f(t + h/2, y + k1/2)
        k3 = h * f(t + h/2, y + k2/2)
        k4 = h * f(t + h,   y + k3)
        minstage = min(minstage, y, y+k1/2, y+k2/2, y+k3)
        verbose && @printf("step %2d t=%.2f y=%.10f k1=%.6f k2=%.6f k3=%.6f k4=%.6f  stage-y: %.5f %.5f %.5f\n", i, t, y, k1,k2,k3,k4, y+k1/2, y+k2/2, y+k3)
        ts[i+1] = t + h
        ys[i+1] = y + (k1 + 2k2 + 2k3 + k4)/6
    end
    ts, ys, minstage
end
ts, ys, ms = rk4(f, 0.0, 1.0, 5.0, 20; verbose=true)
println("min stage y = ", ms)
for i in eachindex(ts)
    @printf("%5.2f  %.12f   label: t=%s  y≈%s\n", ts[i], ys[i], round(ts[i];digits=2), round(ys[i];digits=4))
end
# step-halving on this problem: y at t=1,2,3,5
println("\nStep halving on the page's problem (same routine), y(T):")
for T in (1.0, 2.0, 3.0, 5.0)
    for n in (5,10,20,40,80,160,320,640)
        nn = Int(n*T/5 > 0 ? round(n*T/5) : 1)
        _, y, _ = rk4(f, 0.0, 1.0, T, max(nn,1))
        @printf("T=%.0f n=%4d h=%.5f y=%.12f\n", T, max(nn,1), T/max(nn,1), y[end])
    end
end
# order checks on y'=y and a non-autonomous problem y'=t^2 - y? use y' = -2 t y, y(0)=1 -> exp(-t^2)
println("\nOrder checks with the same routine:")
for (name, g, ex) in (("y'=y, y(0)=1, T=1", (t,y)->y, exp(1.0)),
                      ("y'=cos(t)*y + t, ... use y'=t*y -> exp(t^2/2), T=1", (t,y)->t*y, exp(0.5)),
                      ("y'=1 - t*y^(1/3)? n/a; y'=cos t, y(0)=1 -> 1+sin 1", (t,y)->cos(t), 1+sin(1.0)))
    errs = Float64[]
    for n in (5,10,20,40,80)
        _, y, _ = rk4(g, 0.0, 1.0, 1.0, n); push!(errs, abs(y[end]-ex))
    end
    println(name); for k in 1:length(errs)-1; @printf("  err=%.3e ratio=%.3f p=%.3f\n", errs[k], errs[k]/errs[k+1], log2(errs[k]/errs[k+1])); end
end
