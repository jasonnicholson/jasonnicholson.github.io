# Independent check: exact-rational bisection + mpmath reference roots
from fractions import Fraction as F
import mpmath as mp, sympy as sp
mp.mp.dps = 30
x = sp.symbols('x')
p = x**3 + 4*x**2 - 10
print("real roots of x^3+4x^2-10:", [sp.N(r, 15) for r in sp.real_roots(p)])
print("f(1), f(2) =", p.subs(x,1), p.subs(x,2))
print("f(1.3688) =", sp.N(p.subs(x, sp.Rational(13688,10000))))
r = mp.findroot(lambda t: t**3+4*t**2-10, 1.365); rf=float(r)
print("mpmath root:", r)
def bis(f, a, b, n):
    out=[]
    for i in range(n):
        c=(a+b)/2
        fc=f(c)
        out.append((c, fc))
        if f(a)*fc<0: b=c
        else: a=c
    return out,a,b
pf=lambda t: t**3+4*t**2-10
o,a,b=bis(pf,F(1),F(2),12)
for i,(c,fc) in enumerate(o,1): print(i, float(c), float(fc))
print("final bracket", float(a), float(b), "contains root:", float(a)<=rf<=float(b), "contains 1.3688:", float(a)<=1.3688<=float(b))
cs=[float(c) for c,_ in o]
print("monotone increasing?", all(cs[i]<cs[i+1] for i in range(11)), "monotone decreasing?", all(cs[i]>cs[i+1] for i in range(11)))
print("|c_k - r|:", [abs(c-rf) for c in cs])
# tan case, mpmath at high precision
ft=lambda t: mp.tan(mp.mpf(t.numerator)/t.denominator)
o2,a2,b2=bis(ft,F(1),F(2),12)
for i,(c,fc) in enumerate(o2,1): print(i, float(c), mp.nstr(fc,8))
print("final bracket", float(a2), float(b2), "pi/2=", mp.pi/2, "contains pi/2:", float(a2)<=float(mp.pi/2)<=float(b2))
print("tan(1), tan(2):", mp.tan(1), mp.tan(2))
print("cos has root in [1,2] only at pi/2; tan zeros at k*pi -> none in [1,2]:", [k*mp.pi for k in range(0,2)])
