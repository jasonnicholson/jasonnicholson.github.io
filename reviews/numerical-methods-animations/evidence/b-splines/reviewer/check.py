import numpy as np
from scipy.interpolate import BSpline
from scipy.spatial import ConvexHull, Delaunay
k=3
t=np.array([0,0,0,0,1,2,3,4,4,4,4.])  # independent: clamped cubic, 7 ctrl pts, uniform interior knots
P=np.array([[0,0],[1,2],[2,-1],[3,2],[4,-.5],[5,1.5],[6,0.]])
# basis vs julia
B=np.loadtxt('bb_basis.csv',delimiter=',')
tv=B[:,0]
ref=np.array([BSpline.basis_element(t[i:i+5],extrapolate=False)(tv) for i in range(7)]).T
ref=np.nan_to_num(ref)
print("max |julia basis - scipy basis| =",np.abs(B[:,1:]-ref).max())
print("max |sum-1| scipy:",np.abs(ref.sum(1)-1).max())
print("min basis value:",B[:,1:].min())
# supports (number of nonzero-length spans)
for i in range(7):
    kn=t[i:i+5]; spans=[(kn[j],kn[j+1]) for j in range(4) if kn[j+1]>kn[j]]
    print(f"N_{i+1},4 knots {kn} -> nonzero spans {len(spans)} {spans}")
# curve
C=np.loadtxt('aa_curve.csv',delimiter=',')
S=BSpline(t,P,k)
print("max |julia curve - scipy curve| =",np.abs(C[:,1:]-S(C[:,0])).max())
print("C(0)=",S(0.0),"C(4)=",S(4.0))
# convex hull
hull=Delaunay(P); print("all curve pts in convex hull:",bool(np.all(hull.find_simplex(C[:,1:])>=0)))
# continuity at interior knots
for kk in [1,2,3]:
    for d in range(4):
        L=S.derivative(d)(kk-1e-12) if d>0 else S(kk-1e-12); R=S.derivative(d)(kk+1e-12) if d>0 else S(kk+1e-12)
        print(f"knot {kk} deriv {d}: jump {np.abs(L-R).max():.3e}")
# point at t=1,2,3
print("C(1),C(2),C(3)=",S(1.),S(2.),S(3.))
# distance from interior control pts to curve
for p in P:
    print(p, "min dist to curve", np.min(np.linalg.norm(C[:,1:]-p,axis=1)))
