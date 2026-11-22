# Independent check: rebuild nodes from the case table (my reading: equally spaced on
# [a+0.03w, b-0.03w] of the node span), evaluate f with mpmath (50 digits), and evaluate
# the Lagrange form P(x)=sum y_i prod (x-x_j)/(x_i-x_j) at 9 test points; compare with the
# script's barycentric values dumped in nodes.txt.
import mpmath as mp
mp.mp.dps = 50
pi = mp.pi
F = {
 '01': (lambda x: 1/(1-x), (-1.6,0.9), (-1.6,0.9)),
 '02': (lambda x: 1/(1+x), (-0.9,1.6), (-0.9,1.6)),
 '03': (lambda x: 1/(1-x)**2, (-1.6,0.9), (-1.6,0.9)),
 '04': (mp.sqrt, (0,10.5), (0,2)),
 '05': (mp.sqrt, (0,10.5), (0,8)),
 '06': (mp.sqrt, (0,10.5), (0,10)),
 '07': (lambda x: 1/mp.sqrt(1-x), (-1.6,0.9), (-1.6,0.9)),
 '08': (lambda x: 1/(1+10*x**2), (-1.5,1.5), (-1,1)),
 '09': (mp.log, (-0.5,4.1), (0.02,2)),
 '10': (mp.log, (-0.5,4.1), (0.02,4)),
 '11': (lambda x: mp.log(1+x), (-1.5,1.5), (-0.98,1)),
 '12': (mp.sin, (-3*pi,3*pi), None),
 '13': (mp.cos, (-3*pi,3*pi), None),
 '14': (mp.tan, (-pi,pi), None),
 '15': (mp.exp, (-2,3), None),
 '16': (lambda x: mp.cos(x)*mp.exp(-x), (-2,4), None),
 '17': (mp.cosh, (-4,4), None),
 '18': (mp.atan, (-2.2,2.2), None),
 '19': (mp.asin, (-1.5,1.5), None),
 '20': (lambda x: mp.besselj(0,x), (-10.2,10.2), None),
 '21': (lambda x: mp.besselj(1,x), (-10.2,10.2), None),
 '22': (lambda x: mp.exp(-x**2/2)/mp.sqrt(2*pi), (-3,3), None),
 '23': (lambda x: (1+mp.erf(x/mp.sqrt(2)))/2, (-3,3), None),
 '24': (mp.gamma, (-0.2,5.2), (0.05,2)),
 '25': (mp.gamma, (-0.2,5.2), (0.05,4)),
 '26': (mp.gamma, (-0.2,5.2), (0.5,5)),
 '27': (lambda x: mp.bessely(0,x), (0,22), (0.5,20)),
 '28': (lambda x: mp.bessely(0,x), (0,22), (0.5,10)),
 '29': (lambda x: mp.bessely(0,x), (0,22), (0.5,4)),
}
# asin auto span: finite support of 2200-pt grid on [-1.5,1.5] within [-1,1]
def span_of(cid):
    f, xl, sp = F[cid]
    if sp is not None: return mp.mpf(sp[0]), mp.mpf(sp[1])
    if cid == '19':
        xs = [mp.mpf(-1.5) + 3*mp.mpf(i)/2199 for i in range(2200)]
        inside = [x for x in xs if abs(x) <= 1]
        return inside[0], inside[-1]
    return mp.mpf(xl[0]), mp.mpf(xl[1])
def lag(x, xs, ys):
    s = 0
    for i in range(len(xs)):
        L = 1
        for j in range(len(xs)):
            if j != i: L *= (x-xs[j])/(xs[i]-xs[j])
        s += ys[i]*L
    return s
script_nodes = {}; script_T = {}
for line in open('nodes.txt'):
    p = line.split()
    if p[0] == 'T': script_T[(p[1], int(p[2]))] = [float(v) for v in p[3].split(',')]
    else: script_nodes[(p[0], int(p[1]))] = ([float(v) for v in p[2].split(',')], [float(v) for v in p[3].split(',')])
worst_node = 0; worst_y = 0; worst_T = 0; worst_case = None
for cid,(f,xl,sp) in F.items():
    a,b = span_of(cid); w = b-a
    aa, bb = a+mp.mpf('0.03')*w, b-mp.mpf('0.03')*w
    for n in [2,3,4,5,6,8,10,12,14,16]:
        xs = [aa + (bb-aa)*i/(n-1) for i in range(n)]
        ys = [f(x) for x in xs]
        sx, sy = script_nodes[(cid,n)]
        dn = max(abs(float(x)-s) for x,s in zip(xs,sx))
        dy = max(abs(float(y)-s)/max(1,abs(float(y))) for y,s in zip(ys,sy))
        tp = [mp.mpf(xl[0]) + (mp.mpf(xl[1])-mp.mpf(xl[0]))*k/8 for k in range(9)]
        pv = [lag(t, xs, ys) for t in tp]
        dT = max(abs(float(p)-s)/max(1,abs(float(p))) for p,s in zip(pv, script_T[(cid,n)]))
        worst_node = max(worst_node, dn); worst_y = max(worst_y, dy)
        if dT > worst_T: worst_T, worst_case = dT, (cid,n)
        # nodal reproduction of my own Lagrange form
        nr = max(abs(lag(x,xs,ys)-y) for x,y in zip(xs,ys))
        assert nr < mp.mpf('1e-40'), (cid,n,nr)
    print(cid, 'span used', float(a), float(b), 'nodes on', float(aa), float(bb))
print('max |node x diff| =', worst_node)
print('max rel |node y diff| =', worst_y)
print('max rel |P(t) script - Lagrange mp| over 9 test pts, all cases/degrees =', worst_T, 'at', worst_case)
