# Stack the title strip (top 30 px) of a given frame of every committed GIF.
import sys, os
from PIL import Image
base = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'committed')
which = sys.argv[1]  # 'last' or frame number
ids = [f"{i:02d}" for i in range(int(sys.argv[2]), int(sys.argv[3]) + 1)]
strips = []
for cid in ids:
    d = os.path.join(base, f"cheby{cid}")
    n = int(open(os.path.join(d, 'nframes')).read()) if which == 'last' else int(which)
    im = Image.open(os.path.join(d, f"frame_{n:03d}.png")).convert('RGB')
    strips.append(im.crop((0, 0, 760, 30)))
out = Image.new('RGB', (760, 30 * len(strips)), 'white')
for i, s in enumerate(strips): out.paste(s, (0, 30 * i))
out.save(f"titles_{which}_{ids[0]}_{ids[-1]}.png")
