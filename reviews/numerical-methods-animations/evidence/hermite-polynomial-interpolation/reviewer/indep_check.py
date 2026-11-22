# Independent check: sympy (exact Hermite conditions, degree), scipy KroghInterpolator (repeated-node divided differences)
import numpy as np, sympy as sp
from scipy.interpolate import KroghInterpolator, CubicHermiteSpline
x, t = sp.symbols('x t')

# --- Basis functions as written in both scripts
H00 = 2*t**3-3*t**2+1; H10 = t**3-2*t**2+t; H01 = -2*t**3+3*t**2; H11 = t**3-t**2
print("Basis conditions [H(0),H'(0),H(1),H'(1)]:")
for nm,Hb in [("H00",H00),("H10",H10),("H01",H01),("H11",H11)]:
    d=sp.diff(Hb,t); print(" ",nm,[Hb.subs(t,0),d.subs(t,0),Hb.subs(t,1),d.subs(t,1)], "deg",sp.degree(Hb,t))

# --- Case 1: piecewise cubic Hermite for sin on [0,2pi]
data = np.loadtxt("aa_values.csv", delimiter=",")
for n in [1,2,4,8]:
    xn = np.linspace(0,2*np.pi,n+1)
    rows = data[data[:,0]==n]; xq, Hq = rows[:,1], rows[:,2]
    # scipy piecewise reference
    ref = CubicHermiteSpline(xn, np.sin(xn), np.cos(xn))(xq)
    # Krogh (divided differences with repeated nodes) on each piece
    ref2 = np.empty_like(xq)
    for k,xx in enumerate(xq):
        i = min(max(np.searchsorted(xn,xx,side='right')-1,0),n-1)
        K = KroghInterpolator([xn[i],xn[i],xn[i+1],xn[i+1]],[np.sin(xn[i]),np.cos(xn[i]),np.sin(xn[i+1]),np.cos(xn[i+1])])
        ref2[k]=K(xx)
    # Global Hermite polynomial through all n+1 nodes (degree 2n+1)
    zs = np.repeat(xn,2); ys = np.ravel(np.column_stack([np.sin(xn),np.cos(xn)]))
    G = KroghInterpolator(zs, ys)(xq)
    xf = np.linspace(0,2*np.pi,200001)
    errpw = np.max(np.abs(CubicHermiteSpline(xn,np.sin(xn),np.cos(xn))(xf)-np.sin(xf)))
    errG = np.max(np.abs(KroghInterpolator(zs,ys)(xf)-np.sin(xf)))
    print(f"n={n}: max|script-CubicHermiteSpline|={np.max(np.abs(Hq-ref)):.2e}  max|script-Krogh piecewise|={np.max(np.abs(Hq-ref2)):.2e}  "
          f"max|script-global Hermite deg {2*n+1}|={np.max(np.abs(Hq-G)):.3e}  maxerr piecewise={errpw:.6e}  maxerr global={errG:.3e}")

# sympy: exact piecewise pieces for n=4 -- match f,f' at nodes, degree 3, C1 at interior nodes
n=4; nodes=[sp.Integer(k)*2*sp.pi/n for k in range(n+1)]
pieces=[]
for i in range(n):
    a,b=nodes[i],nodes[i+1]; h=b-a; tt=(x-a)/h
    p=sp.expand(sp.sin(a)*H00.subs(t,tt)+h*sp.cos(a)*H10.subs(t,tt)+sp.sin(b)*H01.subs(t,tt)+h*sp.cos(b)*H11.subs(t,tt))
    pieces.append(p)
    ok=[sp.simplify(p.subs(x,a)-sp.sin(a)),sp.simplify(sp.diff(p,x).subs(x,a)-sp.cos(a)),sp.simplify(p.subs(x,b)-sp.sin(b)),sp.simplify(sp.diff(p,x).subs(x,b)-sp.cos(b))]
    print(f" sympy n=4 piece {i}: residuals f,f' at ends {ok}, degree {sp.Poly(p,x).degree()}")

# n=1 closed form: H = 2pi(2t^3-3t^2+t); max error
tt=sp.symbols('tt')
# --- Case 2: e^x on [0,1]
bb = np.loadtxt("bb_values.csv", delimiter=",")
xb=bb[:,0]; Hs=bb[:,1:].sum(axis=1)
K = KroghInterpolator([0,0,1,1],[1,1,np.e,np.e])
print(f"Case2: max|script H - Krogh|={np.max(np.abs(Hs-K(xb))):.2e}")
Hx = sp.expand(1*H00.subs(t,x)+1*H10.subs(t,x)+sp.E*H01.subs(t,x)+sp.E*H11.subs(t,x))
print(" Case2 sympy H(x) =",Hx, "deg",sp.Poly(Hx,x).degree())
print(" H(0)-1, H'(0)-1, H(1)-e, H'(1)-e:",[sp.simplify(Hx.subs(x,0)-1),sp.simplify(sp.diff(Hx,x).subs(x,0)-1),sp.simplify(Hx.subs(x,1)-sp.E),sp.simplify(sp.diff(Hx,x).subs(x,1)-sp.E)])
xf=np.linspace(0,1,100001); print(" Case2 max|H-e^x| fine:", np.max(np.abs(K(xf)-np.exp(xf))))
for nm,s in [("t1",bb[:,1]),("t1+t2",bb[:,1]+bb[:,2])]:
    print(f" {nm}: min {s.min():.4f}, x where curve leaves ylim 0.8: {xb[np.argmax(s<0.8)]:.3f}; fraction of [0,1] hidden {np.mean(s<0.8):.3f}")
