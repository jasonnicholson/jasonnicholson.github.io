import numpy as np
# PECE ABM4 on y'=lam*y: find real stability interval
def amp(z):
    # y_{n+1} = y_n + z/24*(9*yp + 19 y_n -5 y_{n-1} + y_{n-2}), yp = y_n + z/24*(55y_n-59y_{n-1}+37y_{n-2}-9y_{n-3})
    # characteristic poly in r (degree 4)
    p=np.zeros(5) # coefficients of r^4..r^0
    # r^4 - r^3 - z/24*(9*(r^3 + z/24*(55r^3-59r^2+37r-9)) + 19r^3 -5r^2 + r)
    c={4:1.0,3:-1.0,2:0,1:0,0:0}
    a=z/24
    c[3]-=a*(9+19+9*a*55); c[2]-=a*(-5+9*a*(-59)); c[1]-=a*(1+9*a*37); c[0]-=a*(9*a*(-9))
    return max(abs(np.roots([c[4],c[3],c[2],c[1],c[0]])))
zs=np.linspace(-3,0,30001)
bad=[z for z in zs if amp(z)>1+1e-12 and z<-1e-6]
print("real stability boundary approx", max(bad))
