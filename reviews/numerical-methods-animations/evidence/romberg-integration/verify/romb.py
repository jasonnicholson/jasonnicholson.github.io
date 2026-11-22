import mpmath as mp
mp.mp.dps=50
def run(f,a,b,K,label,exact):
    R=[[None]*K for _ in range(K)]
    for k in range(K):
        n=2**k; h=(b-a)/n
        R[k][0]=h*(f(a)/2+f(b)/2+mp.fsum(f(a+i*h) for i in range(1,n)))
        for j in range(1,k+1):
            R[k][j]=R[k][j-1]+(R[k][j-1]-R[k-1][j-1])/(4**j-1)
    print(label,"exact=",mp.nstr(exact,20))
    print(" k  m    |T-I|        |Rkk-I|      ratio(Rkk)   |R[k,2]-I|")
    prev=None
    for k in range(K):
        e=abs(R[k][k]-exact); t=abs(R[k][0]-exact)
        e2=abs(R[k][1]-exact) if k>0 else mp.nan
        r=mp.nstr(prev/e,4) if prev else ''
        print(f"{k+1:2d} {2**k+1:4d}  {mp.nstr(t,4):12s} {mp.nstr(e,4):12s} {r:10s} {mp.nstr(e2,4)}")
        prev=e
    return R
f=lambda x: 1+mp.exp(-x)*mp.sin(8*mp.cbrt(x)**2)
I=mp.quad(f,[0,mp.mpf('1e-6'),mp.mpf('0.01'),0.1,0.5,1,2],maxdegree=12)
I2=2+mp.quad(lambda t: 3*t**2*mp.exp(-t**3)*mp.sin(8*t**2),[0,0.5,1,mp.cbrt(2)])  # x=t^3 substitution, smooth
print("I quad",I," I subst",I2)
R=run(f,mp.mpf(0),mp.mpf(2),12,"rough",I2)
print("Final table row 8:",[mp.nstr(v,10) for v in R[7][:8]])
g=lambda x: 1+mp.exp(-x)*mp.sin(8*x)
Ig=2+mp.quad(lambda x: mp.exp(-x)*mp.sin(8*x),[0,2])
run(g,mp.mpf(0),mp.mpf(2),8,"smooth sin(8x)",Ig)
