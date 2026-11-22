import numpy as np, mpmath as mp
mp.mp.dps=30
I=float(mp.quad(lambda u: (1+mp.e**(-u**3)*mp.sin(8*u**2))*3*u**2,[0,mp.cbrt(2)]))
fn=lambda x: 1+np.exp(-x)*np.sin(8*x**(2/3))
def GL(g,n):
    t,w=np.polynomial.legendre.leggauss(n); return np.sum(w*g(1+t))
for n1,n2 in [(8,16),(16,32),(32,64),(64,128),(128,256)]:
    e1,e2=GL(fn,n1)-I,GL(fn,n2)-I
    print(f"observed order {n1}->{n2}: {np.log(e1/e2)/np.log(2):.3f}")
# smooth control: same oscillation, smooth argument
gs=lambda x: 1+np.exp(-x)*np.sin(8*x)
Is=float(mp.quad(lambda x:1+mp.e**(-x)*mp.sin(8*x),[0,2]))
for n in [5,10,15,20,25]:
    print(f"smooth control n={n}: err={GL(gs,n)-Is:+.2e}")
