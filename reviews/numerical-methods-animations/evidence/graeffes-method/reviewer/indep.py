# Independent check: build p_m exactly via sympy from the definition
# p_{m+1}(x) = (-1)^n p_m(sqrt x) p_m(-sqrt x), verify roots = r^(2^m),
# compute separated-root estimates in exact/high precision.
import sympy as sp, mpmath as mp, numpy as np
mp.mp.dps=60
x,s=sp.symbols('x s')
cases={'aa':((x+1)*(x-2)*(x+3)*(x-4),[-1,2,-3,4],8),
       'ab':((x-1)*(x+2)*(x-5)**2,[1,-2,5,5],10)}
for name,(f,roots,M) in cases.items():
    print("=== case",name,"expanded:",sp.expand(f))
    p=sp.Poly(sp.expand(f),x); n=p.degree()
    tm=sorted([abs(r) for r in roots],reverse=True)
    print("numpy roots of p0:",np.roots([float(c) for c in p.all_coeffs()]))
    for m in range(M+1):
        c=p.all_coeffs()  # highest first
        # property check: exact polynomial with roots r^(2^m)
        target=sp.Poly(sp.expand(sp.prod([x-sp.Integer(r)**(2**m) for r in roots])),x)
        ok = (p==target)
        est=[mp.mpf(abs(sp.Rational(c[k+1],c[k])))**(mp.mpf(1)/2**m) for k in range(n)]
        if m<=3:
            nr=sorted(np.abs(np.roots([float(cc) for cc in c])),reverse=True)
            print(f"m={m} coeffs={c}\n   p_m == prod(x-r^2^m): {ok}; numpy |roots|^(1/2^m)={[float(v**(1/2**m)) for v in nr]}")
        else:
            print(f"m={m} p_m==prod: {ok}; maxabs coeff ~ 1e{max(len(str(abs(int(cc)))) for cc in c)-1}")
        print("   est=",[mp.nstr(e,17) for e in est], " relerr=",[mp.nstr((e-t)/t,3) for e,t in zip(est,tm)])
        # next squaring from definition
        q=sp.expand((-1)**n*p.as_expr().subs(x,s)*p.as_expr().subs(x,-s))
        p=sp.Poly(q.subs(s**2,x).subs(s,sp.sqrt(x)),x) if False else sp.Poly(sp.expand(q).subs(s,sp.sqrt(x)),x)
