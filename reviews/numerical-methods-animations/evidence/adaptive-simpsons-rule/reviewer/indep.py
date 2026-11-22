# Independent adaptive Simpson implementations + high-precision reference
import math, mpmath
mpmath.mp.dps = 40
f = lambda x: 1 + math.exp(-x)*math.sin(8*x**(2/3))
fm = lambda x: 1 + mpmath.exp(-x)*mpmath.sin(8*mpmath.cbrt(x)**2)
# split at 0 handled by tanh-sinh; also split interior
I = mpmath.quad(fm, [0, 0.25, 0.5, 1, 1.5, 2])
I2 = mpmath.quad(fm, mpmath.linspace(0,2,41), method='gauss-legendre')
print("mpmath I =", mpmath.nstr(I, 20), " check:", mpmath.nstr(I2,20))
Ifl = float(I)

def S(a,b):
    m=(a+b)/2; return (b-a)/6*(f(a)+4*f(m)+f(b))

def adapt(a,b,eps,fac,halve=True,richardson=False,leaves=None,order=None,depth=0,maxdepth=50):
    m=(a+b)/2
    whole=S(a,b); left=S(a,m); right=S(m,b)
    d = left+right-whole
    if abs(d) <= fac*eps or depth>=maxdepth:
        leaves.append((a,b))  # accepted: the two half-panels [a,m],[m,b] are used
        return left+right + (d/15 if richardson else 0.0)
    e2 = eps/2 if halve else eps
    return adapt(a,m,e2,fac,halve,richardson,leaves,depth=depth+1)+adapt(m,b,e2,fac,halve,richardson,leaves,depth=depth+1)

script_final_panels = [(0,2**-11)] + [(2**-k,2**-(k-1)) for k in range(11,4,-1)] + \
  [(0.0625,0.125),(0.125,0.1875),(0.1875,0.25),(0.25,0.375),(0.375,0.5),(0.5,0.625),(0.625,0.75),(0.75,0.875),(0.875,1),(1,1.25),(1.25,1.5),(1.5,2)]
script_final_panels = sorted(set(script_final_panels))
def compS(panels): return sum(S(a,b) for a,b in panels)
print("script final panels (exact dyadic) composite Simpson:", repr(compS(script_final_panels)), " err vs I:", compS(script_final_panels)-Ifl)
print("n panels script:", len(script_final_panels), "nodes", 2*len(script_final_panels)+1)
for fac in (15,10):
  for halve in (True,False):
    for rich in (False,True):
      leaves=[]
      v=adapt(0.0,2.0,1e-3,fac,halve,rich,leaves)
      # leaves are accepted intervals each split into 2 Simpson panels -> nodes
      nodes = sorted(set([x for a,b in leaves for x in (a,(a+b)/2,b)]))
      fine_panels = sorted([(a,(a+b)/2) for a,b in leaves]+[((a+b)/2,b) for a,b in leaves])
      print(f"\nfac={fac} halve={halve} richardson={rich}: value={v:.10f} err={v-Ifl:.3e}  accepted intervals={len(leaves)} nodes={len(nodes)}")
      print("  accepted (coarse) intervals:", [(round(a,6),round(b,6)) for a,b in sorted(leaves)])
      print("  same coarse partition as script's final panels?", sorted(leaves)==script_final_panels)
      print("  script panels == fine panels?", fine_panels==script_final_panels)
