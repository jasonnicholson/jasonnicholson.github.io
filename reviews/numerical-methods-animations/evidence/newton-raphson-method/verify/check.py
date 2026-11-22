import mpmath as mp, numpy as np
mp.mp.dps=40
# Case 1
f=lambda x: 3*mp.e**x-4*mp.cos(x); fp=lambda x:3*mp.e**x+4*mp.sin(x)
print("Case1 root near 0.29:", mp.findroot(f,0.29))
# count real roots of case1: for x<0, look for sign changes on [-60,2]
xs=np.linspace(-60,2,600001); g=3*np.exp(xs)-4*np.cos(xs)
sc=np.where(np.sign(g[:-1])!=np.sign(g[1:]))[0]
print("Case1 sign changes in [-60,2]:", len(sc), "first few:", [float(mp.findroot(f,xs[i])) for i in sc[-5:]])
x=1.0; it=[x]
for i in range(5):
    x=x-(3*np.exp(x)-4*np.cos(x))/(3*np.exp(x)+4*np.sin(x)); it.append(x)
r=float(mp.findroot(f,0.29))
print("Case1 iterates:", it); print("errors:", [v-r for v in it])
# Case 4
print("Case4 real roots:", np.roots([1,0,-1,3]))
x=0.0; it=[x]
for i in range(10):
    x=x-(x**3-x+3)/(3*x**2-1); it.append(x)
print("Case4 iterates:", it)
# longer run
x=0.0; L=[]
for i in range(200):
    x=x-(x**3-x+3)/(3*x**2-1); L.append(x)
print("Case4 iterates 11-200 max |x|:", max(abs(v) for v in L), "last:", L[-5:])
# local min value
xm=1/np.sqrt(3); print("Case4 local min at", xm, "value", xm**3-xm+3)
# Case 5
x=2.0; it=[x]
for i in range(6):
    x=x-x*np.exp(-x)/((1-x)*np.exp(-x)); it.append(x)
print("Case5 iterates:", it)
