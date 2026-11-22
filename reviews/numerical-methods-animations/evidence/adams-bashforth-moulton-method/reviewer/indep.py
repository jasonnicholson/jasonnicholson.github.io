# Independent checks: coefficients derived by integrating Lagrange interpolants (sympy),
# compared to script coefficients; independent ABM-PECE; reference via solve_ivp; stability interval.
import sympy as sp, numpy as np
from scipy.integrate import solve_ivp
s=sp.symbols('s')
def adams(nodes):  # nodes in units of h relative to t_n; integrate over [0,1]
    w=[]
    for j,a in enumerate(nodes):
        L=1
        for k,b in enumerate(nodes):
            if k!=j: L*= (s-b)/sp.Integer(a-b)
        w.append(sp.integrate(L,(s,0,1)))
    return w
ab=adams([0,-1,-2,-3]); am=adams([1,0,-1,-2])
print("AB derived *24:",[x*24 for x in ab]," script: 55,-59,37,-9")
print("AM derived *24:",[x*24 for x in am]," script: 9,19,-5,1")
# property: script coefficients integrate t^k exactly over [t_n,t_n+h]
abS=[sp.Rational(c,24) for c in (55,-59,37,-9)]; amS=[sp.Rational(c,24) for c in (9,19,-5,1)]
for k in range(6):
    ex=sp.integrate(s**k,(s,0,1))
    pa=sum(c*sp.Integer(n)**k for c,n in zip(abS,[0,-1,-2,-3]))
    pm=sum(c*sp.Integer(n)**k for c,n in zip(amS,[1,0,-1,-2]))
    print(f"f=s^{k} (y deg {k+1}): AB err={ex-pa}, AM err={ex-pm}")
# independent PECE
f=lambda t,y: 1-t*np.cbrt(y)
def rk4step(t,y,h):
    k1=f(t,y);k2=f(t+h/2,y+h/2*k1);k3=f(t+h/2,y+h/2*k2);k4=f(t+h,y+h*k3)
    return y+h/6*(k1+2*k2+2*k3+k4)
def abm(n,T=5.0,y0=1.0,passes=1,f=f):
    h=T/n; t=np.linspace(0,T,n+1); y=np.zeros(n+1); y[0]=y0
    for i in range(3):
        k1=f(t[i],y[i]);k2=f(t[i]+h/2,y[i]+h/2*k1);k3=f(t[i]+h/2,y[i]+h/2*k2);k4=f(t[i]+h,y[i]+h*k3)
        y[i+1]=y[i]+h/6*(k1+2*k2+2*k3+k4)
    a=[float(x) for x in ab]; b=[float(x) for x in am]
    for i in range(3,n):
        F=[f(t[i-j],y[i-j]) for j in range(4)]
        yp=y[i]+h*sum(a[j]*F[j] for j in range(4))
        for _ in range(passes):
            yp=y[i]+h*(b[0]*f(t[i+1],yp)+b[1]*F[0]+b[2]*F[1]+b[3]*F[2])
        y[i+1]=yp
    return t,y
t,y=abm(50)
sol=solve_ivp(lambda t,y: [1-t*np.cbrt(y[0])],(0,5),[1.0],method='Radau',rtol=1e-12,atol=1e-14,dense_output=True)
yr=sol.sol(t)[0]
for i in [0,10,20,30,33,40,45,47,48,49,50]:
    print(f"i={i:2d} t={t[i]:.1f} indepABM={y[i]: .10f} Radau={yr[i]: .10f}")
print("y(5) Radau:",yr[-1], " DOP853:", solve_ivp(lambda t,y: [1-t*np.cbrt(y[0])],(0,5),[1.0],method='DOP853',rtol=1e-13,atol=1e-15).y[0,-1])
# step halving on full problem and on smooth sub-interval [0,2]
for T in (2.0,5.0):
    yT=sol.sol(T)[0]; prev=None
    for n in (10,20,40,80,160,320):
        nn=int(n*T/2) if T==2.0 else n
        e=abs(abm(nn,T=T)[1][-1]-yT)
        print(f"T={T} n={nn:4d} err={e:.3e}" + (f" ratio={prev/e:.2f}" if prev else "")); prev=e
# known closed form: y'=-y+t+1 ... use y' = -2 t y, y=exp(-t^2) on [0,1]
g=lambda t,y: -2*t*y; prev=None
for n in (10,20,40,80,160):
    e=abs(abm(n,T=1.0,f=g)[1][-1]-np.exp(-1)); print(f"exp(-t^2) n={n} err={e:.3e}"+(f" ratio={prev/e:.2f}" if prev else "")); prev=e
# corrector passes check: compare 1 vs 2 passes final value
print("1 pass y(5)=",abm(50)[1][-1]," 2 passes y(5)=",abm(50,passes=2)[1][-1])
# PECE stability interval on negative real axis
def maxroot(z):
    a=[float(x) for x in ab]; b=[float(x) for x in am]
    # y_{n+1} = y_n + z*(b0*yp + b1 y_n + b2 y_{n-1} + b3 y_{n-2}), yp = y_n + z*sum a_j y_{n-j}
    # coefficients of y_n,y_{n-1},y_{n-2},y_{n-3}
    c=np.zeros(4); c[0]=1+z*b[1]; c[1]+=z*b[2]; c[2]+=z*b[3]
    pc=np.array([1,0,0,0.])+z*np.array(a); c+=z*b[0]*pc
    return max(abs(np.roots([1,-c[0],-c[1],-c[2],-c[3]])))
zs=np.linspace(-3,0,30001); st=[z for z in zs if maxroot(z)<=1+1e-12]
print("PECE real stability interval approx [",min(st),",0]")
