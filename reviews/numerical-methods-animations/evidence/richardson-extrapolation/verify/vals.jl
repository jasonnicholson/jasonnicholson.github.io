f(x) = exp(-x) * sin(x)
fp(x) = exp(-x) * (cos(x) - sin(x))
d3(x, h) = (f(x + h) - f(x - h)) / (2h)
d5(x, h) = (4d3(x, h / 2) - d3(x, h)) / 3
hs = [0.5, 0.32, 0.2, 0.12, 0.08, 0.05, 0.03, 0.02, 0.01]
for (i,h) in enumerate(hs)
  xint = range(0.0 + h, pi - h, length=700)
  e3 = maximum(abs.(d3.(xint,h) .- fp.(xint))); e5 = maximum(abs.(d5.(xint,h) .- fp.(xint)))
  println("frame $i h=$h  err3=$e3 -> \"$(round(e3;digits=6))\"   err5=$e5 -> \"$(round(e5;digits=6))\"")
end
