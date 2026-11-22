# Independent checks (do not reuse script code)
import numpy as np, mpmath as mp
mp.mp.dps = 30
print("roots x^3-3x-1:", mp.polyroots([1,0,-3,-1], maxsteps=100, extraprec=50))
print("2cos(pi/9) =", 2*mp.cos(mp.pi/9))
print("roots x^3-3x+2:", np.roots([1,0,-3,2]))
print("roots z^2+4:", mp.polyroots([1,0,4]))
import sympy as sp
x=sp.symbols('x'); print("factor x^3-3x+2 =", sp.factor(x**3-3*x+2))

def newton(f, fp, x0, n):
    xs=[x0]
    for _ in range(n):
        x0 = x0 - f(x0)/fp(x0); xs.append(x0)
    return xs
# Case 1: plain Newton (all script steps were undamped)
xs = newton(lambda x: mp.mpf(x)**3-3*x-1, lambda x: 3*x**2-3, mp.mpf(3), 6)
print("Case1 plain Newton:", [mp.nstr(v,16) for v in xs])
# Case 2: plain Newton for double root
xs = newton(lambda x: (x-1)**2*(x+2), lambda x: 3*x**2-3, mp.mpf(4), 14)
print("Case2 plain Newton:", [mp.nstr(v,16) for v in xs])
print("Case2 error ratios:", [mp.nstr((xs[k]-1)/(xs[k-1]-1),5) for k in range(1,15)])
print("theory ratio (m-1)/m for m=2 = 0.5")
# Case 3: complex, replicate stage rules from the page description only
f=lambda z: z*z+4; fp=lambda z: 2*z
z=mp.mpc(1,0); 
dz=f(z)/fp(z); print("z0 Newton step",dz, "full-step |f|^2", abs(f(z-dz))**2, "vs", abs(f(z))**2)
z1 = z-dz/2; print("z1",z1, abs(f(z1))**2)
dz=f(z1)/fp(z1); print("z1 Newton step", dz)
for k in range(5):
    t=dz/2**k; print("  halving",k, z1-t, abs(f(z1-t))**2)
rot = (dz/16)*mp.mpc(0.6,0.8); z2=z1-rot; print("z2 via 53.13deg rotation", z2, abs(f(z2))**2, "angle", mp.degrees(mp.atan2(0.8,0.6)))
dz=f(z2)/fp(z2); print("z2 full Newton", z2-dz, abs(f(z2-dz))**2, "half", z2-dz/2, abs(f(z2-dz/2))**2)
z=z2-dz/2
for k in range(4):
    z=z-f(z)/fp(z); print("  z", k+4, mp.nstr(z,12), mp.nstr(abs(z-2j),3))
# Real-axis alterdirection (dz*(-0.6)) applied where halvings fail: does |f|^2 rise?
g=lambda x: x*x+4
x=-0.25; d=g(x)/(2*x)/16; xn = x - d*(-0.6)
print("real alterdirection test on x^2+4 at x=-0.25: |f|^2", g(x)**2, "->", g(xn)**2, " x_new", xn)
# What 'multiple steps in the same direction' would do for case 2 (illustration of the missing mechanism):
F=lambda x: (x-1)**2*(x+2); Fp=lambda x: 3*x*x-3
x=mp.mpf(4); out=[]
for it in range(8):
    if abs(F(x))<1e-25: break
    d=F(x)/Fp(x); best=x-d; k=2
    while k<=3 and abs(F(x-k*d))<abs(F(best)): best=x-k*d; k+=1
    x=best; out.append(mp.nstr(x-1,4))
print("Case2 with k*dz acceleration (k<=n=3), errors:", out)
