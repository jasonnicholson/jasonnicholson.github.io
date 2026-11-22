# Long-run secant on x*exp(-x) from 1.5, 2.0: does it go to infinity, and how fast?
import mpmath as mp
mp.mp.dps=60
f=lambda x:x*mp.e**(-x)
ps=[mp.mpf('1.5'),mp.mpf(2)]
for _ in range(2000):
    a,b=ps[-2],ps[-1]; ps.append(b-f(b)*(b-a)/(f(b)-f(a)))
for n in [10,16,50,100,500,1000,2000]:
    print(n, mp.nstr(ps[n],8), 'step', mp.nstr(ps[n]-ps[n-1],6))
print('ln2 =', mp.nstr(mp.log(2),6))
