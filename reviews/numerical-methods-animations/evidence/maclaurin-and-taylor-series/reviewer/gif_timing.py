import sys
from PIL import Image
for p in sys.argv[1:]:
    im = Image.open(p); d=[]
    try:
        while True:
            d.append(im.info.get('duration')); im.seek(im.tell()+1)
    except EOFError: pass
    print(p.split('/')[-1], len(d), 'frames, durations(ms)=', sorted(set(d)))
