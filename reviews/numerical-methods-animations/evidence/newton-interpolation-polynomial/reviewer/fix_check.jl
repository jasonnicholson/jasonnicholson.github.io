# Does Float64 Newton form (divided differences + Horner) or first-form barycentric fix the sign flips?
using SpecialFunctions
function dd(xs, ys); n=length(xs); d=copy(ys); c=[d[1]]
  for j in 2:n; for i in n:-1:j; d[i]=(d[i]-d[i-1])/(xs[i]-xs[i-j+1]); end; push!(c,d[j]); end; c; end
hn(x,xs,c)=(v=c[end]; for i in length(c)-1:-1:1; v=v*(x-xs[i])+c[i]; end; v)
function bw(xs); n=length(xs); w=ones(n); for j in 1:n, k in 1:n; j==k && continue; w[j]/=(xs[j]-xs[k]); end; w; end
first_form(x,xs,ys,w)= prod(x .- xs) * sum(w .* ys ./ (x .- xs))
second_form(x,xs,ys,w)= sum(w .* ys ./ (x .- xs)) / sum(w ./ (x .- xs))
for (lab,f,a,b,n,X) in [("sqrt",sqrt,0.0,2.0,16,[5.6862,7.0,10.5]), ("Y0",x->bessely(0,x),0.5,4.0,16,[10.5926,15.0,22.0]), ("Y0",x->bessely(0,x),0.5,4.0,14,[15.4374,21.9119])]
  t=(b-a)*0.03; xs=collect(range(a+t,b-t,length=n)); ys=f.(xs); w=bw(xs); c=dd(xs,ys)
  xb=big.(xs); yb=big.(ys); cb=dd(xb,yb)
  for x in X
    println(lab," n=",n," x=",x,"  second-form=",second_form(x,xs,ys,w),"  first-form=",first_form(x,xs,ys,w),"  Newton64=",hn(x,xs,c),"  exact(BigFloat Newton)=",Float64(hn(big(x),xb,cb)))
  end
end
