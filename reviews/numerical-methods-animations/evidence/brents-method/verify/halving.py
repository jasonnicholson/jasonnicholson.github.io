import math, sys
sys.path.insert(0, '.')
from compare import zeroin, script_brent
tests = [
 ("x^9 on [-1,2]", lambda x: x**9, -1.0, 2.0),
 ("(x-1/3)^15 on [0,1]", lambda x: (x-1/3)**15, 0.0, 1.0),
 ("x^25 on [-1,4]", lambda x: x**25, -1.0, 4.0),
 ("sign(x)|x|^0.1? x^(1/9)-like: cbrt^... on [-1,2]", lambda x: math.copysign(abs(x)**(1/9), x), -1.0, 2.0),
 ("case1", lambda x:4*x**3-16*x**2+17*x-4,0.0,1.0),
]
for name,f,a,b in tests:
    W0=abs(b-a)
    # ZEROIN
    h=[hh for hh in zeroin(f,a,b,1e-12,maxit=2000) if hh[2]!="done"]
    worst=0;wn=None
    for n,(bb,cc,k) in enumerate(h,1):
        r=abs(cc-bb)/(W0*2**(-(n//2)))
        if r>worst: worst,wn=r,n
    nb=sum(1 for x in h if x[2].startswith("Bisection"))
    print(f"ZEROIN  {name:45s} evals={len(h):4d} bisections={nb:3d} max width/(W0*2^-floor(n/2))={worst:.3g} at n={wn}, width there={abs(h[wn-1][1]-h[wn-1][0]):.3g}")
    # script
    s=script_brent(f,a,b,2000,1e-12)
    worst=0;wn=None
    for n,(aa,bb,m,t) in enumerate(s):
        if n==0: continue
        r=abs(bb-aa)/(W0*2**(-(n//2)))
        if r>worst: worst,wn=r,n
    print(f"script  {name:45s} steps={len(s)-1:4d} max ratio={worst:.3g} at n={wn}, width={abs(s[wn][1]-s[wn][0]):.3g}")
