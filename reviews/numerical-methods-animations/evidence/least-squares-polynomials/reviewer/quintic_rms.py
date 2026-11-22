import numpy as np
x=np.array([-4.5,-3.2,-1.4,0.8,2.5,4.1]); y=np.array([0.7,2.3,3.8,5.0,5.5,5.6])
V=np.vander(x,6,increasing=True)
for name,a in [("polyfit",np.polyfit(x,y,5)[::-1]),("lstsq",np.linalg.lstsq(V,y,rcond=None)[0]),("normal eq",np.linalg.solve(V.T@V,V.T@y)),("solve V",np.linalg.solve(V,y))]:
    print(name, np.sqrt(np.mean((V@a-y)**2)))
c=np.array([4.63232375,0.50885354,-0.06062594,-0.00073781,-0.00065051,0.00011667])
print("script coeffs residuals", V@c-y, "RMS", np.sqrt(np.mean((V@c-y)**2)))
# error vs degree ratios
r={2:0.05245143451,3:0.02767320994,4:0.00733996801}
print("ratio 3/4", r[3]/r[4], "ratio 2/3", r[2]/r[3])
