# Same as empirical_order.jl but in BigFloat, and returning the final y in full precision
using Printf
setprecision(256)
include("rkf_from_aa.jl")
# patch: capture final y in BigFloat by wrapping f to record? simpler: script stores ys as Float64; final y error >1e-15 is all we need
probs = [("non-autonomous y'=-2t y + t, y(0)=0, T=2, exact 0.5(1-exp(-t^2))", (t,y)->-2t*y + t, big"0.0", big"2.0", (1-exp(-big"4.0"))/2),
         ("non-autonomous y'=y*cos(t)+cos(t), y(0)=0, T=3, exact exp(sin t)-1", (t,y)->y*cos(t)+cos(t), big"0.0", big"3.0", exp(sin(big"3.0"))-1)]
for (nm,f,y0,T,ex) in probs
  println(nm)
  for mode in (:rkf45,:rkf54)
    prev = NaN
    for n in (4,8,16,32,64,128)
      h = T/n
      ts,ys = rkf_integrate(f,big"0.0",T,y0; h0=h, tol=big"0.0", mode=mode, hmin=h, hmax=h)
      e = Float64(abs(ys[end]-ex))
      @printf("  %s n=%4d steps=%d tend=%.15f err=%.3e ratio=%s\n", mode, n, length(ts)-1, ts[end], e, isnan(prev) ? "-" : @sprintf("%.2f (order %.2f)", prev/e, log2(prev/e)))
      prev = e
    end
  end
end
