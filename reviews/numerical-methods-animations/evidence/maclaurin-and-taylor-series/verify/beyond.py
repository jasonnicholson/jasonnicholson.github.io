import numpy as np, mpmath as mp
co={l.split()[0]:np.array(list(map(float,l.split()[6:]))) for l in open('script_coeffs.txt')}
def P(a,dx): return np.polyval(a[::-1],dx)
# t04 log at 1, order 10, x beyond radius
s=co['t04']; ex=np.array([0]+[(-1)**(k+1)/k for k in range(1,11)])
for x in [2.0,2.2,2.3,2.4,0.25,0.0,-0.3]:
    print('t04 order10 x=%.2f f=%s script=%.4f exact=%.4f'%(x, ('%.4f'%np.log(x)) if x>0 else 'nan', P(s,x-1),P(ex,x-1)))
for x in [0.25,0.0]:
    print('t04 order7 x=%.2f script=%.4f exact=%.4f'%(x,P(s[:8],x-1),P(ex[:8],x-1)))
# t01 sqrt at 1
s=co['t01']; ex=np.array([float(v) for v in mp.taylor(mp.sqrt,1,10)])
for k in [4,7,8,10]:
    for x in [0.1,1.8,2.2,2.5]:
        print('t01 order%d x=%.2f f=%.4f script=%.4f exact=%.4f'%(k,x,np.sqrt(x),P(s[:k+1],x-1),P(ex[:k+1],x-1)))
