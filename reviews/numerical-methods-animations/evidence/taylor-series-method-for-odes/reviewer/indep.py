# Independent check: sympy total derivatives, own Taylor methods, scipy reference
import sympy as sp, numpy as np, mpmath as mp
from scipy.integrate import solve_ivp
t, y = sp.symbols('t y', positive=True)
f = 1 - t*y**sp.Rational(1,3)
D = [f]
for k in range(4):   # y'' .. y'''''
    D.append(sp.simplify(sp.diff(D[-1], t) + sp.diff(D[-1], y)*f))
# script's hand-coded formulas
yp = y**sp.Rational(1,3)
d1 = 1 - t*yp
d2 = -yp - t*sp.Rational(1,3)*y**sp.Rational(-2,3)*d1
d3 = -sp.Rational(2,3)*y**sp.Rational(-2,3)*d1 - t*(sp.Rational(-2,9)*y**sp.Rational(-5,3)*d1**2 + sp.Rational(1,3)*y**sp.Rational(-2,3)*d2)
print("y''  diff:", sp.simplify(D[1]-d2))
print("y''' diff:", sp.simplify(D[2]-d3))
print("y''' =", sp.simplify(D[2]))
print("y''''=", sp.simplify(D[3]))
Fs = [sp.lambdify((t,y), d, 'mpmath') for d in D]
mp.mp.dps = 30
def taylor(p, h, n, t0=0, y0=1):
    tt, yy = mp.mpf(t0), mp.mpf(y0); out=[yy]
    for i in range(n):
        if yy <= 0: out.append(mp.nan); yy = mp.nan; tt += h; continue
        s = yy; fac = 1
        for k in range(1, p+1):
            fac *= k
            s += mp.mpf(h)**k/fac * Fs[k-1](tt, yy)
        yy = s; tt += h; out.append(yy)
    return out
def rhs(tv, yv): return [1 - tv*np.cbrt(yv[0])]
ts = np.linspace(0,5,21)
ref = solve_ivp(rhs, (0,5), [1.0], method='Radau', rtol=1e-13, atol=1e-15, t_eval=ts, dense_output=True)
ref2 = solve_ivp(rhs, (0,5), [1.0], method='LSODA', rtol=1e-12, atol=1e-14, t_eval=ts)
y3 = taylor(3, mp.mpf(1)/4, 20); y4 = taylor(4, mp.mpf(1)/4, 20)
print("\n i   t     ref(Radau)        ref(LSODA)        myT3              myT4")
for i in range(21):
    print(f"{i:2d} {ts[i]:.2f} {ref.y[0][i]: .12e} {ref2.y[0][i]: .12e} {float(y3[i]): .12e} {float(y4[i]): .12e}")
np.save('ref.npy', ref.y[0])
# residual check of reference via dense output
tt = np.linspace(0,5,2001); Y = ref.sol(tt)[0]
dY = np.gradient(Y, tt, edge_order=2)
print("\nmax |y' - f| (central diff on dense output, interior):", np.max(np.abs(dY - (1-tt*np.cbrt(Y)))[5:-5]), " y(0)=", Y[0])
print("min ref y on [0,5]:", Y.min(), " 1/t^3 at 5:", 1/125)
# stability: h * df/dy along reference
J = -tt/(3*np.cbrt(Y)**2)
for tv in [2,2.5,3,3.25,3.5,4,4.5,5]:
    k = np.argmin(abs(tt-tv)); print(f"t={tv}: h*df/dy = {0.25*J[k]:.3f}")
