# Independent Muller computation in mpmath (no reuse of script code).
# Muller step written from the divided-difference / Newton form of the interpolating quadratic:
#   P(x) = f2 + w (x-p2) + f[p0,p1,p2] (x-p2)^2,  w = f[p1,p2] + f[p0,p2] - f[p0,p1]
# root nearest p2: p2 - 2 f2 / (w ± sqrt(w^2 - 4 f2 f[p0,p1,p2])), sign maximising |denominator|.
import mpmath as mp
mp.mp.dps = 600
def dd(f,a,b): return (f(a)-f(b))/(a-b)
def dd3(f,a,b,c): return (dd(f,b,c)-dd(f,a,b))/(c-a)
def step(f,p0,p1,p2,mode):
    a = dd3(f,p0,p1,p2)
    w = dd(f,p1,p2)+dd(f,p0,p2)-dd(f,p0,p1)
    c = f(p2)
    disc = w*w-4*c*a
    s = mp.sqrt(mp.mpc(disc))
    den = w+s if abs(w+s)>=abs(w-s) else w-s
    z = p2 - 2*c/den
    if mode=='real': z = mp.re(z)
    return z, disc, a, w, c
cases = {
 'aa': (lambda x: x**3-3*x+2, [mp.mpf('2.2'),mp.mpf('2.1'),mp.mpf('2.0')], mp.mpf(1)),
 'bb': (lambda x: mp.sin(x**2-2)*(x**2-2), [mp.mpf('0.8'),mp.mpf('0.9'),mp.mpf('1.0')], mp.sqrt(2)),
 'cc': (lambda x: x**6-7*x**4+15*x**2-9, [mp.mpf('1.3'),mp.mpf('1.4'),mp.mpf('1.5')], mp.sqrt(3)),
}
import sys
N = int(sys.argv[1]) if len(sys.argv)>1 else 8
for name,(f,p,r) in cases.items():
    for mode in ['real','complex']:
        print(f"=== {name} mode={mode} root={mp.nstr(r,12)}")
        P = list(p); errs=[]
        for k in range(1,N+1):
            if abs(P[-1]-r) < mp.mpf(10)**-250: break
            z,disc,a,w,c = step(f,*P[-3:],mode)
            # vertex of interpolating parabola
            vert = P[-1] - w/(2*a)
            P.append(z); e = abs(z-r); errs.append(e)
            order = ''
            if len(errs)>=3 and errs[-2]>0 and errs[-3]>0 and errs[-1]>0:
                order = mp.nstr(mp.log(errs[-1]/errs[-2])/mp.log(errs[-2]/errs[-3]),4)
            if k<=N:
                print(f"k={k:2d} p={mp.nstr(z,16):>40s} |err|={mp.nstr(e,5):>10s} disc={mp.nstr(disc,5):>11s} vertex={mp.nstr(vert,16)} order~{order}")
