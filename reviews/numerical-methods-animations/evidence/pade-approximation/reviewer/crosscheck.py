# (1) cross-check sympy-derived Gamma/Y0 Taylor coefficients with mpmath.taylor
# (2) cross-check own linear-solve Pade with mpmath.pade for every exactly-nonsingular pair
# (3) pole locations / values for frames cited in the report
import os, json, numpy as np, mpmath as mp
mp.mp.dps = 50
D = os.path.dirname(os.path.abspath(__file__))
src = open(os.path.join(D, "compare_pade.py")).read().split("summary = []")[0]
g = {"__file__": os.path.join(D, "compare_pade.py")}; exec(src, g)
cases, EX, ref_pade, peval, fpeval = g["cases"], g["EX"], g["ref_pade"], g["peval"], g["fpeval"]
fn = {"22": (mp.gamma, 1), "23": (mp.gamma, 2), "24": (mp.gamma, 3),
      "25": (lambda t: mp.bessely(0, t), 10), "26": (lambda t: mp.bessely(0, t), 5), "27": (lambda t: mp.bessely(0, t), 2)}
for cid, (f, c) in fn.items():
    t = mp.taylor(f, c, 8)
    ex = [mp.mpf(s) for s in EX[cid]["num"]]
    print(cid, "max |mpmath.taylor - sympy| rel =", mp.nstr(max(abs(t[k]-ex[k])/abs(ex[k]) for k in range(9)), 3),
          " script rel err k=5..8:", [f"{abs(cases[cid]['A'][k]-float(ex[k]))/abs(float(ex[k]))*100:.1f}%" for k in range(5, 9)])
# (2)
worst = 0; cnt = 0
for cid, cs in cases.items():
    a = [mp.mpf(s) for s in EX[cid]["num"]]
    for (m, n, how, P, Q) in cs["pairs"]:
        Pr, Qr, ns, _ = ref_pade(a, m, n)
        if not ns: continue
        try:
            p2, q2 = mp.pade(a, m, n)
        except Exception as e:
            print("mp.pade failed", cid, m, n, e); continue
        # compare normalised coefficient vectors (q0=1 both)
        d = max([abs(p2[i]-Pr[i]) for i in range(m+1)] + [abs(q2[i]-Qr[i]) for i in range(n+1)])
        sc = max([abs(v) for v in Pr] + [abs(v) for v in Qr])
        worst = max(worst, d/sc); cnt += 1
print("mpmath.pade vs own solve: pairs compared =", cnt, " max rel coeff diff =", mp.nstr(worst, 3))
# (3)
def realroots(Q, c, lo, hi):
    r = np.roots(np.array([float(v) for v in Q][::-1])) if len(Q) > 1 else []
    return sorted(round(float(z.real) + c, 3) for z in r if abs(z.imag) < 1e-6 and lo <= z.real + c <= hi)
for cid, m, n in [("22", 6, 2), ("22", 4, 4), ("24", 3, 5), ("27", 4, 4), ("27", 6, 2), ("15", 1, 3), ("12", 2, 3), ("23", 2, 5), ("23", 0, 8)]:
    cs = cases[cid]; a = [mp.mpf(s) for s in EX[cid]["num"]]
    P, Q = next((p[3], p[4]) for p in cs["pairs"] if p[0] == m and p[1] == n)
    Pr, Qr, ns, _ = ref_pade(a, m, n)
    c = cs["c"]; lo, hi = cs["xlims"]
    xe = hi
    print(f"case {cid} [{m}/{n}] real poles in window: script {realroots(Q, c, lo, hi)}  ref {realroots([float(v) for v in Qr], c, lo, hi)};"
          f"  R(x={xe}) script {fpeval(P, xe-c)/fpeval(Q, xe-c):.4g} ref {float(peval(Pr, xe-c)/peval(Qr, xe-c)):.4g}; numerator roots script {realroots(P, c, lo, hi)} ref {realroots([float(v) for v in Pr], c, lo, hi)}")
