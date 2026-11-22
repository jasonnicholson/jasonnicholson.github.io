# Independent RK4 (own code) vs tight reference for candidate step counts; also confirms script's n=20 values
import numpy as np
from scipy.integrate import solve_ivp
f = lambda t, y: 1.0 - t*np.cbrt(y)
def rk4(n):
    h=5/n; t=0.0; y=1.0; ts=[t]; ys=[y]; mn=np.inf
    for i in range(n):
        k1=f(t,y); k2=f(t+h/2,y+h/2*k1); k3=f(t+h/2,y+h/2*k2); k4=f(t+h,y+h*k3)
        mn=min(mn,y+h/2*k1,y+h/2*k2,y+h*k3)
        y=y+h/6*(k1+2*k2+2*k3+k4); t=t+h; ts.append(t); ys.append(y)
    return np.array(ts), np.array(ys), mn
for n in (20,40,60,80,100):
    ts, ys, mn = rk4(n)
    ref = solve_ivp(f,(0,5),[1.0],method="Radau",t_eval=ts,rtol=1e-13,atol=1e-15).y[0]
    e = abs(ys-ref); i=np.argmax(e)
    print(f"n={n:4d} h={5/n:.4f} y(5)={ys[-1]:.6f} ref={ref[-1]:.6f} maxerr={e.max():.2e} at t={ts[i]:.3f}  min stage y={mn:.4f}")
