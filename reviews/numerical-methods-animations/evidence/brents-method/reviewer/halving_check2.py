# Search for a counterexample to "halves the bracket at every other step" (index.qmd:44)
import math, importlib.util, io, contextlib
spec = importlib.util.spec_from_file_location("bc", "brent_compare.py"); bc = importlib.util.module_from_spec(spec)
with contextlib.redirect_stdout(io.StringIO()): spec.loader.exec_module(bc)
tests = {"(x-0.3)^9 on [0,2]": (lambda x: (x-0.3)**9, 0, 2),
         "x^5 on [-1,4]": (lambda x: x**5, -1, 4),
         "sign(x)exp(-1/x^2) on [-1,4]": (lambda x: math.copysign(math.exp(-1/x**2), x) if x != 0 else 0.0, -1, 4),
         "atan(50(x-0.1)) on [0,3]": (lambda x: math.atan(50*(x-0.1)), 0, 3),
         "x^(1/3) on [-1,8]": (lambda x: math.copysign(abs(x)**(1/3), x), -1, 8)}
for name,(f,a,b) in tests.items():
    _, log = bc.wiki(f, a, b, 1e-10, maxit=400, strict_cond1=False)
    w = [abs(b-a)] + [abs(t[1]-t[3]) for t in log]
    bad = [(k, w[k], w[k+2]) for k in range(len(w)-2) if w[k+2] > w[k]/2]
    kinds = "".join(t[0][0] for t in log)
    print(f"{name}: script-variant steps={len(log)} (bisection would need {math.ceil(math.log2((b-a)/1e-10))}); kinds={kinds}")
    print(f"   two-step windows without halving: {len(bad)}; first few: {[(k, f'{x:.3g}', f'{y:.3g}') for k,x,y in bad[:4]]}")
print("--- Brent ZEROIN and scipy brentq on the same functions")
from scipy.optimize import brentq
for name,(f,a,b) in tests.items():
    x, log, nfev = bc.zeroin(f, a, b, 1e-10, maxit=400)
    r = brentq(f, a, b, xtol=1e-10, full_output=True)[1]
    print(f"{name}: zeroin steps={len(log)} nfev={nfev}; scipy brentq function_calls={r.function_calls}")
