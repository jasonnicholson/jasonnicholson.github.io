# Stack the title strips of every frame of one case, with the right 360 px only (where the degree is).
import sys, os
from PIL import Image
base = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'committed')
outs = []
for cid in sys.argv[1:]:
    d = os.path.join(base, f"cheby{cid}")
    n = int(open(os.path.join(d, 'nframes')).read())
    for k in range(1, n + 1):
        outs.append(Image.open(os.path.join(d, f"frame_{k:03d}.png")).convert('RGB').crop((400, 0, 760, 30)))
out = Image.new('RGB', (360, 30 * len(outs)), 'white')
for i, s in enumerate(outs): out.paste(s, (0, 30 * i))
out.save("titles_frames_" + "_".join(sys.argv[1:]) + ".png")
