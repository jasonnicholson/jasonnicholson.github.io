import mpmath as mp
mp.mp.dps=40
f=lambda x: mp.e**(-x)*mp.sin(8*mp.cbrt(x)**2)+1
# substitution x=t^3 removes the singularity: dx=3t^2 dt
I=mp.quad(lambda t: f(t**3)*3*t**2,[0,mp.cbrt(2)/2,mp.cbrt(2)])
I2=mp.quad(f,[0,0.001,0.01,0.1,0.5,1,2])
print("I =",I,"  check",I2)
import numpy as np
def fs(x): return np.exp(-x)*np.sin(8*np.cbrt(x)**2)+1
def S(n):
    x=np.linspace(0,2,n+1); y=fs(x); h=2/n
    return h/3*(y[0]+y[-1]+4*y[1:-1:2].sum()+2*y[2:-1:2].sum())
Iref=float(I)
anim=[2,4,6,8,10,12,14,16,18,20,24,28,32,36,40,44,48,56,64,72,84,96,108]
print("animation n: n, S_n (round 6), err")
for n in anim: print(n, round(S(n),6), S(n)-Iref)
print("doubling n: n, err, observed order log2(e_n/e_2n)")
prev=None
for k in range(1,22):
    n=2**k; e=abs(S(n)-Iref)
    print(n, e, "" if prev is None else np.log2(prev/e)); prev=e
# log-log fit over animation range n=12..108
ns=np.array(anim[5:]); es=np.abs([S(n)-Iref for n in ns])
p=np.polyfit(np.log(ns),np.log(es),1); print("fit slope over anim n=12..108:",p[0])
ns=np.array([2**k for k in range(8,21)]); es=np.abs([S(n)-Iref for n in ns])
p=np.polyfit(np.log(ns),np.log(es),1); print("fit slope n=256..2^20:",p[0])
# control: smooth integrand e^-x sin(8x)+1
g=lambda x: np.exp(-x)*np.sin(8*x)+1
Ig=2+float(mp.quad(lambda x: mp.e**(-x)*mp.sin(8*x),[0,2]))
def Sg(n):
    x=np.linspace(0,2,n+1); y=g(x); h=2/n
    return h/3*(y[0]+y[-1]+4*y[1:-1:2].sum()+2*y[2:-1:2].sum())
print("control smooth: ",[np.log2(abs(Sg(n)-Ig)/abs(Sg(2*n)-Ig)) for n in [16,32,64,128]])
