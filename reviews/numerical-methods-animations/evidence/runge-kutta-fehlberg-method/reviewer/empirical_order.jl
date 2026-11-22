# Uses the script's own rkf_integrate, forced to fixed step by hmin=hmax=h (accept branch `h <= hmin` always true)
using Printf
include("rkf_from_aa.jl")
probs = [("y'=y, y(0)=1, T=1", (t,y)->y, 1.0, 1.0, exp(1.0)),
         ("y'=t^4*y... non-autonomous y'=-2t y + t, y(0)=0, T=1 (exact 0.5(1-exp(-t^2)))", (t,y)->-2t*y + t, 0.0, 1.0, 0.5*(1-exp(-1.0))),
         ("y'=1+y^2,y(0)=0.5,T=1", (t,y)->1+y^2, 0.5, 1.0, tan(1+atan(0.5)))]
for (nm,f,y0,T,ex) in probs
  println(nm)
  for mode in (:rkf45,:rkf54)
    prev = NaN
    for n in (8,16,32,64,128)
      h = T/n
      ts,ys = rkf_integrate(f,0.0,T,y0; h0=h, tol=0.0, mode=mode, hmin=h, hmax=h)
      e = abs(ys[end]-ex)
      @printf("  %s n=%4d steps=%d err=%.3e ratio=%s\n", mode, n, length(ts)-1, e, isnan(prev) ? "-" : @sprintf("%.2f (order %.2f)", prev/e, log2(prev/e)))
      prev = e
    end
  end
end
