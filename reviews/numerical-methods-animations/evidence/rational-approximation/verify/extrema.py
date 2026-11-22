import mpmath as mp
mp.mp.dps=30
vals=[mp.mpf(l.strip()) for l in open("cmm.txt")]
def R(c,x):
    a0,a1,a2,b1,b2=c; return (a0+a1*x+a2*x**2)/(1+b1*x+b2*x**2)
for name,c in (("c_mm",vals[:5]),("c_ch",vals[5:])):
    g=[mp.mpf(-1)+2*mp.mpf(i)/20000 for i in range(20001)]
    e=[(mp.exp(x)-R(c,x))/mp.exp(x) for x in g]
    ext=[(g[0],e[0])]+[(g[i],e[i]) for i in range(1,20000) if abs(e[i])>=abs(e[i-1]) and abs(e[i])>=abs(e[i+1]) and abs(e[i])>1e-7]+[(g[-1],e[-1])]
    print(name,[(mp.nstr(x,4),mp.nstr(v,4)) for x,v in ext])
    mags=[abs(v) for _,v in ext]; print("  min/max of extremal |e|:",mp.nstr(min(mags),5),mp.nstr(max(mags),5),"ratio",mp.nstr(min(mags)/max(mags),4))
