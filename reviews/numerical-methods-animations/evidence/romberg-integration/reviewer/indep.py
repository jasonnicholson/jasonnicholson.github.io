import mpmath as mp
mp.mp.dps=40
f=lambda x: 1+mp.e**(-x)*mp.sin(8*mp.cbrt(x)**2)
# reference: substitution x=t^3 removes the singularity: dx=3t^2 dt, t in [0, 2^(1/3)]
I1=mp.quad(lambda t: f(t**3)*3*t**2,[0,mp.cbrt(2)])
I2=mp.quad(f,mp.linspace(0,2,41))
I3=mp.quad(f,[0,1e-6,1e-3,0.1,0.5,1,2],maxdegree=10)
print("ref", I1); print("chk", I2, I3)
N=8
R=[[None]*N for _ in range(N)]
for n in range(N):
    P=2**n; h=mp.mpf(2)/P
    R[n][0]=h*(f(0)/2+sum(f(i*h) for i in range(1,P))+f(2)/2)
    for m in range(1,n+1):
        R[n][m]=R[n][m-1]+(R[n][m-1]-R[n-1][m-1])/(4**m-1)
for n in range(N):
    print(n+1, 2**n+1, "  ".join(mp.nstr(R[n][m],10) for m in range(n+1)))
print("errors col0 and diag:")
for n in range(N):
    print(n+1, 2**n+1, mp.nstr(R[n][0]-I1,5), mp.nstr(R[n][n]-I1,5), " best in row:", mp.nstr(min(abs(R[n][m]-I1) for m in range(n+1)),5))
print("ratios of successive errors col0:", [mp.nstr((R[n-1][0]-I1)/(R[n][0]-I1),4) for n in range(1,N)])
print("ratios diag:", [mp.nstr((R[n-1][n-1]-I1)/(R[n][n]-I1),4) for n in range(1,N)])
print("ratios col1:", [mp.nstr((R[n-1][1]-I1)/(R[n][1]-I1),4) for n in range(2,N)])
# extend further to see asymptotic rates
N2=14
T=[]
for n in range(N2):
    P=2**n; h=mp.mpf(2)/P
    T.append(h*(f(0)/2+mp.fsum(f(i*h) for i in range(1,P))+f(2)/2))
RR=[[T[n]] for n in range(N2)]
for n in range(N2):
    for m in range(1,n+1):
        RR[n].append(RR[n][m-1]+(RR[n][m-1]-RR[n-1][m-1])/(4**m-1))
for n in range(N2):
    print(n, 2**n, "T err", mp.nstr(T[n]-I1,5), "diag err", mp.nstr(RR[n][n]-I1,5), "col1 err", mp.nstr(RR[n][1]-I1,5) if n>=1 else "")
print("col0 ratios long:", [mp.nstr((T[n-1]-I1)/(T[n]-I1),4) for n in range(1,N2)])
print("diag ratios long:", [mp.nstr((RR[n-1][n-1]-I1)/(RR[n][n]-I1),4) for n in range(1,N2)])
# polynomial check: Romberg R[n][m] exact for degree 2m+1
