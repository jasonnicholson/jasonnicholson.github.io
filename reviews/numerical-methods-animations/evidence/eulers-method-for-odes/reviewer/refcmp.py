import numpy as np; from scipy.integrate import solve_ivp
f=lambda t,y: 1-t*np.cbrt(y)
d=np.loadtxt('ref_dump.txt'); _,i=np.unique(d[:,0],return_index=True); d=d[i]
s=solve_ivp(lambda t,y:[f(t,y[0])],(0,5),[1.0],method='Radau',rtol=1e-12,atol=1e-14,t_eval=d[:,0])
print('script RK4 ref vs Radau, max abs diff over',len(d),'samples:',abs(s.y[0]-d[:,1]).max())
