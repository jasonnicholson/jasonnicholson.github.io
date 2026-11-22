# Independent check: weights derived by solving moment equations with sympy (no remembered tables),
# reference integral by mpmath, composite rules in mpmath, error ratios.
import sympy as sp, mpmath as mp
mp.mp.dps = 40
x = sp.symbols('x')
def nc_weights(m):
    # closed NC on nodes 0..m (unit spacing), weights w_j with sum w_j t^k = int_0^m t^k
    w = sp.symbols('w0:%d'%(m+1))
    eqs = [sp.Eq(sum(w[j]*sp.Integer(j)**k for j in range(m+1)), sp.Rational(m**(k+1), k+1)) for k in range(m+1)]
    s = sp.solve(eqs, w)
    return [s[wi] for wi in w]
def dop(m, W):
    d = 0
    for k in range(0, 12):
        q = sum(W[j]*sp.Integer(j)**k for j in range(m+1))
        if q != sp.Rational(m**(k+1),k+1): return k-1
    return 11
for m in [1,2,3,4]:
    W = nc_weights(m)
    print('m=%d weights (times h):'%m, W, ' degree of precision:', dop(m,W))
# script tables: trapezoid h*(1/2,1/2); simpson h/3*(1,4,1); 3/8: 3h/8*(1,3,3,1); boole 2h/45*(7,32,12,32,7)
print('script tables:', [sp.Rational(1,2)]*2, [sp.Rational(1,3)*c for c in (1,4,1)], [sp.Rational(3,8)*c for c in (1,3,3,1)], [sp.Rational(2,45)*c for c in (7,32,12,32,7)])
f = lambda t: mp.e**(-t)*mp.sin(8*mp.cbrt(t)**2)+1
I = mp.quad(f, mp.linspace(0,2,41))
# cross-check with substitution t=u^3 removing singularity: dx = 3u^2 du
I2 = mp.quad(lambda u: 3*u**2*(mp.e**(-u**3)*mp.sin(8*u**2)+1), [0, mp.cbrt(2)])
print('I =', mp.nstr(I,25), '\nI2=', mp.nstr(I2,25))
def comp(m, n):
    W = [mp.mpf(sp.Rational(w).p)/sp.Rational(w).q for w in nc_weights(m)]
    h = mp.mpf(2)/n; s = 0
    for p in range(0, n, m):
        for j in range(m+1): s += W[j]*f(p*h + j*h)
    return h*s
import json
out = {}
seqs = {1:[1,2,3,4,5,6,7,8,10,12,14,16,20,24,28,32,40,48,56,64,72,88,104,120],
        2:list(range(2,41,2)),
        3:[3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,54,60,66,72,84,96,108,120],
        4:[4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,64,72,80,88,96,104,112,116,120]}
for m,seq in seqs.items():
    print('--- m=%d'%m)
    for n in seq:
        v = comp(m,n)
        print(n, n+1, mp.nstr(v,12), 'round6=%.6f'%float(v), 'err=%.3e'%float(v-I))
    out[m] = {n: float(comp(m,n)) for n in seq}
print('--- halving ratios err(n)/err(2n)')
for m in [1,2,3,4]:
    for n in [m*4, m*8, m*16, m*32, m*64, m*128]:
        e1 = comp(m,n)-I; e2 = comp(m,2*n)-I
        print('m=%d n=%d->%d ratio=%.3f  log2=%.3f err=%.3e'%(m,n,2*n,float(e1/e2), float(mp.log(abs(e1/e2),2)), float(e2)))
json.dump({str(k):{str(n):v for n,v in d.items()} for k,d in out.items()}, open('indep_vals.json','w'))
