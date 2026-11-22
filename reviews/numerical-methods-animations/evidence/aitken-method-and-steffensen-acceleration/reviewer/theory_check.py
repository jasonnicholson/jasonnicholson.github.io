# Newton map error ratio at a root of multiplicity m: lim (g(x)-p)/(x-p), with f=(x-p)^m*h(x), h(p)!=0
import sympy as sp
x,p=sp.symbols('x p'); 
for m in (1,2,3,4):
    f=(x-p)**m*(x+5)   # h(x)=x+5, generic
    g=x-f/sp.diff(f,x)
    print('m=%d ratio ='%m, sp.limit(sp.simplify((g-p)/(x-p)),x,p))
