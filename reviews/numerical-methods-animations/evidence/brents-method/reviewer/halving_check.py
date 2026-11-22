# Does the bracket |b-a| halve at least every other step?  (page line 44 claim)
# Uses wiki(strict_cond1=False), shown identical to the scripts' run_brents on both page cases.
import math, importlib.util, io, contextlib
spec = importlib.util.spec_from_file_location("bc", "brent_compare.py"); bc = importlib.util.module_from_spec(spec)
with contextlib.redirect_stdout(io.StringIO()): spec.loader.exec_module(bc)
tests = {"x^2-2 on [0,10]": (lambda x: x*x-2, 0, 10), "exp(x)-2 on [0,5]": (lambda x: math.exp(x)-2, 0, 5),
         "x^3-x-1 on [1,2]": (lambda x: x**3-x-1, 1, 2), "page case 1": (lambda x: 4*x**3-16*x**2+17*x-4, 0, 1),
         "page case 2": (lambda x: math.tan(x)-2*x, 0.5, 1.5)}
for name,(f,a,b) in tests.items():
    _, log = bc.wiki(f, a, b, 1e-10, strict_cond1=False)
    w = [abs(b-a)] + [abs(t[1]-t[3]) for t in log]
    bad = [(k, w[k], w[k+2]) for k in range(len(w)-2) if w[k+2] > w[k]/2]
    print(f"{name}: {len(log)} steps; widths {[f'{x:.3g}' for x in w]}")
    print("   two-step windows without halving:", [(k, f'{x:.3g}', f'{y:.3g}') for k,x,y in bad])
