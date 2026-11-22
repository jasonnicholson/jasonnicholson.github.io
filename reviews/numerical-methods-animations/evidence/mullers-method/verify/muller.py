import mpmath as mp
mp.mp.dps=60
def step(p0,p1,p2,f,discard):
    f0,f1,f2=f(p0),f(p1),f(p2)
    h0=p1-p0;h1=p2-p1
    d0=(f1-f0)/h0;d1=(f2-f1)/h1
    d=(d1-d0)/(h1+h0); b=d1+h1*d
    disc=b*b-4*f2*d
    D=mp.sqrt(mp.mpc(disc))
    E=b+D if abs(b+D)>=abs(b-D) else b-D
    if E==0 or f2==0: return (p2 if discard else mp.mpc(p2)), disc
    p3=p2-2*f2/E
    return (mp.re(p3) if discard else p3), disc
cases={'aa':(lambda x:x**3-3*x+2,[2.2,2.1,2.0],mp.mpf(1)),
 'bb':(lambda x:mp.sin(x**2-2)*(x**2-2),[0.8,0.9,1.0],mp.sqrt(2)),
 'cc':(lambda x:x**6-7*x**4+15*x**2-9,[1.3,1.4,1.5],mp.sqrt(3))}
for k,(f,p,r) in cases.items():
  for discard in (True,False):
    print('==',k,'discard' if discard else 'true complex Muller')
    q=[mp.mpf(str(v)) for v in p]
    errs=[]
    for i in range(30):
        p3,disc=step(q[0],q[1],q[2],f,discard)
        e=abs(p3-r); errs.append(e)
        if i<14: print(i+1, mp.nstr(p3,15), 'disc', mp.nstr(disc,6), 'err', mp.nstr(e,5))
        q=[q[1],q[2],p3]
        if e<mp.mpf(10)**-45 or p3==q[1]: break
    import math
    # order estimates
    orders=[]
    for j in range(2,len(errs)):
        if errs[j]>0 and errs[j-1]>0 and errs[j-2]>0 and errs[j-1]!=errs[j-2]:
            orders.append(mp.nstr(mp.log(errs[j]/errs[j-1])/mp.log(errs[j-1]/errs[j-2]),4))
    print('order est', orders[:20])
    print('ratios', [mp.nstr(errs[j]/errs[j-1],4) for j in range(1,min(len(errs),20))])
