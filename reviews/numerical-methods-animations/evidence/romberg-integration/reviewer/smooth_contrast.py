# Contrast: same Romberg table on a smooth integrand (x^(2/3) replaced by x) to show what the page's L21 claim describes
import mpmath as mp
mp.mp.dps=40
for name,f in [("page f: 1+e^-x sin(8 x^(2/3))", lambda x: 1+mp.e**(-x)*mp.sin(8*mp.cbrt(x)**2)),
               ("smooth: 1+e^-x sin(8x)", lambda x: 1+mp.e**(-x)*mp.sin(8*x))]:
    I=mp.quad(lambda t: f(t**3)*3*t**2,[0,mp.cbrt(2)])
    R=[]
    for n in range(8):
        P=2**n; h=mp.mpf(2)/P
        row=[h*(f(0)/2+mp.fsum(f(i*h) for i in range(1,P))+f(2)/2)]
        for m in range(1,n+1):
            row.append(row[m-1]+(row[m-1]-R[n-1][m-1])/(4**m-1))
        R.append(row)
    print(name, "I=", mp.nstr(I,15))
    for n in range(8):
        print("  k=%d m=%3d  |T err|=%s  |R[k,k] err|=%s"%(n+1,2**n+1,mp.nstr(abs(R[n][0]-I),3),mp.nstr(abs(R[n][n]-I),3)))
