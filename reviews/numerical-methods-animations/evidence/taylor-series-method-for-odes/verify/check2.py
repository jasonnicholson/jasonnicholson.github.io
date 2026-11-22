exec(open('check.py').read().split('# reference with mpmath')[0])
import mpmath as mp, math
mp.mp.dps=30
# one-step local error from t0=1.0 on true solution
sol=mp.odefun(lambda tt,yy: 1-tt*mp.cbrt(yy),0,1)
t0=1.0; y0=float(sol(t0))
def rk4(t,y,h):
    F=lambda t,y:1-t*np.cbrt(y)
    k1=F(t,y);k2=F(t+h/2,y+h/2*k1);k3=F(t+h/2,y+h/2*k2);k4=F(t+h,y+h*k3)
    return y+h/6*(k1+2*k2+2*k3+k4)
for name,step in [("T3",lambda h: taylor(3,1,T=t0+h,T0=t0,y0=y0)[1][-1]),("T4fd",lambda h: taylor(4,1,T=t0+h,T0=t0,y0=y0,fd=True)[1][-1]),("RK4",lambda h: rk4(t0,y0,h))]:
    hs=[0.2,0.1,0.05,0.025]
    e=[abs(step(h)-float(sol(t0+h))) for h in hs]
    print(name,"local errs",['%.2e'%x for x in e],"slopes",['%.2f'%math.log2(e[i]/e[i+1]) for i in range(3)])
# FD vs exact d4 along reference grid
for tt in np.arange(0,5.01,0.5):
    yy=float(sol(tt)); ex=Dn[3](tt,yy); fd=s_d4fd(tt,yy,0.25)
    print(f"t={tt:.1f} d4 exact={ex:.6e} fd={fd:.6e} rel={abs(fd-ex)/abs(ex):.1e}")
