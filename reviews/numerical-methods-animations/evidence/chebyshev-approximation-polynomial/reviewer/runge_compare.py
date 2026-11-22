# Description claim: Chebyshev nodes reduce oscillation vs equally spaced nodes at the same degree.
# Max error on [-1,1] for f=1/(1+10x^2) (case 08), mpmath Lagrange at 40 digits.
import mpmath as mp
mp.mp.dps = 40
f = lambda x: 1/(1+10*x**2)
def maxerr(nodes):
    ys = [f(x) for x in nodes]
    def L(t):
        s = 0
        for j, xj in enumerate(nodes):
            p = ys[j]
            for k, xk in enumerate(nodes):
                if k != j: p *= (t-xk)/(xj-xk)
            s += p
        return s
    return max(abs(L(t)-f(t)) for t in mp.linspace(-1, 1, 801))
for n in (8, 12, 16, 24, 32):
    cheb = [mp.cos((2*k-1)*mp.pi/(2*n)) for k in range(1, n+1)]
    eq = mp.linspace(-1, 1, n)
    print(f"n={n:2d} deg={n-1:2d}  chebyshev maxerr={float(maxerr(cheb)):.3e}  equispaced maxerr={float(maxerr(eq)):.3e}")
