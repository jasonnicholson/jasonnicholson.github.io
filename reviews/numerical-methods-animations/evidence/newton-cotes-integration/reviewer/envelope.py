# max |piecewise interpolant - f| per rule at selected n, independent (numpy polyfit through panel nodes in local coord)
import numpy as np
f = lambda x: np.exp(-x)*np.sin(8*np.cbrt(x)**2)+1
def maxdev(m, n):
    h = 2/n; worst=(0,0)
    for p in range(0,n,m):
        xs = p*h + h*np.arange(m+1); c = np.polyfit(xs-xs[0], f(xs), m)
        t = np.linspace(xs[0], xs[-1], 400); d = np.abs(np.polyval(c, t-xs[0]) - f(t))
        if d.max()>worst[0]: worst=(d.max(), t[d.argmax()])
    return worst
for m,ns in [(1,[1,8,24,120]),(2,[4,16,40]),(3,[6,18,48,120]),(4,[4,8,12,24,120])]:
    for n in ns: print('m=%d n=%d pts=%d maxdev=%.4f at x=%.3f'%((m,n,n+1)+maxdev(m,n)))
