# Stack the title strip (top 30 px) of the last frame of each committed GIF, labelled by GIF name.
import os, sys
from PIL import Image, ImageDraw
W = sys.argv[1]
names = sorted(d for d in os.listdir(os.path.join(W,'committed')) if d.startswith('series_'))
for part, chunk in enumerate([names[:16], names[16:]]):
    out = Image.new('RGB', (820, 32*len(chunk)), 'white'); d = ImageDraw.Draw(out)
    for i, nm in enumerate(chunk):
        n = int(open(os.path.join(W,'committed',nm,'nframes')).read())
        im = Image.open(os.path.join(W,'committed',nm,f'frame_{n:03d}.png')).convert('RGB').crop((0,0,700,30))
        out.paste(im, (120, 32*i)); d.text((4, 32*i+10), nm, fill='black')
    out.save(os.path.join(W,'reviewer',f'titles_{part}.png'))
