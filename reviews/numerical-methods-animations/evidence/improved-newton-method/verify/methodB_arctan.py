from mpmath import mp, mpf, atan
mp.dps=50
f=lambda x: atan(x); fp=lambda x: 1/(1+x**2); fpp=lambda x: -2*x/(1+x**2)**2
print("Method B (Newton on u=f/f'): x - f f'/(f'^2 - f f'')")
x=mpf('1.4')
for i in range(8):
    print(i, mp.nstr(x,20)); x = x - f(x)*fp(x)/(fp(x)**2 - f(x)*fpp(x))
print("Method A m=1 is plain Newton; C m-search from 1.4:")
x=mpf('1.4')
for m in range(1,5):
    print(m, mp.nstr(x - m*f(x)/fp(x),10))
# Basin of Method B: scan starting points
import numpy as np
bad=[]
for x0 in np.linspace(-50,50,2001):
    x=mpf(x0)
    for i in range(60):
        d=(fp(x)**2 - f(x)*fpp(x))
        x = x - f(x)*fp(x)/d
    if abs(x)>1e-20: bad.append(x0)
print("Method B starting points in [-50,50] failing to converge:", bad[:10], len(bad))
