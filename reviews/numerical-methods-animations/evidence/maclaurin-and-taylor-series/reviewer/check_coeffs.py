# Independent Taylor coefficients (sympy for elementary, mpmath.taylor at 50 digits for special functions)
# compared with the coefficients the script uses (script_coeffs.txt from coeffs_dump.jl).
import sys, os
import mpmath as mp
import sympy as sp
import numpy as np
mp.mp.dps = 50
here = os.path.dirname(os.path.abspath(__file__))
x = sp.symbols('x')
E = {
 'm01': 1/(1-x), 'm02': 1/(1+x), 'm03': 1/(1-x)**2, 'm04': 1/sp.sqrt(1-x), 'm05': 1/(1+x**2),
 'm06': sp.log(1+x), 'm07': sp.sin(x), 'm08': sp.cos(x), 'm09': sp.tan(x), 'm10': sp.exp(-x**2/2),
 'm11': sp.exp(-x)*sp.cos(x), 'm12': sp.cosh(x), 'm13': sp.atan(x), 'm14': sp.asin(x),
 'm17': sp.exp(-x**2/2)/sp.sqrt(2*sp.pi), 'm18': sp.Rational(1,2)+sp.erf(x/sp.sqrt(2))/2,
 't01': sp.sqrt(x), 't02': sp.sqrt(x), 't03': sp.sqrt(x), 't04': sp.log(x), 't05': sp.log(x),
 't06': sp.sin(x), 't07': sp.cos(x),
}
centers_exact = {'t06': sp.pi/4, 't07': sp.pi/3}
M = {
 'm15': lambda t: mp.besselj(0,t), 'm16': lambda t: mp.besselj(1,t),
 't08': mp.gamma, 't09': mp.gamma, 't10': mp.gamma,
 't11': lambda t: mp.besselj(0,t), 't12': lambda t: mp.besselj(1,t), 't13': lambda t: mp.bessely(0,t),
}
def exact_coeffs(cid, c, n):
    if cid in E:
        c0 = centers_exact.get(cid, sp.nsimplify(c))
        f = E[cid]
        out = []
        d = f
        for k in range(n+1):
            out.append(float(sp.N(d.subs(x, c0)/sp.factorial(k), 30)))
            d = sp.diff(d, x)
        return out
    return [float(v) for v in mp.taylor(M[cid], mp.mpf(c), n)]

rows = {}
for line in open(os.path.join(here, 'script_coeffs.txt')):
    p = line.split()
    cid, c, n = p[0], float(p[1]), int(p[2])
    xl = (float(p[3]), float(p[4])); yl = (float(p[5]), float(p[6]))
    a = [float(v) for v in p[7:]]
    rows[cid] = (c, n, xl, yl, a)

for cid,(c,n,xl,yl,a) in rows.items():
    ex = exact_coeffs(cid, c, n)
    rel = []
    for k,(s,e) in enumerate(zip(a,ex)):
        if abs(e) > 1e-14: rel.append(abs(s-e)/abs(e))
        else: rel.append(abs(s-e))
    worst = max(range(n+1), key=lambda k: rel[k])
    print(f"{cid} c={c:.4f} n={n}  max rel/abs coeff err={max(rel):.2e} at k={worst}")
    if cid.startswith('t') or max(rel) > 1e-12:
        for k in range(n+1):
            print(f"    k={k:2d} script={a[k]: .10e}  exact={ex[k]: .10e}  rel={rel[k]:.2e}")
    rows[cid] = rows[cid] + (ex,)

# Effect on the plotted curves: compare script partial sum vs exact partial sum on the 900-pt plot grid,
# both clamped to ylims as the script does; report max difference as % of y-range, and where.
print("\n=== plotted-curve difference (clamped), % of y-axis height, per order ===")
for cid,(c,n,xl,yl,a,ex) in rows.items():
    if not cid.startswith('t'): continue
    xs = np.linspace(xl[0], xl[1], 900)
    dx = xs - c
    out = []
    for k in range(n+1):
        ps = sum(a[j]*dx**j for j in range(k+1)); pe = sum(ex[j]*dx**j for j in range(k+1))
        d = np.abs(np.clip(ps,*yl)-np.clip(pe,*yl))/(yl[1]-yl[0])*100
        i = int(np.argmax(d)); out.append(f"k{k}:{d.max():.1f}%@x={xs[i]:.2f}")
    print(cid, " ".join(out))
