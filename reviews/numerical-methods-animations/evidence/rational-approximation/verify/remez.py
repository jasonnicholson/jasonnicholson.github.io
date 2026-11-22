# Independent Remez for minimax RELATIVE error of [2/2] rational to exp on [-1,1]
import mpmath as mp
mp.mp.dps = 40
f = mp.exp
def R(c, x):
    a0,a1,a2,b1,b2 = c
    return (a0+a1*x+a2*x**2)/(1+b1*x+b2*x**2)
def relerr(c,x): return (f(x)-R(c,x))/f(x)

def solve(pts):
    # unknowns a0,a1,a2,b1,b2,E ; equations: f q - p = s_i E f q   (q has b0=1)
    E = mp.mpf(0)
    for it in range(60):
        A = mp.matrix(6,6); rhs = mp.matrix(6,1)
        for i,x in enumerate(pts):
            s = (-1)**i; fx = f(x); w = fx*(1 - s*E)   # (f - sEf) q - p = 0
            A[i,0]=-1; A[i,1]=-x; A[i,2]=-x**2; A[i,3]=w*x; A[i,4]=w*x**2
            # w*(1) + ... = 0  -> move w to rhs ; but E unknown: treat via fixed-point on E
            A[i,5]=0
            rhs[i]=-w
        # 6 eq, 5 unknowns + E: solve with E as unknown by secant on residual: use 5 eqs, check 6th
        # Simpler: full nonlinear Newton via mp.findroot
        break
    def F(*v):
        a0,a1,a2,b1,b2,E = v
        out=[]
        for i,x in enumerate(pts):
            s=(-1)**i
            out.append(f(x)-R((a0,a1,a2,b1,b2),x) - s*E*f(x))
        return out
    return F

pts = [mp.cos(mp.pi*(5-k)/5) for k in range(6)]  # Chebyshev extrema
guess = [1,0.5,1/12.,-0.5,1/12.,1e-4]  # Pade-like start
c=None
for outer in range(30):
    F = solve(pts)
    sol = mp.findroot(F, guess, tol=mp.mpf(10)**-35, maxsteps=200)
    sol = [sol[i] for i in range(6)]
    c = sol[:5]; E = sol[5]; guess = sol
    # exchange: locate extrema of relerr between sign changes
    grid = [mp.mpf(-1)+2*mp.mpf(i)/4000 for i in range(4001)]
    ev = [relerr(c,x) for x in grid]
    # split into sign-constant runs, take max |e| in each
    runs=[]; cur=[0]
    for i in range(1,len(grid)):
        if mp.sign(ev[i])==mp.sign(ev[cur[0]]) or ev[i]==0: cur.append(i)
        else: runs.append(cur); cur=[i]
    runs.append(cur)
    newpts=[]
    for r in runs:
        j=max(r,key=lambda i:abs(ev[i])); x=grid[j]
        if 0<j<len(grid)-1:
            g=lambda t: mp.diff(lambda u: relerr(c,u), t)
            try: x=mp.findroot(g, x)
            except Exception: pass
        newpts.append(x)
    if len(newpts)!=6:
        print("runs",len(newpts)); 
        # keep 6 largest alternating; fallback
        newpts=sorted(newpts,key=lambda x:-abs(relerr(c,x)))[:6]; newpts.sort()
    dev = max(abs(relerr(c,x)) for x in newpts)
    print(outer, "E=",mp.nstr(E,12), "max|e|=",mp.nstr(dev,12))
    if abs(dev-abs(E))<mp.mpf(10)**-25: break
    pts=newpts
print("coeffs", [mp.nstr(v,17) for v in c])
print("extremal pts", [mp.nstr(x,8) for x in pts])
print("errors at pts", [mp.nstr(relerr(c,x),10) for x in pts])
# dense check
mx=max(abs(relerr(c,mp.mpf(-1)+2*mp.mpf(i)/20000)) for i in range(20001))
print("dense max |relerr| =", mp.nstr(mx,15))
# also check script's c_mm and c_ch on dense grid
vals=[mp.mpf(l.strip()) for l in open("cmm.txt")]
for name,cc in (("c_mm",vals[:5]),("c_ch",vals[5:])):
    m=max(abs(relerr(cc,mp.mpf(-1)+2*mp.mpf(i)/20000)) for i in range(20001))
    print(name,"dense max |relerr| =",mp.nstr(m,10))
