using Printf
include("rkf_aa.jl")
f(t,y)=1+y^2
yex(t)=tan(t+atan(0.5))
a,ay=rkf_integrate(f,0.0,1.1,0.5;h0=0.1,tol=1e-6,mode=:rkf45)
b,by=rkf_integrate(f,0.0,1.1,0.5;h0=0.1,tol=1e-6,mode=:rkf54)
println("CASE1 n45=",length(a)," n54=",length(b))
for i in 1:max(length(a),length(b))
  ta = i<=length(a) ? a[i] : NaN; tb = i<=length(b) ? b[i] : NaN
  ya = i<=length(a) ? ay[i] : NaN; yb = i<=length(b) ? by[i] : NaN
  @printf("%3d t45=%.6f t54=%.6f dt=%.2e y45=%.6f y54=%.6f dy=%.2e yex=%.6f slope=%.3e\n", i, ta, tb, ta-tb, ya, yb, ya-yb, yex(ta), 1+ya^2)
end
