# Independent check: Newton divided differences in mpmath (60 digits) vs script's barycentric values.
import re, sys, mpmath as mp
mp.mp.dps = 60
F = {
 '1/(1-x)': lambda x: 1/(1-x), '1/(1+x)': lambda x: 1/(1+x), '1/(1-x)^2': lambda x: 1/(1-x)**2,
 'sqrt(x)': mp.sqrt, '1/sqrt(1-x)': lambda x: 1/mp.sqrt(1-x), '1/(1+10x^2)': lambda x: 1/(1+10*x**2),
 'log(x)': mp.log, 'log(1+x)': lambda x: mp.log(1+x), 'sin(x)': mp.sin, 'cos(x)': mp.cos, 'tan(x)': mp.tan,
 'exp(x)': mp.exp, 'cos(x)*exp(-x)': lambda x: mp.cos(x)*mp.exp(-x), 'cosh(x)': mp.cosh, 'atan(x)': mp.atan,
 'asin(x)': mp.asin, 'besselj(0,x)': lambda x: mp.besselj(0,x), 'besselj(1,x)': lambda x: mp.besselj(1,x),
 'normal_pdf(x)': mp.npdf, 'normal_cdf(x)': mp.ncdf, 'gamma(x)': mp.gamma, 'bessely(0,x)': lambda x: mp.bessely(0,x)}
def arr(s): return [mp.mpf(t) for t in re.findall(r'[-+0-9.eE]+', s)]
def divdiff(xs, ys):
    n=len(xs); d=list(ys); c=[d[0]]
    for j in range(1,n):
        d=[(d[i+1]-d[i])/(xs[i+j]-xs[i]) for i in range(len(d)-1)]; c.append(d[0])
    return c
def neval(x, xs, c):
    v=c[-1]
    for i in range(len(c)-2,-1,-1): v=v*(x-xs[i])+c[i]
    return v
lines=open('lagnewt_dump.txt').read().splitlines()
case=None; worst={}
i=0
while i < len(lines):
    L=lines[i]
    if L.startswith('CASE'):
        p=L.split(' ',3); cid=p[1]; lab=p[2]; f=F[lab]
        span=arr(L.split('span')[1].split('ylims')[0])
        i+=1; continue
    if L.startswith('N '):
        n=int(L.split()[1]); xs=arr(L.split('nodes')[1]); ys=arr(lines[i+1][2:]); xc=arr(lines[i+2][3:]); yc=lines[i+3][3:]
        yc=[mp.mpf(t) if t not in ('NaN','Inf','-Inf') else None for t in re.findall(r'-?Inf|NaN|[-+0-9.eE]+', yc)]
        a,b=span; w=b-a
        h=[xs[k+1]-xs[k] for k in range(n-1)]
        trim=(xs[0]-a)/w; trim2=(b-xs[-1])/w
        eqsp=max(abs(hh-h[0]) for hh in h)/h[0]
        # exact f at script's nodes
        fy=[f(x) for x in xs]
        ferr=max(abs(fy[k]-ys[k])/max(1,abs(fy[k])) for k in range(n))
        c=divdiff(xs, fy)
        rep=max(abs(neval(xs[k],xs,c)-fy[k])/max(1,abs(fy[k])) for k in range(n))
        ierr=0; scale=max(abs(v) for v in fy)
        for x,y in zip(xc,yc):
            p=neval(x,xs,c); ierr=max(ierr, abs(p-y)/max(1,abs(p)))
        print(f"{cid} {lab:15s} n={n:2d} deg={n-1:2d} nodes=[{float(xs[0]):.4f},{float(xs[-1]):.4f}] trim={float(trim):.3f}/{float(trim2):.3f} eqsp={float(eqsp):.1e} f(nodes)relerr={float(ferr):.1e} NewtonRepro={float(rep):.1e} P(xc)relerr_vs_script={float(ierr):.1e}")
        i+=5; continue
    i+=1
