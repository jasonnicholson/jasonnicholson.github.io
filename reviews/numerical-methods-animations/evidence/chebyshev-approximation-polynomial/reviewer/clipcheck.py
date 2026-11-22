# For every frame of every committed GIF: leftmost/rightmost dark pixel in the title strip (rows 0-29).
# A rightmost dark pixel at column >= 758 means the title runs off the right edge.
import os, numpy as np
from PIL import Image
base = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'committed')
for i in range(1, 30):
    cid = f"{i:02d}"; d = os.path.join(base, f"cheby{cid}")
    n = int(open(os.path.join(d, 'nframes')).read())
    res = []
    for k in range(1, n + 1):
        a = np.asarray(Image.open(os.path.join(d, f"frame_{k:03d}.png")).convert('L'))[0:30]
        cols = np.where((a < 128).any(axis=0))[0]
        res.append((cols.min(), cols.max()))
    clipped = [k + 1 for k, (l, r) in enumerate(res) if r >= 758 or l <= 1]
    print(cid, "left/right of frame1", res[0], "last", res[-1], "clipped frames:", clipped)
