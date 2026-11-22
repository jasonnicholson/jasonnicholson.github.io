# Independent checks with sympy/mpmath (no reuse of script code)
import sympy as sp, mpmath as mp, numpy as np
x,h=sp.symbols('x h')
f=sp.exp(-x)*sp.sin(x)
fp=sp.diff(f,x); print("f' =",sp.simplify(fp), " equals e^-x(cos-sin)?", sp.simplify(fp-sp.exp(-x)*(sp.cos(x)-sp.sin(x)))==0)
print("f'' =",sp.simplify(sp.diff(f,x,2)), " f''' =",sp.simplify(sp.diff(f,x,3)))
# exactness on monomials
D3=lambda g:(g.subs(x,x+h)-g.subs(x,x-h))/(2*h)
for k in range(6):
    g=x**k; print("deg",k,"D3-g' =",sp.expand(sp.simplify(D3(g)-sp.diff(g,x))))
# leading error via series in h for general g
F=sp.Function('F')
ser=sp.series(D3(f)-fp,h,0,6).removeO()
print("D3 f - f' series:", sp.simplify(sp.expand(ser)))
print("coef h^2 / f''' :", sp.simplify(ser.coeff(h,2)/sp.diff(f,x,3)))
# values
mp.mp.dps=40
fm=lambda t: mp.e**(-t)*mp.sin(t)
fpm=lambda t: mp.e**(-t)*(mp.cos(t)-mp.sin(t))
print("f'(1) exact =", mp.nstr(fpm(1),15), " via mp.diff:", mp.nstr(mp.diff(fm,1),15))
print("f'''(0) =", sp.diff(f,x,3).subs(x,0), " -> max err on [h,pi-h] ~ h^2/6*|f'''(0)| = h^2/3")
# max |f'''| on [0,pi]
f3=sp.lambdify(x,sp.diff(f,x,3),'numpy'); xs=np.linspace(0,np.pi,200001); print("max|f'''| on [0,pi] =",np.abs(f3(xs)).max(), "at", xs[np.abs(f3(xs)).argmax()])
# measured order at x=1 (high precision, no roundoff)
prev=None
for hh in [mp.mpf('0.4')/2**k for k in range(8)]:
    e=abs((fm(1+hh)-fm(1-hh))/(2*hh)-fpm(1))
    print("h=%-12s err=%s"%(mp.nstr(hh,6),mp.nstr(e,8)), "" if prev is None else "ratio=%s p=%s"%(mp.nstr(prev/e,6),mp.nstr(mp.log(prev/e,2),6))); prev=e
# float64 roundoff vs truncation at x=1
import math
fd=lambda t: math.exp(-t)*math.sin(t)
tru=float(fpm(1))
print("float64 error vs h at x=1:")
for k in range(1,13):
    hh=10.0**-k; e=abs((fd(1+hh)-fd(1-hh))/(2*hh)-tru); print("  h=1e-%d err=%.3e"%(k,e))
f3_1=float(sp.diff(f,x,3).subs(x,1)); eps=2.2e-16; fv=abs(fd(1))
hopt=(3*eps*fv/abs(f3_1))**(1/3); print("f'''(1)=",f3_1," model h_opt=(3 eps|f|/|f'''|)^(1/3)=",hopt)
