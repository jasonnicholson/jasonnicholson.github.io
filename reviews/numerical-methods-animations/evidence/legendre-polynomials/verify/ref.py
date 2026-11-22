import mpmath as mp, numpy as np
mp.mp.dps=40
f=lambda x: mp.cos(mp.pi*x/2)
c=[(2*n+1)/mp.mpf(2)*mp.quad(lambda x: f(x)*mp.legendre(n,x),[-1,0,1]) for n in range(9)]
x=[mp.mpf(-1)+2*mp.mpf(i)/499 for i in range(500)]
xf=np.linspace(-1,1,500)
for N in range(9):
    e=max(abs(sum(c[k]*mp.legendre(k,xi) for k in range(N+1))-f(xi)) for xi in x)
    # also sup on fine grid
    print(N, mp.nstr(c[N],12), "err500=",mp.nstr(e,6))
