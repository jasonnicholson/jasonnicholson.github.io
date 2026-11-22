import numpy as np
from scipy.optimize import brentq
R = lambda z: 1+z+z**2/2+z**3/6+z**4/24
zs = brentq(lambda z: abs(R(z))-1, -3.5, -2.0)
print("RK4 real-axis stability limit z* =", zs, " R(z*) =", R(zs))
# error ratios when halving on the page problem at T=5 (script values from rk4_instrumented.jl output)
ref=0.0081199205
for n,y in [(20,0.289107407190),(40,0.069848154771),(80,0.008126725005),(160,0.008120050298),(320,0.008119926437)]:
    print(n, abs(y-ref))
