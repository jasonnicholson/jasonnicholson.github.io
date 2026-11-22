import sys, numpy as np
from PIL import Image
for p in sys.argv[1:]:
    a=np.asarray(Image.open(p).convert("RGB")).astype(int)
    sat=a.max(axis=2)-a.min(axis=2)
    print(p.split('/')[-1], "coloured px:", int((sat>40).sum()))
