# Independent check: Jacobian (sympy), Newton iterates (mpmath 50 digits),
# all real solutions (resultant + findroot from many starts), convergence rate.
import sympy as sp, mpmath as mp, itertools
mp.mp.dps = 50
x, y = sp.symbols('x y')
f1 = 1 - 4*x + 2*x**2 - 2*y**3
f2 = -4 + x**4 + 4*y + 4*y**4
J = sp.Matrix([f1, f2]).jacobian([x, y])
print("sympy Jacobian:", J)
Jscript = sp.Matrix([[4*x-4, -6*y**2], [4*x**3, 4+16*y**3]])
print("diff vs script:", sp.simplify(J - Jscript))

# All real solutions: resultant in y -> polynomial in x
R = sp.Poly(sp.resultant(f1, f2, y), x)
print("resultant degree:", R.degree())
rr = [r for r in sp.Poly(R, x).nroots(n=30, maxsteps=200) if abs(sp.im(r)) < 1e-20]
sols = []
for xr in rr:
    xr = sp.re(xr)
    py = sp.Poly(f1.subs(x, xr), y)
    for yr in py.nroots(n=30):
        if abs(sp.im(yr)) < 1e-20:
            yr = sp.re(yr)
            if abs(f2.subs({x: xr, y: yr})) < 1e-15:
                sols.append((float(xr), float(yr)))
print("real solutions from resultant:", sols)

F = [sp.lambdify((x, y), f, 'mpmath') for f in (f1, f2)]
Jf = sp.lambdify((x, y), J, 'mpmath')
# findroot from many starts
found = set()
import numpy as np
for a in np.linspace(-3, 3, 25):
    for b in np.linspace(-3, 3, 25):
        try:
            r = mp.findroot([lambda u, v: F[0](u, v), lambda u, v: F[1](u, v)], (a, b))
            found.add((round(float(r[0]), 10), round(float(r[1]), 10)))
        except Exception:
            pass
print("findroot distinct real roots:", sorted(found))

def newton(p0, n=8):
    p = mp.matrix(p0)
    pts = [p]
    for k in range(n):
        Jm = mp.matrix(Jf(p[0], p[1]).tolist())
        Fv = mp.matrix([F[0](p[0], p[1]), F[1](p[0], p[1])])
        p = p - mp.lu_solve(Jm, Fv)
        pts.append(p)
    return pts

for p0 in [(0.5, 0.8), (2.0, -1.0)]:
    pts = newton(p0, 10)
    s = pts[-1]
    Js = mp.matrix(Jf(s[0], s[1]).tolist())
    print(f"\nstart {p0}: limit = ({mp.nstr(s[0],15)}, {mp.nstr(s[1],15)}), det J* = {mp.nstr(mp.det(Js),8)}")
    errs = []
    for k, p in enumerate(pts[:9]):
        e = mp.norm(p - s)
        errs.append(e)
        print(f"  k={k}: ({mp.nstr(p[0],12)}, {mp.nstr(p[1],12)})  round4=({round(float(p[0]),4)}, {round(float(p[1]),4)})  err={mp.nstr(e,4)}")
    for k in range(1, 6):
        if errs[k] > 0 and errs[k-1] > 0 and errs[k+1] > 0:
            print(f"  e{k+1}/e{k}^2 = {mp.nstr(errs[k+1]/errs[k]**2,5)}")
