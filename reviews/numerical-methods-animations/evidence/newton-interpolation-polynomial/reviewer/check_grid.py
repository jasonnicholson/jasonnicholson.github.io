# Compare script's plotted interpolant (clamped to ylims) with an independent mpmath Newton-form
# evaluation (exact-ish data f(x_k) computed by mpmath), over the full 1000-pt plot grid.
import sys, mpmath as mp
sys.path.insert(0, '.')
mp.mp.dps = 50
exec(open('check_newton.py').read().split('lines=open')[0])   # reuse F, divdiff, neval definitions only
L=open('lagnewt_grid.txt').read().splitlines(); i=0
while i<len(L):
    p=L[i].split(); cid,lab,lo,hi=p[1],p[2],float(p[3]),float(p[4]); f=F[lab]; i+=1
    out=[]
    while i<len(L) and L[i].startswith('N '):
        q=L[i].split(); n=int(q[1]); xs=[mp.mpf(t) for t in q[2].split(',')]
        ys=[f(x) for x in xs]; c=divdiff(xs,ys)
        yi=[float(t) for t in L[i+1].split(',')]; xp=[mp.mpf(t) for t in L[i+2].split(',')]
        d=0; dfull=0
        for x,y in zip(xp,yi):
            pv=float(neval(x,xs,c))
            d=max(d, abs(min(max(pv,lo),hi)-min(max(y,lo),hi)))
        out.append(f"n={n}:{d/(hi-lo):.0e}")
        i+=3
    print(cid, lab, "max |clamped diff|/yrange:", " ".join(out))
