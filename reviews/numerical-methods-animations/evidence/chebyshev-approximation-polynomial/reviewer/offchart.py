# Count nodes whose f-value lies outside the plot ylims (scatter is not clamped -> invisible),
# and the range of true f inside the approximation interval vs the ylims.
import re, numpy as np
txt = open('dump.txt').read()
for c in re.split(r'^CASE ', txt, flags=re.M)[1:]:
    cid = c[:2]
    yl = eval(re.search(r'ylims=(\([^)]*\))', c).group(1))
    out = []
    for n, xs, ys in re.findall(r'n=(\d+) .*?\n    xs=(\[.*?\])\n    ys=(\[.*?\])', c):
        xs = eval(xs); ys = eval(ys)
        off = [(round(x,3), round(y,2)) for x, y in zip(xs, ys) if y < yl[0] or y > yl[1]]
        if off: out.append(f"n={n}:{off}")
    print(cid, f"ylims=({yl[0]:.3g},{yl[1]:.3g})", "; ".join(out) if out else "all nodes visible")
