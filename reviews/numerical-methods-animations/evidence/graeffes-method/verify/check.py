import numpy as np, mpmath as mp
mp.mp.dps=50
def step(c):
    c4,c3,c2,c1,c0=c
    return [c4**2, 2*c4*c2-c3**2, c2**2+2*c4*c0-2*c3*c1, 2*c2*c0-c1**2, c0**2]
# verify step against numpy roots
for name,c in [("case1",[1.,-2,-13,14,24]),("case2",[1.,-9,13,45,-50])]:
    print("==",name, "roots", np.roots(c))
    d=step(c); print(" step roots", sorted(abs(np.roots(d))), "vs squares", sorted(abs(np.roots(c))**2))
    # float64 iteration
    p=[np.float64(x) for x in c]; q=[mp.mpf(x) for x in c]
    for m in range(0,11):
        with np.errstate(all='ignore'):
            ok=[abs(p[i+1]/p[i])**(1/2**m) for i in range(4)]
        ex=[abs(q[i+1]/q[i])**(mp.mpf(1)/2**m) for i in range(4)]
        # page formula, c_j = coeff of x^j: c_j = poly[4-j]; |r_k| ~ |c_{n-k+1}/c_{n-k}|^(1/2^m)
        cj=lambda j: q[4-j]
        page=[abs(cj(4-k+1)/cj(4-k))**(mp.mpf(1)/2**m) for k in range(1,5)]
        print(f" m={m} float64 coeffs={['%.3g'%x for x in p]}")
        print(f"    float est={['%.6g'%x for x in ok]}  exact est={[mp.nstr(x,8) for x in ex]}  page-formula={[mp.nstr(x,8) for x in page]}")
        with np.errstate(all='ignore'):
            p=step(p)
        q=step(q)
