import numpy as np
x=np.array([-4.5,-3.2,-1.4,0.8,2.5,4.1]); y=np.array([0.7,2.3,3.8,5.0,5.5,5.6])
xx=np.linspace(-5,4.5,2001)
for m in (2,3,4,5):
    c=np.polyfit(x,y,m); d2=np.polyval(np.polyder(c,2),xx)
    print(m,"p'' range on [-5,4.5]:",d2.min(),d2.max(), "max p on window", np.polyval(c,xx).max(), "p(-5)",np.polyval(c,-5),"p(4.5)",np.polyval(c,4.5))
