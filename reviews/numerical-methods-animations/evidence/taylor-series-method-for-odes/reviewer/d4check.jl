# Compare script's finite-difference d4 with exact y'''' (sympy formula pasted from indep.py output)
s = read(joinpath(ARGS[1], "taylorderivativebb.jl"), String)
include_string(Main, replace(split(s, "t0, y0")[1], "using Plots"=>"", "gr()"=>""))
y4(t,y) = (3t^4*y - 15t^3*cbrt(y)^2 + 18t^2*cbrt(y)^5 + 22t^2*cbrt(y) - 39t*cbrt(y)^4 - 10t + 27cbrt(y)^7 + 18y)/(27cbrt(y)^8)
h = 0.25
for (t,y) in ((0.0,1.0),(1.0,1.44),(2.0,0.86),(3.0,0.09),(4.0,0.0162))
    eps_h = h*1e-5; d1 = yd1_f(t,y); d3 = yd3_f(t,y)
    fd = (yd3_f(t+eps_h, y+eps_h*d1) - d3)/eps_h
    println("t=$t y=$y  FD d4=$fd  exact=$(y4(t,y))  relerr=$(abs(fd-y4(t,y))/abs(y4(t,y)))")
end
