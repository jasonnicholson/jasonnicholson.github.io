import cmath
def step(p0,p1,p2,f):
    f0,f1,f2=f(p0),f(p1),f(p2)
    h0=p1-p0;h1=p2-p1
    d0=(f1-f0)/h0;d1=(f2-f1)/h1
    d=(d1-d0)/(h1+h0);b=d1+h1*d
    disc=b*b-4*f2*d
    D=cmath.sqrt(complex(disc))
    E=b+D if abs(b+D)>=abs(b-D) else b-D
    z=p2-2*f2/E
    return z.real, z, disc
f=lambda x:x**3-3*x+2
q=[2.2,2.1,2.0]
for i in range(8):
    r,z,disc=step(*q,f); print(i+1,r,'imag dropped',z.imag,'disc',disc); q=[q[1],q[2],r]
