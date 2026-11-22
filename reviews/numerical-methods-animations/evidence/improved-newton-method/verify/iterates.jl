f(x)  = x^4 - x^3 - 3x^2 + 5x - 2
fp(x) = 4x^3 - 3x^2 - 6x + 5
for T in (Float64, BigFloat)
  setprecision(BigFloat, 256)
  x = T(13)/10; m=3
  println("== ", T)
  for i in 0:5
    println(i, "  x=", Float64(x), "  err=", Float64(x-1), "  f=", Float64(f(x)), "  label=", round(Float64(x); digits=6))
    x = x - m*f(x)/fp(x)
  end
end
# factored form in Float64
g(x)=(x-1)^3*(x+2); gp(x)=3(x-1)^2*(x+2)+(x-1)^3
let x=1.3; println("== factored Float64")
for i in 0:5; println(i," x=",x," err=",x-1); x=x-3g(x)/gp(x); end
end
