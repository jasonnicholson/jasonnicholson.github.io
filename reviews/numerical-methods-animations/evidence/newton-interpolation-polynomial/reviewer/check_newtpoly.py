import mpmath as mp
mp.mp.dps=40
def dd(xs,ys):
    d=list(ys); c=[d[0]]
    for j in range(1,len(xs)):
        d=[(d[i+1]-d[i])/(xs[i+j]-xs[i]) for i in range(len(d)-1)]; c.append(d[0])
    return c
xs=[2*mp.pi*k/6 for k in range(7)]; print("aa", [mp.nstr(v,12) for v in dd(xs,[mp.cos(x) for x in xs])])
xs=[-1+mp.mpf(k)/5 for k in range(11)]; f=lambda x:1/(1+25*x**2); c=dd(xs,[f(x) for x in xs])
print("bb", [mp.nstr(v,12) for v in c])
P=lambda x: sum(c[k]*mp.fprod([x-xs[j] for j in range(k)]) for k in range(11))
m=mp.findroot(lambda x: mp.diff(P,x), -0.96); print("bb Runge max: x=",mp.nstr(m,8),"P=",mp.nstr(P(m),8))
