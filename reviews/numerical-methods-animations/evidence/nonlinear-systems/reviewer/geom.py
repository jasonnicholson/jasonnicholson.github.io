# Geometry of the zero curves, signs at the starting points, Newton-map Jacobian,
# and a counterexample to "row-sum violated => diverges".
import sympy as sp, numpy as np
x, y = sp.symbols('x y', real=True)
f1 = 1 - 4*x + 2*x**2 - 2*y**3
f2 = -4 + x**4 + 4*y + 4*y**4
# f2 = 0  <=>  4y^4 + 4y = 4 - x^4 ; h(y)=4y^4+4y has a single minimum
ymin = -sp.Rational(1,4)**sp.Rational(1,3)
hmin = 4*ymin**4 + 4*ymin
xmax = (4 - hmin)**sp.Rational(1,4)
print("h min at y =", float(ymin), " value", float(hmin), " => f2=0 spans |x| <=", float(xmax))
for xv in [0, 0.5, 1.0, 1.5, 1.55]:
    ys = [complex(r) for r in sp.Poly(f2.subs(x, xv), y).nroots()]
    print(" x=", xv, " real y on f2=0:", sorted(round(r.real,4) for r in ys if abs(r.imag)<1e-12))
print(" f2=0 y-range: x=0 gives y in", [round(float(r),4) for r in sp.Poly(f2.subs(x,0),y).real_roots()])
print(" f1=0 is the graph y = cbrt(x^2-2x+1/2); its minimum y =", float(-sp.Rational(1,2)**sp.Rational(1,3)), "at x=1")
for p in [(0.5,0.8),(2,-1)]:
    print("start", p, "f1 =", float(f1.subs({x:p[0],y:p[1]})), "f2 =", float(f2.subs({x:p[0],y:p[1]})),
          "; f1=0 at x:", round(float(sp.real_root(p[0]**2-2*p[0]+sp.Rational(1,2),3)),4),
          "; f2=0 at x:", sorted(round(complex(r).real,4) for r in sp.Poly(f2.subs(x,p[0]),y).nroots() if abs(complex(r).imag)<1e-12))
# Newton map N(X) = X - J^{-1} F ; its Jacobian at each solution
J = sp.Matrix([f1,f2]).jacobian([x,y])
N = sp.Matrix([x,y]) - J.inv()*sp.Matrix([f1,f2])
DN = N.jacobian([x,y])
for s in [(0.06177012633860737, 0.7244905153472166),(1.556097484322053,-0.5756507696188434)]:
    print("Newton-map Jacobian at", s, ":", np.array(DN.subs({x:s[0],y:s[1]}).evalf(), dtype=float).round(12).tolist())
# Counterexample: G(x,y) = (0.6x + 0.6y + 0.05 sin y, 0.1y); row 1 sum ~1.25 > 1 at fixed point (0,0)
import math
Xk = np.array([5.0, -3.0])
for k in range(60):
    Xk = np.array([0.6*Xk[0] + 0.6*Xk[1] + 0.05*math.sin(Xk[1]), 0.1*Xk[1]])
print("row sums at (0,0):", 0.6+0.65, 0.1, " spectral radius:", max(abs(np.linalg.eigvals([[0.6,0.65],[0,0.1]]))), " after 60 iters from (5,-3):", Xk)
