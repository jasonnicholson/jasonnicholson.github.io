import numpy as np
from scipy.interpolate import CubicSpline
tests = {
 "sin x on [0,2pi] (animation; f''=0 at ends)": (np.sin, 0, 2*np.pi),
 "cos x on [0,2pi]": (np.cos, 0, 2*np.pi),
 "sin x on [0,pi/2]": (np.sin, 0, np.pi/2),
 "exp x on [0,1]": (np.exp, 0, 1),
 "1/(1+x^2) on [0,2]": (lambda x: 1/(1+x**2), 0, 2),
 "x^3 on [0,1]": (lambda x: x**3, 0, 1),
}
for name,(f,a,b) in tests.items():
    print(name)
    prev=None
    xq=np.linspace(a,b,200001)
    for N in [8,16,32,64,128,256,512]:
        x=np.linspace(a,b,N+1)
        for bc in ["natural","clamped_exact" ]:
            pass
        s=CubicSpline(x,f(x),bc_type="natural")
        e=np.max(abs(s(xq)-f(xq)))
        # interior error (middle half)
        m=(xq>a+(b-a)/4)&(xq<b-(b-a)/4)
        ei=np.max(abs(s(xq[m])-f(xq[m])))
        r = "" if prev is None else f"  rate={np.log2(prev[0]/e):.2f}  interior rate={np.log2(prev[1]/ei):.2f}"
        print(f"  N={N:4d} h={(b-a)/N:.4g} maxerr={e:.3e} interior={ei:.3e}{r}")
        prev=(e,ei)
