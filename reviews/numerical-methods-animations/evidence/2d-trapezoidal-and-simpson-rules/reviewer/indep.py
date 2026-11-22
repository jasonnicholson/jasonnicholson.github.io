# Independent check: reference integral (mpmath), tensor rules built from scratch with exact rationals,
# polynomial-exactness properties, and approximations/errors for the script's mesh sequence.
import mpmath as mp
from fractions import Fraction as Fr
mp.mp.dps = 40
I_ref = 8*mp.quad(lambda x: mp.exp(-x**2),[0,1])*mp.quad(lambda y: mp.exp(-y**4),[0,1])
I_2d = mp.quad(lambda x,y: 8*mp.exp(-x**2-y**4),[0,1],[0,1])
I_cf = 8*(mp.sqrt(mp.pi)/2*mp.erf(1))*mp.quad(lambda y: mp.exp(-y**4),[0,1])
print("I (separable mpmath) =", mp.nstr(I_ref,25))
print("I (2D mpmath quad)   =", mp.nstr(I_2d,25))
print("I (erf closed form x)=", mp.nstr(I_cf,25))
bench = mp.mpf('5.04756680717')
print("benchmark - I =", mp.nstr(bench-I_ref,5))

def w_trap(n): w=[Fr(1)]*(n+1); w[0]=w[-1]=Fr(1,2); return [wi/ n for wi in w]
def w_simp(n):
    a=[Fr(1)]+[Fr(4) if i%2 else Fr(2) for i in range(1,n)]+[Fr(1)]
    return [ai/(3*n) for ai in a]
def tensor(wfun,n,g):
    w=wfun(n); xs=[Fr(i,n) for i in range(n+1)]
    return sum(w[i]*w[j]*g(xs[i],xs[j]) for i in range(n+1) for j in range(n+1))
def exact(p,q): return Fr(1,p+1)*Fr(1,q+1)
print("\nPolynomial exactness x^p y^q on [0,1]^2 (n=2 and n=4):")
for name,wf in [("trap",w_trap),("simp",w_simp)]:
    for n in (2,4):
        res=[]
        for p in range(6):
            for q in range(6):
                if p+q>6: continue
                ok = tensor(wf,n,lambda x,y:x**p*y**q)==exact(p,q)
                res.append(((p,q),ok))
        exactset=[pq for pq,ok in res if ok]
        maxdeg = max(max(pq) for pq in exactset)
        print(name,n,"exact monomials:",exactset)
# mesh sequence
f=lambda x,y: 8*mp.exp(-x**2-y**4)
def rule(wfun,n):
    w=[mp.mpf(wi.numerator)/wi.denominator for wi in wfun(n)]
    return sum(w[i]*w[j]*f(mp.mpf(i)/n,mp.mpf(j)/n) for i in range(n+1) for j in range(n+1))
print("\nn  I_T  |I_T-I|  |I_T-bench|   I_S  |I_S-I|  |I_S-bench|")
for n in [2,4,6,8,10,12,16,20]:
    T=rule(w_trap,n); S=rule(w_simp,n)
    print(n, mp.nstr(T,14), mp.nstr(abs(T-I_ref),8), mp.nstr(abs(T-bench),8), "|", mp.nstr(S,14), mp.nstr(abs(S-I_ref),8), mp.nstr(abs(S-bench),8))
