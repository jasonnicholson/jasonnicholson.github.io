# For the 6 cases whose coefficients come from the numeric fit, compare the drawn
# (clamped) polynomial with the exact Taylor polynomial (mpmath.taylor), per frame n.
import mpmath as mp, numpy as np, sys
mp.mp.dps = 40
script = {l.split()[0]: [float(v) for v in l.split()[4:]] for l in open(sys.argv[1])}
cases = [("22", mp.gamma, 1.0, (-0.2,5.2), (-10,35)),
         ("23", mp.gamma, 2.0, (-0.2,5.2), (-10,35)),
         ("24", mp.gamma, 3.0, (-0.2,5.2), (-10,45)),
         ("25", lambda z: mp.bessely(0,z), 10.0, (0,22), (-2,2)),
         ("26", lambda z: mp.bessely(0,z), 5.0, (0,22), (-2,2)),
         ("27", lambda z: mp.bessely(0,z), 2.0, (0,22), (-2,2))]
for cid, f, c, xl, yl in cases:
    sc = script[cid]; n = len(sc)-1
    tr = [float(v) for v in mp.taylor(f, c, n)]
    x = np.linspace(xl[0], xl[1], 900); z = x - c
    span = yl[1]-yl[0]
    out = []
    for N in range(1, n+1):
        ps = np.polyval(sc[:N+1][::-1], z); pt = np.polyval(tr[:N+1][::-1], z)
        d = np.abs(np.clip(ps, *yl) - np.clip(pt, *yl))
        out.append(f"N={N}: {d.max()/span*100:.2f}%")
    print(cid, "max clamped diff as % of y-span:", ", ".join(out))
