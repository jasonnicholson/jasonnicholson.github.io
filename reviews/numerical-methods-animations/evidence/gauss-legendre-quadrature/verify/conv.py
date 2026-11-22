import mpmath as mp, numpy as np
mp.mp.dps=40
f=lambda x: 1+mp.e**(-x)*mp.sin(8*mp.cbrt(x)**2)
# substitution x=u^3 removes singularity: dx=3u^2 du, u in [0, 2^(1/3)]
I=mp.quad(lambda u: f(u**3)*3*u**2,[0,mp.cbrt(2)/2,mp.cbrt(2)])
I2=mp.quad(f,[0,0.01,0.1,0.5,1,2],maxdegree=12)
print("I =",I," check",I2)
# trapezoid ref used by script
xr=np.linspace(0,2,120001); yr=1+np.exp(-xr)*np.sin(8*xr**(2/3))
tr=2/120000*(yr.sum()-0.5*(yr[0]+yr[-1])); print("script trapz ref",tr, "err",tr-float(I))
fn=lambda x: 1+np.exp(-x)*np.sin(8*x**(2/3))
prev=None
for n in [2,3,4,5,6,8,10,12,14,16,18,20,24,28,32,36,40,44,48,56,64,128,256,512]:
    t,w=np.polynomial.legendre.leggauss(n)
    x=1+t; In=np.sum(w*fn(x))
    e=In-float(I)
    print(f"n={n:4d} I_n={In:.10f} round6={round(In,6):.6f} err={e:+.3e} n^(8/3)*err={e*n**(8/3):+.3f}")
