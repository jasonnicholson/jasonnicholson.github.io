import numpy as np, mpmath as mp
f=lambda x: 1+np.exp(-x)*np.sin(8*x**(2/3))
def S(a,b): m=(a+b)/2; return (b-a)/6*(f(a)+4*f(m)+f(b))
def run(eps, factor, halve, thr=15, maxdepth=60):
    leaves=[]
    def rec(a,b,e,d):
        m=(a+b)/2; whole=S(a,b); L=S(a,m); R=S(m,b)
        if abs(L+R-whole)<thr*e or d>=maxdepth:
            leaves.append((a,b,L+R+(L+R-whole)/15 if factor else L+R)); return
        e2=e/2 if halve else e
        rec(a,m,e2,d+1); rec(m,b,e2,d+1)
    rec(0.0,2.0,eps,0)
    leaves.sort()
    nodes=sorted(set([x for l in leaves for x in (l[0],(l[0]+l[1])/2,l[1])]))
    return nodes, sum(l[2] for l in leaves), leaves
mp.mp.dps=30
ex=mp.quad(lambda x:1+mp.e**(-x)*mp.sin(8*x**(mp.mpf(2)/3)),[0,mp.mpf('1e-6'),0.01,0.1,0.5,1,2])
print("exact",ex)
anim_final=[0.0, 0.000244141, 0.000488281, 0.000732422, 0.000976563, 0.00146484, 0.00195313, 0.00292969, 0.00390625, 0.00585938, 0.0078125, 0.0117188, 0.015625, 0.0234375, 0.03125, 0.046875, 0.0625, 0.09375, 0.125, 0.15625, 0.1875, 0.21875, 0.25, 0.3125, 0.375, 0.4375, 0.5, 0.5625, 0.625, 0.6875, 0.75, 0.8125, 0.875, 0.9375, 1.0, 1.125, 1.25, 1.375, 1.5, 1.75, 2.0]
print("anim final npts",len(anim_final))
for halve in (False,True):
  for factor in (False,True):
    for thr in (15,10,1):
        n,v,l=run(1e-3,factor,halve,thr)
        print(f"halve={halve} richardson={factor} thr={thr}: npts={len(n)} val={v:.8f} err={float(v-ex):.2e} min_h={min(b-a for a,b,_ in l):.3g} same_as_anim={np.allclose(n,anim_final,atol=1e-6) if len(n)==len(anim_final) else False}")
        if len(n)<40: print("   nodes",[round(x,6) for x in n])
