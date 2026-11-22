import mpmath as mp
mp.mp.dps=30
f=lambda x: mp.e**(-x)*mp.sin(8*mp.cbrt(x)**2)+1
fp=lambda x: mp.diff(f,x)
a,b=mp.mpf(0),mp.mpf(2)
# integral: substitute to handle x^(2/3)
I=mp.quad(f,[0,0.01,0.1,0.5,1,2])
print("I =",I)
# critical points: roots of f' on (0,2]; scan finely
import numpy as np
xs=np.linspace(1e-9,2,200001)
fv=lambda x: np.exp(-x)*np.sin(8*np.cbrt(x)**2)+1
dfn=lambda x: -np.exp(-x)*np.sin(8*np.cbrt(x)**2)+np.exp(-x)*np.cos(8*np.cbrt(x)**2)*(16/3)*x**(-1/3)
d=dfn(xs)
crit=[]
for i in np.where(np.sign(d[:-1])!=np.sign(d[1:]))[0]:
    crit.append(mp.findroot(fp,(mp.mpf(xs[i]),mp.mpf(xs[i+1])),solver='anderson'))
print("critical points:",[mp.nstr(c,10) for c in crit],[mp.nstr(f(c),10) for c in crit])
ns=[1,2,3,4,5,6,7,8,10,12,14,16,20,24,28,32,40,48,56,64,72,88,104,120]
rows=[]
for n in ns:
    dx=(b-a)/n
    Le=Ue=Lt=Ut=0
    for i in range(1,n+1):
        xl=a+(i-1)*dx; xr=a+i*dx
        cand=[f(xl),f(xr)]+[f(c) for c in crit if xl<c<xr]
        Le+=min(f(xl),f(xr)); Ue+=max(f(xl),f(xr))
        Lt+=min(cand); Ut+=max(cand)
    rows.append((n,Le*dx,Lt*dx,Ue*dx,Ut*dx))
print(f"{'n':>4} {'endpt_min':>10} {'true_lower':>10} {'endpt_max':>10} {'true_upper':>10}  Lmin>I  Umax<I")
for n,Le,Lt,Ue,Ut in rows:
    print(f"{n:4d} {float(Le):10.6f} {float(Lt):10.6f} {float(Ue):10.6f} {float(Ut):10.6f}  {str(Le>I):6} {str(Ue<I):6}")
# monotonicity
import itertools
Le=[r[1] for r in rows]; Ue=[r[3] for r in rows]
print("endpt-min decreases at:",[(ns[k],ns[k+1]) for k in range(len(ns)-1) if Le[k+1]<Le[k]])
print("endpt-max increases at:",[(ns[k],ns[k+1]) for k in range(len(ns)-1) if Ue[k+1]>Ue[k]])
Lt=[r[2] for r in rows]; Ut=[r[4] for r in rows]
print("true-lower decreases at:",[(ns[k],ns[k+1]) for k in range(len(ns)-1) if Lt[k+1]<Lt[k]])
print("true-upper increases at:",[(ns[k],ns[k+1]) for k in range(len(ns)-1) if Ut[k+1]>Ut[k]])
# brute-force cross-check of true sums with dense sampling for a few n
for n in [1,3,7,16]:
    dx=2/n; s1=s2=0
    for i in range(n):
        t=np.linspace(i*dx,(i+1)*dx,200001); v=fv(t); s1+=v.min(); s2+=v.max()
    print("dense check n=",n,s1*dx,s2*dx)
