# Long-run behaviour of the true (unclamped) Case-6 orbit and the stability of its limit cycle
import mpmath as mp
mp.mp.dps = 50
g  = lambda t: -t*t/4 - t/2 + 4
dg = lambda t: -t/2 - mp.mpf(1)/2
t = mp.mpf('1.5'); seq=[t]
for i in range(400): t=g(t); seq.append(t)
print("min,max over 400 steps:", mp.nstr(min(seq),8), mp.nstr(max(seq),8))
print("last 8:", [mp.nstr(v,10) for v in seq[-8:]])
for p in (1,2,3,4,8):
    print(f"|x400 - x{400-p}| =", mp.nstr(abs(seq[-1]-seq[-1-p]),5))
cyc = seq[-4:]
mult = mp.fprod([dg(c) for c in cyc])
print("4-cycle:", [mp.nstr(c,12) for c in cyc], " multiplier prod g' =", mp.nstr(mult,8))
# 2-cycles of g, for comparison with the GIF's apparent {0,4} cycle
import sympy as sp
x=sp.symbols('x')
G=-x**2/4-x/2+4
print("g(g(x))=x roots:", [sp.nsimplify(r) for r in sp.solve(sp.expand(G.subs(x,G)-x),x)])
print("g(0)=",G.subs(x,0)," g(4)=",G.subs(x,4))
