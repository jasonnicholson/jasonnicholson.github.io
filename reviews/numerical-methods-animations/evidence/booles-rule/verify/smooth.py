import mpmath as mp
mp.mp.dps=40
g=lambda x: 1+mp.e**(-x)*mp.sin(8*x)
I=mp.quad(g,[0,1,2])
def boole(n):
    h=mp.mpf(2)/n; s=0
    for i in range(0,n,4):
        x=[i*h+k*h for k in range(5)]
        s+=2*h/45*(7*g(x[0])+32*g(x[1])+12*g(x[2])+32*g(x[3])+7*g(x[4]))
    return s
p=None
for n in [16,32,64,128,256]:
    e=boole(n)-I
    print(n, mp.nstr(e,6), "" if p is None else mp.nstr(mp.log(abs(p/e))/mp.log(2),4)); p=e
