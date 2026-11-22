# stack the title+legend strip (top 95 px) of the last frame of every committed GIF into 3 tall images
import os, numpy as np, matplotlib; matplotlib.use("Agg"); import matplotlib.image as mpimg, matplotlib.pyplot as plt
D = os.path.dirname(os.path.abspath(__file__)); C = os.path.join(D, "..", "committed")
for grp in range(3):
    strips = []
    for i in range(grp*9+1, grp*9+10):
        d = os.path.join(C, f"pade{i:02d}"); n = int(open(os.path.join(d, "nframes")).read())
        im = mpimg.imread(os.path.join(d, f"frame_{n:03d}.png"))[:95, :, :3]
        strips.append(im)
    plt.imsave(os.path.join(D, f"titles_{grp+1}.png"), np.concatenate(strips, axis=0))
print("ok")
