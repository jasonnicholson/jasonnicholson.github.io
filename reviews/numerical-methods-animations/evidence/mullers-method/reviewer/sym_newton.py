import sympy as sp
x=sp.symbols('x')
for name,f,r in [('aa',x**3-3*x+2,1),('bb',sp.sin(x**2-2)*(x**2-2),sp.sqrt(2)),('cc',x**6-7*x**4+15*x**2-9,sp.sqrt(3))]:
    print(name,'factor:',sp.factor(f) if name!='bb' else '-', ' f(r)=',sp.simplify(f.subs(x,r)),' f\'(r)=',sp.simplify(sp.diff(f,x).subs(x,r)),' f\'\'(r)=',sp.simplify(sp.diff(f,x,2).subs(x,r)))
    if name!='bb': print('   real roots:',sp.real_roots(sp.Poly(f,x)))
    # Newton from the same p2, 8 steps
    fn=sp.lambdify(x,f,'mpmath'); dfn=sp.lambdify(x,sp.diff(f,x),'mpmath')
    import mpmath as mp; mp.mp.dps=50
    p=mp.mpf({'aa':'2.0','bb':'1.0','cc':'1.5'}[name]); errs=[]
    for k in range(8):
        p=p-fn(p)/dfn(p); errs.append(abs(p-mp.mpf(sp.N(r,60))))
    print('   Newton 8 steps errors:',[mp.nstr(e,3) for e in errs], ' last ratios:',[mp.nstr(errs[i+1]/errs[i],3) for i in range(5,7)])
print('f(2.2) case aa =', 2.2**3-3*2.2+2, ' f(2.1)=',2.1**3-3*2.1+2)
