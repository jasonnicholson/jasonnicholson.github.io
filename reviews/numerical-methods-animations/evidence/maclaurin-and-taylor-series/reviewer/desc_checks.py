# Independent checks of the Description's radius-of-convergence heuristics.
import mpmath as mp, sympy as sp
mp.mp.dps = 40
x = sp.symbols('x')
def coeffs(expr, n, c=0):
    s = sp.series(expr, x, c, n+1).removeO()
    return [s.coeff(x - c if c else x, k) if c==0 else None for k in range(n+1)]
def root_test(expr, n=60):
    p = sp.Poly(sp.series(expr, x, 0, n+1).removeO(), x)
    cs = [(k, abs(float(p.coeff_monomial(x**k)))) for k in range(n-10, n+1) if p.coeff_monomial(x**k) != 0]
    return [round(a**(-1.0/k), 4) for k, a in cs][-3:]
print("Root-test radius estimates |a_k|^(-1/k) for k near 60:")
for name, e in [("tanh", sp.tanh(x)), ("atan", sp.atan(x)), ("1/(1+x^2)", 1/(1+x**2)),
                ("erf(x/sqrt2) (normal CDF)", sp.erf(x/sp.sqrt(2))), ("exp(-x^2/2)", sp.exp(-x**2/2)), ("exp(x)", sp.exp(x))]:
    print(f"  {name:28s}", root_test(e))
print("  pi/2 =", float(mp.pi/2))
# Normal CDF Maclaurin partial sums at x=3 (entire function with two horizontal asymptotes)
def ncdf_partial(xv, N):
    s = mp.mpf(1)/2
    for m in range(0, (N-1)//2+1):
        k = 2*m+1
        s += (-1)**m * xv**k / (mp.sqrt(2*mp.pi) * 2**m * mp.factorial(m) * k)
    return s
X = mp.mpf(3); tru = mp.ncdf(X)
print("\nNormal CDF at x=3, true =", mp.nstr(tru, 12))
for N in (10, 20, 30, 40, 60):
    print(f"  Maclaurin order {N:2d}: {mp.nstr(ncdf_partial(X, N), 12)}  err={mp.nstr(abs(ncdf_partial(X,N)-tru),3)}")
X = mp.mpf(10)
print("Normal CDF at x=10, order 400 partial sum:", mp.nstr(ncdf_partial(X, 400), 12), " true:", mp.nstr(mp.ncdf(X), 12))
# exp(-x^2/2) at x=3
for N in (12, 30, 60):
    s = sum((-1)**m * mp.mpf(3)**(2*m) / (2**m * mp.factorial(m)) for m in range(N//2+1))
    print(f"exp(-x^2/2) at x=3, order {N}: {mp.nstr(s,10)} true {mp.nstr(mp.exp(-4.5),10)}")
# Quadrature: trapezoid order vs exactness (for the 'second-order accurate' sentence)
print("\nTrapezoid single panel on [0,1]: x^0 ->", (1+1)/2, "exact 1; x^1 ->", (0+1)/2, "exact 0.5; x^2 ->", (0+1)/2, "exact", 1/3)
f = lambda t: mp.exp(t); I = mp.e - 1
def ctrap(n):
    h = mp.mpf(1)/n; return h*(f(0)/2 + sum(f(i*h) for i in range(1,n)) + f(1)/2)
e1, e2 = abs(ctrap(10)-I), abs(ctrap(20)-I)
print("Composite trapezoid exp on [0,1]: err(10)/err(20) =", mp.nstr(e1/e2, 6), "(=> order", mp.nstr(mp.log(e1/e2,2),4), ")")
