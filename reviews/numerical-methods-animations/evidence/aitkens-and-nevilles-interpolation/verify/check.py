import sympy as sp
x=sp.symbols('x'); pi=sp.pi
xs=[0,pi/4,pi/2,3*pi/4,pi]; ys=[sp.cos(t) for t in xs]
def interp(idx):
    return sp.expand(sp.interpolate(list(zip([xs[i] for i in idx],[ys[i] for i in idx])),x))
P3=interp([0,1,2,3]); P4=interp([0,1,2,3,4])
print("A2: P4-P3 =", sp.simplify(P4-P3))
print("A2: x^4 coeff of P4 =", sp.simplify(sp.Poly(P4,x).coeff_monomial(x**4)) if sp.Poly(P4,x).degree()>=4 else 0)
print("A2: P3(pi) =", sp.nsimplify(sp.simplify(P3.subs(x,pi))), " cos(pi)=-1")
# max error of each degree on [0,pi]
import numpy as np
for d in range(5):
    p=sp.lambdify(x,interp(list(range(d+1))),'numpy'); g=np.linspace(-0.1,np.pi+0.1,500)
    print("deg",d,"max|err| on plot grid",np.max(np.abs(p(g)-np.cos(g))))
# A1: Neville vs Aitken tables at xq
xq=sp.Rational(1,3)
n=5
N=[[None]*n for _ in range(n)]
for i in range(n): N[i][i]=ys[i]
for L in range(1,n):
    for i in range(n-L):
        j=i+L; N[i][j]=sp.simplify(((xq-xs[i])*N[i+1][j]-(xq-xs[j])*N[i][j-1])/(xs[j]-xs[i]))
# Aitken: A[k][j] = interpolant on nodes {0..k-1, j}, j>=k
A=[[None]*n for _ in range(n)]
for j in range(n): A[0][j]=ys[j]
for k in range(1,n):
    for j in range(k,n):
        A[k][j]=sp.simplify(((xq-xs[k-1])*A[k-1][j]-(xq-xs[j])*A[k-1][k-1])/(xs[j]-xs[k-1]))
print("Neville level-2 entries (nodes {i,i+1,i+2}):",[float(N[i][i+2]) for i in range(3)])
print("Aitken  level-2 entries (nodes {0,1,j}):",[float(A[2][j]) for j in range(2,5)])
print("Final Neville",float(N[0][4]),"Final Aitken",float(A[4][4]))
# check Aitken A[2][j] equals interp on {0,1,j}
print("Aitken A[2][4] vs interp{0,1,4}:",float(A[2][4]), float(interp([0,1,4]).subs(x,xq)))
print("Neville N[2][4] vs interp{2,3,4}:",float(N[2][4]), float(interp([2,3,4]).subs(x,xq)))
