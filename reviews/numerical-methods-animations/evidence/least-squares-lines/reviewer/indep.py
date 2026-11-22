# Independent least-squares checks for least-squares-lines (does not reuse script code)
import numpy as np
from fractions import Fraction as F
np.set_printoptions(precision=10)
x=np.array([-1,0,1,2,3,4,5,6.]); y=np.array([10,9,7,5,4,3,0,-1.])
print("Case 1: y = b + a x, prefixes k=2..8 (numpy.lstsq, polyfit, residual . [1,x])")
for k in range(2,9):
    A=np.c_[np.ones(k),x[:k]]; (b,a),*_=np.linalg.lstsq(A,y[:k],rcond=None)
    pa,pb=np.polyfit(x[:k],y[:k],1); r=y[:k]-A@[b,a]
    print(f" k={k} a={a:.10f} b={b:.10f} polyfit a={pa:.10f} b={pb:.10f} rss={r@r:.10f} A^T r={A.T@r}")
# exact rational
def exact(xs,ys):
    n=len(xs); sx=sum(xs); sy=sum(ys); sxx=sum(t*t for t in xs); sxy=sum(p*q for p,q in zip(xs,ys))
    a=F(n*sxy-sx*sy, n*sxx-sx*sx); b=(sy-a*sx)/n; return a,b
xs=[F(int(t)) for t in x]; ys=[F(int(t)) for t in y]
a,b=exact(xs,ys); print(" exact 8-pt: a =",a,"=",float(a)," b =",b,"=",float(b))
a7,b7=exact(xs[:7],ys[:7]); print(" exact 7-pt:",a7,b7," residual of point 8 on 7-pt line:", ys[7]-(a7*xs[7]+b7))
print("\nCase 2: x on y, prefixes, intersection vs centroid")
for k in range(2,9):
    B=np.c_[np.ones(k),y[:k]]; (d,c),*_=np.linalg.lstsq(B,x[:k],rcond=None)
    A=np.c_[np.ones(k),x[:k]]; (b,a),*_=np.linalg.lstsq(A,y[:k],rcond=None)
    rr=x[:k]-B@[d,c]
    M=np.array([[a,-1.],[1/c,-1.]]) # y=a x + b ; y = x/c - d/c
    try:
        xi,yi=np.linalg.solve(M,[-b, d/c]); 
    except Exception as e: xi=yi=float('nan')
    print(f" k={k} c={c:.10f} d={d:.10f} B^T r={B.T@rr} alpha=1/c={1/c:.10f} beta={-d/c:.10f} r^2={a*c:.10f} intersection=({xi:.6f},{yi:.6f}) centroid=({x[:k].mean():.6f},{y[:k].mean():.6f})")
print("\nCase 3: y = a x")
x3=np.arange(1,9.); y3=np.array([2,3,5,6,8,9,11,12.])
for k in range(1,9):
    A=x3[:k,None]; (a,),*_=np.linalg.lstsq(A,y3[:k],rcond=None); r=y3[:k]-a*x3[:k]
    print(f" k={k} a={a:.10f} rss={r@r:.10f} x.r={x3[:k]@r:.2e}")
print(" exact 8-pt a =",F(int(x3@y3),int(x3@x3)), float(F(int(x3@y3),int(x3@x3))))
print(" unconstrained fit for comparison (polyfit):",np.polyfit(x3,y3,1))
print("\nCase 4: T = a r^1.5")
r4=np.array([57.59,108.11,149.57,227.84]); T=np.array([87.99,224.70,365.26,686.98])
for k in range(1,5):
    A=(r4[:k]**1.5)[:,None]; (a,),*_=np.linalg.lstsq(A,T[:k],rcond=None); res=T[:k]-a*r4[:k]**1.5
    print(f" k={k} a={a:.10f} rss={res@res:.10f} basis.r={A[:,0]@res:.2e}")
print(" per-planet T/r^1.5:",T/r4**1.5)
# physical reference: a = 2*pi*(1e9 m)^1.5/sqrt(GM_sun)/86400 s
GM=1.32712440018e20
print(" Kepler constant from GM_sun (r in 1e6 km, T in days):",2*np.pi*(1e9)**1.5/np.sqrt(GM)/86400)
# Modern semi-major axes (1e6 km) and sidereal periods (days), NASA fact sheet values
ref_r=np.array([57.909,108.209,149.598,227.956]); ref_T=np.array([87.969,224.701,365.256,686.980])
print(" r rel diff vs modern:",(r4-ref_r)/ref_r); print(" T rel diff vs modern:",(T-ref_T)/ref_T)
A=(ref_r**1.5)[:,None]; (am,),*_=np.linalg.lstsq(A,ref_T,rcond=None); print(" a with modern data:",am)
