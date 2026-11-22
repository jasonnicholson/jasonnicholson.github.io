import numpy as np, mpmath as mp
from scipy.integrate import solve_ivp
cbrt=np.cbrt
f=lambda t,y: 1.0 - t*cbrt(y)
def rk4(n,T=5.0):
    h=T/n; t=0.0; y=1.0; ts=[t]; ys=[y]
    for i in range(n):
        k1=h*f(t,y);k2=h*f(t+h/2,y+k1/2);k3=h*f(t+h/2,y+k2/2);k4=h*f(t+h,y+k3)
        y=y+(k1+2*k2+2*k3+k4)/6; t=t+h; ts.append(t); ys.append(y)
    return np.array(ts),np.array(ys)
# reference: stiff implicit solver at tight tol + mpmath taylor check
ref=solve_ivp(lambda t,y:[1-t*np.cbrt(y[0])],(0,5),[1.0],method='Radau',rtol=1e-12,atol=1e-14,dense_output=True)
mp.mp.dps=30
g=mp.odefun(lambda t,y: 1-t*mp.cbrt(y),0,mp.mpf(1))
for tt in [1,2,3,4,5]:
    print('ref t=%d radau=%.12g mpmath=%s nullcline 1/t^3=%.6g'%(tt,ref.sol(tt)[0],mp.nstr(g(tt),14),1/tt**3))
ts,ys=rk4(20)
print('\nscript RK4 n=20 (h=0.25):')
print(' t      rk4           ref           err      h*J (J=-t/(3y^(2/3)) at ref)')
for t,y in zip(ts,ys):
    r=ref.sol(t)[0]; J=-t/(3*r**(2/3)) if t>0 else 0
    print('%4.2f %13.6f %13.8f %10.3e %8.3f'%(t,y,r,y-r,0.25*J))
print('\nerror at selected t vs n, and halving ratios')
ns=[20,40,80,160,320,640]
for tt in [1.0,2.0,3.0,4.0,5.0]:
    errs=[]
    for n in ns:
        ts,ys=rk4(n); k=int(round(tt/(5/n))); errs.append(abs(ys[k]-ref.sol(tt)[0]))
    print('t=%.0f'%tt,' '.join('%.2e'%e for e in errs),' ratios',' '.join('%.1f'%(errs[i]/errs[i+1]) for i in range(len(errs)-1)))
# max error over [0,1], [0,2], ...
print('\nmax |err| on [0,t1] for n=20,40,80')
for t1 in [1,2,3,3.25,5]:
    out=[]
    for n in [20,40,80,160]:
        ts,ys=rk4(n); m=ts<=t1+1e-12; out.append(np.max(np.abs(ys[m]-ref.sol(ts[m])[0])))
    print(t1,' '.join('%.2e'%e for e in out),' ratios',' '.join('%.1f'%(out[i]/out[i+1]) for i in range(3)))
# RK4 real-axis stability limit
import scipy.optimize as so
R=lambda z:1+z+z**2/2+z**3/6+z**4/24
zs=so.brentq(lambda z:abs(R(z))-1,-3,-2.5); print('\nRK4 real stability boundary z=',zs)
# t where h*J crosses it along ref
tg=np.linspace(0.5,5,100001); r=ref.sol(tg)[0]; hj=0.25*(-tg/(3*np.abs(r)**(2/3)))
print('h*J crosses boundary at t=',tg[np.argmax(hj<zs)])
# nullcline check: is y=1/t^3 a solution? residual of y'=f
t=np.array([1,2,3,4,5.]); print('d/dt(1/t^3)=',-3/t**4,' f on nullcline=',f(t,1/t**3))
