# Independent computation (does not reuse script code): reference integral (mpmath),
# left/right/endpoint-min/endpoint-max sums, and TRUE lower/upper (Darboux) sums using inf/sup on each subinterval.
import mpmath as mp
mp.mp.dps = 40
f = lambda x: mp.e**(-x)*mp.sin(8*mp.cbrt(x)**2)+1
a, b = mp.mpf(0), mp.mpf(2)
# substitution x=t^3 removes the x^(2/3) cusp: dx = 3t^2 dt
I = mp.quad(lambda t: f(t**3)*3*t**2, [0, mp.cbrt(2)])
I2 = mp.quad(f, mp.linspace(0, 2, 41))
print("I (t-substitution) =", mp.nstr(I, 20))
print("I (direct split)   =", mp.nstr(I2, 20))
# critical points of f: f'(x)= e^{-x}[ -sin(8x^{2/3}) + (16/3) x^{-1/3} cos(8x^{2/3}) ]=0
g = lambda x: -mp.sin(8*mp.cbrt(x)**2) + mp.mpf(16)/3*mp.cos(8*mp.cbrt(x)**2)/mp.cbrt(x)
crit = []
xs = [mp.mpf(k)/20000*2 for k in range(1, 20001)]
for x0, x1 in zip(xs[:-1], xs[1:]):
    if g(x0)*g(x1) < 0:
        crit.append(mp.findroot(g, (x0, x1), solver='bisect'))
print("critical points:", [(mp.nstr(c, 10), mp.nstr(f(c), 10)) for c in crit])
print("global min f on [0,2]:", mp.nstr(min([f(c) for c in crit]+[f(a),f(b)]),12), " max:", mp.nstr(max([f(c) for c in crit]+[f(a),f(b)]),12))
def ext(xl, xr, op):
    pts = [xl, xr] + [c for c in crit if xl < c < xr]
    return op([f(p) for p in pts])
n_seq = [1,2,3,4,5,6,7,8,10,12,14,16,20,24,28,32,40,48,56,64,72,88,104,120]
print("n | L | R | endpt-min | endpt-max | TRUE lower | TRUE upper | endptmin<=I? | endptmax>=I?")
for n in n_seq:
    dx = (b-a)/n
    xsn = [a+i*dx for i in range(n+1)]
    fv = [f(x) for x in xsn]
    L = dx*sum(fv[:-1]); R = dx*sum(fv[1:])
    emin = dx*sum(min(fv[i],fv[i+1]) for i in range(n)); emax = dx*sum(max(fv[i],fv[i+1]) for i in range(n))
    tl = dx*sum(ext(xsn[i],xsn[i+1],min) for i in range(n)); tu = dx*sum(ext(xsn[i],xsn[i+1],max) for i in range(n))
    print(n, *[mp.nstr(v, 8) for v in (L,R,emin,emax,tl,tu)], emin<=I, emax>=I, sep=" | ")
# convergence rate of left sum error
print("rate check: n, L-I, R-I, (L-I)*n")
for n in [10,20,40,80,160,320,640,1280]:
    dx=(b-a)/n; fv=[f(a+i*dx) for i in range(n+1)]
    L=dx*sum(fv[:-1]); R=dx*sum(fv[1:])
    print(n, mp.nstr(L-I,8), mp.nstr(R-I,8), mp.nstr((L-I)*n,8))
