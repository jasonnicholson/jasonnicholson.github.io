# Independent Laurent coefficients a_k, k=-3..n, via mpmath contour integrals
# a_k = (1/2πi) ∮ f(z)/(z-c)^{k+1} dz on |z-c|=r, r inside the largest disc of analyticity,
# cross-checked with mpmath.taylor (numerical high-precision differentiation).
import mpmath as mp, sys
mp.mp.dps = 40
pi = mp.pi
cases = [
 ("01", lambda z: mp.sqrt(z), 1, 10, 0.5),
 ("02", lambda z: mp.sqrt(z), 4, 10, 2),
 ("03", lambda z: mp.sqrt(z), 5, 10, 2.5),
 ("04", lambda z: 1/mp.sqrt(1-z), 0, 10, 0.5),
 ("05", lambda z: mp.log(z), 1, 10, 0.5),
 ("06", lambda z: mp.log(z), 2, 10, 1),
 ("07", lambda z: mp.log(1+z), 0, 10, 0.5),
 ("08", mp.sin, 0, 10, 1),
 ("09", mp.cos, 0, 10, 1),
 ("10", mp.sin, pi/4, 10, 1),
 ("11", mp.cos, pi/3, 10, 1),
 ("12", mp.tan, 0, 8, 0.8),
 ("13", mp.exp, 0, 10, 1),
 ("14", lambda z: mp.exp(-z)*mp.cos(z), 0, 10, 1),
 ("15", mp.cosh, 0, 10, 1),
 ("16", mp.atan, 0, 10, 0.5),
 ("17", mp.asin, 0, 8, 0.5),
 ("18", lambda z: mp.besselj(0,z), 0, 10, 1),
 ("19", lambda z: mp.besselj(1,z), 0, 10, 1),
 ("20", lambda z: mp.exp(-z**2/2)/mp.sqrt(2*pi), 0, 10, 1),
 ("21", lambda z: mp.mpf(1)/2 + mp.erf(z/mp.sqrt(2))/2, 0, 10, 1),
 ("22", mp.gamma, 1, 8, 0.5),
 ("23", mp.gamma, 2, 8, 1),
 ("24", mp.gamma, 3, 8, 1.5),
 ("25", lambda z: mp.bessely(0,z), 10, 8, 2),
 ("26", lambda z: mp.bessely(0,z), 5, 8, 2),
 ("27", lambda z: mp.bessely(0,z), 2, 8, 1),
]
script = {}
for line in open(sys.argv[1]):
    p = line.split()
    script[p[0]] = [float(v) for v in p[4:]]
def coef(f, c, k, r, M=256):
    # trapezoid on circle (spectrally accurate for analytic integrand)
    s = 0
    for j in range(M):
        th = 2*pi*j/M
        z = c + r*mp.expj(th)
        s += f(z) * (r*mp.expj(th))**(-k)
    return s/M
worst = {}
for cid, f, c, n, r in cases:
    c = mp.mpf(c)
    neg = [coef(f, c, k, r) for k in (-1,-2,-3)]
    pos = [coef(f, c, k, r) for k in range(n+1)]
    tay = mp.taylor(f, c, n)
    sc = script[cid]
    print(f"Case {cid} c={mp.nstr(c,6)} r={r}  max|a_-1..-3|={mp.nstr(max(abs(v) for v in neg),3)}")
    rel = []
    for k in range(n+1):
        ref = pos[k].real
        d = abs(sc[k]-ref)
        rel.append((k, sc[k], float(ref), float(tay[k]), float(d/(abs(ref) if abs(ref)>1e-30 else 1))))
    mx = max(r_[4] for r_ in rel)
    print(f"   max rel err script vs contour: {mx:.2e}   max|contour-taylor|: {mp.nstr(max(abs(pos[k].real-tay[k]) for k in range(n+1)),3)}")
    if mx > 1e-8:
        for k, s, ref, t, e in rel:
            print(f"     k={k}: script={s:+.10e}  true={ref:+.10e}  relerr={e:.2e}")
