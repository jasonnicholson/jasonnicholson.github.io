# Independent Newton computation with sympy-derived derivatives and mpmath (50 digits)
import sympy as sp, mpmath as mp
mp.mp.dps = 50
x = sp.symbols('x')
cases = {
 'aa': (3*sp.exp(x)-4*sp.cos(x), 1.0, 5),
 'bb': ((1-5*x)**2, 1.0, 12),
 'cc': (sp.atan(x), 1.35, 8),
 'dd': (x**3-x+3, 0.0, 10),
 'ee': (x*sp.exp(-x), 2.0, 6),
 'ff': (sp.atan(x), 1.4, 6),
}
for name,(fx,x0,n) in cases.items():
    dfx = sp.diff(fx,x)
    f = sp.lambdify(x,fx,'mpmath'); df = sp.lambdify(x,dfx,'mpmath')
    print(f"== {name}: f={fx}, f'={dfx}")
    xs=[mp.mpf(x0)]
    for i in range(n):
        xs.append(xs[-1]-f(xs[-1])/df(xs[-1]))
    for i,v in enumerate(xs):
        print(f"  x{i} = {mp.nstr(v,17):>24}   f = {mp.nstr(f(v),10)}  f' = {mp.nstr(df(v),10)}")
# roots
print("root aa:", mp.findroot(lambda t: 3*mp.e**t-4*mp.cos(t), 0.3))
print("root dd real:", sp.Poly(x**3-x+3).nroots())
print("dd local min at 1/sqrt3:", mp.nstr(mp.mpf(1)/mp.sqrt(3)), mp.nstr((1/mp.sqrt(3))**3-1/mp.sqrt(3)+3, 10))
# arctan critical: x_c solves 2x = (1+x^2) atan(x)
xc = mp.findroot(lambda t: 2*t-(1+t**2)*mp.atan(t), 1.39)
print("arctan x_c:", xc)
# longer runs
def run(f,df,x0,n):
    v=mp.mpf(x0); out=[]
    for i in range(n): v=v-f(v)/df(v); out.append(v)
    return out
o=run(lambda t:t**3-t+3, lambda t:3*t**2-1, 0, 60)
print("dd long:", [mp.nstr(v,6) for v in o])
o=run(mp.atan, lambda t:1/(1+t**2), 1.35, 20)
print("cc long:", [mp.nstr(v,6) for v in o])
