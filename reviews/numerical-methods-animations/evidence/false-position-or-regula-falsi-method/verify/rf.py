import mpmath as mp
mp.mp.dps=30
def run(f,a,b,n):
    print("f(a)=",f(a),"f(b)=",f(b))
    for i in range(1,n+1):
        c=(a*f(b)-b*f(a))/(f(b)-f(a))
        side = 'b<-c' if f(a)*f(c)<0 else 'a<-c'
        if f(a)*f(c)<0: b=c
        else: a=c
        print(i, float(c), float(f(c)), side, "bracket", float(a), float(b))
fA=lambda x:x**3+4*x**2-10
fB=lambda x:x-mp.cos(x)
print("rootA",mp.findroot(fA,1.3),"all roots",mp.polyroots([1,4,0,-10]))
print("rootB",mp.findroot(fB,0.7))
run(fA,mp.mpf(-1),mp.mpf(2),12)
run(fB,mp.mpf(0),mp.mpf(1),10)
