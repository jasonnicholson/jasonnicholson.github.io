import mpmath as mp
mp.mp.dps=30
f=lambda x: mp.e**(-x)*mp.sin(8*mp.cbrt(x)**2)+1
I=mp.quad(lambda t: f(t**3)*3*t**2,[0,mp.cbrt(2)])
def S(n,off):
    h=mp.mpf(2)/n; return h*mp.fsum(f((i+off)*h) for i in range(n))
M=lambda n:S(n,mp.mpf(1)/2); L=lambda n:S(n,0); R=lambda n:S(n,1)
T=lambda n:(L(n)+R(n))/2
print("n  errM  errL  errR  errT")
for n in [3,4,6,8,10,16,20,32,64,120]:
    print(n, *[mp.nstr(g(n)-I,4) for g in (M,L,R,T)])
print("pairs in n_seq (n,2n): ratio errM(n)/errM(2n)")
for n in [1,2,3,4,5,6,7,8,10,12,14,16,20,24,28,32,52,60]:
    print(n,2*n, mp.nstr((M(n)-I)/(M(2*n)-I),5))
print("f(1/3),f(1),f(5/3):",[mp.nstr(f(x),6) for x in (mp.mpf(1)/3,1,mp.mpf(5)/3)])
print("f(0),f(2)",f(0),f(2))
