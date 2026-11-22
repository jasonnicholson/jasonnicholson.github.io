# Independent check: all real solutions of the system (sympy resultant + mpmath polish),
# an independent 'good Broyden' implementation (numpy), secant-condition residuals, error ratios.
import sympy as sp, mpmath as mp, numpy as np
x,y=sp.symbols('x y')
f1=1-4*x+2*x**2-2*y**2; f2=-4+x**2+4*y+y**2
J=sp.Matrix([f1,f2]).jacobian([x,y]); print("Jacobian (sympy):",J)
res=sp.resultant(f1,f2,x); print("resultant in y:",sp.factor(res))
mp.mp.dps=30
sols=[]
for yr in sp.Poly(res,y).nroots(n=30):
    if abs(sp.im(yr))>1e-20: continue
    yr=sp.re(yr)
    for xr in sp.Poly(f2.subs(y,yr),x).nroots(n=30):
        if abs(sp.im(xr))>1e-20: continue
        xr=sp.re(xr)
        if abs(f1.subs({x:xr,y:yr}))<1e-15:
            s=mp.findroot([lambda a,b:1-4*a+2*a**2-2*b**2, lambda a,b:-4+a**2+4*b+b**2],(mp.mpf(str(xr)),mp.mpf(str(yr))))
            sols.append((s[0],s[1]))
print("real solutions:")
for s in sols: print("  (%s, %s)"%(mp.nstr(s[0],15),mp.nstr(s[1],15)))
F=lambda X: np.array([1-4*X[0]+2*X[0]**2-2*X[1]**2, -4+X[0]**2+4*X[1]+X[1]**2])
Jf=sp.lambdify((x,y),J,'numpy')
def broyden(X0,n=10):
    X=[np.array(X0,float)]; B=np.array(Jf(*X0),float)
    X.append(X[0]-np.linalg.solve(B,F(X[0]))); sec=[]
    while len(X)<n+2:
        s=X[-1]-X[-2]; yv=F(X[-1])-F(X[-2])
        if np.linalg.norm(F(X[-1]))<1e-12: break
        B=B+np.outer(yv-B@s,s)/(s@s)
        sec.append(np.linalg.norm(B@s-yv)/np.linalg.norm(yv))
        X.append(X[-1]-np.linalg.solve(B,F(X[-1])))
    return X,sec
for X0 in [(0,1),(2.5,-1.5)]:
    X,sec=broyden(X0)
    r=min(sols,key=lambda s: float((s[0]-X[-1][0])**2+(s[1]-X[-1][1])**2)); r=np.array([float(r[0]),float(r[1])])
    print("\nstart",X0,"-> root",r)
    e=[np.linalg.norm(Xk-r) for Xk in X]
    for k,(Xk,ek) in enumerate(zip(X,e)):
        print("  k=%d x=%.17g y=%.17g err=%.3e ratio=%s"%(k,Xk[0],Xk[1],ek, "%.3e"%(ek/e[k-1]) if k>0 and e[k-1]>0 else "-"))
    print("  relative secant residual |B_{k+1}s_k-y_k|/|y_k| per update:",["%.1e"%v for v in sec])
