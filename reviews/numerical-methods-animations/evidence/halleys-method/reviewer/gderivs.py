import sympy as sp
x=sp.symbols('x')
for f,r in [(x**2-2,sp.sqrt(2)),(x**3-3*x+2,-2)]:
    g = sp.simplify(x - 2*f*sp.diff(f,x)/(2*sp.diff(f,x)**2 - f*sp.diff(f,x,2)))
    gn = x - f/sp.diff(f,x)
    print(f, 'Halley g =', sp.factor(g), '| g1,g2 at root:', [sp.simplify(sp.diff(g,x,k).subs(x,r)) for k in (1,2)], '| g3/6 =', sp.nsimplify(sp.simplify(sp.diff(g,x,3).subs(x,r)/6)),
          '| Newton g2/2 =', sp.nsimplify(sp.simplify(sp.diff(gn,x,2).subs(x,r)/2)))
