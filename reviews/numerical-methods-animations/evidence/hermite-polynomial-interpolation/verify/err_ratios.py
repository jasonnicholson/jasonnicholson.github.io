import numpy as np
from scipy.interpolate import CubicHermiteSpline
def maxerr(n, npts):
    xn = np.linspace(0, 2*np.pi, n+1)
    H = CubicHermiteSpline(xn, np.sin(xn), np.cos(xn))
    x = np.linspace(0, 2*np.pi, npts)
    return np.max(np.abs(H(x)-np.sin(x)))
for npts, lab in [(600, "script grid (600 pts)"), (200001, "dense grid")]:
    print(lab)
    prev=None
    for n in [1,2,4,8,16,32,64]:
        e = maxerr(n, npts)
        r = "" if prev is None else f"ratio {prev/e:.3f}"
        print(f"  n={n:3d} maxerr={e:.4g} {r}")
        prev=e
# theoretical asymptotic: max|f''''| h^4/384 = h^4/384
for n in [1,2,4,8]:
    h=2*np.pi/n; print(n, "bound h^4/384 =", h**4/384)
