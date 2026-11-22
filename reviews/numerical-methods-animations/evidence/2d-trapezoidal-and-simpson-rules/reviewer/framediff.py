# Compare Trapezoidal and Simpson frames pixel-by-pixel below the title band (rows >= 60).
import sys, numpy as np
from PIL import Image
W=sys.argv[1]
for k in range(1,9):
    a=np.asarray(Image.open(f"{W}/committed/trapezoidal2daa/frame_{k:03d}.png").convert("RGB")).astype(int)
    b=np.asarray(Image.open(f"{W}/committed/simpson2daa/frame_{k:03d}.png").convert("RGB")).astype(int)
    d=np.abs(a-b).sum(axis=2)
    rows=np.where(d.any(axis=1))[0]
    print(k, a.shape, "differing rows:", (rows.min(), rows.max()) if len(rows) else None, "diff px below row 60:", int((d[60:]>0).sum()))
print("magnitude check (rows>=60): max per-pixel |dRGB| sum, count >60")
for k in (1,8):
    a=np.asarray(Image.open(f"{W}/committed/trapezoidal2daa/frame_{k:03d}.png").convert("RGB")).astype(int)
    b=np.asarray(Image.open(f"{W}/committed/simpson2daa/frame_{k:03d}.png").convert("RGB")).astype(int)
    d=np.abs(a-b).sum(axis=2)[60:]
    print(k, int(d.max()), int((d>60).sum()))
