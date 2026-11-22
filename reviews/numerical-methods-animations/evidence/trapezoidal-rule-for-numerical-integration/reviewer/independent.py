# Independent check: mpmath reference integral, exact-rational-node trapezoid sums, error ratios
import mpmath as mp
mp.mp.dps = 40
f = lambda x: mp.e**(-x)*mp.sin(8*mp.cbrt(x)**2)+1
# substitution x=t^3 removes the singular derivative at 0: dx = 3t^2 dt
I1 = mp.quad(lambda t: f(t**3)*3*t**2, [0, mp.cbrt(2)], maxdegree=12)
I2 = mp.quad(f, mp.linspace(0,2,41), maxdegree=12)
print("I (subst) =", mp.nstr(I1, 25)); print("I (direct)=", mp.nstr(I2, 25))
I = I1
def T(n):
    h = mp.mpf(2)/n
    return h*(f(0)/2 + mp.fsum(f(i*h) for i in range(1,n)) + f(2)/2)
nseq=[1,2,3,4,5,6,7,8,10,12,14,16,18,20,24,28,32,40,48,56,72,96,120]
for n in nseq:
    print(n, n+1, mp.nstr(T(n),12), "err", mp.nstr(T(n)-I,6))
print("halving ratios E(n)/E(2n), and observed order log2:")
prev=None
for n in [8,16,32,64,128,256,512,1024,2048,4096,8192]:
    e = T(n)-I
    if prev is not None:
        r = prev/e
        print(n, mp.nstr(e,6), "ratio", mp.nstr(r,6), "p=", mp.nstr(mp.log(abs(r),2),5))
    else: print(n, mp.nstr(e,6))
    prev = e
# ratio within the frames shown: 24->48, 28->56, 48->96, 60->120
for n1,n2 in [(24,48),(28,56),(48,96),(60,120),(40,120)]:
    e1=T(n1)-I; e2=T(n2)-I
    print(n1,n2,"ratio",mp.nstr(e1/e2,6),"p=",mp.nstr(mp.log(abs(e1/e2))/mp.log(mp.mpf(n2)/n1),5))
