# Independent exact Taylor coefficients via sympy differentiation (no reuse of script formulas)
import sympy as sp, json, sys, os
x = sp.symbols('x')
D = os.path.dirname(os.path.abspath(__file__))
cases = [
 ("01", sp.sqrt(x), 1, 10), ("02", sp.sqrt(x), 4, 10), ("03", sp.sqrt(x), 5, 10),
 ("04", 1/sp.sqrt(1-x), 0, 10), ("05", sp.log(x), 1, 10), ("06", sp.log(x), 2, 10),
 ("07", sp.log(1+x), 0, 10), ("08", sp.sin(x), 0, 10), ("09", sp.cos(x), 0, 10),
 ("10", sp.sin(x), sp.pi/4, 10), ("11", sp.cos(x), sp.pi/3, 10), ("12", sp.tan(x), 0, 8),
 ("13", sp.exp(x), 0, 10), ("14", sp.exp(-x)*sp.cos(x), 0, 10), ("15", sp.cosh(x), 0, 10),
 ("16", sp.atan(x), 0, 10), ("17", sp.asin(x), 0, 8), ("18", sp.besselj(0,x), 0, 10),
 ("19", sp.besselj(1,x), 0, 10), ("20", sp.exp(-x**2/2)/sp.sqrt(2*sp.pi), 0, 10),
 ("21", sp.Rational(1,2)+sp.erf(x/sp.sqrt(2))/2, 0, 10),
 ("22", sp.gamma(x), 1, 8), ("23", sp.gamma(x), 2, 8), ("24", sp.gamma(x), 3, 8),
 ("25", sp.bessely(0,x), 10, 8), ("26", sp.bessely(0,x), 5, 8), ("27", sp.bessely(0,x), 2, 8),
]
out = {}
for cid, f, c, n in cases:
    exact = []
    g = f
    for k in range(n+1):
        v = g.subs(x, c)
        v = sp.simplify(v) if cid not in ("22","23","24","25","26","27") else v
        exact.append(v / sp.factorial(k))
        g = sp.diff(g, x)
    out[cid] = {"c": str(c), "n": n, "exact": [str(e) for e in exact],
                "num": [str(sp.N(e, 40)) for e in exact]}
    print(cid, [sp.N(e, 12) for e in exact])
json.dump(out, open(os.path.join(D, "exact_coeffs.json"), "w"), indent=1)
