# Trapezoid vs Simpson error for the page's integrand at the same n (context for the O(h^4) claim)
import mpmath as mp
mp.mp.dps=30
f=lambda x: mp.e**(-x)*mp.sin(8*mp.cbrt(x)**2)+1
I=mp.quad(lambda t: f(t**3)*3*t**2,[0,mp.cbrt(2)])
def T(n):
    h=mp.mpf(2)/n; return h*(f(0)/2+f(2)/2+sum(f(i*h) for i in range(1,n)))
def S(n):
    h=mp.mpf(2)/n; return h/3*sum(f(i*h)+4*f((i+1)*h)+f((i+2)*h) for i in range(0,n,2))
for n in [20,48,108,1024]:
    print(n, "trap err", mp.nstr(T(n)-I,5), " simpson err", mp.nstr(S(n)-I,5))
# smooth control: Simpson on e^{-x}sin(8x)+1 shows ratio ~16
g=lambda x: mp.e**(-x)*mp.sin(8*x)+1
Ig=mp.quad(g,[0,2])
def Sg(n):
    h=mp.mpf(2)/n; return h/3*sum(g(i*h)+4*g((i+1)*h)+g((i+2)*h) for i in range(0,n,2))
for n in [16,32,64]:
    print("smooth control", n, mp.nstr((Sg(n)-Ig)/(Sg(2*n)-Ig),5))
