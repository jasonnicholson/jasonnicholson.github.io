import mpmath as mp
mp.mp.dps=40
f=lambda x: mp.e**(-x)*mp.sin(8*mp.cbrt(x)**2)+1
# substitution x=t^3 removes the singularity: dx=3t^2 dt
I=mp.quad(lambda t: f(t**3)*3*t**2,[0,mp.cbrt(2)])
I2=mp.quad(f,[0,0.5,1,2])
print("I =",I, " check", I2)
def M(n):
    dx=mp.mpf(2)/n
    return dx*mp.fsum(f((i+mp.mpf(1)/2)*dx) for i in range(n))
print("Animation n sequence (doubling pairs):")
seq=[1,2,3,4,5,6,7,8,10,12,14,16,20,24,28,32,40,48,56,64,72,88,104,120]
E={n:M(n)-I for n in seq}
for n in seq: print(n, mp.nstr(M(n),10), mp.nstr(E[n],6))
print("ratios E(n)/E(2n) within animation:")
for n in seq:
    if 2*n in E: print(n,2*n, mp.nstr(E[n]/E[2*n],5))
print("asymptotic ratios:")
prev=None
for k in range(4,16):
    n=2**k; e=M(n)-I
    if prev is not None: print(n, mp.nstr(e,6), "ratio",mp.nstr(prev/e,6), "order", mp.nstr(mp.log(abs(prev/e),2),5))
    prev=e
print("2^(5/3)=",2**(5/3))
