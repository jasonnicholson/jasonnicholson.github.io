import sympy as sp, mpmath as mp
mp.mp.dps = 400
x,t = sp.symbols('x t')
cases = {'aa/ab: x^2-2': (x**2-2, sp.Rational(2), sp.sqrt(2)),
         'ba: x^3-3x+2': (x**3-3*x+2, sp.Rational(-11,5), sp.Integer(-2))}
for name,(f,x0,root) in cases.items():
    fp, fpp, fppp = [sp.diff(f,x,k) for k in (1,2,3)]
    print('==',name,' f\'=',fp,' f\'\'=',fpp, ' factor:', sp.factor(f))
    F = sp.lambdify(x,f,'mpmath'); Fp=sp.lambdify(x,fp,'mpmath'); Fpp=sp.lambdify(x,fpp,'mpmath')
    r = mp.mpf(sp.N(root,400))
    # asymptotic constant from page formula
    C = abs(fppp.subs(x,root)/(6*fp.subs(x,root)) - fpp.subs(x,root)**2/(4*fp.subs(x,root)**2))
    print(' page C =', sp.nsimplify(C), float(C))
    for meth in ('newton','halley'):
        xn = mp.mpf(sp.N(x0,400)); errs=[]
        seq=[]
        for k in range(7):
            seq.append(xn); errs.append(xn-r)
            if meth=='newton': xn = xn - F(xn)/Fp(xn)
            else:
                a,b,c = F(xn),Fp(xn),Fpp(xn); xn = xn - 2*a*b/(2*b*b - a*c)
        print(' ',meth)
        for k in range(7):
            e=errs[k]
            s = f'   k={k} x={mp.nstr(seq[k],17)} e={mp.nstr(e,5)}'
            if k>=2 and errs[k-1]!=0 and errs[k-2]!=0:
                p = mp.log(abs(e/errs[k-1]))/mp.log(abs(errs[k-1]/errs[k-2]))
                s += f' order={mp.nstr(p,6)}'
            if meth=='halley' and k>=1: s += f' e_k/e_(k-1)^3={mp.nstr(e/errs[k-1]**3,8)}'
            print(s)
    # Taylor parabola root vs Halley root vs osculating hyperbola root at x0 and x1
    for xc in [x0] + ([sp.Rational(10,7)] if root==sp.sqrt(2) else []):
        a,b,c = [g.subs(x,xc) for g in (f,fp,fpp)]
        P = a + b*t + c/2*t**2
        proots = [sp.N(xc+rt,15) for rt in sp.solve(P,t)]
        halley = sp.N(xc - 2*a*b/(2*b**2-a*c),15)
        # osculating hyperbola (a0+a1 t)/(1+b1 t)
        b1 = -c/(2*b); a1 = b + a*b1
        H = (a + a1*t)/(1+b1*t)
        ser = sp.series(H,t,0,3).removeO()
        print(f'  at xn={xc}: Taylor-parabola roots {proots}; Halley {halley}; hyperbola root {sp.N(xc - a/a1,15)}; hyperbola matches Taylor to O(t^2): {sp.simplify(sp.expand(ser - P))==0}')
        print(f'    parabola - f identically zero? {sp.simplify(sp.expand(P.subs(t,x-xc)-f))==0}')
# symbolic check of C for general f via series of iteration map
y=sp.symbols('y'); c1,c2,c3,c4=sp.symbols('c1:5')
e=sp.symbols('e')
g = c1*e + c2*e**2 + c3*e**3 + c4*e**4  # f(root+e)
gp, gpp = sp.diff(g,e), sp.diff(g,e,2)
enew = e - 2*g*gp/(2*gp**2 - g*gpp)
print('general e_{n+1} series:', sp.simplify(sp.series(enew,e,0,4).removeO()))
print('page C (signed) in these coeffs: f\'\'\'/(6f\') - f\'\'^2/(4f\'^2) =', sp.simplify((6*c3)/(6*c1) - (2*c2)**2/(4*c1**2)))
# multiple root m=2 rate
m=2
g2 = (e**2)*(1+e); gp2=sp.diff(g2,e); gpp2=sp.diff(g2,e,2)
print('double root: e_{n+1}/e_n ->', sp.limit((e - 2*g2*gp2/(2*gp2**2-g2*gpp2))/e, e, 0))
