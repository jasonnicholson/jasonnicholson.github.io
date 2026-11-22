exec(open('asr.py').read().split('mp.mp.dps')[0])
import numpy as np
af=[0.0, 0.000244141, 0.000488281, 0.000732422, 0.000976563, 0.00146484, 0.00195313, 0.00292969, 0.00390625, 0.00585938, 0.0078125, 0.0117188, 0.015625, 0.0234375, 0.03125, 0.046875, 0.0625, 0.09375, 0.125, 0.15625, 0.1875, 0.21875, 0.25, 0.3125, 0.375, 0.4375, 0.5, 0.5625, 0.625, 0.6875, 0.75, 0.8125, 0.875, 0.9375, 1.0, 1.125, 1.25, 1.375, 1.5, 1.75, 2.0]
for halve in (True,False):
  match=[]
  for thr in np.geomspace(0.01,30,400):
    n,v,l=run(1e-3,False,halve,thr)
    if len(n)==len(af) and np.allclose(n,af,atol=1e-6): match.append(thr)
  print("halve",halve,"thr range matching anim:",(min(match),max(match)) if match else None)
# animation's own displayed final value
xs=np.array(af); tot=sum((xs[i+2]-xs[i])/6*(f(xs[i])+4*f(xs[i+1])+f(xs[i+2])) for i in range(0,len(xs)-2,2))
print("anim final displayed approx", tot)
# also check pairing in anim is consistent with panels (midpoint test)
print("pairs midpoints ok:", all(abs(xs[i+1]-(xs[i]+xs[i+2])/2)<1e-6 for i in range(0,len(xs)-2,2)))
# 15eps halving: final set + leaf errors
n,v,l=run(1e-3,False,True,15); print("15eps halving leaves:",[(round(a,5),round(b,5)) for a,b,_ in l])
