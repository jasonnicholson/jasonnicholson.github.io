# Reference values on uniform grids for n=40,80 (for fixcheck.jl comparison)
import numpy as np, sys
from scipy.integrate import solve_ivp
for n in (40,80):
    ts = np.linspace(0,5,n+1)
    r = solve_ivp(lambda t,y:[1-t*np.cbrt(y[0])],(0,5),[1.0],method='Radau',rtol=1e-13,atol=1e-16,t_eval=ts)
    np.savetxt(f'ref_n{n}.txt', r.y[0], fmt='%.16e')
