import mpmath as mp, numpy as np
mp.mp.dps=40
f=lambda x: mp.e**(-x)*mp.sin(8*mp.cbrt(x)**2)+1
# substitution x=t^3 removes singularity
I=mp.quad(lambda t: f(t**3)*3*t**2,[0,0.5,1,mp.cbrt(2)])
I2=mp.quad(f,[0,0.1,0.5,1,2])
print("I =",I, " check", I2)
def S(n):
    h=mp.mpf(2)/n
    s=f(0)+f(2)
    for i in range(1,n):
        s+= (2 if i%3==0 else 3)*f(i*h)
    return 3*h/8*s
seq=[3,6,9,12,15,18,21,24,27,30,33,36,42,48,54,60,66,72,81,90,99,108,120]
errs=[]
for n in seq:
    e=S(n)-I; errs.append(abs(e)); print(n, mp.nstr(S(n),10), mp.nstr(e,5))
print("observed order, animation sequence endpoints 3->120:", float(mp.log(errs[0]/errs[-1])/mp.log(120/3)))
print("60->120:", float(mp.log(errs[seq.index(60)]/errs[-1])/mp.log(2)))
prev=None
for n in [3*2**k for k in range(0,13)]:
    e=abs(S(n)-I)
    if prev: print(n, mp.nstr(e,5), "order", float(mp.log(prev/e)/mp.log(2)))
    prev=e
# smooth check: g = e^-x sin(8x)+1 shows O(h^4)
g=lambda x: mp.e**(-x)*mp.sin(8*x)+1
Ig=mp.quad(g,[0,2])
def Sg(n):
    h=mp.mpf(2)/n; return 3*h/8*sum((1 if i in(0,n) else (2 if i%3==0 else 3))*g(i*h) for i in range(n+1))
p=None
for n in [24,48,96,192,384]:
    e=abs(Sg(n)-Ig)
    if p: print("smooth",n,mp.nstr(e,5),float(mp.log(p/e)/mp.log(2)))
    p=e
