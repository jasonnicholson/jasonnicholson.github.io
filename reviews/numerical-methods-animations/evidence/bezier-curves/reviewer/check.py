import sys, numpy as np, sympy as sp
from math import comb
from scipy.spatial import Delaunay, ConvexHull
cases={'aa':[(0,0),(1,2),(3,2),(4,0)],'bb':[(0,0),(0,2),(4,0),(4,2)]}
d=sys.argv[1]
for k,Pl in cases.items():
    P=np.array(Pl,float)
    bern=lambda t: sum(comb(3,i)*(1-t)**(3-i)*t**i*P[i] for i in range(4))
    print("=== case",k)
    # per-frame check
    D=np.loadtxt(f"{d}/dump_{k}.txt")
    maxe=dict(L1=0,L2=0,L3=0,bern=0,tgrid=0)
    for row in D:
        fi,t=int(row[0]),row[1]
        tex=sp.Rational(int(fi)-1,39)
        assert abs(float(tex)-t)<1e-15
        L1=row[6:12].reshape(3,2); L2=row[12:16].reshape(2,2); L3=row[16:18]
        # independent: each level point lies on segment between its parents at fraction t
        L1e=np.array([(1-t)*P[i]+t*P[i+1] for i in range(3)])
        L2e=np.array([(1-t)*L1e[i]+t*L1e[i+1] for i in range(2)])
        maxe['L1']=max(maxe['L1'],abs(L1-L1e).max())
        maxe['L2']=max(maxe['L2'],abs(L2-L2e).max())
        # exact Bernstein with sympy rationals
        Pe=[sp.Matrix(p) for p in Pl]
        B=sum((sp.binomial(3,i)*(1-tex)**(3-i)*tex**i*Pe[i] for i in range(4)),sp.zeros(2,1))
        maxe['bern']=max(maxe['bern'],float(max(abs(B[0]-L3[0]),abs(B[1]-L3[1]))))
    print("max |L1-indep|, |L2-indep|, |L3-Bernstein exact|:",maxe['L1'],maxe['L2'],maxe['bern'])
    C=np.loadtxt(f"{d}/curve_{k}.txt")
    eb=max(np.abs(bern(t)-C[i,1:]).max() for i,t in enumerate(C[:,0]))
    print("backdrop curve vs Bernstein max err:",eb)
    hull=Delaunay(P); print("all 300 curve pts in hull:",bool(np.all(hull.find_simplex(C[:,1:],tol=1e-12)>=0)))
    print("B(0),B(1):",bern(0.0),bern(1.0))
    t=sp.symbols('t'); Pe=[sp.Matrix(p) for p in Pl]
    B=sp.expand(sum((sp.binomial(3,i)*(1-t)**(3-i)*t**i*Pe[i] for i in range(4)),sp.zeros(2,1)))
    print("x(t)=",B[0]," y(t)=",B[1])
    dB=B.diff(t); dd=dB.diff(t)
    print("B'(0)=",list(dB.subs(t,0))," 3(P1-P0)=",list(3*(Pe[1]-Pe[0]))," B'(1)=",list(dB.subs(t,1))," 3(P3-P2)=",list(3*(Pe[3]-Pe[2])))
    cr=sp.factor(dB[0]*dd[1]-dB[1]*dd[0]); print("curvature numerator x'y''-y'x'' =",cr, " roots:",sp.solve(cr,t))
    print("B(1/2)=",list(B.subs(t,sp.Rational(1,2))))
    # frame-end of traced curve vs red point
    for row in D[[0,9,19,29,38,39]]:
        print(f" frame {int(row[0])}: red t={row[1]:.4f} at ({row[16]:.4f},{row[17]:.4f}); blue ends t={row[3]:.4f} at ({row[4]:.4f},{row[5]:.4f}); gap={np.hypot(row[16]-row[4],row[17]-row[5]):.4f}")
    print(" max gap over frames:",max(np.hypot(r[16]-r[4],r[17]-r[5]) for r in D))
    # axis limits
    print(" curve range x",C[:,1].min(),C[:,1].max()," y",C[:,2].min(),C[:,2].max())
