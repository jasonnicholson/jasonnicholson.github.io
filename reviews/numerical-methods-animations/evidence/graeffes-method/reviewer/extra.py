import sympy as sp, mpmath as mp
mp.mp.dps=50
x=sp.symbols('x')
def graeffe_coeffs(roots,m):  # p_m via its exact roots (verified equal to the squaring recurrence in indep.py)
    return sp.Poly(sp.expand(sp.prod([x-sp.Integer(r)**(2**m) for r in roots])),x).all_coeffs()
# 1) Page formula (index.qmd l.30/34) |r_k| ~ |c_{n-k+1}/c_{n-k}|^(1/2^m), c_j = coeff of x^j
for roots in ([-1,2,-3,4],):
    for m in (3,5):
        hi=graeffe_coeffs(roots,m); n=len(hi)-1
        c={j:hi[n-j] for j in range(n+1)}           # c_j multiplies x^j
        page=[mp.mpf(abs(sp.Rational(c[n-k+1],c[n-k])))**(mp.mpf(1)/2**m) for k in range(1,n+1)]
        lead=[mp.mpf(abs(sp.Rational(hi[n-k+1],hi[n-k])))**(mp.mpf(1)/2**m) for k in range(1,n+1)]  # c_0 = leading
        right=[mp.mpf(abs(sp.Rational(c[n-k],c[n-k+1])))**(mp.mpf(1)/2**m) for k in range(1,n+1)]
        print(f"m={m} page formula (c_j of x^j): {[mp.nstr(v,6) for v in page]}")
        print(f"     page formula (c_0 leading): {[mp.nstr(v,6) for v in lead]}")
        print(f"     |c_(n-k)/c_(n-k+1)|       : {[mp.nstr(v,6) for v in right]}  (true 4,3,2,1)")
# 2) equal-magnitude but distinct roots +5,-5: same linear behaviour as the double root?
for roots in ([1,-2,5,-5],[1,-2,5,5]):
    print("roots",roots)
    for m in range(1,9):
        hi=graeffe_coeffs(roots,m)
        e=[mp.mpf(abs(sp.Rational(hi[k+1],hi[k])))**(mp.mpf(1)/2**m) for k in range(2)]
        print(f"  m={m} est r1,r2 = {mp.nstr(e[0],8)}, {mp.nstr(e[1],8)}")
