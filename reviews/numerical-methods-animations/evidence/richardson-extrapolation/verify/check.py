import mpmath as mp
mp.mp.dps=40
f=lambda x: mp.e**(-x)*mp.sin(x); fp=lambda x: mp.e**(-x)*(mp.cos(x)-mp.sin(x))
d3=lambda x,h:(f(x+h)-f(x-h))/(2*h); d5=lambda x,h:(4*d3(x,h/2)-d3(x,h))/3
for h in [0.5,0.32,0.2,0.12,0.08,0.05,0.03,0.02,0.01]:
    h=mp.mpf(h); xs=[h+(mp.pi-2*h)*k/699 for k in range(700)]
    e3=max(abs(d3(x,h)-fp(x)) for x in xs); e5=max(abs(d5(x,h)-fp(x)) for x in xs)
    print(float(h), mp.nstr(e3,4), mp.nstr(e5,4))
