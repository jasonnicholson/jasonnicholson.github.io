import numpy as np, mpmath as mp
mp.mp.dps=30
I = mp.mpf('2.0162797196170963279')
f = lambda x: 1+np.exp(-x)*np.sin(8*np.cbrt(x)**2)
fs = lambda x: 1+np.exp(-x)*np.sin(8*x)          # smooth comparison, same oscillation scale
Is = float(mp.quad(lambda x: 1+mp.exp(-x)*mp.sin(8*x), [0,2]))
prev=None
for n in [8,16,20,32,64,128]:
    t,w = np.polynomial.legendre.leggauss(n); x=1+t
    e = float(mp.mpf(np.sum(w*f(x))) - I); es = np.sum(w*fs(x))-Is
    p = '' if prev is None else f"  observed order log2(e_prev/e)/log2(n/n_prev)={np.log(prev[1]/e)/np.log(n/prev[0]):.3f}"
    print(f"n={n:3d} err(page f)={e:.4e}  err(smooth 1+e^-x sin 8x)={es:.2e}{p}")
    prev=(n,e)
