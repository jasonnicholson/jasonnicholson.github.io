from fractions import Fraction as F
import sympy as sp
x=sp.symbols('x')
def run(name,g,x0,n,clamp=True):
    t=float(x0); c=float(x0); print(name)
    for i in range(n+1):
        print(f"  n={i:2d} true={t:.6g}  clamped={c:.6g}")
        t=g(t) if abs(t)<1e100 else t
        c=min(max(g(c),0.0),4.0)
g4=lambda t:t*t/4+t/2
g6=lambda t:-t*t/4-t/2+4
run("case4 x0=1.5",g4,1.5,8)
run("case4 x0=1.5 long",g4,1.5,40)
run("case5 x0=2.5",g4,2.5,8)
run("case6 x0=1.5",g6,1.5,10)
G4=x**2/4+x/2; G6=-x**2/4-x/2+4
print("case4 fixed pts",sp.solve(G4-x,x),"g'",[sp.diff(G4,x).subs(x,r) for r in sp.solve(G4-x,x)])
print("case6 fixed pts",sp.solve(G6-x,x),"g'",[sp.diff(G6,x).subs(x,r) for r in sp.solve(G6-x,x)])
print("G4-x =",sp.factor(G4-x))
# case6 2-cycle
G66=sp.expand(G6.subs(x,G6)-x)
print("case6 g(g(x))-x roots",sp.Poly(G66,x).nroots())
r=[rr for rr in sp.Poly(G66,x).nroots() if abs(sp.im(rr))<1e-12]
for rr in r:
    rr=sp.re(rr); print(" root",rr,"g(root)",G6.subs(x,rr),"(g o g)'",(sp.diff(G6,x).subs(x,rr)*sp.diff(G6,x).subs(x,G6.subs(x,rr))))
