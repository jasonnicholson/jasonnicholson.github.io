# Reproduce script's series_coeffs_fit grid (q=max(n+6,14), h=min(0.01*max(1,|c|), 0.45*min(room)/q)) and
# fit (a) with exact 50-digit samples and (b) with samples rounded to Float64, to see which causes the error.
import mpmath as mp, json, os
mp.mp.dps = 50
D = os.path.dirname(os.path.abspath(__file__)); EX = json.load(open(os.path.join(D, "exact_coeffs.json")))
cs = {"22": (mp.gamma, 1.0, (-0.2, 5.2)), "23": (mp.gamma, 2.0, (-0.2, 5.2)), "24": (mp.gamma, 3.0, (-0.2, 5.2)),
      "25": (lambda t: mp.bessely(0, t), 10.0, (0.0, 22.0)), "26": (lambda t: mp.bessely(0, t), 5.0, (0.0, 22.0)), "27": (lambda t: mp.bessely(0, t), 2.0, (0.0, 22.0))}
n = 8
for cid, (f, c, xl) in cs.items():
    q = max(n+6, 14); h = max(1e-5, min(0.01*max(1, abs(c)), 0.45*min(c-xl[0], xl[1]-c)/q))
    ts = list(range(-q, q+1))
    ex = [mp.mpf(s) for s in EX[cid]["num"]]
    out = []
    for rnd in (False, True):
        ys = [f(mp.mpf(c) + mp.mpf(h)*t) for t in ts]
        if rnd: ys = [mp.mpf(float(y)) for y in ys]
        A = mp.matrix([[mp.mpf(t)**k for k in range(n+1)] for t in ts]); Y = mp.matrix(ys)
        a = mp.lu_solve(A.T*A, A.T*Y)   # normal equations at 50 digits
        out.append([float(abs(a[k]/mp.mpf(h)**k - ex[k])/abs(ex[k])) for k in range(n+1)])
    print(cid, f"h={h:g}", "exact samples: max rel err k=5..8", ["%.1e" % e for e in out[0][5:]], "| Float64 samples:", ["%.1e" % e for e in out[1][5:]])
