import sympy as sp
x=sp.symbols('x'); f=x**3-3*x+2; h=(x-1)*(x+2)/(3*(x+1))
fp=sp.diff(f,x); hp=sp.diff(h,x)
# script iterates (from iter_*.jl output)
aa=[1.2,1.1030303030303028,1.0523564171979161]
bb=[1.2,1.0060606060606054,1.0000061033293672]
cc=[1.2,0.99415204678362468,0.99999427796503726]
for name,xs,F,FP in [("aa (plain, f)",aa,f,fp),("bb (accel, f)",bb,f,fp),("cc (modified, h)",cc,h,hp)]:
    for k in range(2):
        xn,xn1=xs[k],xs[k+1]
        drawn=float(F.subs(x,xn))/(xn-xn1)
        tang=float(FP.subs(x,xn))
        print(f"{name} k={k}: drawn-line slope={drawn:.8g}  tangent slope={tang:.8g}  ratio={drawn/tang:.6f}")
