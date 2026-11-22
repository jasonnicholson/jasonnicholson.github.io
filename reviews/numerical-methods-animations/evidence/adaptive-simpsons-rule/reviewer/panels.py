# For the script's frame progression: for every panel ever drawn, compute the
# standard adaptive-Simpson error indicator d=|S(a,m)+S(m,b)-S(a,b)| and whether
# the script later split it.  Tests whether ANY width-proportional or absolute
# threshold reproduces the script's split/keep decisions.
import math, mpmath
f = lambda x: 1 + math.exp(-x)*math.sin(8*x**(2/3))
def S(a,b):
    m=(a+b)/2; return (b-a)/6*(f(a)+4*f(m)+f(b))
# frames' panel lists (exact dyadic)
import re
src=open('../regen/adaptivesimpsonsaa.jl').read()
block=src[src.index('node_sets = ['):src.index('xlims')]
sets=[[float(v) for v in re.findall(r'[0-9.]+(?:e-?\d+)?',line)] for line in block.splitlines()[1:] if line.strip().startswith('[')]
def snap(x):  # snap 6-sig-digit rounded nodes to dyadic
    if x==0: return 0.0
    for k in range(0,20):
        y=round(x*2**k)/2**k
        if abs(y-x)<1e-6*max(x,1e-12)+1e-12 and abs(x*2**k-round(x*2**k))<1e-3: return y
    return x
sets=[[snap(x) for x in s] for s in sets]
panel_sets=[set((s[i],s[i+2]) for i in range(0,len(s)-2,2)) for s in sets]
allp=set().union(*panel_sets); final=panel_sets[-1]
print("frame order of splits:")
for k in range(1,len(panel_sets)):
    gone=panel_sets[k-1]-panel_sets[k]; new=panel_sets[k]-panel_sets[k-1]
    print(f"  set {k}->{k+1}: split {sorted(gone)} -> {sorted(new)}")
rows=[]
for (a,b) in sorted(allp):
    m=(a+b)/2; d=abs(S(a,m)+S(m,b)-S(a,b))
    rows.append((a,b,d,(a,b) in final))
print(f"\n{'panel':>24} {'d':>11} {'d/(b-a)*2':>11} kept_in_final")
for a,b,d,k in rows:
    print(f"  [{a:.6g},{b:.6g}]".ljust(26), f"{d:11.3e} {d/(b-a)*2:11.3e}  {'KEPT' if k else 'split'}")
kept=[r for r in rows if r[3]]; split=[r for r in rows if not r[3]]
print("\nabsolute d: max over kept =",max(r[2] for r in kept)," min over split =",min(r[2] for r in split))
print("width-scaled d/(b-a): max kept =",max(r[2]/(r[1]-r[0]) for r in kept)," min split =",min(r[2]/(r[1]-r[0]) for r in split))
# true per-panel error of drawn Simpson panel
mpmath.mp.dps=30
fm=lambda x: 1+mpmath.exp(-x)*mpmath.sin(8*mpmath.cbrt(x)**2)
print("\nper-panel true error of single Simpson panel, final set:")
for a,b in sorted(final):
    e=float(mpmath.quad(fm,[a,b]))-S(a,b)
    print(f"  [{a:.6g},{b:.6g}] err={e:.2e}")
