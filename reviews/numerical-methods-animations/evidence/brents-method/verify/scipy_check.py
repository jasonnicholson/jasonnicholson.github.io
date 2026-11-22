import math, sys
sys.path.insert(0, '.')
from scipy.optimize import brentq
from compare import zeroin
for name,f,a,b in [("case1",lambda x:4*x**3-16*x**2+17*x-4,0.0,1.0),("case2",lambda x:math.tan(x)-2*x,0.5,1.5)]:
    xs=[]
    def g(x): xs.append(x); return f(x)
    r=brentq(g,a,b,xtol=1e-10,rtol=4*2.0**-52)
    z=[h[0] for h in zeroin(f,a,b,1e-10) if h[2]!="done"]
    print(name,"root",r)
    print(" scipy evals :",["%.12f"%x for x in xs[2:]])
    print(" zeroin evals:",["%.12f"%x for x in z])
