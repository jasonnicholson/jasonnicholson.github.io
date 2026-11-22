import mpmath as mp
mp.mp.dps=40
f=lambda x: 1+mp.e**(-x)*mp.sin(8*mp.cbrt(x)**2)
# substitution x=t^3 removes singularity
I=mp.quad(lambda t: f(t**3)*3*t**2,[0,mp.cbrt(2)])
I2=mp.quad(f,[0,0.5,1,2])
print("I =",I, " check", I2)
def boole(n):
    h=mp.mpf(2)/n; s=0
    for i in range(0,n,4):
        x=[i*h+k*h for k in range(5)]
        s+=2*h/45*(7*f(x[0])+32*f(x[1])+12*f(x[2])+32*f(x[3])+7*f(x[4]))
    return s
ns=[4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,64,72,80,88,96,104,112,120]
prev=None
for n in ns:
    e=boole(n)-I
    s=f"n={n:4d} B={mp.nstr(boole(n),12)} err={mp.nstr(e,6)}"
    if prev: s+=f"  local order={mp.nstr(mp.log(abs(prev[1]/e))/mp.log(mp.mpf(n)/prev[0]),4)}"
    print(s); prev=(n,e)
import numpy as np
ns2=[16,32,64,128,256,512,1024,2048,4096]
errs=[boole(n)-I for n in ns2]
for k in range(1,len(ns2)):
    print(ns2[k], mp.nstr(errs[k],6), "order", mp.nstr(mp.log(abs(errs[k-1]/errs[k]))/mp.log(2),4))
# fit over animation range
x=np.log([float(n) for n in ns[3:]]); y=np.log([abs(float(boole(n)-I)) for n in ns[3:]])
print("LS slope n=16..120:", np.polyfit(x,y,1)[0])
