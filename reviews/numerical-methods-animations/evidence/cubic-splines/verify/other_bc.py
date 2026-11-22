import numpy as np
from scipy.interpolate import CubicSpline
xq=np.linspace(0,1,100001)
for bc in ["natural",((1,1.0),(1,np.e)),"not-a-knot"]:
    prev=None; out=[]
    for N in [16,32,64,128,256]:
        x=np.linspace(0,1,N+1); e=np.max(abs(CubicSpline(x,np.exp(x),bc_type=bc)(xq)-np.exp(xq)))
        if prev: out.append(round(np.log2(prev/e),2))
        prev=e
    print("exp on [0,1], bc=",bc if isinstance(bc,str) else "clamped exact", "rates:",out)
