import numpy as np
x=np.array([-4.5,-3.2,-1.4,0.8,2.5,4.1]); y=np.array([0.7,2.3,3.8,5.0,5.5,5.6])
C={2:[4.67425137,0.52860951,-0.07563441],3:[4.66862641,0.48939249,-0.07423867,0.00267659],
4:[4.62862816,0.49668723,-0.05823430,0.00201395,-0.00080138],
5:[4.63232375,0.50885354,-0.06062594,-0.00073781,-0.00065051,0.00011667]}
rms=lambda c: np.sqrt(np.mean((np.polyval(c[::-1],x)-y)**2))
ls={}
for k in range(6):
    V=np.vander(x,k+1,increasing=True); c,*_=np.linalg.lstsq(V,y,rcond=None); ls[k]=c
    print("true LS deg",k,np.round(c,8),"RMS",rms(c))
for m,c in C.items():
    print("committed m=%d matches LS:"%m, np.allclose(c,ls[m],atol=1e-7))
    for k in range(m+1):
        t=c[:k+1]; print("  m=%d trunc k=%d RMS=%.5f  trueLS deg k RMS=%.5f  coeff diff max=%.4g"%(m,k,rms(t),rms(ls[k]),np.max(np.abs(np.array(t)-ls[k]))))
