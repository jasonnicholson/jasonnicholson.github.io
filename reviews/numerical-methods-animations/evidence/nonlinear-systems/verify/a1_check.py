import numpy as np
# 1) Concrete nonlinear counterexample: G(x,y) = (0.6x + 0.8y + 0.1 sin(y), 0.3y + 0.5y^2), fixed point at origin
def G(v):
    x,y=v
    return np.array([0.6*x+0.8*y+0.1*np.sin(y), 0.3*y+0.5*y*y])
# Jacobian at (0,0): [[0.6, 0.9],[0,0.3]] -> row sums 1.5, 0.3 ; eigenvalues 0.6, 0.3
J=np.array([[0.6,0.9],[0,0.3]])
print("row sums",np.abs(J).sum(1),"eig",np.linalg.eigvals(J))
for r in [1e-1,1e-3]:
    v=np.array([r,r])
    for k in range(200): v=G(v)
    print("start",r,"-> after 200 iters",v)
# 2) Random Jacobians: among those violating row-sum, fraction with spectral radius<1
rng=np.random.default_rng(0)
A=rng.uniform(-1,1,(200000,2,2))
viol=(np.abs(A).sum(2).max(1)>=1)
rho=np.abs(np.linalg.eigvals(A)).max(1)
print("violating:",viol.mean(),"of those, rho<1 (converge locally):",(rho[viol]<1).mean())
