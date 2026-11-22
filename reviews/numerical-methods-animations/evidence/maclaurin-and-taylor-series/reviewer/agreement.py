# For each Taylor case and each order: the connected x-interval around c on which the partial sum is within
# 1% of the y-axis height of f (i.e. visually on top of f), for the script's coefficients and for exact ones.
import os, numpy as np, mpmath as mp
import importlib.util
here = os.path.dirname(os.path.abspath(__file__))
spec = importlib.util.spec_from_file_location("cc", os.path.join(here, "check_coeffs.py"))
import io, contextlib
buf = io.StringIO()
with contextlib.redirect_stdout(buf):
    cc = importlib.util.module_from_spec(spec); spec.loader.exec_module(cc)
F = {'t01': np.sqrt,'t02': np.sqrt,'t03': np.sqrt,'t04': np.log,'t05': np.log,'t06': np.sin,'t07': np.cos,
     't08': lambda x: np.array([float(mp.gamma(v)) if not (v<=0 and v==int(v)) else np.nan for v in x]),
     't09': None,'t10': None,
     't11': lambda x: np.array([float(mp.besselj(0,v)) for v in x]),
     't12': lambda x: np.array([float(mp.besselj(1,v)) for v in x]),
     't13': lambda x: np.array([float(mp.bessely(0,v)) if v>0 else np.nan for v in x])}
F['t09']=F['t08']; F['t10']=F['t08']
R = {'t01':1,'t02':4,'t03':5,'t04':1,'t05':2,'t06':np.inf,'t07':np.inf,'t08':2,'t09':3,'t10':4,'t11':np.inf,'t12':np.inf,'t13':2}
def interval(xs, ok, c):
    i0 = int(np.argmin(abs(xs-c)))
    if not ok[i0]: return None
    lo=i0; hi=i0
    while lo>0 and ok[lo-1]: lo-=1
    while hi<len(xs)-1 and ok[hi+1]: hi+=1
    return xs[lo], xs[hi]
import warnings; warnings.filterwarnings("ignore")
for cid,row in cc.rows.items():
    if not cid.startswith('t'): continue
    c,n,xl,yl,a,ex = row
    xs = np.linspace(xl[0], xl[1], 900); dx = xs-c
    fx = F[cid](xs)
    tol = 0.01*(yl[1]-yl[0])
    print(f"{cid} c={c:.4f} radius={R[cid]} -> conv. interval {c-R[cid]:.3g}..{c+R[cid]:.3g} (within plot {xl})")
    for k in range(n+1):
        ps = sum(a[j]*dx**j for j in range(k+1)); pe = sum(ex[j]*dx**j for j in range(k+1))
        Is = interval(xs, np.abs(ps-fx)<tol, c); Ie = interval(xs, np.abs(pe-fx)<tol, c)
        fmt = lambda I: "none" if I is None else f"[{I[0]:.2f},{I[1]:.2f}]"
        print(f"   order {k:2d}: script within 1%: {fmt(Is):16s} exact Taylor within 1%: {fmt(Ie)}")
