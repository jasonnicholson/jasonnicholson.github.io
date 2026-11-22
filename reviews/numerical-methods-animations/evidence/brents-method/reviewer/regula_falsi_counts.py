import math
f = lambda x: math.tan(x) - 2*x
r = 1.1655611852072113
a, b = 0.5, 1.5; fa, fb = f(a), f(b)
xs = []
for k in range(1, 2000):
    x = b - fb*(b-a)/(fb-fa); fx = f(x); xs.append((x, fx, a, b))
    if fa*fx < 0: b, fb = x, fx
    else: a, fa = x, fx
print("first 5 chord points:", [round(t[0],4) for t in xs[:5]], " right endpoint after 1000 iters:", xs[999][3])
print("error ratio e_k/e_{k-1} at k=50,100:", (r-xs[50][0])/(r-xs[49][0]), (r-xs[100][0])/(r-xs[99][0]))
for tol in (1e-4,1e-5,1e-6,1e-8,1e-10,1e-12,1e-14):
    k_err = next(i+1 for i,t in enumerate(xs) if abs(t[0]-r) < tol)
    k_f = next(i+1 for i,t in enumerate(xs) if abs(t[1]) < tol)
    k_dx = next(i+1 for i in range(1,len(xs)) if abs(xs[i][0]-xs[i-1][0]) < tol)
    print(f"tol={tol:g}: |x-r|<tol at k={k_err}, |f|<tol at k={k_f}, |dx|<tol at k={k_dx}")
