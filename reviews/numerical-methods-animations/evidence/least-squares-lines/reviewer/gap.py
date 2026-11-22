# Max vertical gap between y-on-x and rearranged x-on-y lines over the plot window x in [-2,7], and in pixels (~plot height 13.5 y-units over ~340 px)
import numpy as np
x=np.array([-1,0,1,2,3,4,5,6.]); y=np.array([10,9,7,5,4,3,0,-1.])
xs=np.linspace(-2,7,400)
for k in range(3,9):
    a,b=np.polyfit(x[:k],y[:k],1); c,d=np.polyfit(y[:k],x[:k],1)
    g=np.max(np.abs((a*xs+b)-(xs/c-d/c))); print(f"k={k} max gap={g:.4f} y-units ~{g/13.5*340:.1f} px")
