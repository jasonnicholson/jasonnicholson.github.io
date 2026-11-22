import mpmath as mp
mp.mp.dps=30
f=lambda x: x**3+4*x**2-10
r=mp.findroot(f,1.36)
print("root",r, "f(1.3688)=",f(mp.mpf('1.3688')), "f(1.3652)=",f(mp.mpf('1.3652')))
import numpy as np
fl=lambda x: x**3+4*x**2-10
a,b=1.0,2.0; cs=[]
for i in range(12):
    c=(a+b)/2; cs.append(c)
    if fl(a)*fl(c)<0: b=c
    else: a=c
for i,c in enumerate(cs,1): print(i, c, float(c-r), "f(c)=%.4g"%fl(c))
d=np.diff(cs); print("diffs signs", np.sign(d))
print("final bracket",a,b)
