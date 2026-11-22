# Independent checks of the difference formulas (sympy + mpmath), not reusing script code.
import sympy as sp
x,h=sp.symbols('x h'); F=sp.Function('f')
fx=sp.exp(-x)*sp.sin(x)

# formulas as stencils {offset: weight}, divisor
forms={
 'D1_3 (aa,ab)': ({-1:-1,1:1}, 2*h, 1),
 'D1_5 (ab)':    ({-2:1,-1:-8,1:8,2:-1}, 12*h, 1),
 'D2_3 (ac)':    ({-1:1,0:-2,1:1}, h**2, 2),
 'D2_5 (ac)':    ({-2:-1,-1:16,0:-30,1:16,2:-1}, 12*h**2, 2),
}
x0=sp.Symbol('x0')
for name,(st,div,d) in forms.items():
    print('==',name)
    # exactness on monomials (x-x0)^k at x0
    for k in range(0,8):
        p=lambda t: t**k
        approx=sp.simplify(sum(w*(o*h)**k for o,w in st.items())/div)
        exact=sp.diff(x**k,x,d).subs(x,0)
        print(f'  deg {k}: approx={approx}, exact={exact}, ok={sp.simplify(approx-exact)==0}')
    # leading error term via Taylor
    N=9
    ser=sum(sp.Symbol(f'f{j}')*(sp.Symbol('s')*h)**j/sp.factorial(j) for j in range(N))
    expr=sp.expand(sum(w*ser.subs(sp.Symbol('s'),o) for o,w in st.items())/div - sp.Symbol(f'f{d}'))
    print('  approx - exact =', sp.collect(sp.expand(expr),h))

# derive coefficients by solving the Taylor moment linear systems (as the page describes)
for d in (1,2):
    for offs in ([-1,0,1],[-2,-1,0,1,2]):
        c=sp.symbols(f'c0:{len(offs)}')
        eqs=[sp.Eq(sum(ci*o**k for ci,o in zip(c,offs)), sp.factorial(k) if k==d else 0) for k in range(len(offs))]
        sol=sp.solve(eqs,c)
        print(f'derived d={d} offs={offs}:',[sol[ci] for ci in c],'(times 1/h^%d)'%d)

# derivatives of f
for k in range(1,7):
    print(f'f^({k}) =', sp.simplify(sp.diff(fx,x,k)))
print("script fp check:", sp.simplify(sp.diff(fx,x)-sp.exp(-x)*(sp.cos(x)-sp.sin(x))))
print("script fpp check:", sp.simplify(sp.diff(fx,x,2)-(-2*sp.exp(-x)*sp.cos(x))))
