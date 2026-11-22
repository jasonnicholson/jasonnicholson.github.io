# Asymptotic order of secant on atan at root 0 (f''(0)=0) vs generic 1.618
import mpmath as mp
mp.mp.dps = 3000
for p0,p1 in [('1.60','1.50'),('1.35','1.30')]:
    ps=[mp.mpf(p0),mp.mpf(p1)]
    for _ in range(16):
        a,b=ps[-2],ps[-1]; ps.append(b-mp.atan(b)*(b-a)/(mp.atan(b)-mp.atan(a)))
    e=[abs(p) for p in ps]
    print(p0,p1,[mp.nstr(mp.log(e[j]/e[j-1])/mp.log(e[j-1]/e[j-2]),4) for j in range(4,len(e)) if e[j]>0])
    print('  log10 errors', [mp.nstr(mp.log10(x),5) for x in e[2:]])
