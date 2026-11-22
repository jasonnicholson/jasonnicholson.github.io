# Independent high-precision Padé from exact Taylor coeffs (mpmath.pade, 50 digits),
# compared against the script's drawn curve (fitted coeffs, script's Float64 solver re-implemented).
import mpmath as mp, numpy as np
mp.mp.dps=50
cases={"22":(mp.gamma,1.0,(-0.2,5.2),(-10,35)),"23":(mp.gamma,2.0,(-0.2,5.2),(-10,35)),"24":(mp.gamma,3.0,(-0.2,5.2),(-10,45)),
       "25":(lambda x:mp.bessely(0,x),10.0,(0,22),(-2,2)),"26":(lambda x:mp.bessely(0,x),5.0,(0,22),(-2,2)),"27":(lambda x:mp.bessely(0,x),2.0,(0,22),(-2,2))}
fit={l.split()[0]:[float(v) for v in l.split()[2:]] for l in open("fitcoefs.txt")}
def script_pade(a,m,n):
    if n==0: return np.array(a[:m+1]),np.array([1.0])
    B=np.zeros((n,n));r=np.zeros(n)
    for i in range(1,n+1):
        k=m+i;r[i-1]=-a[k]
        for j in range(1,n+1):
            idx=k-j;B[i-1,j-1]=a[idx] if idx>=0 else 0
    qt=np.linalg.solve(B,r);q=np.r_[1.0,qt]
    p=np.array([sum(q[j]*a[i-j] for j in range(min(i,n)+1)) for i in range(m+1)])
    return p,q
def ev(p,q,z):
    num=np.polyval(p[::-1],z);den=np.polyval(q[::-1],z)
    y=np.where(np.abs(den)<1e-8,np.nan,num/np.where(den==0,1,den));return y
pairs=[(m,t-m) for t in range(9) for m in range(t+1)]
for cid,(f,c,xl,yl) in cases.items():
    ex=mp.taylor(f,mp.mpf(c),8)
    x=np.linspace(xl[0],xl[1],900);z=x-c;span=yl[1]-yl[0];pxper=430/span
    rows=[]
    for fi,(m,n) in enumerate(pairs,1):
        P,Q=mp.pade(ex,m,n) if n>0 else (ex[:m+1],[mp.mpf(1)])
        yt=np.array([float(mp.polyval(P[::-1],zz)/mp.polyval(Q[::-1],zz)) if mp.polyval(Q[::-1],zz)!=0 else np.nan for zz in z])
        pf,qf=script_pade(fit[cid],m,n);yd=ev(pf,qf,z)
        yt_c=np.clip(yt,*yl);yd_c=np.clip(yd,*yl)
        # exclude neighbourhoods (+-0.03 of x-range) of real poles of either curve
        excl=np.zeros_like(x,bool)
        for qq in ([float(v) for v in Q],list(qf)):
            if len(qq)>1:
                for rt in np.roots(qq[::-1]):
                    if abs(rt.imag)<1e-6: excl|=np.abs(z-rt.real)<0.03*(xl[1]-xl[0])
        d=np.abs(yt_c-yd_c);d[excl]=0;d=np.nan_to_num(d)
        npts=int((d*pxper>3).sum())
        if npts>0: rows.append(f"  frame {fi:2d} [{m}/{n}]: {npts:3d}/900 x-pts off by >3px away from poles; max {d.max()*pxper:.0f}px at x={x[d.argmax()]:.2f}")
    print(f"Case {cid}: {len(rows)} of 45 frames visibly differ (excluding pole neighbourhoods)")
    print("\n".join(rows))
