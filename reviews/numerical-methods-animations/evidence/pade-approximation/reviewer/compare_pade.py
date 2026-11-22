# Compare script's Pade (p,q from script_values.txt) with an independent Pade built from exact
# Taylor coefficients (exact_coeffs.json) at 60 digits; Frobenius (null-space) form when singular.
import json, os, math, sys
import mpmath as mp
import numpy as np
mp.mp.dps = 60
D = os.path.dirname(os.path.abspath(__file__))
EX = json.load(open(os.path.join(D, "exact_coeffs.json")))

# parse script values
cases = {}
cur = None
for line in open(os.path.join(D, "script_values.txt")):
    t = line.split()
    if t[0] == "CASE":
        cid = t[1]; cur = {"pairs": []}; cases[cid] = cur
        cur["c"] = float(line.split("c=")[1].split()[0])
        xl = line.split("xlims=(")[1].split(")")[0].split(",")
        yl = line.split("ylims=(")[1].split(")")[0].split(",")
        cur["xlims"] = (float(xl[0]), float(xl[1])); cur["ylims"] = (float(yl[0]), float(yl[1]))
    elif t[0] == "A":
        cur["A"] = [float(v) for v in t[1:]]
    elif t[0] == "PQ":
        m, n, how = int(t[1]), int(t[2]), t[3]
        i = t.index("Q")
        P = [float(v) for v in t[5:i]]; Q = [float(v) for v in t[i+1:]]
        cur["pairs"].append((m, n, how, P, Q))

def nullvec(M):
    # null vector of an mpmath matrix via SVD (smallest singular vector)
    U, S, V = mp.svd_r(M, full_matrices=True)
    return [V[V.rows-1, j] for j in range(V.cols)], S

def ref_pade(a, L, M):
    """Frobenius-form Pade: Q (deg<=M) with (Qf - P) = O(x^{L+M+1}); returns P,Q (mp lists), Q normalised
    to Q[first nonzero]=1, plus flag whether exact Baker solution with Q(0)!=0 exists (nonsingular Toeplitz)."""
    if M == 0:
        return a[:L+1], [mp.mpf(1)], True, None
    C = mp.matrix(M, M+1)
    for r in range(M):
        k = L + 1 + r
        for j in range(M+1):
            C[r, j] = a[k-j] if k-j >= 0 else 0
    B = mp.matrix(M, M)
    for r in range(M):
        for j in range(M):
            B[r, j] = C[r, j+1]
    # relative singularity test
    S = mp.svd_r(B, compute_uv=False)
    smax = max(S); smin = min(S)
    nonsing = smax != 0 and smin > smax * mp.mpf(10)**(-40)
    if nonsing:
        rhs = mp.matrix([-C[r, 0] for r in range(M)])
        qt = mp.lu_solve(B, rhs)
        Q = [mp.mpf(1)] + [qt[i] for i in range(M)]
    else:
        Q, _ = nullvec(C)
    P = [sum(Q[j]*a[i-j] for j in range(0, min(i, M)+1)) for i in range(L+1)]
    return P, Q, nonsing, (smin/smax if smax != 0 else 0)

def peval(c, z):
    v = mp.mpf(0)
    for co in reversed(c): v = v*z + co
    return v

def fpeval(c, z):
    v = c[-1]
    for co in reversed(c[:-1]): v = v*z + co
    return v

summary = []
for cid in sorted(cases):
    cs = cases[cid]; ex = EX[cid]
    a_ex = [mp.mpf(mp.mpmathify(s)) for s in ex["num"]]
    a_sc = cs["A"]
    relA = [abs(a_sc[k]-float(a_ex[k]))/max(abs(float(a_ex[k])), 1e-300) if a_ex[k] != 0 else abs(a_sc[k]) for k in range(len(a_sc))]
    xs = np.linspace(cs["xlims"][0], cs["xlims"][1], 900)
    ylo, yhi = cs["ylims"]; span = yhi - ylo
    worst = (0, None); maxmatch = 0; worst_match = None
    rows = []
    for (m, n, how, P, Q) in cs["pairs"]:
        # script R on grid exactly as script does (Float64, NaN if |den|<1e-8, clamp)
        ys = []
        for x in xs:
            z = x - cs["c"]; den = fpeval(Q, z)
            ys.append(np.nan if abs(den) < 1e-8 else fpeval(P, z)/den)
        ys = np.clip(np.array(ys), ylo, yhi)
        # reference R from exact coefficients
        Pr, Qr, nonsing, cond = ref_pade(a_ex, m, n)
        yr = []
        for x in xs:
            z = mp.mpf(x) - mp.mpf(ex_c) if False else mp.mpf(x) - mp.mpf(cs["c"])
            den = peval(Qr, z)
            yr.append(float(peval(Pr, z)/den) if den != 0 else np.nan)
        yr = np.clip(np.array(yr), ylo, yhi)
        mask = np.isfinite(ys) & np.isfinite(yr)
        d = np.abs(ys - yr)[mask]
        # ignore points adjacent to a sign flip of reference denominator (pole) -> use median-robust metric
        dmax = d.max()/span if d.size else 0
        npts_bad = int((d > 0.01*span).sum())
        # Baker matching of script's R against exact series: residual of Q*f - P through order m+n
        res = []
        for k in range(m+n+1):
            s = sum(mp.mpf(Q[j])*a_ex[k-j] for j in range(0, min(k, n)+1)) - (mp.mpf(P[k]) if k <= m else 0)
            res.append(abs(s))
        scale = max([abs(mp.mpf(v)) for v in P] + [abs(mp.mpf(v)) for v in Q])
        match = float(max(res)/scale)
        rows.append((m, n, how, nonsing, dmax, npts_bad, match))
    summary.append((cid, relA, rows))

for cid, relA, rows in summary:
    print(f"=== case {cid}  max rel coeff err = {max(relA):.2e}  per-k: " + " ".join(f"{r:.1e}" for r in relA))
    for (m, n, how, nonsing, dmax, nb, match) in rows:
        flag = "" if (dmax < 0.005 and nb == 0) else "  <-- differs"
        if (not nonsing) or how == "PINV" or flag:
            print(f"  [{m}/{n}] solve={how} exact_nonsing={nonsing} max|Rscript-Rref|/yspan={dmax:.3e} pts>1%={nb} BakerRes={match:.1e}{flag}")
    worst = max(rows, key=lambda r: r[4])
    print(f"  worst pair [{worst[0]}/{worst[1]}] diff/yspan={worst[4]:.3e}; max Baker residual(nonsing only)={max([r[6] for r in rows if r[3]]):.1e}")
