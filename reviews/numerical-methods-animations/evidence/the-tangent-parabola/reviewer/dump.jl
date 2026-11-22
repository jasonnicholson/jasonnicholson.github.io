# Instrumented copy of tangparabaa.jl: prints computed values, no rendering
f(x)=cos(x); df(x)=-sin(x); d2f(x)=-cos(x)
x0=π/4
x_plot = collect(range(x0 - 1.5, x0 + 1.5, length=500))
T2(x) = f(x0) + df(x0) * (x - x0) + 0.5 * d2f(x0) * (x - x0)^2
function newton_parabola(x, h)
    x1, x2, x3 = x0 - h, x0, x0 + h
    y1, y2, y3 = f(x1), f(x2), f(x3)
    d01 = (y2 - y1) / (x2 - x1); d12 = (y3 - y2) / (x3 - x2); d012 = (d12 - d01) / (x3 - x1)
    return y1 + d01 * (x - x1) + d012 * (x - x1) * (x - x2)
end
h_vals_log = exp.(range(log(1.0), log(0.01), length=18))
h_vals = vcat(h_vals_log, fill(0.0, 5))
println("nframes=", length(h_vals))
for (k,h) in enumerate(h_vals)
  if h>1e-6
    # recover monomial coeffs about x0: c0 + c1 t + c2 t^2 by sampling
    p(t)=newton_parabola(x0+t,h)
    c0=p(0.0); c1=(p(1.0)-p(-1.0))/2; c2=(p(1.0)+p(-1.0)-2c0)/2
    nodes_err = maximum(abs.([newton_parabola(x,h)-f(x) for x in (x0-h,x0,x0+h)]))
    maxdev = maximum(abs.(newton_parabola.(x_plot,h) .- T2.(x_plot)))
    println(k," h=",h," lbl=",round(h,digits=3)," c=(",c0,",",c1,",",c2,") nodeerr=",nodes_err," maxdev_vs_T2=",maxdev)
  else
    println(k," h=0 -> T2 drawn")
  end
end
println("T2 coeffs: ", f(x0)," ",df(x0)," ",0.5*d2f(x0))
