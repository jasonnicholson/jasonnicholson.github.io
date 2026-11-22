# Actual degree of each interpolant: Chebyshev coefficients of the interpolant through the script's
# node values (exact solve in the T_k basis on the mapped interval); report frames where the
# leading coefficient is ~0 relative to the others, i.e. true degree < the "degree n-1" in the title.
import re, numpy as np
from numpy.polynomial import chebyshev as C
txt = open('dump.txt').read()
for c in re.split(r'^CASE ', txt, flags=re.M)[1:]:
    cid = c[:2]
    span = eval(re.search(r' span=\(([^)]*)\)', c).group(0).split('=')[1])
    a, b = span
    bad = []
    for n, xs, ys in re.findall(r'n=(\d+) .*?\n    xs=(\[.*?\])\n    ys=(\[.*?\])', c):
        n = int(n); t = (2*np.array(eval(xs)) - a - b)/(b - a); y = np.array(eval(ys))
        V = C.chebvander(t, n-1); coef = np.linalg.solve(V, y)
        tol = 1e-10*np.max(np.abs(coef))
        deg = max(k for k in range(n) if abs(coef[k]) > tol)
        if deg != n-1: bad.append(f"title {n-1} -> actual {deg}")
    print(cid, "; ".join(bad) if bad else "all frames: actual degree = title degree")
