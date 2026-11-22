import numpy as np
from scipy.integrate import solve_ivp
f=lambda t,y: 1-t*np.cbrt(y)
t=np.linspace(0,5,50001)
s=solve_ivp(f,(0,5),[1.0],t_eval=t,rtol=1e-12,atol=1e-14,method='DOP853')
y=s.y[0]; yp=f(t,y)
i=np.argmax(np.abs(yp)); print("max |y'| =%.4f at t=%.3f"%(abs(yp[i]),t[i]))
d=yp.copy()
for k in range(2,6):
    d=np.gradient(d,t)
    m=slice(500,-500); j=np.argmax(np.abs(d[m]))+500
    print("max |y^(%d)| = %.3g at t=%.3f"%(k,abs(d[j]),t[j]))
