import numpy as np,sys
sys.path.insert(0,'.')
from indep import euler,heun
for name,fn in [("inst_aa.jl",euler),("inst_bb.jl",heun)]:
    d=np.loadtxt(f"iterates_{name}.txt"); t,y=fn(0.125)
    print(name,"max|t diff|",abs(d[:,0]-t).max(),"max|y diff|",abs(d[:,1]-y).max())
