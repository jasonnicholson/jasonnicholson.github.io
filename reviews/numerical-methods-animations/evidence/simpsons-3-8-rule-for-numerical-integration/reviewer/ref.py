import mpmath as mp
mp.mp.dps=40
f=lambda x: mp.e**(-x)*mp.sin(8*mp.cbrt(x)**2)+1
I=mp.quad(f,[0,mp.mpf('0.001'),mp.mpf('0.1'),0.5,1,1.5,2],maxdegree=12)
# substitution x=t^3 removes singularity: dx=3t^2 dt, t in [0, 2^(1/3)]
g=lambda t: f(t**3)*3*t**2
I2=mp.quad(g,[0,mp.cbrt(2)/2,mp.cbrt(2)])
print(mp.nstr(I,30)); print(mp.nstr(I2,30)); print(mp.nstr(I-I2,5))
def s38(n):
    h=mp.mpf(2)/n
    s=f(0)+f(2)
    for i in range(1,n):
        s+= (2 if i%3==0 else 3)*f(i*h)
    return 3*h/8*s
ns=[3,6,9,12,15,18,21,24,27,30,33,36,42,48,54,60,66,72,81,90,99,108,120]
prev=None
for n in ns:
    S=s38(n); e=S-I2
    print(n, n+1, mp.nstr(S,12), mp.nstr(e,6))
print("halving ratios")
import math
for n in [12,24,48,96,192,384,768,1536,3072]:
    e1=s38(n)-I2; e2=s38(2*n)-I2
    print(n, mp.nstr(e1,6), mp.nstr(e1/e2,6), mp.nstr(mp.log(abs(e1/e2),2),5))
