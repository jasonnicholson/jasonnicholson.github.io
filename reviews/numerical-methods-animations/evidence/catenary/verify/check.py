import numpy as np
from scipy.optimize import brentq
x=np.linspace(-4,4,500)
for c in np.linspace(0.5,4,25):
    cat=c*np.cosh(x/c); par=x**2/(2*c)+c
    mind=(cat-par).min()
    xc=np.arccosh(12/c)*c if 12/c>1 else np.inf
    xp=np.sqrt(max(0,(12-c)*2*c))
    # first x>0 where gap >= 0.1 (about 3-4 px vertical at 500px/12 units)
    f=lambda t: c*np.cosh(t/c)-t*t/(2*c)-c-0.1
    xs=brentq(f,1e-9,50)
    print(f"c={c:.3f} min(cat-par)={mind:.2e} cat exits y=12 at |x|={xc:.2f} par exits at {xp:.2f} gap>=0.1 at |x|={xs:.2f} gap@x=4: {c*np.cosh(4/c)-16/(2*c)-c:.3g}")
