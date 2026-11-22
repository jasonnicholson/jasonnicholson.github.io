# For each n: largest gap between the drawn endpoint-min/max height and the true inf/sup on a subinterval,
# and the area differences (endpoint version - true version), rounded like the GIF (6 decimals).
import mpmath as mp
mp.mp.dps=30
f=lambda x: mp.e**(-x)*mp.sin(8*mp.cbrt(x)**2)+1
crit=[mp.mpf('0.08038354937'),mp.mpf('0.4319819572'),mp.mpf('0.9392052471'),mp.mpf('1.564475501')]
crit=[mp.findroot(lambda x: mp.diff(f,x), c) for c in crit]
print("refined crit:", [mp.nstr(c,12) for c in crit], "f'' signs:", [mp.sign(mp.diff(f,c,2)) for c in crit])
for n in [1,2,3,4,5,6,7,8,10,12,14,16,20,24,28,32,40,48,56,64,72,88,104,120]:
    dx=mp.mpf(2)/n; gl=gu=0; dl=du=0
    for i in range(n):
        xl,xr=i*dx,(i+1)*dx
        pts=[xl,xr]+[c for c in crit if xl<c<xr]
        vals=[f(p) for p in pts]
        e_lo,e_hi=min(f(xl),f(xr)),max(f(xl),f(xr))
        gl=max(gl,e_lo-min(vals)); gu=max(gu,max(vals)-e_hi)
        dl+=(e_lo-min(vals))*dx; du+=(e_hi-max(vals))*dx
    print(n, "max lower-height gap", mp.nstr(gl,4), "max upper-height gap", mp.nstr(gu,4), "area diff lower", mp.nstr(dl,4), "upper", mp.nstr(du,4))
