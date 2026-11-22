import mpmath as mp
mp.mp.dps=40
f=lambda x: mp.e**(-x)*mp.sin(8*mp.cbrt(x)**2)+1
I=mp.quad(f,mp.linspace(0,2,41),maxdegree=10)
# second check: substitution x=t^3 removes singularity
I2=mp.quad(lambda t: f(t**3)*3*t**2,[0,mp.cbrt(2)])
print("I =",mp.nstr(I,25)); print("I2=",mp.nstr(I2,25))
def M(n):
    h=mp.mpf(2)/n
    return h*mp.fsum(f((i+mp.mpf(1)/2)*h) for i in range(n))
seq=[1,2,3,4,5,6,7,8,10,12,14,16,20,24,28,32,40,48,56,64,72,88,104,120]
for n in seq: print(n, mp.nstr(M(n),10), mp.nstr(M(n)-I,6))
print("halving ratios")
prev=None
for n in [10,20,40,80,160,320,640,1280,2560,5120,10240,20480]:
    e=M(n)-I
    if prev is not None: print(n, mp.nstr(e,6), "ratio", mp.nstr(prev/e,6), "p=", mp.nstr(mp.log(abs(prev/e),2),5))
    else: print(n, mp.nstr(e,6))
    prev=e
# local max of f
xm=mp.findroot(lambda x: mp.diff(f,x), 0.08); print("max at",xm,f(xm))
