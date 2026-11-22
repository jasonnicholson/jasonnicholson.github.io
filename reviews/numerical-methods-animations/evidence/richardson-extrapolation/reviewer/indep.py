import sympy as sp, mpmath as mp
x,h=sp.symbols('x h')
f=sp.exp(-x)*sp.sin(x)
fp=sp.diff(f,x)
print("f' =",sp.simplify(fp), " matches script:", sp.simplify(fp-sp.exp(-x)*(sp.cos(x)-sp.sin(x)))==0)
D3=lambda hh:(f.subs(x,x+hh)-f.subs(x,x-hh))/(2*hh)
D5=(4*D3(h/2)-D3(h))/3
print("D3 series:", sp.simplify(sp.series(D3(h)-fp,h,0,5).removeO()))
s5=sp.series(D5-fp,h,0,7).removeO()
print("D5 - f' series:", sp.simplify(s5))
# generic: exactness on polynomials
g=sp.Function('g')
for deg in range(7):
    p=x**deg
    d3=( p.subs(x,x+h)-p.subs(x,x-h))/(2*h)
    d3h=( p.subs(x,x+h/2)-p.subs(x,x-h/2))/(h)
    d5=sp.simplify((4*d3h-d3)/3 - sp.diff(p,x))
    print("deg",deg,"D3 err",sp.simplify(d3-sp.diff(p,x)),"  D5 err",d5)
mp.mp.dps=50
F=lambda t: mp.e**(-t)*mp.sin(t)
FP=lambda t: mp.e**(-t)*(mp.cos(t)-mp.sin(t))
d3=lambda t,hh:(F(t+hh)-F(t-hh))/(2*hh)
d5=lambda t,hh:(4*d3(t,hh/2)-d3(t,hh))/3
print("f'(1) =",mp.nstr(FP(1),20))
hs=[0.5,0.32,0.2,0.12,0.08,0.05,0.03,0.02,0.01,0.006,0.003,0.0015]
prev=None
for hh in hs:
    e3=abs(d3(1,mp.mpf(hh))-FP(1)); e5=abs(d5(1,mp.mpf(hh))-FP(1))
    print(hh, mp.nstr(e3,8), mp.nstr(e5,8))
# max errors over xint grid (exact arithmetic) for case 1
import numpy as np
for hh in [0.5,0.32,0.2,0.12,0.08,0.05,0.03,0.02,0.01]:
    xs=np.linspace(hh,np.pi-hh,700)
    m3=max(abs(d3(mp.mpf(t),mp.mpf(hh))-FP(mp.mpf(t))) for t in xs)
    m5=max(abs(d5(mp.mpf(t),mp.mpf(hh))-FP(mp.mpf(t))) for t in xs)
    print("case1 h",hh,"max e3",mp.nstr(m3,6),"max e5",mp.nstr(m5,6))
