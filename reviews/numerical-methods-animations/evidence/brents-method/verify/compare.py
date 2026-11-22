"""Compare the page's script algorithm (Python port) with Brent's ZEROIN (netlib zeroin.f logic)
step by step, and test the bracket-halving claim."""
import math, sys

EPS = 2.0**-52


def script_brent(f, a, b, n_iters, tol):
    """Line-for-line port of run_brents in brentsaa.jl / brentsbb.jl"""
    steps = []
    fa, fb = f(a), f(b)
    if abs(fa) < abs(fb):
        a, b = b, a
    c = a
    mflag = True
    s = b
    d = 0.0
    steps.append((a, b, "init", None))
    for _ in range(n_iters):
        fa, fb, fc = f(a), f(b), f(c)
        if abs(fb) < tol or abs(b - a) < tol:
            break
        if fa != fc and fb != fc:
            s = (a * fb * fc / ((fa - fb) * (fa - fc)) + b * fa * fc / ((fb - fa) * (fb - fc))
                 + c * fa * fb / ((fc - fa) * (fc - fb)))
            method = "IQI"
        else:
            s = b - fb * (b - a) / (fb - fa)
            method = "Secant"
        tried = method
        mid = (a + b) / 2
        lo, hi = min(a, b), max(a, b)
        c1 = not (lo < s < hi)
        c2 = mflag and abs(s - b) >= abs(b - c) / 2
        c3 = (not mflag) and abs(s - b) >= abs(c - d) / 2
        c4 = mflag and abs(b - c) < tol
        c5 = (not mflag) and abs(c - d) < tol
        if c1 or c2 or c3 or c4 or c5:
            s = mid
            method = "Bisection"
            mflag = True
        else:
            mflag = False
        d = c
        c = b
        if f(a) * f(s) < 0:
            b = s
        else:
            a = s
        if abs(f(a)) < abs(f(b)):
            a, b = b, a
        steps.append((a, b, method, tried))
    return steps


def zeroin(f, ax, bx, tol, maxit=500):
    """Brent's ZEROIN (Brent 1973, ch.4; netlib zeroin.f). Returns list of
    (b, c, kind) after each evaluation; [b,c] is the bracket, b the best point."""
    a, b = ax, bx
    fa, fb = f(a), f(b)
    hist = []
    c, fc = a, fa
    d = b - a
    e = d
    need_reset = False
    it = 0
    while it < maxit:
        if need_reset:
            c, fc = a, fa
            d = b - a
            e = d
        if abs(fc) < abs(fb):
            a, b, c = b, c, b
            fa, fb, fc = fb, fc, fb
        tol1 = 2.0 * EPS * abs(b) + 0.5 * tol
        xm = 0.5 * (c - b)
        if abs(xm) <= tol1 or fb == 0.0:
            hist.append((b, c, "done"))
            return hist
        kind = None
        if abs(e) >= tol1 and abs(fa) > abs(fb):
            s = fb / fa
            if a == c:
                p = 2.0 * xm * s
                q = 1.0 - s
                tried = "Secant"
            else:
                q = fa / fc
                r = fb / fc
                p = s * (2.0 * xm * q * (q - r) - (b - a) * (r - 1.0))
                q = (q - 1.0) * (r - 1.0) * (s - 1.0)
                tried = "IQI"
            if p > 0:
                q = -q
            p = abs(p)
            if 2.0 * p >= 3.0 * xm * q - abs(tol1 * q) or p >= abs(0.5 * e * q):
                d = xm; e = d; kind = "Bisection(rejected " + tried + ")"
            else:
                e = d; d = p / q; kind = tried
        else:
            d = xm; e = d; kind = "Bisection"
        a, fa = b, fb
        if abs(d) > tol1:
            b = b + d
        else:
            b = b + math.copysign(tol1, xm)
        fb = f(b)
        it += 1
        need_reset = (fb * (fc / abs(fc))) > 0
        # report bracket after this step: the bracket is [b, c'] where c' = c unless reset
        cc = a if need_reset else c
        hist.append((b, cc, kind))
    return hist


if __name__ == "__main__":
    cases = {
        "case1": (lambda x: 4 * x**3 - 16 * x**2 + 17 * x - 4, 0.0, 1.0, 14),
        "case2": (lambda x: math.tan(x) - 2 * x, 0.5, 1.5, 16),
    }
    for name, (f, a0, b0, n) in cases.items():
        print("=====", name)
        print("-- script algorithm (port)")
        for i, (a, b, m, tried) in enumerate(script_brent(f, a0, b0, n, 1e-10)):
            bb = a if abs(f(a)) < abs(f(b)) else b
            print(f"{i:2d} {m:10s} tried={tried!s:7s} best={bb:.15f} width={abs(b-a):.3e}")
        print("-- Brent ZEROIN (tol=1e-10)")
        for i, (b, c, k) in enumerate(zeroin(f, a0, b0, 1e-10)):
            print(f"{i+1:2d} {k:28s} b={b:.15f} width={abs(c-b):.3e} f(b)={f(b):.3e}")
