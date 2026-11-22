# Independent high-precision computation (does not reuse script code)
import mpmath as mp, sympy as sp
mp.mp.dps = 400
X = sp.symbols('x')
cases = {
 'aa': (X**3-3*X+2, 1, 10), 'bb': (X**3-3*X+2, 2, 5),
 'cc': (X**4-X**3-3*X**2+5*X-2, 1, 12), 'dd': (X**4-X**3-3*X**2+5*X-2, 3, 5),
}
for k,(F,m,n) in cases.items():
    print('==',k,'f =',sp.factor(F),' m =',m, ' roots:', sp.roots(sp.Poly(F,X)))
    f = sp.lambdify(X,F,'mpmath'); fp = sp.lambdify(X,sp.diff(F,X),'mpmath')
    x = mp.mpf('1.3'); xs=[x]
    for i in range(max(n,12)):
        x = x - m*f(x)/fp(x); xs.append(x)
    for i,x in enumerate(xs):
        e = x-1
        r1 = (xs[i]-1)/(xs[i-1]-1) if i>0 else None
        r2 = (xs[i]-1)/(xs[i-1]-1)**2 if i>0 else None
        q = (mp.log(abs(xs[i]-1))/mp.log(abs(xs[i-1]-1))) if i>0 else None
        print(i, mp.nstr(x,17), ' err=',mp.nstr(e,6), ' e/e_prev=', mp.nstr(r1,6) if r1 is not None else '-', ' e/e_prev^2=', mp.nstr(r2,6) if r2 is not None else '-', ' log-ratio=', mp.nstr(q,5) if q is not None else '-', '' if i<=n else '(beyond script)')
# arctan
print('== arctan, standard Newton')
x = mp.mpf('1.4'); xs=[x]
for i in range(6):
    x = x - mp.atan(x)*(1+x**2); xs.append(x)
for i,x in enumerate(xs): print(i, mp.nstr(x,17))
xc = mp.findroot(lambda x: 2*x-(1+x**2)*mp.atan(x), 1.39)
print('x_c (2-cycle: N(x)=-x) =', mp.nstr(xc,20))
print('check N(xc)=', mp.nstr(xc - mp.atan(xc)*(1+xc**2),20))
# Method B: modified Newton x - f f'/(f'^2 - f f'') == Newton on u=f/f'
print('== arctan, Method B (Newton on u=f/fp), x0=1.4')
x = mp.mpf('1.4')
for i in range(8):
    f=mp.atan(x); fp=1/(1+x**2); fpp=-2*x/(1+x**2)**2
    x = x - f*fp/(fp**2-f*fpp); print(i+1, mp.nstr(x,20))
# Method A with m=1,2,3 from 1.4 (first step)
for m in (1,2,3):
    x=mp.mpf('1.4'); print('m=',m,' x_{1,m}=', mp.nstr(x-m*mp.atan(x)*(1+x**2),10))
