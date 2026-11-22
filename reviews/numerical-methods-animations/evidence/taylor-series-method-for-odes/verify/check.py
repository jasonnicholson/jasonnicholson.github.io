import numpy as np, sympy as sp, mpmath as mp
from scipy.integrate import solve_ivp
t,y=sp.symbols('t y',real=True)
f=1-t*sp.cbrt(y)  # y>0 branch
D=[f]
for k in range(3):
    g=D[-1]; D.append(sp.simplify(sp.diff(g,t)+sp.diff(g,y)*f))
# cube root valid for negative y too (real cbrt)
mods=[{'cbrt':np.cbrt},'numpy']
def realcbrt(x): return np.cbrt(x)
Dn=[sp.lambdify((t,y),d.subs(sp.cbrt(y),sp.Symbol('c')).subs(sp.Symbol('c'),sp.Function('cb')(y)),modules=[{'cb':np.cbrt},'numpy']) for d in D]
# script formulas
def s_d1(t,y): return 1-t*np.cbrt(y)
def s_d2(t,y): return -np.cbrt(y)-t/3*np.cbrt(y)**-2*s_d1(t,y)
def s_d3(t,y):
    d1=s_d1(t,y); d2=s_d2(t,y); c=np.cbrt(y)
    return -(2/3)*c**-2*d1 - t*((-2/9)*c**-5*d1**2+(1/3)*c**-2*d2)
def s_d4fd(t,y,h):
    e=h*1e-5; return (s_d3(t+e,y+e*s_d1(t,y))-s_d3(t,y))/e
# check script derivatives vs sympy at random points
rng=np.random.default_rng(0)
mx=[0,0,0]
for _ in range(200):
    tt=rng.uniform(0,5); yy=rng.uniform(0.005,2)
    for k,(a,b) in enumerate([(s_d1,Dn[0]),(s_d2,Dn[1]),(s_d3,Dn[2])]):
        mx[k]=max(mx[k],abs(a(tt,yy)-b(tt,yy))/max(1,abs(b(tt,yy))))
print("max rel diff script vs sympy d1,d2,d3:",mx)
def taylor(p,n,T=5.0,fd=False):
    h=T/n; ts=[0.0]; ys=[1.0]
    for i in range(n):
        tt,yy=ts[-1],ys[-1]
        d=[Dn[k](tt,yy) for k in range(p)]
        if fd and p==4: d[3]=s_d4fd(tt,yy,h)
        ys.append(yy+sum(h**(k+1)/np.math.factorial(k+1)*d[k] if hasattr(np,'math') else 0 for k in range(p)))
        ts.append(tt+h)
    return np.array(ts),np.array(ys)
import math
def taylor(p,n,T=5.0,fd=False,T0=0.0,y0=1.0):
    h=(T-T0)/n; ts=[T0]; ys=[y0]
    for i in range(n):
        tt,yy=ts[-1],ys[-1]
        d=[Dn[k](tt,yy) for k in range(p)]
        if fd and p==4: d[3]=s_d4fd(tt,yy,h)
        ys.append(yy+sum(h**(k+1)/math.factorial(k+1)*d[k] for k in range(p)))
        ts.append(tt+h)
    return np.array(ts),np.array(ys)
# reference with mpmath odefun (high precision)
mp.mp.dps=30
sol=mp.odefun(lambda tt,yy: 1-tt*mp.cbrt(yy),0,1)
ref=lambda tt: float(sol(tt))
tg=np.linspace(0,5,21)
yr=np.array([ref(x) for x in tg])
t3,y3=taylor(3,20); t4,y4=taylor(4,20); t4f,y4f=taylor(4,20,fd=True)
print("t   ref   T3   T4exact   T4fd   err3  err4fd")
for i in range(21):
    print(f"{tg[i]:.2f} {yr[i]:.6f} {y3[i]:.6f} {y4[i]:.6f} {y4f[i]:.6f} {y3[i]-yr[i]:+.2e} {y4f[i]-yr[i]:+.2e}")
print("max |T4exact - T4fd| over steps up to t=4:",np.max(np.abs(y4[:17]-y4f[:17])), " all:",np.max(np.abs(y4-y4f)))
# stability: h*df/dy along reference
h=0.25
for x,yy in zip(tg,yr):
    J=-x/(3*np.cbrt(yy)**2)
    print(f"t={x:.2f} h*J={h*J:.3f}")
z=sp.symbols('z')
for p in (3,4):
    R=sum(z**k/sp.factorial(k) for k in range(p+1))
    roots=[r for r in sp.nroots(R**2-1) if abs(sp.im(r))<1e-12 and sp.re(r)<-0.1]
    print("order",p,"real stability boundary",roots)
# convergence orders on [0,2] (smooth, non-stiff) and full [0,5] with fine h
for T in (2.0,5.0):
    yT=ref(T)
    for p,fd in ((3,False),(4,False),(4,True)):
        ns=[40,80,160,320] if T==2 else [80,160,320,640]
        errs=[abs(taylor(p,n,T=T,fd=fd)[1][-1]-yT) for n in ns]
        ords=[math.log2(errs[i]/errs[i+1]) for i in range(len(errs)-1)]
        print(f"T={T} p={p} fd={fd} errs={['%.2e'%e for e in errs]} orders={['%.2f'%o for o in ords]}")
# error comparisons early: max error on [0,3] for h=0.25
print("max |err| on t<=3: T3",np.max(np.abs(y3[:13]-yr[:13])),"T4fd",np.max(np.abs(y4f[:13]-yr[:13])))
print("max |err| on t<=4: T3",np.max(np.abs(y3[:17]-yr[:17])),"T4fd",np.max(np.abs(y4f[:17]-yr[:17])))
# smaller step stable?
for n in (30,40,50):
    a=taylor(3,n)[1]; b=taylor(4,n,fd=True)[1]
    print(n, "T3 end",a[-1],"min",a.min(),"T4 end",b[-1],"min",b.min(),"ref",ref(5))
