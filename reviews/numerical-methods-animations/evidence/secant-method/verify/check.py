import mpmath as mp
mp.mp.dps=200
def secant(f,p0,p1,n):
    ps=[mp.mpf(p0),mp.mpf(p1)]
    for i in range(n):
        a,b=ps[-2],ps[-1]
        d=f(b)-f(a)
        if d==0: break
        ps.append(b-f(b)*(b-a)/d)
    return ps
f1=lambda x:3*mp.e**x-4*mp.cos(x)
r1=mp.findroot(f1,0.3)
print("Case1 root",mp.nstr(r1,15),"f(0.456)=",mp.nstr(f1(mp.mpf('0.456')),6))
ps=secant(f1,'1.0','0.9',10)
for i,p in enumerate(ps): print(i,mp.nstr(p,12),mp.nstr(abs(p-r1),5))
print("Case 6")
f6=mp.atan
ps=secant(f6,'1.6','1.5',14)
e=[abs(p) for p in ps]
for i,p in enumerate(ps):
    s=""
    if i>=3 and e[i]>0 and e[i-1]>0 and e[i-2]>0 and e[i-3]>0:
        s=mp.nstr(mp.log(e[i]/e[i-1])/mp.log(e[i-1]/e[i-2]),6)
    print(i,mp.nstr(p,10),"order est",s)
print("ratio e_{n+1}/(e_n*e_{n-1}^2) (theory 1/3 since f''(0)=0, f'''(0)/(6f'(0)) = -1/3)")
for i in range(5,12):
    print(i, mp.nstr(e[i]/(e[i-1]*e[i-2]**2),6))
