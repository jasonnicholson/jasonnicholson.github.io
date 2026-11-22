import numpy as np
from scipy.integrate import solve_ivp
import mpmath as mp
def cbrt(y): return np.cbrt(y)
def f(t,y): return 1 - t*np.cbrt(y)
def euler(h, T=5.0):
    n=int(round(T/h)); ts=np.linspace(0,T,n+1); ys=np.zeros(n+1); ys[0]=1
    for i in range(n): ys[i+1]=ys[i]+h*f(ts[i],ys[i])
    return ts,ys
def heun(h, T=5.0):
    n=int(round(T/h)); ts=np.linspace(0,T,n+1); ys=np.zeros(n+1); ys[0]=1
    for i in range(n):
        k1=f(ts[i],ys[i]); yp=ys[i]+h*k1; k2=f(ts[i+1],yp); ys[i+1]=ys[i]+h/2*(k1+k2)
    return ts,ys
# reference: Radau tight tol (stiff near y~0) and DOP853
ts=np.linspace(0,5,41)
r1=solve_ivp(lambda t,y:[f(t,y[0])],(0,5),[1.0],method='Radau',rtol=1e-12,atol=1e-14,t_eval=ts)
r2=solve_ivp(lambda t,y:[f(t,y[0])],(0,5),[1.0],method='DOP853',rtol=1e-13,atol=1e-15,t_eval=ts)
ref=r1.y[0]
print("Radau vs DOP853 max diff on grid:", np.max(abs(r1.y[0]-r2.y[0])))
# mpmath taylor reference at a few points
mp.mp.dps=30
sol=mp.odefun(lambda t,y: 1 - t*mp.cbrt(y), 0, 1)
for tt in [1,2,3,4,5]:
    print("mpmath y(%g)="%tt, mp.nstr(sol(tt),15), " Radau:", r1.y[0][int(tt*8)])
te,ye=euler(0.125); th,yh=heun(0.125)
print("\n k   t      Euler        Heun        ref        Eerr       Herr     hJ=h*df/dy(ref)")
for k in range(41):
    J=-ts[k]/(3*np.cbrt(ref[k])**2)
    print(f"{k:2d} {ts[k]:5.3f} {ye[k]: .6f} {yh[k]: .6f} {ref[k]: .6f} {ye[k]-ref[k]: .5f} {yh[k]-ref[k]: .5f} {0.125*J: .3f}")
print("max ref", ref.max(), "argmax t", ts[ref.argmax()])
fine=solve_ivp(lambda t,y:[f(t,y[0])],(0,5),[1.0],method='Radau',rtol=1e-12,atol=1e-14,dense_output=True)
tt=np.linspace(0,5,500001); yy=fine.sol(tt)[0]; print("ref peak", yy.max(), "at t", tt[yy.argmax()], " min ref", yy.min())
# convergence study
def refat(t): return fine.sol(t)[0]
print("\nconvergence: h, Euler err@t=2, Heun err@t=2, Euler err@5, Heun err@5, Euler maxerr, Heun maxerr")
for h in [0.25,0.125,0.0625,0.03125,0.015625,0.0078125,0.00390625,0.001953125]:
    a,b=euler(h); c,d=heun(h); R=refat(a)
    i2=int(round(2/h))
    print(f"{h:.6f} {b[i2]-R[i2]: .3e} {d[i2]-R[i2]: .3e} {b[-1]-R[-1]: .3e} {d[-1]-R[-1]: .3e} {np.max(abs(b-R)): .3e} {np.max(abs(d-R)): .3e}")
