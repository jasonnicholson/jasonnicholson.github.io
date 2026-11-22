# Overlay script's R (as drawn: clamped) vs reference Pade from exact coefficients, for chosen frames.
import sys, os, importlib.util
import numpy as np, mpmath as mp
import matplotlib; matplotlib.use("Agg"); import matplotlib.pyplot as plt
D = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location("cp", os.path.join(D, "compare_pade.py"))
# reuse parsing + ref_pade by exec'ing only the defs (avoid running the summary print)
src = open(os.path.join(D, "compare_pade.py")).read().split("summary = []")[0]
g = {"__file__": os.path.join(D, "compare_pade.py")}; exec(src, g)
cases, EX, ref_pade, peval, fpeval = g["cases"], g["EX"], g["ref_pade"], g["peval"], g["fpeval"]
import sympy as sp
x = sp.symbols('x')
F = {"12": lambda t: np.tan(t), "15": np.cosh, "16": np.arctan, "17": lambda t: np.where(abs(t)<=1, np.arcsin(np.clip(t,-1,1)), np.nan),
     "20": lambda t: np.exp(-t**2/2)/np.sqrt(2*np.pi)}
from scipy.special import gamma as G, y0
F.update({"22": G, "23": G, "24": G, "25": y0, "26": y0, "27": y0})
def frameno(m, n): t = m+n; return t*(t+1)//2 + m + 1
def go(cid, pairs, fname):
    cs = cases[cid]; a_ex = [mp.mpf(s) for s in EX[cid]["num"]]
    xs = np.linspace(*cs["xlims"], 900); ylo, yhi = cs["ylims"]
    k = len(pairs); fig, axs = plt.subplots(1, k, figsize=(4.2*k, 3.6), squeeze=False)
    for ax, (m, n) in zip(axs[0], pairs):
        P, Q = next((p[3], p[4]) for p in cs["pairs"] if p[0]==m and p[1]==n)
        ys = np.array([np.nan if abs(fpeval(Q, t-cs["c"]))<1e-8 else fpeval(P, t-cs["c"])/fpeval(Q, t-cs["c"]) for t in xs])
        Pr, Qr, ns, _ = ref_pade(a_ex, m, n)
        yr = np.array([float(peval(Pr, mp.mpf(t)-cs["c"])/peval(Qr, mp.mpf(t)-cs["c"])) for t in xs])
        with np.errstate(all="ignore"):
            ax.plot(xs, F[cid](xs), color="m", lw=2, label="f")
        ax.plot(xs, np.clip(ys, ylo, yhi), color="steelblue", lw=2, label="script (as drawn)")
        ax.plot(xs, np.clip(yr, ylo, yhi), "k--", lw=1.2, label="reference")
        ax.set_ylim(ylo, yhi); ax.set_xlim(*cs["xlims"]); ax.set_title(f"case {cid} [{m}/{n}] frame {frameno(m,n)}")
        ax.legend(fontsize=7)
    fig.tight_layout(); fig.savefig(os.path.join(D, fname), dpi=80); plt.close(fig)
jobs = {
 "ov_degenerate1.png": [("12", [(2,3)]), ("15", [(1,3),(3,3),(1,7)])],
}
go("12", [(2,3),(2,5)], "ov_case12.png")
go("15", [(1,3),(3,3),(1,7)], "ov_case15.png")
go("16", [(2,5),(2,7)], "ov_case16.png")
go("17", [(4,3),(2,3)], "ov_case17.png")
go("20", [(1,3),(5,3)], "ov_case20.png")
go("22", [(2,2),(0,5),(3,3),(4,4),(6,2),(8,0)], "ov_case22.png")
go("23", [(2,5),(4,3),(4,4),(0,8),(7,1)], "ov_case23.png")
go("24", [(3,3),(0,7),(2,6),(3,5),(4,4)], "ov_case24.png")
go("25", [(2,5),(5,3),(4,4),(8,0)], "ov_case25.png")
go("26", [(3,5),(6,2),(8,0)], "ov_case26.png")
go("27", [(4,2),(4,3),(6,1),(4,4),(6,2)], "ov_case27.png")
print("ok")
