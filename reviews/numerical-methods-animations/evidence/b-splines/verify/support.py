import numpy as np
from scipy.interpolate import BSpline
k=3  # degree
knots=np.array([0,0,0,0,1,2,3,4,4,4,4],float)
n=len(knots)-k-1
print("knots",knots,"n basis",n)
x=np.linspace(0,4,4001)[:-1]+1e-12
tot=np.zeros_like(x)
for i in range(n):
    c=np.zeros(n);c[i]=1
    y=BSpline(knots,c,k,extrapolate=False)(x)
    y=np.nan_to_num(y); tot+=y
    nz=x[y>1e-12]
    sup=(nz.min(),nz.max())
    spans=[j for j in range(4) if np.any(y[(x>=j)&(x<j+1)]>1e-12)]
    print(f"N_{i+1}: support ~[{sup[0]:.3f},{sup[1]:.3f}], knot interval [{knots[i]},{knots[i+k+1]}], nonzero-length spans={len(spans)} {spans}, min={y.min():.2e}, max={y.max():.4f}")
print("partition of unity max err", np.abs(tot-1).max())
# degree-4 check: what would N_{i,4} with p=4 be on same domain? number of functions
