# Independent reference for y' = 1 - t*cbrt(y), y(0)=1 and comparison to script values
import numpy as np, sympy as sp
from scipy.integrate import solve_ivp
f = lambda t, y: 1.0 - t*np.cbrt(y)
tg = np.linspace(0, 5, 21)
refs = {}
for m in ("DOP853", "Radau", "LSODA"):
    s = solve_ivp(f, (0, 5), [1.0], method=m, t_eval=tg, rtol=1e-13, atol=1e-15, dense_output=False)
    refs[m] = s.y[0]
ref = refs["Radau"]
print("max |DOP853-Radau| =", np.max(abs(refs["DOP853"]-ref)), " max |LSODA-Radau| =", np.max(abs(refs["LSODA"]-ref)))
# script values (from rk4_instrumented.jl)
script = [1.000000000000,1.217261493199,1.364817475116,1.439579343628,1.442167782035,1.376530529812,1.249867171399,1.072774219434,0.859592956388,0.628962825693,0.404508207676,0.215072729545,0.091358363059,0.049982570222,0.097496161329,0.122104252151,0.134210286985,0.156742459303,0.245697127909,0.160332548976,0.289107407190]
print(" t     script(RK4 h=.25)  reference        abs err     1/t^3")
for t, s, r in zip(tg, script, ref):
    print(f"{t:4.2f}  {s:.10f}  {r:.10f}  {abs(s-r):.2e}  {(1/t**3 if t>0 else float('inf')):.5f}")
# independent RK4 from sympy-derived Butcher tableau check: order conditions for classical RK4
A = sp.Matrix([[0,0,0,0],[sp.Rational(1,2),0,0,0],[0,sp.Rational(1,2),0,0],[0,0,1,0]])
b = sp.Matrix([sp.Rational(1,6),sp.Rational(1,3),sp.Rational(1,3),sp.Rational(1,6)])
c = sp.Matrix([0,sp.Rational(1,2),sp.Rational(1,2),1])
C = sp.diag(*c)
conds = {"sum b=1": sum(b), "b.c=1/2": (b.T*c)[0], "b.c^2=1/3": (b.T*C*c)[0], "b.Ac=1/6": (b.T*A*c)[0],
         "b.c^3=1/4": (b.T*C*C*c)[0], "b.C.A.c=1/8": (b.T*C*A*c)[0], "b.A.c^2=1/12": (b.T*A*C*c)[0], "b.A.A.c=1/24": (b.T*A*A*c)[0],
         "row sums=c": list(A*sp.ones(4,1) - c)}
for k,v in conds.items(): print(k, "->", v)
# Linear stability: RK4 amplification R(z)=1+z+z^2/2+z^3/6+z^4/24; real stability boundary
z = sp.symbols('z'); R = 1+z+z**2/2+z**3/6+z**4/24
print("RK4 real stability limit:", [sp.N(r) for r in sp.solve(sp.Eq(R, -1), z) if sp.im(sp.N(r))==0 and sp.N(r) < 0])
# h*df/dy along the reference solution
h = 0.25
for t, r in zip(tg, ref):
    if t>0: print(f"t={t:4.2f}  h*df/dy = {-h*t/(3*np.cbrt(r)**2):8.3f}")
