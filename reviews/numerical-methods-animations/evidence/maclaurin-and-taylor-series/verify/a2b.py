import mpmath as mp
mp.mp.dps=200
x=mp.mpf(8)
# exact series: exp(-x^2/2)=sum (-1)^m x^{2m}/(2^m m!) ; erf(z)=2/sqrt(pi) sum (-1)^m z^{2m+1}/(m!(2m+1))
for N in [100,200,300,400]:
    s=mp.fsum((-1)**m*x**(2*m)/(2**m*mp.factorial(m)) for m in range(N))
    z=x/mp.sqrt(2); e=2/mp.sqrt(mp.pi)*mp.fsum((-1)**m*z**(2*m+1)/(mp.factorial(m)*(2*m+1)) for m in range(N))
    print(N, mp.nstr(abs(s-mp.exp(-x**2/2)),3), mp.nstr(abs((1+e)/2-(1+mp.erf(z))/2),3))
