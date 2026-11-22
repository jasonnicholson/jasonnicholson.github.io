# per-node error of script values (values_aa.out / values_bb.out) vs Radau reference
import numpy as np, re
ref = np.load('ref.npy')
def load(f): return np.array([float(l.split('y=')[1]) for l in open(f)])
a, b = load('values_aa.out'), load('values_bb.out')
print(" t     ref          err_order3   err_order4   |e4|<|e3|?")
for i,t in enumerate(np.linspace(0,5,21)):
    e3, e4 = a[i]-ref[i], b[i]-ref[i]
    print(f"{t:4.2f} {ref[i]:.6e} {e3: .3e} {e4: .3e} {abs(e4)<abs(e3)}")
