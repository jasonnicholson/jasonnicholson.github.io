import mpmath as mp
mp.mp.dps=50
cases=[("22",mp.gamma,1),("23",mp.gamma,2),("24",mp.gamma,3),("25",lambda x:mp.bessely(0,x),10),("26",lambda x:mp.bessely(0,x),5),("27",lambda x:mp.bessely(0,x),2)]
fit={}
for line in open("fitcoefs.txt"):
    p=line.split(); fit[p[0]]=[float(v) for v in p[2:]]
out=open("exactcoefs.txt","w")
for cid,f,c in cases:
    ex=mp.taylor(f,c,8)
    out.write(cid+" "+" ".join(mp.nstr(v,25) for v in ex)+"\n")
    print("Case",cid,"c=",c)
    for k,(e,a) in enumerate(zip(ex,fit[cid])):
        rel=abs(a-e)/abs(e) if e!=0 else float('nan')
        print(f"  k={k}  exact={mp.nstr(e,12):>20}  fit={a:>22.12g}  relerr={float(rel):.2e}")
