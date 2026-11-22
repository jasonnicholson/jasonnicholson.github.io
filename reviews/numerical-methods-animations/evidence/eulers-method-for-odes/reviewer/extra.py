import numpy as np, mpmath as mp
from scipy.integrate import solve_ivp
f=lambda t,y: 1-t*np.cbrt(y)
fine=solve_ivp(lambda t,y:[f(t,y[0])],(0,5),[1.0],method='Radau',rtol=1e-12,atol=1e-14,dense_output=True)
# script's RK4 reference replicated independently? -> compare via Julia dump instead; here local truncation error
mp.mp.dps=30
sol=mp.odefun(lambda t,y: 1 - t*mp.cbrt(y), 0, 1)
print("local error one step from (0,1): h, Euler LTE, Heun LTE")
prev=None
for h in [0.2,0.1,0.05,0.025,0.0125]:
    ex=sol(h); e=1+h*1 - ex
    k1=1; yp=1+h; k2=1-h*mp.cbrt(yp); hh=1+h/2*(k1+k2)-ex
    print(h, mp.nstr(e,6), mp.nstr(hh,6), "" if prev is None else (mp.nstr(prev[0]/e,4), mp.nstr(prev[1]/hh,4)))
    prev=(e,hh)
# Heun segment slope check
ts=np.linspace(0,5,41); d=np.loadtxt("iterates_inst_bb.jl.txt")[:,1]; h=0.125
k1=f(ts[:-1],d[:-1]); k2=f(ts[1:],d[:-1]+h*k1)
print("Heun max|segment slope-(k1+k2)/2|", np.max(abs(np.diff(d)/h-(k1+k2)/2)))
# where h*df/dy crosses -2 along the true solution
tt=np.linspace(0.01,5,200000); yy=fine.sol(tt)[0]; z=-0.125*tt/(3*np.cbrt(yy)**2)
print("h*df/dy = -2 first at t =", tt[np.argmax(z<-2)], " y there", yy[np.argmax(z<-2)])
print("true solution min on [0,5]:", yy.min(), "(stays positive)")
