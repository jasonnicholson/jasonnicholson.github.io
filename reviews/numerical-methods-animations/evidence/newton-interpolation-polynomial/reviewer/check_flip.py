# Locate grid points where script's barycentric value and exact Newton value land on different sides after clamping.
import sys, mpmath as mp
mp.mp.dps = 50
exec(open('check_newton.py').read().split('lines=open')[0])
L=open('lagnewt_grid.txt').read().splitlines(); i=0
want={('04',16),('29',14),('29',16),('29',12),('28',16)}
while i<len(L):
    p=L[i].split(); cid,lab,lo,hi=p[1],p[2],float(p[3]),float(p[4]); f=F[lab]; i+=1
    while i<len(L) and L[i].startswith('N '):
        q=L[i].split(); n=int(q[1])
        if (cid,n) in want:
            xs=[mp.mpf(t) for t in q[2].split(',')]; ys=[f(x) for x in xs]; c=divdiff(xs,ys)
            yi=[float(t) for t in L[i+1].split(',')]; xp=[float(t) for t in L[i+2].split(',')]
            bad=[]
            for x,y in zip(xp,yi):
                pv=float(neval(mp.mpf(x),xs,c))
                if abs(min(max(pv,lo),hi)-min(max(y,lo),hi))>1e-3*(hi-lo): bad.append((x,y,pv))
            print(cid,n,"ylims",(round(lo,3),round(hi,3)),"nbad",len(bad))
            for b in bad[:3]+bad[-3:]: print("   x=%.4f script=%.4e exact=%.4e"%b)
            # also: largest |P| region & where exact P leaves the window for the first time to the right
        i+=3
