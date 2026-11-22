import sys, mpmath as mp
from fractions import Fraction
mp.mp.dps = 40
f = lambda x: 1 + mp.exp(-x)*mp.sin(8*mp.cbrt(x)**2)
# true integral, tanh-sinh handles x^(2/3) endpoint behaviour; split for oscillation
I1 = mp.quad(f, [0, 0.25, 0.5, 1, 1.5, 2], method='tanh-sinh')
# cross-check by substitution x = u^3 (removes the fractional power): dx = 3u^2 du
g = lambda u: f(u**3)*3*u**2
I2 = mp.quad(g, mp.linspace(0, mp.cbrt(2), 9), method='gauss-legendre')
print("I tanh-sinh  =", mp.nstr(I1, 20))
print("I u=x^(1/3)  =", mp.nstr(I2, 20))
I = I1
print("trap ref error =", mp.nstr(mp.mpf('2.016279706128') - I, 5))
# read script's nodes/weights
data = {}
for line in open(sys.argv[1]):
    n,t,w = line.split(); data.setdefault(int(n), []).append((mp.mpf(t), mp.mpf(w)))
for n, tw in sorted(data.items()):
    maxres = max(abs(mp.legendre(n, t)) for t,_ in tw)
    # exactness: int_{-1}^1 t^k = 2/(k+1) for even k, 0 odd
    def err(k):
        exact = mp.mpf(2)/(k+1) if k%2==0 else 0
        return abs(sum(w*t**k for t,w in tw) - exact)
    maxe = max(err(k) for k in range(0, 2*n))
    print(f"n={n:2d} max|P_n(t_i)|={mp.nstr(maxres,3)}  max err deg0..{2*n-1}={mp.nstr(maxe,3)}  err deg {2*n}={mp.nstr(err(2*n),6)}")
    # independent nodes/weights with mpmath: roots of P_n, w = 2/((1-t^2) P_n'(t)^2)
    ref = []
    for t,_ in tw:
        r = mp.findroot(lambda x: mp.legendre(n, x), t)
        dp = mp.diff(lambda x: mp.legendre(n, x), r)
        ref.append((r, 2/((1-r**2)*dp**2)))
    print("      max|t-t_ref|=", mp.nstr(max(abs(a[0]-b[0]) for a,b in zip(tw,ref)),3),
          " max|w-w_ref|=", mp.nstr(max(abs(a[1]-b[1]) for a,b in zip(tw,ref)),3),
          " distinct roots:", len(set(mp.nstr(r[0],12) for r in ref))==n)
# independent I_n with mpmath gauss nodes (own computation)
def gl(n):
    import numpy as np
    t,w = np.polynomial.legendre.leggauss(n)
    return mp.fsum(mp.mpf(wi)*f(1+mp.mpf(ti)) for ti,wi in zip(t,w))
for n in [2,3,5,8,12,16,20,28,36,44,56,64]:
    In = gl(n); print(f"n={n:2d} I_n(numpy leggauss)={mp.nstr(In,13)}  err={mp.nstr(In-I,4)}")
