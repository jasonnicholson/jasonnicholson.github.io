# Case 03, degree 15: where is the max interpolation error, and is it inside the visible y-window?
import re, numpy as np
from scipy.interpolate import BarycentricInterpolator
txt = open('dump.txt').read()
c = [s for s in re.split(r'^CASE ', txt, flags=re.M)[1:] if s.startswith('03')][0]
xs, ys = re.findall(r'n=16 .*?\n    xs=(\[.*?\])\n    ys=(\[.*?\])', c)[0]
p = BarycentricInterpolator(eval(xs), eval(ys))
t = np.linspace(-1.6, 0.9, 20001); e = np.abs(p(t) - 1/(1-t)**2)
i = e.argmax(); print(f"max err {e[i]:.3f} at x={t[i]:.4f}, f there={1/(1-t[i])**2:.1f}; ylims top 37.5 reached at x={1-1/np.sqrt(37.495):.4f}")
vis = t < 1-1/np.sqrt(37.495); print(f"max err within visible part: {e[vis].max():.3f}")
