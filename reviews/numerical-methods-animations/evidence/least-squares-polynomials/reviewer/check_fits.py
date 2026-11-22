import numpy as np
from fractions import Fraction
import sympy as sp
x=np.array([-4.5,-3.2,-1.4,0.8,2.5,4.1]); y=np.array([0.7,2.3,3.8,5.0,5.5,5.6])
script={2:[4.67425137,0.52860951,-0.07563441],
3:[4.66862641,0.48939249,-0.07423867,0.00267659],
4:[4.62862816,0.49668723,-0.05823430,0.00201395,-0.00080138],
5:[4.63232375,0.50885354,-0.06062594,-0.00073781,-0.00065051,0.00011667]}
# exact rational solution
xs=[sp.Rational(str(v)) for v in x]; ys=[sp.Rational(str(v)) for v in y]
for m in range(0,6):
    V=sp.Matrix([[xi**j for j in range(m+1)] for xi in xs]); Y=sp.Matrix(ys)
    a=(V.T*V).LUsolve(V.T*Y)
    r=V*a-Y
    sse=sum(ri**2 for ri in r)
    an=np.array([float(v) for v in a])
    pf=np.polyfit(x,y,m)[::-1]
    ls=np.linalg.lstsq(np.vander(x,m+1,increasing=True),y,rcond=None)[0]
    print(f"m={m}: exact a = {[f'{v:.8f}' for v in an]}")
    print(f"   polyfit = {[f'{v:.8f}' for v in pf]}  lstsq maxdiff={np.max(abs(ls-an)):.2e}")
    print(f"   exact SSE={float(sse):.10g} RMS={float(sp.sqrt(sse/6)):.10g}  V^T r = {[str(v) for v in V.T*r]}")
    if m in script:
        c=np.array(script[m]); rr=np.vander(x,m+1,increasing=True)@c-y
        print(f"   script c: maxdiff vs exact={np.max(abs(c-an)):.2e}; RMS(script c)={np.sqrt(np.mean(rr**2)):.6g}; V^T r(script)={np.vander(x,m+1,increasing=True).T@rr}")
        print(f"   residuals exact={[f'{float(v):.5f}' for v in r]}")
