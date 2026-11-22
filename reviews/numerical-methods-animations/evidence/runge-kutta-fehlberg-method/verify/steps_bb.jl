using Printf
include("rkf_bb.jl")
f(t,y)=1-t*cbrt(y)
# also log rejections
for mode in (:rkf45,:rkf54)
a,ay=rkf_integrate(f,0.0,5.0,1.0;h0=0.1,tol=1e-6,mode=mode)
println("CASE2 ",mode," n=",length(a))
for i in 1:length(a)
  h = i>1 ? a[i]-a[i-1] : NaN
  fp = i>1 ? (ay[i]-ay[i-1])/h : NaN
  @printf("%3d t=%.5f y=%.6f h=%.4e |y'|=%.4f chord=%.4f\n", i, a[i], ay[i], h, abs(f(a[i],ay[i])), fp)
end
end
