import numpy as np
f=lambda x: np.exp(-x)*np.sin(x)
fp=lambda x: np.exp(-x)*(np.cos(x)-np.sin(x))
hs=[0.5,0.3,0.2,0.1,0.07,0.05,0.03,0.02,0.01,0.005,0.002,0.001]
print("A1 maxerr per frame")
for k,h in enumerate(hs):
    x=np.linspace(h,np.pi-h,700)
    e=np.max(np.abs((f(x+h)-f(x-h))/(2*h)-fp(x)))
    print(k+1,h,e,round(e,6), e/h**2)
print("A2 chord vs drawn line at x0=1")
hs=[0.6,0.4,0.25,0.15,0.1,0.07,0.05,0.03,0.02,0.01,0.005,0.001]
x0=1.0
for k,h in enumerate(hs):
    yl,yr,y0=f(x0-h),f(x0+h),f(x0)
    m=(yr-yl)/(2*h)
    # drawn line value at xl, xr
    dl=y0+m*(-h); dr=y0+m*h
    print(k+1,h,"miss at xl",dl-yl,"miss at xr",dr-yr,"chord mid",(yl+yr)/2-y0)
