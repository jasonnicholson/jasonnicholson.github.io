import numpy as np, sympy as sp, mpmath as mp
from scipy.integrate import solve_ivp
# ---- Case 1 exact solution check
t=sp.symbols('t'); y=sp.tan(t+sp.atan(sp.Rational(1,2)))
print("case1 residual y'-(1+y^2):", sp.simplify(sp.diff(y,t)-(1+y**2)), " y(0)=", y.subs(t,0))
print("case1 pole at t =", float(sp.pi/2-sp.atan(sp.Rational(1,2))), " y(1.1)=", float(y.subs(t,sp.Rational(11,10))))
print("case1 y=20 reached at t =", float(sp.atan(20)-sp.atan(sp.Rational(1,2))))
# ---- Case 2 reference
f=lambda t,y: 1 - t*np.cbrt(y)
sol=solve_ivp(f,(0,5),[1.0],method='DOP853',rtol=1e-13,atol=1e-15,dense_output=True)
print("case2 solve_ivp y(5)=%.15f  (script RK4 h=1e-4 ref: 0.008119920464867961)"%sol.sol(5)[0])
# compare script ref (sampled every 1000 points) to solve_ivp
d=np.loadtxt("ref_bb.txt"); print("case2 max |RK4ref - solve_ivp| on samples:", np.max(np.abs(d[:,1]-sol.sol(d[:,0])[0])))
tt=np.linspace(0,5,5001); yy=sol.sol(tt)[0]
print("case2 min y on [0,5] = %.6g at t=%.3f"%(yy.min(), tt[yy.argmin()]))
yp=1-tt*np.cbrt(yy); J=-tt/(3*np.cbrt(yy)**2)
i=np.argmin(yp); print("case2 steepest slope y'=%.4f at t=%.3f (y=%.4f)"%(yp[i],tt[i],yy[i]))
ipk=np.argmax(yy); print("case2 peak y=%.6f at t=%.4f"%(yy[ipk],tt[ipk]))
for tq in (1.0,2.0,2.35,2.6,3.0,3.3,4.0,5.0):
    k=int(round(tq*1000)); print("   t=%.2f y=%.5f y'=%.4f df/dy=%.2f"%(tq,yy[k],yp[k],J[k]))
# RKF points vs reference
L=open("pts_bb.txt").read().split("\n")
for nm,a,b in (("RKF45",L[0],L[1]),("RKF54",L[2],L[3])):
    ts=np.array(list(map(float,a.split(",")))); ys=np.array(list(map(float,b.split(","))))
    e=np.abs(ys-sol.sol(ts)[0]); h=np.diff(ts)
    print(nm,"max |y-ref| at accepted pts = %.3e (at t=%.3f); final err=%.3e"%(e.max(),ts[e.argmax()],e[-1]))
    print(nm,"h at hmax=0.25 for t in [%.2f,%.2f]; min h=%.4f at t=%.3f"%(ts[np.where(np.isclose(h,0.25))[0][0]], ts[np.where(np.isclose(h,0.25))[0][-1]+1], h.min(), ts[h.argmin()]))
    # chord deviation: max distance between polyline and true curve
    tf=np.linspace(0,5,50001); poly=np.interp(tf,ts,ys); dev=np.abs(poly-sol.sol(tf)[0]); j=dev.argmax()
    print(nm,"max |polyline - ref| = %.4f at t=%.3f"%(dev[j],tf[j]))
