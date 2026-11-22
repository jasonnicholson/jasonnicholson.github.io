# Real roots of f(x)=3e^x-4cos(x): sign-change scan on [-20, 3] then mpmath refinement
import mpmath as mp
mp.mp.dps=30
f=lambda t: 3*mp.e**t-4*mp.cos(t)
N=23000; a=mp.mpf(-20); h=mp.mpf(23)/N
roots=[]
prev=f(a)
for i in range(1,N+1):
    b=a+i*h; v=f(b)
    if prev*v<0: roots.append(mp.findroot(f,(b-h,b),solver='bisect'))
    prev=v
print([mp.nstr(r,10) for r in roots])
# for x>0: f'(x)=3e^x+4sin x>0 on (0,pi) and f>0 for x>=ln(4/3)... check f>0 on [0.3,50]
print("min f on [0.3,10]:", min(f(mp.mpf(0.3)+k*0.001) for k in range(9700)))
# Quadratic rate check e_{n+1}/e_n^2
r=roots[-1]; xs=[mp.mpf(1)]
for i in range(5): xs.append(xs[-1]-f(xs[-1])/(3*mp.e**xs[-1]+4*mp.sin(xs[-1])))
e=[x-r for x in xs]; print("errors:",[mp.nstr(v,5) for v in e])
print("ratios e_{n+1}/e_n^2:",[mp.nstr(e[i+1]/e[i]**2,5) for i in range(4)])
print("f''/(2f') at root:", mp.nstr((3*mp.e**r+4*mp.cos(r))/(2*(3*mp.e**r+4*mp.sin(r))),5))
print("relative error of page 0.2910:", mp.nstr((mp.mpf('0.2910')-r),5), "f(0.2910)=",mp.nstr(f(mp.mpf('0.2910')),5))
