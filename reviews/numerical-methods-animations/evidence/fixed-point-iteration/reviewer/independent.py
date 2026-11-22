# Independent check (sympy exact fixed points/derivatives, mpmath 40-digit unclamped iterates)
import sympy as sp, mpmath as mp
mp.mp.dps = 40
x = sp.symbols('x', real=True)
cases = {
 'aa': (sp.sqrt(2*x), sp.Rational(1,10), 12),
 'bb': (sp.sqrt(2*x), sp.Rational(38,10), 12),
 'cc': (8/(x+2), sp.Integer(1), 12),
 'dd': (x**2/4 + x/2, sp.Rational(3,2), 8),
 'ee': (x**2/4 + x/2, sp.Rational(5,2), 8),
 'ff': (-x**2/4 - x/2 + 4, sp.Rational(3,2), 10),
}
for k,(g,x0,n) in cases.items():
    fps = sp.solve(sp.Eq(g, x), x)
    dg = sp.diff(g, x)
    print(f"== {k}: g={g}, x0={x0}")
    for p in fps:
        print(f"   fixed point {p}: g'={sp.nsimplify(dg.subs(x,p))}")
    # tangency check at 2: g(2)-2 and g'(2)-1
    print(f"   g(2)={g.subs(x,2)}, g'(2)={dg.subs(x,2)}")
    f = sp.lambdify(x, g, 'mpmath')
    xs=[mp.mpf(x0.p)/x0.q]
    for i in range(n): xs.append(f(xs[-1]))
    print("   unclamped:", [mp.nstr(v,8) for v in xs])
    s = [mp.sign(v-2) for v in xs]
    print("   side of 2 :", ''.join('+' if t>0 else '-' if t<0 else '0' for t in s))
# long-run behaviour of ff and dd
f = lambda t: -t*t/4 - t/2 + 4
t = mp.mpf('1.5'); seq=[t]
for i in range(20):
    t = f(t); seq.append(t)
print("ff 20 steps:", [mp.nstr(v,6) for v in seq])
f = lambda t: t*t/4 + t/2
t = mp.mpf('1.5'); seq=[t]
for i in range(40): t=f(t); seq.append(t)
print("dd 40 steps tail:", [mp.nstr(v,6) for v in seq[-5:]], "ratio x40/x39", mp.nstr(seq[-1]/seq[-2],8))
