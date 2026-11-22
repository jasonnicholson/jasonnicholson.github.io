import mpmath as mp
mp.mp.dps=60
cases={'M10 exp(-x^2/2)':lambda x:mp.exp(-x**2/2),'M11 exp(-x)cos x':lambda x:mp.exp(-x)*mp.cos(x),
 'M15 J0':lambda x:mp.besselj(0,x),'M16 J1':lambda x:mp.besselj(1,x),'M18 normal CDF':lambda x:mp.mpf(1)/2+mp.erf(x/mp.sqrt(2))/2,
 'M12 cosh':mp.cosh,'exp':mp.exp,'M05 1/(1+x^2)':lambda x:1/(1+x**2),'M13 atan':mp.atan}
for name,f in cases.items():
    c=mp.taylor(f,0,120)
    # root test estimate of radius
    tail=[abs(c[k])**(-mp.mpf(1)/k) for k in range(100,121) if c[k]!=0]
    x=mp.mpf(8)
    err=abs(mp.polyval(c[::-1],x)-f(x))
    print(f"{name:20s} radius est ~{mp.nstr(min(tail),4):>8s}  |T_120(8)-f(8)| = {mp.nstr(err,3)}")
