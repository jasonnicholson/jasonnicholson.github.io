import sys,numpy as np
from PIL import Image
d=sys.argv[1]
for f in range(30,41):
    a=np.asarray(Image.open(f"{d}/frame_{f:03d}.png").convert('RGB')).astype(int)
    r=(a[...,0]>200)&(a[...,1]<60)&(a[...,2]<60)
    # exclude legend region pixels (legend box approx x 490-668, y 48-140)
    m=r.copy(); m[45:143,488:670]=False
    print(f, "red px outside legend:", m.sum())
