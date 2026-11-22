import numpy as np
from scipy.interpolate import CubicSpline
xp = np.linspace(0, 2*np.pi, 600)
xf = np.linspace(0, 2*np.pi, 200001)
print("sin(x) on [0,2pi], bc_type='natural' (same grid as script, 600 pts):")
for nn in [3,4,5,6,7,9]:
    xs = np.linspace(0, 2*np.pi, nn); ys = np.sin(xs)
    cs = CubicSpline(xs, ys, bc_type='natural')
    print(f" nn={nn} max err (600 pts)={np.max(np.abs(cs(xp)-np.sin(xp))):.10g}  "
          f"title-round={float(f'{np.max(np.abs(cs(xp)-np.sin(xp))):.3g}')}  M={np.round(cs(xs,2),12)}")
print("\nrates for sin (natural, should be ~16 per halving if O(h^4)):")
prev=None
for nn in [9,17,33,65,129]:
    xs=np.linspace(0,2*np.pi,nn); cs=CubicSpline(xs,np.sin(xs),bc_type='natural')
    e=np.max(np.abs(cs(xf)-np.sin(xf))); print(f" nn={nn} err={e:.4e} ratio={prev/e if prev else float('nan'):.2f}"); prev=e
print("\nnot-a-knot / clamped comparison for nn=9 sin (are they different from natural?):")
xs=np.linspace(0,2*np.pi,9)
for bc in ['natural','not-a-knot',((1,1.0),(1,1.0))]:
    cs=CubicSpline(xs,np.sin(xs),bc_type=bc); print(f" bc={bc}: err={np.max(np.abs(cs(xp)-np.sin(xp))):.4e}")
print("\nGeneral-claim test: natural spline for f with f''(a),f''(b) != 0")
for name,fn in [("cos(x) on [0,2pi]",np.cos),("exp(x) on [0,2pi]",np.exp)]:
    prev=None
    for nn in [9,17,33,65,129,257]:
        xs=np.linspace(0,2*np.pi,nn); cs=CubicSpline(xs,fn(xs),bc_type='natural')
        e=np.max(np.abs(cs(xf)-fn(xf)))
        csn=CubicSpline(xs,fn(xs),bc_type='not-a-knot'); e2=np.max(np.abs(csn(xf)-fn(xf)))
        print(f" {name} nn={nn} natural err={e:.4e} ratio={prev/e if prev else float('nan'):.2f}  | not-a-knot err={e2:.4e}"); prev=e
