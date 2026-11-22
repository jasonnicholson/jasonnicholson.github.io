# Independent check: exact (sympy) Lagrange interpolants of cos at the first k nodes,
# mpmath barycentric/Lagrange evaluation compared to the script's plotted values,
# plus independent Neville and Aitken tableaux at a sample point.
import sympy as sp, mpmath as mp
mp.mp.dps = 40
x = sp.symbols('x')
nodes = [0, sp.pi/4, sp.pi/2, 3*sp.pi/4, sp.pi]
vals = [sp.cos(t) for t in nodes]
polys = {}
for deg in range(5):
    p = sp.expand(sp.interpolate(list(zip(nodes[:deg+1], vals[:deg+1])), x))
    polys[deg] = p
    lc = sp.Poly(p, x).coeffs()[0] if p.has(x) else p
    print(f"deg {deg}: exact degree = {sp.Poly(p,x).degree()}, leading coeff = {sp.nsimplify(sp.simplify(lc))} ~ {sp.N(lc)}")
print("P4 - P3 simplified:", sp.simplify(polys[4]-polys[3]))
print("P3(pi) =", sp.simplify(polys[3].subs(x, sp.pi)))
# nodal reproduction
for deg in range(5):
    print(deg, [sp.simplify(polys[deg].subs(x, nodes[k]) - vals[k]) for k in range(deg+1)])
# compare with script values
maxdiff = {d:0 for d in range(5)}
fs = {d: sp.lambdify(x, polys[d], 'mpmath') for d in range(5)}
for line in open('julia_vals.txt'):
    d, xq, v = line.split(); d=int(d)
    ref = fs[d](mp.mpf(xq))
    maxdiff[d] = max(maxdiff[d], abs(ref - mp.mpf(v)))
print("max |script - exact Lagrange| per degree:", {d: mp.nstr(m,3) for d,m in maxdiff.items()})
# max errors vs cos
for d in range(5):
    for a,b,lab in ((-0.1, float(mp.pi)+0.1, "plot window"), (0, float(mp.pi), "[0,pi]")):
        g = lambda t: abs(fs[d](t) - mp.cos(t))
        pts = [a + (b-a)*k/4000 for k in range(4001)]
        print(f"deg {d} {lab}: max|P-cos| = {mp.nstr(max(g(mp.mpf(t)) for t in pts),4)}")
# independent tableaux at xq = 1
xs = [mp.mpf(0), mp.pi/4, mp.pi/2, 3*mp.pi/4, mp.pi]; ys = [mp.cos(t) for t in xs]
xq = mp.mpf(1)
n=5
N = [[None]*n for _ in range(n)]
for i in range(n): N[i][i]=ys[i]
for L in range(1,n):
    for i in range(n-L):
        j=i+L
        N[i][j] = ((xq-xs[i])*N[i+1][j] - (xq-xs[j])*N[i][j-1])/(xs[j]-xs[i])
print("Neville P_{i,j}(1):"); [print(i, [mp.nstr(N[i][j],12) for j in range(i,n)]) for i in range(n)]
# Aitken: A[k][j] = interpolant on nodes {0..k-1, j}, j>=k
A = [[None]*n for _ in range(n)]
for j in range(n): A[0][j]=ys[j]
for k in range(1,n):
    for j in range(k,n):
        A[k][j] = ((xq-xs[k-1])*A[k-1][j] - (xq-xs[j])*A[k-1][k-1])/(xs[j]-xs[k-1])
print("Aitken column k (nodes 0..k-1 and j):"); [print(k, [mp.nstr(A[k][j],12) for j in range(k,n)]) for k in range(n)]
print("Lagrange P4(1) exact:", mp.nstr(fs[4](mp.mpf(1)),15), " cos(1)=", mp.nstr(mp.cos(1),15))
