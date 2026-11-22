import sys; sys.path.insert(0,'.')
from compare import zeroin, script_brent
f=lambda x:x**9; a,b=-1.0,2.0; W0=3.0
h=[hh for hh in zeroin(f,a,b,1e-12,maxit=2000) if hh[2]!="done"]
for n,(bb,cc,k) in enumerate(h,1):
    if n<=40 or n%10==0: print("ZEROIN n=%3d width=%.3e  bound W0*2^-floor(n/2)=%.3e  %s"%(n,abs(cc-bb),W0*2**-(n//2),k))
s=script_brent(f,a,b,2000,1e-12)
for n,(aa,bb,m,t) in enumerate(s):
    print("script n=%2d width=%.3e bound=%.3e %s f(best)=%.2e"%(n,abs(bb-aa),W0*2**-(n//2),m,min(abs(f(aa)),abs(f(bb)))))
