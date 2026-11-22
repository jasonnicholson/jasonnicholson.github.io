from mpmath import mp, mpf, sqrt, polyroots
mp.dps=40
def run(f,fp,fpp,x0,n,root):
    x=mpf(x0)
    for k in range(n):
        F,Fp,Fpp=f(x),fp(x),fpp(x)
        h=x-2*F*Fp/(2*Fp**2-F*Fpp)
        nw=x-F/Fp
        # Taylor parabola roots: F + Fp*d + Fpp/2 d^2 = 0
        a,b,c=Fpp/2,Fp,F
        if a!=0:
            disc=b*b-4*a*c
            if disc>=0:
                r=[x+(-b+s*sqrt(disc))/(2*a) for s in (1,-1)]
                pr=min(r,key=lambda t:abs(t-x))
            else: pr=None
        # hyperbola (Halley) check: rational y=(A + B(t-x))/(1+C(t-x)) matching f,f',f''
        print(f"k={k} x={mp.nstr(x,15)} newton={mp.nstr(nw,15)} halley={mp.nstr(h,15)} parab_root_nearest={mp.nstr(pr,15) if pr is not None else None}  err_newton={mp.nstr(nw-root,5)} err_halley={mp.nstr(h-root,5)} err_parab={mp.nstr(pr-root,5) if pr is not None else None}")
        x=h
print("Case 1b"); run(lambda x:x**2-2,lambda x:2*x,lambda x:mpf(2),2,4,sqrt(2))
print("Case 2"); run(lambda x:x**3-3*x+2,lambda x:3*x**2-3,lambda x:6*x,mpf('-2.2'),5,mpf(-2))
