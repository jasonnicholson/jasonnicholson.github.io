import numpy as np, math
p=np.loadtxt("pts.txt"); x,y=p[:,0],p[:,1]
ins=(x*x+y*y)<=1
print("all in [0,1):", x.min()>=0, x.max()<1, y.min()>=0, y.max()<1)
for n in [100,400,1600,6400,10000]:
    m=int(ins[:n].sum()); ph=4*m/n; sd=4*math.sqrt(math.pi/4*(1-math.pi/4)/n)
    print(n,m,n-m,ph,abs(math.pi-ph),1/math.sqrt(n),sd, abs(math.pi-ph)/sd)
