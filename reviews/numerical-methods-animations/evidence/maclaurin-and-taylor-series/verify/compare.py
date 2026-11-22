import mpmath as mp, numpy as np, sys
mp.mp.dps = 40
F = {'t01':mp.sqrt,'t02':mp.sqrt,'t03':mp.sqrt,'t04':mp.log,'t05':mp.log,'t06':mp.sin,'t07':mp.cos,
     't08':mp.gamma,'t09':mp.gamma,'t10':mp.gamma,'t11':lambda x:mp.besselj(0,x),'t12':lambda x:mp.besselj(1,x),'t13':lambda x:mp.bessely(0,x)}
C = {'t06':mp.pi/4,'t07':mp.pi/3}
for line in open(sys.argv[1]):
    p = line.split(); cid=p[0]; c=float(p[1]); x0,x1,y0,y1=map(float,p[2:6]); s=np.array(list(map(float,p[6:])))
    n=len(s)-1
    cc = C.get(cid, mp.mpf(p[1]))
    ex = np.array([float(v) for v in mp.taylor(F[cid], cc, n)])
    rel = np.abs(s-ex)/np.maximum(np.abs(ex),1e-300)
    signs = sum(1 for a,b in zip(s,ex) if abs(b)>1e-14 and np.sign(a)!=np.sign(b))
    xs=np.linspace(x0,x1,900)
    print(f"== {cid} c={c} n={n}  sign-wrong coeffs: {signs}/{sum(abs(ex)>1e-14)}")
    print("  k  script            exact             relerr")
    for k in range(n+1): print(f"  {k:2d} {s[k]: .6e} {ex[k]: .6e} {rel[k]:.2e}")
    yr=y1-y0
    worst=[]
    for k in range(n+1):
        ps=np.polyval(s[:k+1][::-1], xs-c); pe=np.polyval(ex[:k+1][::-1], xs-c)
        d=np.abs(np.clip(ps,y0,y1)-np.clip(pe,y0,y1))/yr
        worst.append(d.max())
    print("  max clamped diff per order as fraction of y-range:", " ".join(f"{w:.3f}" for w in worst))
