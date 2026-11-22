# Reproduce the script's fit with (a) exact (50-digit) samples and (b) Float64-rounded samples,
# to see whether the coefficient error comes from sample roundoff or from truncation.
import mpmath as mp
mp.mp.dps=60
cases=[("22",mp.gamma,1.0,(-0.2,5.2)),("23",mp.gamma,2.0,(-0.2,5.2)),("24",mp.gamma,3.0,(-0.2,5.2)),
       ("25",lambda x:mp.bessely(0,x),10.0,(0.0,22.0)),("26",lambda x:mp.bessely(0,x),5.0,(0.0,22.0)),("27",lambda x:mp.bessely(0,x),2.0,(0.0,22.0))]
n=8;q=max(n+6,14)
for cid,f,c,xl in cases:
    h=max(1e-5,min(0.01*max(1,abs(c)),0.45*min(c-xl[0],xl[1]-c)/q))
    ts=list(range(-q,q+1))
    xs=[c+h*t for t in ts]  # Float64 nodes as in script
    ex=mp.taylor(f,mp.mpf(c),n)
    res={}
    for mode in ("exact","f64"):
        ys=[f(mp.mpf(x)) for x in xs]
        if mode=="f64": ys=[mp.mpf(float(y)) for y in ys]
        A=mp.matrix([[mp.mpf(t)**k for k in range(n+1)] for t in ts])
        a=mp.lu_solve(A.T*A, A.T*mp.matrix(ys))  # normal eqns at 60 digits = LS solution
        res[mode]=[a[k]/mp.mpf(h)**k for k in range(n+1)]
    print(f"Case {cid} h={h}")
    for k in range(n+1):
        re=lambda v: float(abs(v-ex[k])/abs(ex[k]))
        print(f"  k={k} relerr exact-samples={re(res['exact'][k]):.1e}  f64-samples={re(res['f64'][k]):.1e}")
