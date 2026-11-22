# Which acceptance rule reproduces the script's final partition?
import math, mpmath
f = lambda x: 1 + math.exp(-x)*math.sin(8*x**(2/3))
def S(a,b):
    m=(a+b)/2; return (b-a)/6*(f(a)+4*f(m)+f(b))
A,B,eps=0.0,2.0,1e-3
script_final = sorted(set([(0,2**-11)] + [(2**-k,2**-(k-1)) for k in range(11,4,-1)] +
  [(0.0625,0.125),(0.125,0.1875),(0.1875,0.25),(0.25,0.375),(0.375,0.5),(0.5,0.625),(0.625,0.75),(0.75,0.875),(0.875,1),(1,1.25),(1.25,1.5),(1.5,2)]))
def run(fac, keep_coarse):
    out=[]
    def rec(a,b,tl):
        m=(a+b)/2; d=S(a,m)+S(m,b)-S(a,b)
        if abs(d) < fac*tl:
            if keep_coarse: out.append(((a,b),S(a,b)))
            else: out.extend([((a,m),S(a,m)),((m,b),S(m,b))])
        else: rec(a,m,tl/2); rec(m,b,tl/2)
    rec(A,B,eps); return out
for fac in (1,10,15):
  for kc in (True,False):
    o=run(fac,kc); P=sorted(p for p,_ in o); v=sum(s for _,s in o)
    print(f"fac={fac:2d} drawn panels={'coarse S(a,b)' if kc else 'halves     '}: panels={len(P):2d} nodes={2*len(P)+1:2d} value={v:.10f} matches script partition: {P==script_final}")
# threshold window for fac (rule: |d| < fac*eps*(b-a)/(B-A), coarse panels kept)
# reference integral by smoothing substitution x=t^3
mpmath.mp.dps=40
g=lambda t: (1+mpmath.exp(-t**3)*mpmath.sin(8*t**2))*3*t**2
I=mpmath.quad(g,[0,mpmath.cbrt(2)/2,mpmath.cbrt(2)])
I2=mpmath.quad(g,mpmath.linspace(0,mpmath.cbrt(2),9),method='gauss-legendre')
print("I (x=t^3, tanh-sinh)  =",mpmath.nstr(I,20)); print("I (x=t^3, gauss-leg.) =",mpmath.nstr(I2,20))
print("script final 2.0162517668 - I =", 2.0162517668-float(I))
