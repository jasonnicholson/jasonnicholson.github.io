import sympy as sp, mpmath as mp
x=sp.symbols('x')
f=x**3-3*x+2
print("factor f:", sp.factor(f))
for r in sp.roots(f).items(): print("root, multiplicity (sympy.roots):", r)
print("f(1), f'(1), f''(1):", f.subs(x,1), sp.diff(f,x).subs(x,1), sp.diff(f,x,2).subs(x,1))
h=sp.simplify(f/sp.diff(f,x)); print("h = f/f' simplified:", sp.factor(h))
print("page h (x-1)(x+2)/(3(x+1)) equal?:", sp.simplify(h-(x-1)*(x+2)/(3*(x+1)))==0)
# Newton on h vs page formula
fp=sp.diff(f,x); fpp=sp.diff(f,x,2)
newton_h = x - h/sp.diff(h,x)
page = x - f*fp/(fp**2 - f*fpp)
print("Newton on h == page Method-B formula?:", sp.simplify(newton_h-page)==0)
print("h'(1) =", sp.limit(sp.diff(h,x),x,1), " (nonzero => simple root of h)")
# error constants
e=sp.symbols('e')
for name,phi in [("plain", x - f/fp), ("accel m=2", x-2*f/fp), ("modified", page)]:
    E=sp.series(sp.simplify(phi.subs(x,1+e))-1, e, 0, 3).removeO()
    print(name, " e_{n+1} series in e_n:", sp.expand(E))
mp.mp.dps=60
F=lambda t: t**3-3*t+2; FP=lambda t: 3*t**2-3; FPP=lambda t: 6*t
steps={"plain(aa)":(lambda t: t-F(t)/FP(t),12),
       "accel m=2(bb)":(lambda t: t-2*F(t)/FP(t),5),
       "modified(cc)":(lambda t: t-F(t)*FP(t)/(FP(t)**2-F(t)*FPP(t)),4)}
for name,(phi,n) in steps.items():
    xs=[mp.mpf('1.2')]
    for i in range(n): xs.append(phi(xs[-1]))
    es=[t-1 for t in xs]
    print("\n==",name)
    for k,t in enumerate(xs):
        line=f"n={k:2d} x={mp.nstr(t,17):>22} e={mp.nstr(es[k],6):>14}"
        if k>=1 and es[k-1]!=0: line+=f" e_n/e_(n-1)={mp.nstr(es[k]/es[k-1],6):>10} e_n/e_(n-1)^2={mp.nstr(es[k]/es[k-1]**2,6):>10}"
        if k>=2 and abs(es[k])>0: line+=f" p_est={mp.nstr(mp.log(abs(es[k]/es[k-1]))/mp.log(abs(es[k-1]/es[k-2])),5)}"
        print(line)
