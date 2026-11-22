import os, mpmath as mp
mp.mp.dps = 50
D = os.path.dirname(os.path.abspath(__file__))
src = open(os.path.join(D, "compare_pade.py")).read().split("summary = []")[0]
g = {"__file__": os.path.join(D, "compare_pade.py")}; exec(src, g)
cases, EX, ref_pade = g["cases"], g["EX"], g["ref_pade"]
for cid, cs in cases.items():
    a = [mp.mpf(s) for s in EX[cid]["num"]]
    for (m, n, how, P, Q) in cs["pairs"]:
        Pr, Qr, ns, _ = ref_pade(a, m, n)
        if not ns: continue
        p2, q2 = mp.pade(a, m, n)
        d = max([abs(p2[i]-Pr[i]) for i in range(m+1)] + [abs(q2[i]-Qr[i]) for i in range(n+1)])
        sc = max([abs(v) for v in Pr] + [abs(v) for v in Qr])
        if d/sc > 1e-20:
            # residual of mp.pade's own result against the series
            res = max(abs(sum(q2[j]*a[k-j] for j in range(0, min(k, n)+1)) - (p2[k] if k <= m else 0)) for k in range(m+n+1))
            res2 = max(abs(sum(Qr[j]*a[k-j] for j in range(0, min(k, n)+1)) - (Pr[k] if k <= m else 0)) for k in range(m+n+1))
            print(cid, m, n, "diff", mp.nstr(d/sc, 3), "mp.pade residual", mp.nstr(res, 3), "own residual", mp.nstr(res2, 3))
