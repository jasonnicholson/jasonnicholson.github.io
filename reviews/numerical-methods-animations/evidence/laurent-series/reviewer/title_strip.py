# Stack the title strip (top 30 px) and legend box of each case's LAST frame into one image
import sys, os
from PIL import Image
base = sys.argv[1]; out = sys.argv[2]
rows = []
for i in range(1, 28):
    d = os.path.join(base, f"laurent{i:02d}")
    n = int(open(os.path.join(d, "nframes")).read().strip())
    im = Image.open(os.path.join(d, f"frame_{n:03d}.png")).convert("RGB")
    title = im.crop((0, 0, im.width, 28))
    leg = im.crop((60, 40, 330, 90))
    row = Image.new("RGB", (im.width + 270, 50), "white")
    row.paste(title, (0, 0)); row.paste(leg, (im.width, 0))
    rows.append(row)
H = sum(r.height for r in rows)
canvas = Image.new("RGB", (rows[0].width, H), "white")
y = 0
for r in rows:
    canvas.paste(r, (0, y)); y += r.height
canvas.save(out)
print(canvas.size, im.size)
