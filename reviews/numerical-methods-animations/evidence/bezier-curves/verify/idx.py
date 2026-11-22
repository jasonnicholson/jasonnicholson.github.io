import numpy as np
def B(P,t):
    P=np.array(P,float);return ((1-t)**3)*P[0]+3*(1-t)**2*t*P[1]+3*(1-t)*t**2*P[2]+t**3*P[3]
cases={'aa':[[0,0],[1,2],[3,2],[4,0]],'bb':[[0,0],[0,2],[4,0],[4,2]]}
n_curve,n_frames=300,40
tc=np.linspace(0,1,n_curve); ta=np.linspace(0,1,n_frames)
for k,P in cases.items():
    print(k)
    for f in [1,5,10,11,20,30,35,38,39,40]:
        ie=min(f*(n_curve//n_frames),n_curve)
        tend=tc[ie-1]; t=ta[f-1]
        print(f"frame {f:2d} t={t:.4f} idx_end={ie} curve drawn to t={tend:.4f} end={B(P,tend).round(3)} point={B(P,t).round(3)} gap={np.linalg.norm(B(P,t)-B(P,tend)):.3f}")
