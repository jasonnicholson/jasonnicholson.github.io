import numpy as np
L=open("pts_bb.txt").read().split("\n")
ts=np.array(list(map(float,L[0].split(",")))); ys=np.array(list(map(float,L[1].split(","))))
sl=1-ts*np.cbrt(ys); J=-ts/(3*np.cbrt(ys)**2)
print(" step start t    h      |y'| at start  df/dy   h*|df/dy|")
for i in range(len(ts)-1):
    if i%3==0 or i in (9,10,11,21,22):
        print("%2d %7.4f  %.4f   %.4f       %7.2f  %.2f"%(i+1,ts[i],ts[i+1]-ts[i],abs(sl[i]),J[i],(ts[i+1]-ts[i])*abs(J[i])))
