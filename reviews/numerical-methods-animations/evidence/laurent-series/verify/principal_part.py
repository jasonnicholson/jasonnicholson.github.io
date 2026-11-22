# Compute Laurent coefficients a_{-1..-5} of each case about x0 via the contour integral
# a_k = (1/2πi) ∮ f(z) (z-x0)^{-k-1} dz on a circle of radius r < distance to nearest singularity.
import mpmath as mp
mp.mp.dps = 30
pi = mp.pi
cases = [
 ("01","sqrt",lambda z: mp.sqrt(z),1,0), ("02","sqrt",lambda z: mp.sqrt(z),4,0), ("03","sqrt",lambda z: mp.sqrt(z),5,0),
 ("04","1/sqrt(1-x)",lambda z: 1/mp.sqrt(1-z),0,1),
 ("05","log",mp.log,1,0), ("06","log",mp.log,2,0), ("07","log1p",lambda z: mp.log(1+z),0,-1),
 ("08","sin",mp.sin,0,None),("09","cos",mp.cos,0,None),("10","sin",mp.sin,pi/4,None),("11","cos",mp.cos,pi/3,None),
 ("12","tan",mp.tan,0,pi/2),("13","exp",mp.exp,0,None),("14","e^-x cos",lambda z: mp.exp(-z)*mp.cos(z),0,None),
 ("15","cosh",mp.cosh,0,None),("16","atan",mp.atan,0,1j),("17","asin",mp.asin,0,1),
 ("18","J0",lambda z: mp.besselj(0,z),0,None),("19","J1",lambda z: mp.besselj(1,z),0,None),
 ("20","npdf",lambda z: mp.exp(-z**2/2)/mp.sqrt(2*pi),0,None),("21","ncdf",lambda z: 0.5+0.5*mp.erf(z/mp.sqrt(2)),0,None),
 ("22","gamma",mp.gamma,1,0),("23","gamma",mp.gamma,2,0),("24","gamma",mp.gamma,3,0),
 ("25","Y0",lambda z: mp.bessely(0,z),10,0),("26","Y0",lambda z: mp.bessely(0,z),5,0),("27","Y0",lambda z: mp.bessely(0,z),2,0),
]
worst=0
for cid,name,f,x0,sing in cases:
    x0=mp.mpf(x0)
    d = 1 if sing is None else abs(mp.mpc(sing)-x0)
    r = 0.5*min(d,1)
    def coef(k):
        g=lambda t: f(x0+r*mp.expj(t))*(r*mp.expj(t))**(-k)
        return mp.quad(g,[0,pi/2,pi,3*pi/2,2*pi])/(2*pi)
    neg=[abs(coef(k)) for k in range(-5,0)]
    a0=coef(0); fx0=f(x0)
    m=max(neg); worst=max(worst,m)
    print(f"case {cid} {name:12s} x0={float(x0):.4f} r={float(r):.3f}  max|a_-1..-5|={float(m):.2e}  a0-f(x0)={float(abs(a0-fx0)):.1e}")
print("worst max|a_neg| over all cases:", float(worst))
