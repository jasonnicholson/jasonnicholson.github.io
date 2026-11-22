from mpmath import mp, mpf
mp.dps=30
f=lambda x:x**3-3*x+2
fp=lambda x:3*x**2-3
print("Case 2 (m=2): drawn-line slope vs tangent slope")
x=mpf('1.2')
for k in range(5):
    x1=x-2*f(x)/fp(x)
    if f(x)==0: break
    s=(f(x)-0)/(x-x1)
    print(k, float(x), "drawn slope",float(s),"f'(xn)",float(fp(x)),"ratio",float(s/fp(x)), "tangent x-int",float(x-f(x)/fp(x)),"drawn x-int",float(x1))
    x=x1
print("Case 1 standard Newton")
x=mpf('1.2')
for k in range(13):
    x1=x-f(x)/fp(x)
    print(k, "x_n",float(x),"e_n",float(x-1),"x_{n+1}",float(x1),"e_{n+1}",float(x1-1),"ratio",float((x1-1)/(x-1)),"step",float(x-x1), "tangent slope", float(fp(x)))
    x=x1
