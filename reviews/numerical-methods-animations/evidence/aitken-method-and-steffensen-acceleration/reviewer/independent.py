# Independent check: Newton, Steffensen (restart from each Aitken value, applied to Newton map),
# and plain Aitken Delta^2 of the Newton sequence; exact (mpmath 60 digits) and IEEE double.
import sympy as sp, mpmath as mp
mp.mp.dps = 120
x = sp.symbols('x')
cases = {
 'aitkenab': (x**3-3*x+2, sp.Integer(1), 2.0, 7),
 'aitkencd': ((x**2-2)*sp.sin(x**2-2), sp.sqrt(2), 1.0, 5),
 'aitkenef': (x**6-7*x**4+15*x**2-9, sp.sqrt(3), 1.5, 6),
}
for name,(f,p,x0,ns) in cases.items():
    print('=====',name)
    df = sp.diff(f,x)
    print('factor f:', sp.factor(f), ' f(p)=',sp.simplify(f.subs(x,p)),' f\'(p)=',sp.simplify(df.subs(x,p)),' f\'\'(p)=',sp.simplify(sp.diff(f,x,2).subs(x,p)))
    print('sympy df =', sp.expand(df) if f.is_polynomial(x) else df)
    fm = sp.lambdify(x,f,'mpmath'); dfm = sp.lambdify(x,df,'mpmath')
    pm = mp.mpf(sp.N(p,70))
    g = lambda t: t - fm(t)/dfm(t)
    # Newton exact
    xs=[mp.mpf(x0)]
    for i in range(22): xs.append(g(xs[-1]))
    print('Newton exact: k, x_k, err, ratio')
    for k,v in enumerate(xs):
        e=abs(v-pm); r = e/abs(xs[k-1]-pm) if k else 0
        if k in (0,1,2,3,4,10,20,21,22): print('  %2d %s %.6e %.6f'%(k, mp.nstr(v,17), float(e), float(r)))
    # Steffensen exact
    s=[mp.mpf(x0)]
    for i in range(ns):
        a=s[-1]; q1=g(a); q2=g(q1); den=q2-2*q1+a
        if den==0: s.append(a); continue
        s.append(a-(q1-a)**2/den)
    print('Steffensen exact: n, x, err, log10err')
    for n,v in enumerate(s):
        e=abs(v-pm); print('  %d %s %.6e %.3f'%(n, mp.nstr(v,17), float(e), float(mp.log10(e)) if e>0 else -999))
    # Aitken Delta^2 of the Newton sequence (no restart), exact
    print('Aitken D2 of Newton sequence (exact), first 6: err')
    print('  ', ['%.2e'%float(abs(xs[k]-(xs[k+1]-xs[k])**2/(xs[k+2]-2*xs[k+1]+xs[k])-pm)) for k in range(6)])
    # double precision, expanded form as in script (python floats)
    import math
    fd = sp.lambdify(x,f,'math'); dfd = sp.lambdify(x,df,'math')
    gd = lambda t: t - fd(t)/dfd(t)
    s=[x0]
    for i in range(ns):
        a=s[-1]; q1=gd(a); q2=gd(q1); den=q2-2*q1+a
        if abs(den)<1e-15: s.append(a); print('   (double) denom=%r at step %d, f(a)=%r'%(den,i+1,fd(a))); continue
        s.append(a-(q1-a)**2/den)
    print('Steffensen double (sympy-lambdified f): errs', ['%.3e'%abs(v-float(sp.N(p,20))) for v in s])
