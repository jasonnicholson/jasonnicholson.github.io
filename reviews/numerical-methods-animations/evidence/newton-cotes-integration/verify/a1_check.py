from fractions import Fraction as F
import mpmath as mp
mp.mp.dps=40
W={'trap':[F(1,2),F(1,2)],'simp13':[F(1,6),F(4,6),F(1,6)],'simp38':[F(1,8),F(3,8),F(3,8),F(1,8)],'boole':[F(7,90),F(32,90),F(12,90),F(32,90),F(7,90)]}
# degree of precision on [0,1]
for k,w in W.items():
    m=len(w)-1; d=0
    while True:
        q=sum(wi*F(i,m)**d for i,wi in enumerate(w)); ex=F(1,d+1)
        if q!=ex: print(k,'degree of precision',d-1,'| x^%d error coefficient'%d, float(q-ex)); break
        d+=1
def comp(f,a,b,w,N):  # N panels
    m=len(w)-1; n=N*m; h=(b-a)/mp.mpf(n); s=0
    for p in range(N):
        for i,wi in enumerate(w): s+=mp.mpf(wi.numerator)/wi.denominator*f(a+(p*m+i)*h)
    return s*m*h
def study(name,f,a,b):
    I=mp.quad(f,[a,(a+b)/2,b]); print('\n',name,'I=',mp.nstr(I,20))
    for k,w in W.items():
        m=len(w)-1; prev=None; out=[]
        # use same h for all rules: n = 12*2^j subintervals (divisible by 1..4)
        for j in range(1,8):
            n=12*2**j; e=abs(comp(f,a,b,w,n//m)-I)
            if prev: out.append(float(mp.log(prev/e,2)))
            prev=e
        print(f'{k:7s} err(n=1536)={float(e):.3e} observed orders',['%.2f'%o for o in out])
study('smooth: exp(-x)*sin(8x)+1 on [0,2]',lambda x: mp.e**(-x)*mp.sin(8*x)+1,0,2)
study('page integrand exp(-x)*sin(8x^(2/3))+1 on [0,2]',lambda x: mp.e**(-x)*mp.sin(8*mp.cbrt(x)**2)+1,mp.mpf(0),mp.mpf(2))
