using Printf
include("rkf_count.jl")
for (nm,f,t0,tf,y0) in (("case1",(t,y)->1+y^2,0.0,1.1,0.5),("case2",(t,y)->1-t*cbrt(y),0.0,5.0,1.0))
  for mode in (:rkf45,:rkf54)
    ts,ys,nrej,r,hs = rkf_integrate_count(f,t0,tf,y0; h0=0.1, tol=1e-6, mode=mode)
    h = diff(ts)
    @printf("%s %s accepted=%d rejected=%d attempts=%d  err/tol on accepted: min %.3f median %.3f max %.3f; min accepted h (excl. last)=%.4g at t=%.3f; any h==hmin? %s\n",
      nm, mode, length(ts)-1, nrej, length(hs), minimum(r), sort(r)[div(end+1,2)], maximum(r), minimum(h[1:end-1]), ts[argmin(h[1:end-1])], any(h .<= 1e-6))
  end
end
# compare step sequences of the two modes
include("rkf_from_aa.jl")
for (nm,f,t0,tf,y0) in (("case1",(t,y)->1+y^2,0.0,1.1,0.5),("case2",(t,y)->1-t*cbrt(y),0.0,5.0,1.0))
  a,_ = rkf_integrate(f,t0,tf,y0; h0=0.1,tol=1e-6,mode=:rkf45); b,_ = rkf_integrate(f,t0,tf,y0; h0=0.1,tol=1e-6,mode=:rkf54)
  ha=diff(a); hb=diff(b); n=min(length(ha),length(hb))
  @printf("%s: n45=%d n54=%d  max |t45-t54| over points=%.3e  max rel diff in h (excl. last)=%.3e\n", nm, length(a), length(b), maximum(abs.(a[1:n].-b[1:n])), maximum(abs.(ha[1:n-1].-hb[1:n-1])./ha[1:n-1]))
end
