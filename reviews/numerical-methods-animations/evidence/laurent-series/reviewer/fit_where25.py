import mpmath as mp, numpy as np, sys
script = {l.split()[0]: [float(v) for v in l.split()[4:]] for l in open(sys.argv[1])}
sc=script["25"]; tr=[float(v) for v in mp.taylor(lambda z: mp.bessely(0,z),10,8)]
for N in (7,8):
  for x in (5,6,7,8,9,10,11,12,13,14,15):
    z=x-10; print(N,x,"script %.4f exact %.4f Y0 %.4f"%(np.polyval(sc[:N+1][::-1],z),np.polyval(tr[:N+1][::-1],z),float(mp.bessely(0,x))))
