import mpmath as mp
mp.mp.dps=60
def run(x0,n=200):
    x=mp.mpf(x0)
    for i in range(n):
        x = x-mp.atan(x)*(1+x**2)
        if abs(x)>1e6: return 'diverge'
        if abs(x)<mp.mpf('1e-40'): return 'converge'
    return 'undecided |x|=%s'%mp.nstr(abs(x),5)
for x0 in ['0.5','1.0','1.39','1.3917','1.39174','1.39175','1.3918','1.4','2.0']:
    print(x0, run(x0))
# Float64 roundoff floor for expanded polynomials near x=1
import numpy as np
for k,(c) in {'double':[1,0,-3,2],'triple':[1,-1,-3,5,-2]}.items():
    xs=1+np.linspace(-2e-5,2e-5,20001)
    vals=np.polyval(c,xs)
    print(k,'max |f| for |x-1|<2e-5 in float64 (Horner):',np.abs(vals).max())
