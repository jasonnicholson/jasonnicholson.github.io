import mpmath as mp, numpy as np, sys
mp.mp.dps = 40
F = {'t01':mp.sqrt,'t02':mp.sqrt,'t03':mp.sqrt,'t04':mp.log,'t05':mp.log,'t06':mp.sin,'t07':mp.cos,
     't08':mp.gamma,'t09':mp.gamma,'t10':mp.gamma,'t11':lambda x:mp.besselj(0,x),'t12':lambda x:mp.besselj(1,x),'t13':lambda x:mp.bessely(0,x)}
C = {'t06':mp.pi/4,'t07':mp.pi/3}
R = {'t01':1,'t02':4,'t03':5,'t04':1,'t05':2,'t06':np.inf,'t07':np.inf,'t08':2,'t09':3,'t10':4,'t11':np.inf,'t12':np.inf,'t13':2}
def fnum(cid,x):
    try:
        v=F[cid](mp.mpf(x)); 
        if isinstance(v,mp.mpc) or not mp.isfinite(v): return np.nan
        return float(v)
    except Exception: return np.nan
for line in open(sys.argv[1]):
    p=line.split(); cid=p[0]; c=float(p[1]); x0,x1,y0,y1=map(float,p[2:6]); s=np.array(list(map(float,p[6:]))); n=len(s)-1
    ex=np.array([float(v) for v in mp.taylor(F[cid], C.get(cid,mp.mpf(p[1])), n)])
    xs=np.linspace(x0,x1,900); fy=np.array([fnum(cid,x) for x in xs]); yr=y1-y0
    inside=np.abs(xs-c)<R[cid]
    out=[]
    for k in range(n+1):
        ps=np.clip(np.polyval(s[:k+1][::-1],xs-c),y0,y1); pe=np.clip(np.polyval(ex[:k+1][::-1],xs-c),y0,y1)
        out.append(np.max(np.abs(ps-pe)[inside])/yr)
    nvis=sum(o>0.02 for o in out)
    line=f"{cid} R={R[cid]} max-diff-inside-R per order: "+" ".join(f"{o:.3f}" for o in out)+f"  orders>2%: {nvis}"
    # beyond radius: error to f at final order
    beyond=(~inside)&np.isfinite(fy)&(xs>c)
    if beyond.any():
        ps=np.polyval(s[::-1],xs-c); pe=np.polyval(ex[::-1],xs-c)
        line+=f"\n     right of radius x in [{xs[beyond].min():.2f},{xs[beyond].max():.2f}]: final-order max|p-f| script={np.max(np.abs(ps-fy)[beyond]):.3g} exact={np.max(np.abs(pe-fy)[beyond]):.3g}"
    print(line)
