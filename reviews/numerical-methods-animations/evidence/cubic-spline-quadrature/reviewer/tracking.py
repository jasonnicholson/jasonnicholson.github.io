import numpy as np
from scipy.interpolate import CubicSpline
f = lambda x: np.exp(-x)*np.sin(8*x**(2/3))+1
xx=np.linspace(0,2,200001)
fx=f(xx); print("f min/max on [0,2]:", fx.min(), fx.max())
for m in range(3,42,2):
    xs=np.linspace(0,2,m); cs=CubicSpline(xs,f(xs),bc_type="natural")
    s=cs(xx); e=np.abs(s-fx)
    print(f"m={m:2d} sup|S-f|={e.max():.4f} at x={xx[e.argmax()]:.4f}  L1={np.trapz(e,xx):.5f}  S min={s.min():.4f} max={s.max():.4f}")
