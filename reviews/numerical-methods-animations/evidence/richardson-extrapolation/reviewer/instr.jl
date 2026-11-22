using Printf
f(x) = exp(-x) * sin(x)
fp(x) = exp(-x) * (cos(x) - sin(x))
d3(x, h) = (f(x + h) - f(x - h)) / (2h)
d5(x, h) = (4d3(x, h / 2) - d3(x, h)) / 3
println("== richexaa values (script grid)")
for h in [0.5, 0.32, 0.2, 0.12, 0.08, 0.05, 0.03, 0.02, 0.01]
    xint = range(0.0 + h, pi - h, length=700)
    err3 = maximum(abs.(d3.(xint, h) .- fp.(xint)))
    err5 = maximum(abs.(d5.(xint, h) .- fp.(xint)))
    @printf("h=%-5g err3=%.6e err5=%.6e  label: %s / %s\n", h, err3, err5, string(round(err3; digits=6)), string(round(err5; digits=6)))
end
println("== richexab values")
hs = [0.5, 0.32, 0.2, 0.12, 0.08, 0.05, 0.03, 0.02, 0.01, 0.006, 0.003, 0.0015]
e3 = [abs(d3(1.0, h) - fp(1.0)) for h in hs]
e5 = [abs(d5(1.0, h) - fp(1.0)) for h in hs]
for k in eachindex(hs)
    s3 = k>1 ? log(e3[k-1]/e3[k])/log(hs[k-1]/hs[k]) : NaN
    s5 = k>1 ? log(e5[k-1]/e5[k])/log(hs[k-1]/hs[k]) : NaN
    @printf("h=%-7g e3=%.6e (slope %.3f)  e5=%.6e (slope %.3f)\n", hs[k], e3[k], s3, e5[k], s5)
end
@printf("c2=%.6g c4=%.6g\n", e3[1]/hs[1]^2, e5[1]/hs[1]^4)
@printf("asymptotic C2=|f'''(1)/6|=%.6g  C4=|f^(5)(1)/120|=%.6g\n", abs(sqrt(2)*exp(-1)*10*sin(1+pi/4)/30), abs(sqrt(2)*exp(-1)*cos(1+pi/4)/120))
