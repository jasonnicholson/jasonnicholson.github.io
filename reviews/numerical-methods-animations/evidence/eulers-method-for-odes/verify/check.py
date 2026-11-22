import numpy as np, mpmath as mp
from scipy.integrate import solve_ivp
cbrt=np.cbrt
f=lambda t,y: 1-t*cbrt(y)
# high-accuracy reference: Radau tight tol, plus mpmath odefun check
sol=solve_ivp(lambda t,y:[1-t*np.cbrt(y[0])],(0,5),[1.0],method='Radau',rtol=1e-12,atol=1e-14,dense_output=True)
mp.mp.dps=30
g=mp.odefun(lambda t,y: 1-t*mp.cbrt(y),0,mp.mpf(1))
h=0.125; ts=np.linspace(0,5,41)
ye=np.zeros(41); yh=np.zeros(41); ye[0]=yh[0]=1
for i in range(40):
    ye[i+1]=ye[i]+h*f(ts[i],ye[i])
    k1=f(ts[i],yh[i]); k2=f(ts[i+1],yh[i]+h*k1); yh[i+1]=yh[i]+h/2*(k1+k2)
print(" i     t     true        Euler      Heun      e_err     h_err")
for i in range(41):
    yt=sol.sol(ts[i])[0]
    print(f"{i:2d} {ts[i]:5.3f} {yt: .6f} {ye[i]: .6f} {yh[i]: .6f} {ye[i]-yt: .2e} {yh[i]-yt: .2e}")
print("mpmath y(5)=",g(5), "radau y(5)=",sol.sol(5)[0])
# stability: J=-t/(3 y^(2/3)) along true solution, h*J
for t in [2,3,3.5,3.75,4,4.5,5]:
    yt=sol.sol(t)[0]; print(t, "h*J=",h*(-t/(3*yt**(2/3))))
# convergence order of Euler/Heun at t=5 and at t=2 with smaller h
for n in [40,80,160,320,640,1280,2560]:
    hh=5/n; t=np.linspace(0,5,n+1); a=1.0;b=1.0
    for i in range(n):
        a=a+hh*f(t[i],a); k1=f(t[i],b); k2=f(t[i+1],b+hh*k1); b=b+hh/2*(k1+k2)
    print(n, hh, "Euler err", a-sol.sol(5)[0], "Heun err", b-sol.sol(5)[0])
