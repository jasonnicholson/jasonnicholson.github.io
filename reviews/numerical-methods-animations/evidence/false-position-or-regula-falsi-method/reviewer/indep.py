import mpmath as mp
mp.mp.dps=40
def rf(f,a,b,n):
    out=[]
    for i in range(n):
        fa,fb=f(a),f(b)
        c=b-fb*(b-a)/(fb-fa)   # different algebraic form from the script
        fc=f(c)
        out.append((a,b,c,fc))
        if mp.sign(fc)==mp.sign(fa): a=c
        else: b=c
    return out
for name,f,a,b,n,x0 in [("A",lambda x:x**3+4*x**2-10,mp.mpf(-1),mp.mpf(2),12,1.3),
                         ("B",lambda x:x-mp.cos(x),mp.mpf(0),mp.mpf(1),10,0.7)]:
    r=mp.findroot(f,x0); print(name,"root",mp.nstr(r,15), "f(-1)/f(0) and f(b):", mp.nstr(f(a),6), mp.nstr(f(b),6))
    prev=None
    for i,(aa,bb,c,fc) in enumerate(rf(f,a,b,n),1):
        e=abs(c-r); ratio = e/prev if prev else None; prev=e
        print(i,mp.nstr(aa,10),mp.nstr(bb,10),mp.nstr(c,12),"err",mp.nstr(e,4),"ratio",mp.nstr(ratio,5) if ratio else "")
    # bisection comparison: error after n steps width/2^n
    print("bisection half-width after n:", mp.nstr((b-a)/2**(n+1),4))
# theoretical linear rate for fixed endpoint b: 1 - f'(r)(b-r)/(f(b)-f(r))
for name,f,df,b,x0 in [("A",lambda x:x**3+4*x**2-10,lambda x:3*x**2+8*x,2,1.3),("B",lambda x:x-mp.cos(x),lambda x:1+mp.sin(x),1,0.7)]:
    r=mp.findroot(f,x0); print(name,"asymptotic ratio",mp.nstr(1-df(r)*(b-r)/f(b),6))
