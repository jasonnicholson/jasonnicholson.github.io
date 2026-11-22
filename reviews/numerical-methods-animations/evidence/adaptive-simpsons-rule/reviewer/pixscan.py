# Pixel-row scan of committed frames 14 and 21 at y=430 to locate panel-boundary seams; writes 3x zoom crop
from PIL import Image
for fr in ('frame_014','frame_021'):
    im=Image.open('../committed/adaptivesimpsonsaa/%s.png'%fr).convert('RGB')
    c=im.crop((38,300,330,450)); c.resize((c.width*3,c.height*3),Image.NEAREST).save(fr+'_zoom.png')
    row=[im.getpixel((x,430)) for x in range(38,620)]
    print(fr,[(x+38,row[x]) for x in range(1,len(row)) if row[x]!=row[x-1]])
