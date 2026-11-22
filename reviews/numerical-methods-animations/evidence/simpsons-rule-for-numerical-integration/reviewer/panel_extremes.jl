# Extremes of drawn parabolas and of f vs ylims (0, 2.1); also x^4 halving ratio of simpson weights
f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a,b=0.0,2.0
n_seq = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 56, 64, 72, 84, 96, 108]
lo,hi=Inf,-Inf
for n in n_seq
  dx=(b-a)/n
  for i in 0:2:n-2
    x0=a+i*dx; x1=x0+dx; x2=x0+2dx
    A=[x^(j-1) for x in (x0,x1,x2), j in 1:3]; c=A\[f(x0),f(x1),f(x2)]
    for x in range(x0,x2,length=80); y=c[1]+c[2]x+c[3]x^2; global lo=min(lo,y); global hi=max(hi,y); end
  end
end
xs=range(0,2,length=100001); println("parabola range: ",lo," .. ",hi, "   f range: ", minimum(f.(xs))," .. ",maximum(f.(xs)))
