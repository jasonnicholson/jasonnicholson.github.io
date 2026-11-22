import sympy as sp
x,h,t=sp.symbols('x h t',real=True)
x0=sp.pi/4
f=sp.cos
# independent: Lagrange interpolant through x0-h,x0,x0+h
P=sp.interpolate([(x0-h,f(x0-h)),(x0,f(x0)),(x0+h,f(x0+h))],x)
Pt=sp.expand(sp.simplify(P.subs(x,x0+t)))
c=[sp.simplify(Pt.coeff(t,k)) for k in range(3)]
print("secant coeffs about x0:",c)
lim=[sp.limit(ck,h,0) for ck in c]
print("limits h->0:",lim)
T2=f(x0)+sp.diff(f(x),x).subs(x,x0)*t+sp.diff(f(x),x,2).subs(x,x0)/2*t**2
print("T2:",sp.expand(T2))
# property: T2 matches f,f',f'' at x0
T2x=T2.subs(t,x-x0)
for k in range(3):
    print("deriv",k, sp.simplify(sp.diff(T2x,x,k).subs(x,x0)-sp.diff(f(x),x,k).subs(x,x0)))
print("3rd deriv differs:", sp.diff(T2x,x,3), sp.diff(f(x),x,3).subs(x,x0))
# leading-order error of coefficients
for k in range(3):
    print("c%d - lim series:"%k, sp.series(c[k]-lim[k],h,0,5))
import numpy as np
hs=np.exp(np.linspace(np.log(1.0),np.log(0.01),18))
cf=[sp.lambdify(h,ck) for ck in c]
xp=np.linspace(np.pi/4-1.5,np.pi/4+1.5,500)
T2f=sp.lambdify(t,T2)
for hv in hs:
    cv=[float(g(hv)) for g in cf]
    tt=xp-np.pi/4
    Pv=cv[0]+cv[1]*tt+cv[2]*tt**2
    print("h=%.6f c=(%.12f, %.12f, %.12f) maxdev=%.6e"%(hv,*cv,np.max(np.abs(Pv-T2f(tt)))))
