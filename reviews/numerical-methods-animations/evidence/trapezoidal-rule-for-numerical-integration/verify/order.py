import mpmath as mp, numpy as np
mp.mp.dps = 40
f = lambda x: mp.e**(-x)*mp.sin(8*mp.power(x, mp.mpf(2)/3)) + 1
# substitution x=t^3 removes the singularity: dx = 3t^2 dt
I = mp.quad(lambda t: f(t**3)*3*t**2, [0, mp.mpf(2)**(mp.mpf(1)/3)])
I2 = mp.quad(f, [0, mp.mpf('0.001'), mp.mpf('0.1'), 1, 2])
print("I =", I, " cross-check diff", I - I2)
def T(n):
    h = mp.mpf(2)/n
    return h*(f(0)/2 + mp.fsum(f(i*h) for i in range(1,n)) + f(2)/2)
print("animation n values:")
for n in [1,2,4,8,16,32,48,56,72,96,120]:
    print(n, mp.nstr(T(n),10), mp.nstr(T(n)-I,6))
print("doubling sequence, observed order log2(e_n/e_2n):")
prev=None
for k in range(3,15):
    n=2**k; e=T(n)-I
    if prev is not None: print(n, mp.nstr(e,6), mp.nstr(mp.log(abs(prev/e),2),5))
    prev=e
ns = np.array([8,10,12,14,16,20,24,28,32,40,48,56,72,96,120])
es = np.array([float(abs(T(int(n))-I)) for n in ns])
p = np.polyfit(np.log(2/ns), np.log(es), 1)[0]
print("LS slope over animation range n=8..120:", p)
