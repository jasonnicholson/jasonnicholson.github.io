import sys,numpy as np
from PIL import Image
D=sys.argv[1]
fr=[np.asarray(Image.open(f"{D}/frame_{i+1:03d}.png").convert("RGB")).astype(int) for i in range(9)]
for i in range(1,9):
    d=np.any(fr[i]!=fr[i-1],axis=2); ys,xs=np.nonzero(d)
    print(i,"->",i+1,"changed px",d.sum(), "bbox", (ys.min(),ys.max(),xs.min(),xs.max()) if d.sum() else None, "shape",d.shape)
