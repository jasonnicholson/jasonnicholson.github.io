# Independent checks for booles-rule (no reuse of the script's code)
import mpmath as mp, sympy as sp
mp.mp.dps = 40
f = lambda x: 1 + mp.exp(-x)*mp.sin(8*mp.cbrt(x)**2)
# reference: substitute x=t^3 to remove the x^(2/3) singularity
g = lambda t: f(t**3)*3*t**2
I = mp.quad(g, [0, mp.cbrt(2)], maxdegree=12)
I2 = mp.quad(f, mp.linspace(0,2,41))
print("I (t-substitution) =", mp.nstr(I,25))
print("I (direct, split)  =", mp.nstr(I2,25))
# derive Boole weights from scratch: solve moment equations on nodes 0..4 over [0,4]
w = sp.symbols('w0:5'); x = sp.symbols('x')
eqs = [sp.Eq(sum(w[i]*sp.Integer(i)**k for i in range(5)), sp.integrate(x**k,(x,0,4))) for k in range(5)]
sol = sp.solve(eqs, w); print("weights (h=1) =", [sol[wi] for wi in w], " vs 2/45*[7,32,12,32,7] =", [sp.Rational(2,45)*c for c in [7,32,12,32,7]])
# degree of precision with page weights on [a,b] generic
a,b = sp.symbols('a b')
for k in range(8):
    h=(b-a)/4
    B = sp.Rational(2,45)*h*sum(c*(a+i*h)**k for i,c in enumerate([7,32,12,32,7]))
    ex = sp.integrate(x**k,(x,a,b))
    print("deg",k,"error =", sp.factor(sp.simplify(B-ex)))
def boole(fun, a, b, n):
    h = mp.mpf(b-a)/n; s=0
    for i in range(0,n,4):
        s += 2*h/45*(7*fun(a+i*h)+32*fun(a+(i+1)*h)+12*fun(a+(i+2)*h)+32*fun(a+(i+3)*h)+7*fun(a+(i+4)*h))
    return s
# composite convergence on a smooth function with known integral
sm = lambda x: mp.exp(-x)*mp.sin(8*x) + 1
Ism = mp.quad(sm,[0,2])
print("smooth test exp(-x)sin(8x)+1 on [0,2]:")
prev=None
for n in [8,16,32,64,128]:
    e = boole(sm,0,2,n)-Ism
    print(n, mp.nstr(e,6), "" if prev is None else mp.nstr(prev/e,6)); prev=e
print("page integrand:")
seq=[4,8,12,16,20,24,28,32,36,40,44,48,52,56,60,64,72,80,88,96,104,112,120]
for n in seq:
    B=boole(f,0,2,n); print(n, n+1, mp.nstr(B,10), "rounded", round(float(B),6), "err", mp.nstr(B-I,6))
prev=None
for n in [8,16,32,64,128,256,512,1024]:
    e=boole(f,0,2,n)-I
    print("halving n=",n, mp.nstr(e,6), "" if prev is None else "ratio %s  order %s"%(mp.nstr(prev/e,6), mp.nstr(mp.log(abs(prev/e),2),4))); prev=e
