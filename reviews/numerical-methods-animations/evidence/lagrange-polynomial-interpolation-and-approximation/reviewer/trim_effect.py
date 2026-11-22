# Effect of the script's 3% inset: max |P - f| over the plotted node hull for
# nodes on the full table interval vs on the inset interval actually used (degree 15, 16 nodes).
import mpmath as mp
mp.mp.dps = 40
def lag(x, xs, ys):
    s = 0
    for i in range(len(xs)):
        L = 1
        for j in range(len(xs)):
            if j != i: L *= (x-xs[j])/(xs[i]-xs[j])
        s += ys[i]*L
    return s
def maxerr(f, a, b, n, lo, hi):
    xs = [a+(b-a)*mp.mpf(i)/(n-1) for i in range(n)]; ys = [f(x) for x in xs]
    return max(abs(lag(lo+(hi-lo)*mp.mpf(k)/2000, xs, ys) - f(lo+(hi-lo)*mp.mpf(k)/2000)) for k in range(2001))
runge = lambda x: 1/(1+10*x**2)
for n in (10, 16):
    print('Case 08 Runge, %d nodes: max err on [-1,1] with nodes on [-1,1] = %.4f ; on [-0.94,0.94] with script nodes = %.4f' % (
        n, maxerr(runge, -1, 1, n, -1, 1), maxerr(runge, mp.mpf('-0.94'), mp.mpf('0.94'), n, mp.mpf('-0.94'), mp.mpf('0.94'))))
print('Case 04 sqrt, 16 nodes: max err on [0,2] nodes on [0,2] = %.4f ; script nodes [0.06,1.94] err on [0.06,1.94] = %.5f' % (
    maxerr(mp.sqrt, 0, 2, 16, 0, 2), maxerr(mp.sqrt, mp.mpf('0.06'), mp.mpf('1.94'), 16, mp.mpf('0.06'), mp.mpf('1.94'))))
