# Independent check of chebyshev_animations_all.jl values (parsed from dump.txt)
# using mpmath at 50 digits: nodes from the first-kind formula, f at nodes,
# Lagrange interpolant (high-precision, product form) at probe points.
import re, mpmath as mp
mp.mp.dps = 50
F = {
 '01': lambda x: 1/(1-x), '02': lambda x: 1/(1+x), '03': lambda x: 1/(1-x)**2,
 '04': mp.sqrt, '05': mp.sqrt, '06': mp.sqrt, '07': lambda x: 1/mp.sqrt(1-x),
 '08': lambda x: 1/(1+10*x**2), '09': mp.log, '10': mp.log, '11': lambda x: mp.log(1+x),
 '12': mp.sin, '13': mp.cos, '14': mp.tan, '15': mp.exp, '16': lambda x: mp.cos(x)*mp.exp(-x),
 '17': mp.cosh, '18': mp.atan, '19': mp.asin, '20': lambda x: mp.besselj(0,x), '21': lambda x: mp.besselj(1,x),
 '22': mp.npdf, '23': mp.ncdf, '24': mp.gamma, '25': mp.gamma, '26': mp.gamma,
 '27': lambda x: mp.bessely(0,x), '28': lambda x: mp.bessely(0,x), '29': lambda x: mp.bessely(0,x),
}
txt = open('dump.txt').read()
cases = re.split(r'^CASE ', txt, flags=re.M)[1:]
worst = {}
for c in cases:
    cid = c[:2]
    span = eval(re.search(r' span=\(([^)]*)\)', c).group(0).split('=')[1])
    a, b = mp.mpf(span[0]), mp.mpf(span[1])
    blocks = re.findall(r'n=(\d+) .*?\n    xs=(\[.*?\])\n    ys=(\[.*?\])\n    probes=(\[.*?\])\n    pvals=(\[.*?\])', c)
    wn = wy = wp = 0; wT = 0
    for n, xs, ys, pr, pv in blocks:
        n = int(n); xs = eval(xs); ys = eval(ys); pr = eval(pr); pv = eval(pv)
        # independent nodes: roots of T_n mapped to [a,b]
        ref = sorted([(a+b)/2 + (b-a)/2*mp.cos((2*k-1)*mp.pi/(2*n)) for k in range(1, n+1)])
        wn = max(wn, max(abs(mp.mpf(x)-r)/(b-a) for x, r in zip(xs, ref)))
        # T_n at mapped nodes should vanish
        wT = max(wT, max(abs(mp.chebyt(n, (2*mp.mpf(x)-a-b)/(b-a))) for x in xs))
        fy = [F[cid](mp.mpf(x)) for x in xs]
        wy = max(wy, max(abs(mp.mpf(y)-f)/max(1, abs(f)) for y, f in zip(ys, fy)))
        # high-precision Lagrange interpolant through the exact f values at exact nodes
        def L(t):
            t = mp.mpf(t); s = 0
            for j in range(n):
                p = fy[j]
                for k in range(n):
                    if k != j: p *= (t-ref[k])/(ref[j]-ref[k])
                s += p
            return s
        wp = max(wp, max(abs(mp.mpf(v)-L(t))/max(1, abs(L(t))) for t, v in zip(pr, pv)))
    worst[cid] = (len(blocks), wn, wT, wy, wp)
    print(f"{cid} n-sets={len(blocks):2d} node_dev/(b-a)={float(wn):.1e} max|T_n(node)|={float(wT):.1e} f_rel={float(wy):.1e} interp_rel={float(wp):.1e}")
