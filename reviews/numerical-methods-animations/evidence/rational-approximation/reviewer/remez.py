# Independent Remez (relative error) for [2/2] rational approx to exp on [-1,1], plus independent interpolants.
import mpmath as mp
mp.mp.dps = 40
f = mp.exp
def R(c, x):
    a0,a1,a2,b1,b2 = c
    return (a0+a1*x+a2*x**2)/(1+b1*x+b2*x**2)
def relerr(c,x): return (f(x)-R(c,x))/f(x)

def interp(xs):
    A = mp.matrix(5,5); r = mp.matrix(5,1)
    for i,x in enumerate(xs):
        y = f(x); A[i,0]=1; A[i,1]=x; A[i,2]=x**2; A[i,3]=-y*x; A[i,4]=-y*x**2; r[i]=y
    return list(mp.lu_solve(A,r))
xeq = [mp.mpf(-1)+mp.mpf(k)/2 for k in range(5)]
xch = sorted([mp.cos((2*k-1)*mp.pi/10) for k in range(1,6)])
ceq = interp(xeq); cch = interp(xch)
def maxerr(c, N=20001):
    return max(abs(relerr(c, mp.mpf(-1)+2*mp.mpf(i)/(N-1))) for i in range(N))
print("eq coeffs", [mp.nstr(v,15) for v in ceq], "max rel err", mp.nstr(maxerr(ceq,4001),10))
print("ch coeffs", [mp.nstr(v,15) for v in cch], "max rel err", mp.nstr(maxerr(cch,4001),10))

# Remez: solve f(x_i)-R(x_i) = (-1)^i E f(x_i) at 6 points
def solve_ref(pts, c0, E0):
    def eqs(a0,a1,a2,b1,b2,E):
        c=(a0,a1,a2,b1,b2)
        return [ (a0+a1*x+a2*x**2) - f(x)*(1-(-1)**i*E)*(1+b1*x+b2*x**2) for i,x in enumerate(pts)]
    sol = mp.findroot(eqs, list(c0)+[E0])
    return [sol[i] for i in range(5)], sol[5]
pts = [mp.cos(mp.pi*(5-k)/5) for k in range(6)]  # Chebyshev extrema as initial reference
c, E = cch, mp.mpf('8.8e-5')
for it in range(12):
    c, E = solve_ref(pts, c, E)
    # locate extrema of relerr: endpoints + interior critical points near previous pts
    newpts=[mp.mpf(-1)]
    for p in pts[1:-1]:
        g = lambda x: mp.diff(lambda t: relerr(c,t), x)
        newpts.append(mp.findroot(g, p))
    newpts.append(mp.mpf(1))
    vals=[relerr(c,p) for p in newpts]
    pts=newpts
    spread = max(abs(v) for v in vals)-min(abs(v) for v in vals)
    if spread < mp.mpf('1e-25'): break
print("Remez iterations:", it+1)
print("minimax coeffs", [mp.nstr(v,15) for v in c])
print("levelled E =", mp.nstr(E,12))
print("reference points & rel err:")
for p,v in zip(pts,vals): print("  ", mp.nstr(p,10), mp.nstr(v,12))
print("max rel err on 20001 grid:", mp.nstr(maxerr(c,4001),12))
print("den min:", mp.nstr(min(1+c[3]*x+c[4]*x**2 for x in [mp.mpf(-1)+2*mp.mpf(i)/400 for i in range(401)]),8))
