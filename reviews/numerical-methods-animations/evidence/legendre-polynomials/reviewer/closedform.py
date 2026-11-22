import mpmath as mp
mp.mp.dps=30
k=mp.pi/2
for n in range(0,11,2):
    cf=(2*n+1)*(-1)**(n//2)*mp.sqrt(mp.pi/(2*k))*mp.besselj(n+mp.mpf(1)/2,k)
    q=(2*n+1)/mp.mpf(2)*mp.quad(lambda t: mp.cos(k*t)*mp.legendre(n,t),[-1,0,1])
    print(n, mp.nstr(cf,15), mp.nstr(q,15))
# predicted trapezoid endpoint error: c_trap - c_true ~ -(2n+1)/2 * h^2/12 * [g'(1)-g'(-1)], g=f*P_n, g'(+-1)=f'(+-1)P_n(+-1)
h=mp.mpf(2)/999
for n in range(0,9,2):
    print("predicted trap error n=%d: %s"%(n, mp.nstr(-(2*n+1)/mp.mpf(2)*h**2/12*(-mp.pi),4)))
