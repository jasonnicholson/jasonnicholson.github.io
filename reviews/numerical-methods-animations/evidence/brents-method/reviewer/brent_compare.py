"""Independent implementations for comparison with brentsaa.jl / brentsbb.jl.
 - zeroin(): Brent's 1973 ZEROIN (netlib zeroin.f) transcribed, with step-type logging
 - wiki():   Wikipedia "Brent's method" pseudocode, faithful (cond1 = s not between (3a+b)/4 and b)
 - script_variant(): the scripts' logic re-written in Python (cond1 = s not strictly inside (a,b))
 - scipy brentq call counts; mpmath reference roots; bisection / regula falsi counts."""
import math, sys
import mpmath as mp
from scipy.optimize import brentq

EPS = 2.0**-52

def zeroin(f, ax, bx, tol, maxit=100):
    log = []
    a, b = ax, bx
    fa, fb = f(a), f(b)
    nfev = 2
    c, fc = a, fa; d = b - a; e = d
    first = True
    while True:
        if not first:
            pass
        first = False
        if abs(fc) < abs(fb):
            a, b, c = b, c, b
            fa, fb, fc = fb, fc, fb
        tol1 = 2.0*EPS*abs(b) + 0.5*tol
        xm = 0.5*(c - b)
        if abs(xm) <= tol1 or fb == 0.0:
            return b, log, nfev
        if abs(e) >= tol1 and abs(fa) > abs(fb):
            s = fb/fa
            if a == c:
                kind = "Secant"; p = 2.0*xm*s; q = 1.0 - s
            else:
                kind = "IQI"
                q = fa/fc; r = fb/fc
                p = s*(2.0*xm*q*(q - r) - (b - a)*(r - 1.0))
                q = (q - 1.0)*(r - 1.0)*(s - 1.0)
            if p > 0: q = -q
            else: p = -p
            s_ = e; e = d
            cand = b + p/q if q != 0 else float('nan')
            if (2.0*p >= 3.0*xm*q - abs(tol1*q)) or (p >= abs(0.5*s_*q)):
                d = xm; e = d; kind = "Bisection(rejected %s, cand=%.10g)" % (kind, cand)
            else:
                d = p/q
        else:
            d = xm; e = d; kind = "Bisection(forced)"
        a, fa = b, fb
        b = b + d if abs(d) > tol1 else b + math.copysign(tol1, xm)
        fb = f(b); nfev += 1
        log.append((kind, b, fb))
        if fb*(fc/abs(fc)) > 0:
            c, fc = a, fa; d = b - a; e = d
        if len(log) > maxit: return b, log, nfev

def wiki(f, a, b, tol, maxit=50, strict_cond1=True):
    log = []
    fa, fb = f(a), f(b)
    if abs(fa) < abs(fb): a, b, fa, fb = b, a, fb, fa
    c, fc = a, fa; mflag = True; d = 0.0
    for _ in range(maxit):
        if fb == 0 or abs(b - a) < tol: break
        if fa != fc and fb != fc:
            s = (a*fb*fc/((fa-fb)*(fa-fc)) + b*fa*fc/((fb-fa)*(fb-fc)) + c*fa*fb/((fc-fa)*(fc-fb))); kind = "IQI"
        else:
            s = b - fb*(b - a)/(fb - fa); kind = "Secant"
        cand = s
        if strict_cond1:
            lo, hi = sorted(((3*a + b)/4, b)); c1 = not (lo < s < hi)
        else:
            lo, hi = sorted((a, b)); c1 = not (lo < s < hi)
        c2 = mflag and abs(s-b) >= abs(b-c)/2
        c3 = (not mflag) and abs(s-b) >= abs(c-d)/2
        c4 = mflag and abs(b-c) < tol
        c5 = (not mflag) and abs(c-d) < tol
        if c1 or c2 or c3 or c4 or c5:
            s = (a + b)/2; kind = "Bisection(rejected %s, cand=%.10g; c%s)" % (kind, cand, ",".join(str(i+1) for i,v in enumerate((c1,c2,c3,c4,c5)) if v)); mflag = True
        else:
            mflag = False
        fs = f(s); d, c, fc = c, b, fb
        if fa*fs < 0: b, fb = s, fs
        else: a, fa = s, fs
        if abs(fa) < abs(fb): a, b, fa, fb = b, a, fb, fa
        log.append((kind, b, fb, a))
    return b, log

def regula_falsi(f, a, b, tol, maxit=100000):
    fa, fb = f(a), f(b); x_old = None
    for k in range(1, maxit+1):
        x = b - fb*(b - a)/(fb - fa); fx = f(x)
        if x_old is not None and abs(x - x_old) < tol: return k, x
        if fa*fx < 0: b, fb = x, fx
        else: a, fa = x, fx
        x_old = x
    return None, x

cases = {
 "aa": (lambda x: 4*x**3 - 16*x**2 + 17*x - 4, lambda x: 4*x**3 - 16*x**2 + 17*x - 4, 0.0, 1.0),
 "bb": (lambda x: math.tan(x) - 2*x, lambda x: mp.tan(x) - 2*x, 0.5, 1.5),
}
mp.mp.dps = 40
for name, (f, fm, a0, b0) in cases.items():
    print("="*20, name)
    r = mp.findroot(fm, (a0+b0)/2 if name=="bb" else 0.33)
    print("mpmath root:", mp.nstr(r, 20), " residual", mp.nstr(fm(r), 3))
    if name == "aa":
        print("all roots of 4x^3-16x^2+17x-4:", [mp.nstr(z, 15) for z in mp.polyroots([4,-16,17,-4])])
    print("f(a0)=%.6g f(b0)=%.6g" % (f(a0), f(b0)))
    print("-- Brent ZEROIN (tol=1e-10):")
    x, log, nfev = zeroin(f, a0, b0, 1e-10)
    for i, (k, xb, fxb) in enumerate(log, 1): print("  %2d %-55s b=%.15f f=%.3e" % (i, k, xb, fxb))
    print("  -> %.15f, nfev=%d" % (x, nfev))
    rr = brentq(f, a0, b0, xtol=1e-10, full_output=True)[1]
    print("-- scipy brentq(xtol=1e-10): root=%.15f iterations=%d function_calls=%d" % (rr.root, rr.iterations, rr.function_calls))
    print("-- Wikipedia pseudocode, faithful cond1 ((3a+b)/4..b):")
    x, log = wiki(f, a0, b0, 1e-10, strict_cond1=True)
    for i, (k, xb, fxb, xa) in enumerate(log, 1): print("  %2d %-55s b=%.15f a=%.6f width=%.2e" % (i, k, xb, xa, abs(xb-xa)))
    print("-- script variant re-implemented (cond1 = inside (a,b)):")
    x, log = wiki(f, a0, b0, 1e-10, strict_cond1=False)
    for i, (k, xb, fxb, xa) in enumerate(log, 1): print("  %2d %-55s b=%.15f a=%.6f width=%.2e" % (i, k, xb, xa, abs(xb-xa)))
    for tol in (1e-4, 1e-6, 1e-8, 1e-10):
        k, x = regula_falsi(f, a0, b0, tol)
        nb = math.ceil(math.log2((b0-a0)/tol))
        print("  tol=%g: regula falsi iters=%s (x=%.10f), bisection iters=%d" % (tol, k, x, nb))
