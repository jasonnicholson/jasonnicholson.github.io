import mpmath as mp, sympy as sp
mp.mp.dps=30
x=sp.symbols('x')
print("== Case 1 properties (sympy legendre) ==")
for n in range(0,7):
    P=sp.legendre(n,x)
    print(n, sp.expand(P), " P(1)=",P.subs(x,1)," P(-1)=",P.subs(x,-1),
          " vals@k/3:",[sp.nsimplify(P.subs(x,sp.Rational(k,3))) for k in range(-3,4)])
for n in range(1,6):
    lhs=(n+1)*sp.legendre(n+1,x); rhs=(2*n+1)*x*sp.legendre(n,x)-n*sp.legendre(n-1,x)
    print("recurrence n=",n, sp.expand(lhs-rhs)==0)
for m in range(6):
    row=[sp.integrate(sp.legendre(m,x)*sp.legendre(n,x),(x,-1,1)) for n in range(6)]
    print("gram row",m,row," expected diag",sp.Rational(2,2*m+1))
for n in range(1,6):
    r=sp.Poly(sp.legendre(n,x),x).nroots(n=15)
    print("roots P_%d:"%n, [float(v) for v in r], "all in (-1,1):", all(-1<float(v)<1 and abs(sp.im(v))<1e-14 for v in r))
# local extrema of P_2..P_5 to check against frame
for n in range(2,6):
    d=sp.Poly(sp.diff(sp.legendre(n,x),x),x).nroots()
    print("extrema P_%d:"%n,[(round(float(v),4),round(float(sp.legendre(n,x).subs(x,v)),4)) for v in d])
print("== Case 2: Legendre coefficients of cos(pi x/2) with mpmath ==")
f=lambda t: mp.cos(mp.pi*t/2)
c=[]
for n in range(0,11):
    I=mp.quad(lambda t: f(t)*mp.legendre(n,t),[-1,0,1])
    c.append((2*n+1)*I/2)
    print("c_%d = %s"%(n, mp.nstr(c[-1],15)))
# max error of true partial sums, dense grid incl 500-pt grid of script and endpoints
import numpy as np
grid=[mp.mpf(-1)+2*mp.mpf(i)/499 for i in range(500)]
for N in range(0,9):
    errs=[abs(f(t)-sum(c[k]*mp.legendre(k,t) for k in range(N+1))) for t in grid]
    i=max(range(500),key=lambda j:errs[j])
    print("true S_%d max err on script grid = %s at x=%s"%(N,mp.nstr(errs[i],6),mp.nstr(grid[i],5)))
# least-squares check: residual of true S_8 orthogonal to P_0..P_8
S8=lambda t: sum(c[k]*mp.legendre(k,t) for k in range(9))
print("orthogonality of residual f-S_8 to P_k:",[mp.nstr(mp.quad(lambda t:(f(t)-S8(t))*mp.legendre(k,t),[-1,0,1]),3) for k in range(9)])
