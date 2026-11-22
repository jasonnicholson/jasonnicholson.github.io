# Independent high-precision evaluation (mpmath, 40 digits) of the errors the scripts annotate.
import mpmath as mp
mp.mp.dps=40
f=lambda x: mp.e**(-x)*mp.sin(x)
d=lambda x,k: mp.diff(f,x,k)
x0=mp.mpf(1)
fp1=d(x0,1); f3=d(x0,3); f5=d(x0,5)
print("f'(1) =",mp.nstr(fp1,15), " f'''(1)=",mp.nstr(f3,10)," f5(1)=",mp.nstr(f5,10))
D13=lambda x,h:(f(x+h)-f(x-h))/(2*h)
D15=lambda x,h:(f(x-2*h)-8*f(x-h)+8*f(x+h)-f(x+2*h))/(12*h)
D23=lambda x,h:(f(x+h)-2*f(x)+f(x-h))/h**2
D25=lambda x,h:(-f(x+2*h)+16*f(x+h)-30*f(x)+16*f(x-h)-f(x-2*h))/(12*h**2)
print("== aa: err3, leading term f'''h^2/6, ratio to previous for halving pairs")
for h in ['0.6','0.4','0.25','0.15','0.1','0.07','0.05','0.03','0.02','0.01','0.005','0.001']:
    h=mp.mpf(h); e=D13(x0,h)-fp1
    print(f"h={mp.nstr(h,4):6} approx={mp.nstr(D13(x0,h),12)} err={mp.nstr(e,6)} lead={mp.nstr(f3*h**2/6,6)}")
for a,b in [('0.1','0.05'),('0.02','0.01'),('0.01','0.005')]:
    print(" halving",a,"->",b,"ratio err3 =",mp.nstr((D13(x0,mp.mpf(a))-fp1)/(D13(x0,mp.mpf(b))-fp1),6))
print("== ab")
for h in ['0.35','0.25','0.18','0.12','0.08','0.05','0.03','0.02','0.01','0.005','0.002']:
    h=mp.mpf(h); e3=D13(x0,h)-fp1; e5=D15(x0,h)-fp1
    print(f"h={mp.nstr(h,4):6} err3={mp.nstr(e3,6)} err5={mp.nstr(e5,6)} lead5={mp.nstr(-f5*h**4/30,6)} err5<err3:{abs(e5)<abs(e3)}")
for a,b in [('0.1','0.05'),('0.02','0.01'),('0.01','0.005')]:
    print(" halving",a,"->",b,"ratio err5 =",mp.nstr((D15(x0,mp.mpf(a))-fp1)/(D15(x0,mp.mpf(b))-fp1),6))
print("== ac: max |err| over the script's 700-point grid [2h, pi-2h]")
fpp=lambda x: -2*mp.e**(-x)*mp.cos(x)
for hs in ['0.35','0.25','0.18','0.12','0.08','0.05','0.03','0.02','0.01','0.005','0.002']:
    h=mp.mpf(hs); a=2*h; b=mp.pi-2*h
    xs=[a+(b-a)*i/699 for i in range(700)]
    e3=max(abs(D23(x,h)-fpp(x)) for x in xs); e5=max(abs(D25(x,h)-fpp(x)) for x in xs)
    print(f"h={hs:6} max err3={mp.nstr(e3,6)} max err5={mp.nstr(e5,6)} ratio={mp.nstr(e3/e5,4)}")
for a,b in [('0.1','0.05'),('0.02','0.01')]:
    print(" halving at x=1",a,"->",b,"ratio err3 =",mp.nstr((D23(x0,mp.mpf(a))-fpp(x0))/(D23(x0,mp.mpf(b))-fpp(x0)),6),
          " ratio err5 =",mp.nstr((D25(x0,mp.mpf(a))-fpp(x0))/(D25(x0,mp.mpf(b))-fpp(x0)),6))
# f'' extrema on [0,pi] for ylims
print("f''(0)=",mp.nstr(fpp(0),6)," f''(3pi/4)=",mp.nstr(fpp(3*mp.pi/4),6)," f''(pi)=",mp.nstr(fpp(mp.pi),6))
