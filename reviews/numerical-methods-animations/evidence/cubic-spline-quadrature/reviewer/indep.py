import numpy as np, mpmath as mp, sys
from scipy.interpolate import CubicSpline
mp.mp.dps = 40
f = lambda x: np.exp(-x)*np.sin(8*x**(2/3))+1
fm = lambda x: mp.e**(-x)*mp.sin(8*mp.cbrt(x)**2)+1
# split at many points to handle the x^(2/3) cusp at 0
I = mp.quad(fm, mp.linspace(0,2,41))
I2 = mp.quad(fm, [0,1e-6,1e-3,0.01,0.1,0.5,1,1.5,2], maxdegree=10)
print("true integral (mpmath):", mp.nstr(I,20), " cross-check:", mp.nstr(I2,20))
script = {int(l.split()[0]): float(l.split()[1]) for l in open(sys.argv[1])}
Itrue=float(I)
for m in range(3,42,2):
    xs=np.linspace(0,2,m); ys=f(xs)
    res={}
    for bc in ["natural","not-a-knot","clamped"]:
        if bc=="not-a-knot" and m<4: res[bc]=float('nan'); continue
        if bc=="clamped":
            cs=CubicSpline(xs,ys,bc_type=((1,0.0),(1,0.0)))
        else:
            cs=CubicSpline(xs,ys,bc_type=bc)
        res[bc]=cs.integrate(0,2)
    cs=CubicSpline(xs,ys,bc_type="natural")
    d2=cs(xs[[0,-1]],2)
    # C1/C2 continuity from piecewise coefficients
    c=cs.c; h=np.diff(xs)
    S1L = 3*c[0,:-1]*h[:-1]**2+2*c[1,:-1]*h[:-1]+c[2,:-1]; S1R=c[2,1:]
    print(f"m={m:2d} script={script[m]:.15f} scipy_nat={res['natural']:.15f} diff={script[m]-res['natural']:+.1e} "
          f"nak={res['not-a-knot']:.6f} err_vs_true={script[m]-Itrue:+.6f} S''ends={d2[0]:.1e},{d2[1]:.1e}")
