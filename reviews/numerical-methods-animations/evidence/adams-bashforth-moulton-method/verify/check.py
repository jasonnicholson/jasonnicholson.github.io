import numpy as np
from scipy.integrate import solve_ivp
cbrt=np.cbrt
f=lambda t,y: 1-t*cbrt(y)
# high-accuracy reference
sol=solve_ivp(lambda t,y:[f(t,y[0])],(0,5),[1.0],method='DOP853',rtol=1e-13,atol=1e-15,dense_output=True)
def abm(N, corrector_iters=1):
    h=5/N; t=np.linspace(0,5,N+1); y=np.zeros(N+1); y[0]=1
    for i in range(3):
        k1=f(t[i],y[i]);k2=f(t[i]+h/2,y[i]+h/2*k1);k3=f(t[i]+h/2,y[i]+h/2*k2);k4=f(t[i]+h,y[i]+h*k3)
        y[i+1]=y[i]+h/6*(k1+2*k2+2*k3+k4)
    for n in range(3,N):
        F=[f(t[n-j],y[n-j]) for j in range(4)]
        yp=y[n]+h/24*(55*F[0]-59*F[1]+37*F[2]-9*F[3])
        for _ in range(corrector_iters):
            yp=y[n]+h/24*(9*f(t[n+1],yp)+19*F[0]-5*F[1]+F[2])
        y[n+1]=yp
    return t,y
t,y=abm(50)
ref=sol.sol(t)[0]
print("ref y(5)=",ref[-1])
for i in range(0,51):
    lam=-t[i]/(3*abs(ref[i])**(2/3))
    print(f"{i:2d} t={t[i]:.1f} abm={y[i]: .6f} ref={ref[i]: .6f} err={y[i]-ref[i]: .2e} h*dfdy={0.1*lam: .3f}")
for N in [50,100,200,400,800]:
    t2,y2=abm(N); r=sol.sol(t2)[0]
    print(N, "y(5)=",y2[-1], "maxerr=",np.max(abs(y2-r)), "min y=",y2.min())
