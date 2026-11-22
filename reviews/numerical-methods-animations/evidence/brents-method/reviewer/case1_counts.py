import math
f = lambda x: 4*x**3-16*x**2+17*x-4; r = 0.32853845861141489597
a,b = 0.0,1.0; fa,fb = f(a),f(b)
for k in range(1,200):
    x = b - fb*(b-a)/(fb-fa); fx = f(x)
    if abs(x-r) < 1e-10: print("regula falsi |x-r|<1e-10 at k =", k); break
    if fa*fx<0: b,fb=x,fx
    else: a,fa=x,fx
print("bisection to 1e-10:", math.ceil(math.log2(1/1e-10)), "; script final error:", abs(0.32853845861121722-r))
print("IQI order (real root of t^3=t^2+t+1):", [z for z in __import__('numpy').roots([1,-1,-1,-1]) if abs(z.imag)<1e-12])
