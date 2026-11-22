using Printf
f(x) = exp(-x) * sin(x)
fp(x) = exp(-x) * (cos(x) - sin(x))
fpp(x) = -2exp(-x) * cos(x)
d1_3(x, h) = (f(x + h) - f(x - h)) / (2h)
d1_5(x, h) = (f(x - 2h) - 8f(x - h) + 8f(x + h) - f(x + 2h)) / (12h)
d2_3(x, h) = (f(x + h) - 2f(x) + f(x - h)) / h^2
d2_5(x, h) = (-f(x + 2h) + 16f(x + h) - 30f(x) + 16f(x - h) - f(x - 2h)) / (12h^2)
x0=1.0
println("== aa"); for h in [0.6, 0.4, 0.25, 0.15, 0.1, 0.07, 0.05, 0.03, 0.02, 0.01, 0.005, 0.001]
  a=d1_3(x0,h); e=fp(x0); @printf("h=%-6g approx=%.15f exact=%.15f err=%.3e  annot: approx=%s exact=%s\n",h,a,e,a-e,round(a;digits=6),round(e;digits=6)); end
println("== ab"); for h in [0.35, 0.25, 0.18, 0.12, 0.08, 0.05, 0.03, 0.02, 0.01, 0.005, 0.002]
  a3=d1_3(x0,h); a5=d1_5(x0,h); e=fp(x0); @printf("h=%-6g err3=%.6e err5=%.6e  annot |err3|≈%s |err5|≈%s\n",h,a3-e,a5-e,round(abs(a3-e);digits=6),round(abs(a5-e);digits=6)); end
println("== ac"); for h in [0.35, 0.25, 0.18, 0.12, 0.08, 0.05, 0.03, 0.02, 0.01, 0.005, 0.002]
  xi=range(0.0+2h, pi-2h, length=700); y3=d2_3.(xi,h); y5=d2_5.(xi,h)
  e3=abs.(y3 .- fpp.(xi)); e5=abs.(y5 .- fpp.(xi))
  @printf("h=%-6g err3=%.6e (at x=%.3f) err5=%.6e (at x=%.3f) annot %s %s  d2_3(1)-fpp(1)=%.3e d2_5(1)-fpp(1)=%.3e\n",h,maximum(e3),xi[argmax(e3)],maximum(e5),xi[argmax(e5)],round(maximum(e3);digits=8),round(maximum(e5);digits=8),d2_3(1.0,h)-fpp(1.0),d2_5(1.0,h)-fpp(1.0)); end
