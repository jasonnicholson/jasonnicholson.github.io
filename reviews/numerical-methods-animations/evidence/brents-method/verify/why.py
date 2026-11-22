# instrumented copy of script loop: print the conditions that triggered bisection
def run(f,a,b,n,tol):
    fa,fb=f(a),f(b)
    if abs(fa)<abs(fb): a,b=b,a
    c=a; mflag=True; d=0.0
    for k in range(1,n+1):
        fa,fb,fc=f(a),f(b),f(c)
        if abs(fb)<tol or abs(b-a)<tol: break
        if fa!=fc and fb!=fc:
            s=(a*fb*fc/((fa-fb)*(fa-fc))+b*fa*fc/((fb-fa)*(fb-fc))+c*fa*fb/((fc-fa)*(fc-fb))); m="IQI"
        else: s=b-fb*(b-a)/(fb-fa); m="Secant"
        lo,hi=min(a,b),max(a,b)
        conds=dict(c1=not(lo<s<hi),c2=mflag and abs(s-b)>=abs(b-c)/2,c3=(not mflag) and abs(s-b)>=abs(c-d)/2,
                   c4=mflag and abs(b-c)<tol,c5=(not mflag) and abs(c-d)<tol)
        trig=[x for x,v in conds.items() if v]
        print(k,"tried",m,"s=%.6f"%s,"b=%.6f c=%.6f d=%.6f |b-c|=%.3g |c-d|=%.3g mflag=%s"%(b,c,d,abs(b-c),abs(c-d),mflag),"->",("Bisection via "+",".join(trig)) if trig else "accepted")
        if trig: s=(a+b)/2; mflag=True
        else: mflag=False
        d=c;c=b
        if f(a)*f(s)<0: b=s
        else: a=s
        if abs(f(a))<abs(f(b)): a,b=b,a
import math
print("case1");run(lambda x:4*x**3-16*x**2+17*x-4,0.0,1.0,14,1e-10)
print("case2");run(lambda x:math.tan(x)-2*x,0.5,1.5,16,1e-10)
