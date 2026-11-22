# Independent check: reference integral (mpmath) and independent Simpson sums, error ratios
import mpmath as mp
mp.mp.dps = 40
f = lambda x: mp.e**(-x)*mp.sin(8*mp.cbrt(x)**2) + 1
# split at 0 singular-derivative point; use tanh-sinh, check with subdivision
I1 = mp.quad(f, [0, 2])
I2 = mp.quad(f, mp.linspace(0, 2, 41))
# substitution x=t^3 removes the x^(2/3) non-smoothness: dx = 3t^2 dt, t in [0, 2^(1/3)]
I3 = mp.quad(lambda t: f(t**3)*3*t**2, [0, mp.cbrt(2)])
print("I (tanh-sinh)      =", mp.nstr(I1, 25))
print("I (40 subintervals)=", mp.nstr(I2, 25))
print("I (t^3 subst.)     =", mp.nstr(I3, 25))
I = I3
def simpson(n):
    h = mp.mpf(2)/n
    xs = [i*h for i in range(n+1)]
    # Simpson weights built panel-by-panel: (h/3)[1,4,1]
    s = 0
    for i in range(0, n, 2):
        s += h/3*(f(xs[i]) + 4*f(xs[i+1]) + f(xs[i+2]))
    return s
script = {2:2.4912610172534464,4:1.611786328647445,6:1.8405602095615228,8:1.9414360776747084,10:1.9763885057788257,12:1.991249237540609,14:1.9988141398228967,16:2.0032094989460294,18:2.006018174734146,20:2.0079417386648446,24:2.010369629370005,28:2.011813592933058,32:2.012756197183165,36:2.0134120330938727,40:2.0138900411352303,44:2.014251008823117,48:2.0145313361281936,56:2.0149343497581955,64:2.0152063434566827,72:2.0153996741989433,84:2.0156006459086404,96:2.0157369856104674,108:2.015834215997174}
print("n  indep_S  script_S  diff  err")
for n in sorted(script):
    s = simpson(n)
    print(n, mp.nstr(s,16), script[n], mp.nstr(abs(s-script[n]),3), mp.nstr(s-I,6))
print("halving ratios E(n)/E(2n), observed order log2:")
for n in [4,8,16,32,64,128,256,512,1024,2048,4096]:
    e1 = simpson(n)-I; e2 = simpson(2*n)-I
    r = e1/e2
    print(n, 2*n, mp.nstr(e1,6), mp.nstr(e2,6), mp.nstr(r,6), mp.nstr(mp.log(abs(r),2),4))
# within displayed range: n=24->48, 36->72, 48->96, 54? 
for (n1,n2) in [(10,20),(12,24),(14,28),(16,32),(18,36),(20,40),(24,48),(28,56),(32,64),(36,72),(48,96)]:
    e1 = simpson(n1)-I; e2 = simpson(n2)-I
    print("shown",n1,n2, mp.nstr(e1/e2,5), mp.nstr(mp.log(abs(e1/e2),2),4))
