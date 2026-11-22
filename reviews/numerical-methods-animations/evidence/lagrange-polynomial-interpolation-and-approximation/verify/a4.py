import mpmath as mp
mp.mp.dps=60
def interp(xs,ys,x):
    s=0
    for i in range(len(xs)):
        L=mp.mpf(1)
        for j in range(len(xs)):
            if i!=j: L*=(x-xs[j])/(xs[i]-xs[j])
        s+=ys[i]*L
    return s
def run(name,f,a,b,trim,nlist,ev):
    for n in nlist:
        t=(b-a)*trim
        xs=[mp.mpf(a+t)+(mp.mpf(b-a-2*t))*k/(n-1) for k in range(n)]
        ys=[f(x) for x in xs]
        E=[abs(interp(xs,ys,x)-f(x)) for x in ev]
        print(f"{name} trim={trim} deg={n-1}: max|err| on [{float(ev[0]):.3g},{float(ev[-1]):.3g}] = {mp.nstr(max(E),4)}")
ev=lambda a,b,m=2001:[mp.mpf(a)+(mp.mpf(b)-a)*k/(m-1) for k in range(m)]
for tr in (0.03,0.0):
    run("sqrt [0,2]",mp.sqrt,0,2,tr,[2,6,16],ev(0,2))
for tr in (0.03,0.0):
    run("runge08 [-1,1]",lambda x:1/(1+10*x**2),-1,1,tr,[6,10,16],ev(-1,1))
for tr in (0.03,0.0):
    run("runge08 on node hull [-0.94,0.94]",lambda x:1/(1+10*x**2),-1,1,tr,[16],ev(-0.94,0.94))
