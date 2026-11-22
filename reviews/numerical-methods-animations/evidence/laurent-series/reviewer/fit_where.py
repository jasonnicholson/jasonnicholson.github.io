import mpmath as mp, numpy as np, sys
script = {l.split()[0]: [float(v) for v in l.split()[4:]] for l in open(sys.argv[1])}
for cid, f, c, xl, yl in [("25", lambda z: mp.bessely(0,z), 10.0, (0,22), (-2,2)), ("22", mp.gamma, 1.0, (-0.2,5.2), (-10,35))]:
  sc=script[cid]; tr=[float(v) for v in mp.taylor(f,c,len(sc)-1)]
  x=np.linspace(*xl,900); z=x-c
  for N in (7,8):
    ps=np.clip(np.polyval(sc[:N+1][::-1],z),*yl); pt=np.clip(np.polyval(tr[:N+1][::-1],z),*yl)
    d=np.abs(ps-pt); m=d>0.01*(yl[1]-yl[0])
    if m.any():
      # x where each curve leaves window
      def exits(p): 
          inside=(p>yl[0])&(p<yl[1]); idx=np.where(inside)[0]; return x[idx[0]], x[idx[-1]]
      print(cid,N,"diff>1%% span on x in [%.2f,%.2f]"%(x[m].min(),x[m].max()), "script visible x-range %.3f..%.3f"%exits(ps), "exact %.3f..%.3f"%exits(pt))
