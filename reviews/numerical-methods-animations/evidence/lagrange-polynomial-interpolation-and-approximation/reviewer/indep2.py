exec(open('indep.py').read().split('worst_node = 0')[0])
# per-case worst discrepancy, split into test points whose true P is inside the plotted ylims vs outside
ylims = {}
for line in open('instr_out.txt'):
    if line.startswith('CASE'):
        cid = line.split()[1]; s = line.split('ylims=(')[1].rstrip(')\n').split(',')
        ylims[cid] = (float(s[0]), float(s[1]))
for cid,(f,xl,sp) in F.items():
    a,b = span_of(cid); w=b-a; aa,bb = a+mp.mpf('0.03')*w, b-mp.mpf('0.03')*w
    wi = 0; wo = 0; big=0
    for n in [2,3,4,5,6,8,10,12,14,16]:
        xs = [aa + (bb-aa)*i/(n-1) for i in range(n)]; ys=[f(x) for x in xs]
        tp = [mp.mpf(xl[0]) + (mp.mpf(xl[1])-mp.mpf(xl[0]))*k/8 for k in range(9)]
        for t,s in zip(tp, script_T[(cid,n)]):
            p = float(lag(t,xs,ys)); d = abs(p-s)
            if ylims[cid][0] <= p <= ylims[cid][1]: wi = max(wi, d)
            else: wo = max(wo, d/abs(p)); big=max(big,abs(p))
    print(cid, 'max abs diff (visible pts) %.2e   max rel diff (off-chart pts) %.2e  largest off-chart |P| %.3g' % (wi, wo, big))
