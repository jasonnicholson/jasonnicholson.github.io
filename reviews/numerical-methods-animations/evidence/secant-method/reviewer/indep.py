# Independent secant iterates in high precision (mpmath), no reuse of script code
import mpmath as mp
mp.mp.dps = 50
cases = {
 'aa': (lambda x: 3*mp.e**x - 4*mp.cos(x), mp.mpf('1.0'), mp.mpf('0.9'), 9, 0.4),
 'bb': (lambda x: 1-10*x+25*x**2, mp.mpf('1.0'), mp.mpf('0.9'), 28, 0.2),
 'cc': (lambda x: mp.atan(x), mp.mpf('1.35'), mp.mpf('1.30'), 10, 0),
 'dd': (lambda x: x**3-x+3, mp.mpf('2.0'), mp.mpf('1.0'), 16, -1.6),
 'ee': (lambda x: x*mp.e**(-x), mp.mpf('1.5'), mp.mpf('2.0'), 16, 0),
 'ff': (lambda x: mp.atan(x), mp.mpf('1.60'), mp.mpf('1.50'), 6, 0),
}
for k,(f,p0,p1,n,guess) in cases.items():
    if k=='bb': r = mp.mpf(1)/5
    else: r = mp.findroot(f, guess)
    print(f"=== {k}  root = {mp.nstr(r,15)}  f(root)={mp.nstr(f(r),3)}")
    ps=[p0,p1]
    for i in range(n+ (1 if k!='x' else 0)):
        a,b=ps[-2],ps[-1]
        d=f(b)-f(a)
        if d==0: break
        ps.append(b - f(b)*(b-a)/d)
    errs=[abs(p-r) for p in ps]
    for j,p in enumerate(ps):
        q=''
        if j>=2 and errs[j-1]>0 and errs[j-2]>0 and errs[j]>0 and errs[j-1]!=errs[j-2]:
            try: q = mp.nstr(mp.log(errs[j]/errs[j-1])/mp.log(errs[j-1]/errs[j-2]),5)
            except: q=''
        rat = mp.nstr(errs[j]/errs[j-1],5) if j>=1 and errs[j-1]>0 else ''
        print(f"p{j:2d} = {mp.nstr(p,17):>26}  err={mp.nstr(errs[j],5):>12} ratio={rat:>10} order~{q}")
