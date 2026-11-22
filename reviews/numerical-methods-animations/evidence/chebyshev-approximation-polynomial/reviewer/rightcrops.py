# For each case: right 230 px of the title strip of frame 1 (single-digit degree) and of the last frame
# (two-digit degree), side by side with a grey separator, one row per case.
import os
from PIL import Image, ImageDraw
base = os.path.join(os.path.dirname(os.path.abspath(__file__)), '..', 'committed')
W = 230
rows = []
for i in range(1, 30):
    d = os.path.join(base, f"cheby{i:02d}")
    n = int(open(os.path.join(d, 'nframes')).read())
    row = Image.new('RGB', (40 + 2 * W + 10, 30), 'white')
    ImageDraw.Draw(row).text((5, 8), f"{i:02d}", fill='blue')
    for j, k in enumerate((1, n)):
        im = Image.open(os.path.join(d, f"frame_{k:03d}.png")).convert('RGB').crop((760 - W, 0, 760, 30))
        row.paste(im, (40 + j * (W + 10), 0))
        ImageDraw.Draw(row).rectangle((40 + j * (W + 10) + W, 0, 40 + j * (W + 10) + W + 9, 30), fill='grey')
    rows.append(row)
out = Image.new('RGB', (rows[0].width, 30 * len(rows)), 'white')
for i, r in enumerate(rows): out.paste(r, (0, 30 * i))
out = out.resize((out.width * 2, out.height * 2))
out.crop((0, 0, out.width, out.height // 2)).save("right_top.png")
out.crop((0, out.height // 2, out.width, out.height)).save("right_bot.png")
