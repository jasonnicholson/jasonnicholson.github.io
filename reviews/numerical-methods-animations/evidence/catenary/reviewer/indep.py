import sympy as sp, mpmath as mp, numpy as np
x,c=sp.symbols('x c',positive=True)
y=c*sp.cosh(x/c)
print("Maclaurin:", sp.series(y,x,0,7))
d=sp.simplify(sp.series(y,x,0,8).removeO()-(x**2/(2*c)+c))
print("cat - parabola leading:", d)
# derivative zero at 0, min value
print("y'(0)=",sp.diff(y,x).subs(x,0)," y(0)=",y.subs(x,0)," y''>0:",sp.simplify(sp.diff(y,x,2)))
# ODE check: y'' = (1/c) sqrt(1+y'^2)
print("ODE residual:", sp.simplify(sp.diff(y,x,2)-sp.sqrt(1+sp.diff(y,x)**2)/c))
cs=np.linspace(0.5,4.0,25)
print("c values:", [round(v,4) for v in cs])
print(" c     cat(4)     par(4)    gap(4)   rel   sag_span=c(cosh(4/c)-1)  cat_exit|x|  par_exit|x|  x where gap=0.05")
for cv in cs:
    cv=mp.mpf(cv)
    cat4=cv*mp.cosh(4/cv); par4=16/(2*cv)+cv
    ce = cv*mp.acosh(12/cv) if 12/cv>1 else None
    pe = mp.sqrt(2*cv*(12-cv))
    xg = mp.findroot(lambda t: cv*mp.cosh(t/cv)-(t**2/(2*cv)+cv)-0.05, (mp.mpf('0.01'), 4*cv), solver='bisect') if cat4-par4>0.05 else None
    print(f"{float(cv):5.3f} {float(cat4):10.4f} {float(par4):8.4f} {float(cat4-par4):9.4f} {float((cat4-par4)/cat4):6.3f} {float(cv*(mp.cosh(4/cv)-1)):12.4f} {float(min(ce,4)):10.4f} {float(min(pe,4)):10.4f}  {xg if xg is None else float(xg):}")
# min over grid of catenary - parabola (nonnegativity)
xs=np.linspace(-4,4,500)
print("min(cat-par) over all frames:", min((cv*np.cosh(xs/cv)-(xs**2/(2*cv)+cv)).min() for cv in cs))
