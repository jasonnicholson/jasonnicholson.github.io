# Print the exact title strings each script draws, to compare with what is visible in the clipped frames
f(x) = exp(-x) * sin(x); fp(x) = exp(-x) * (cos(x) - sin(x))
central3(x, h) = (f(x + h) - f(x - h)) / (2h)
for h in [0.5, 0.3, 0.2, 0.1, 0.07, 0.05, 0.03, 0.02, 0.01, 0.005, 0.002, 0.001]
    xint = range(h, pi - h, length=700); maxerr = maximum(abs.(central3.(xint, h) .- fp.(xint)))
    println("aa: ", "Three-Point Central Difference on [0, pi]  |  h = $(h)  |  max error ≈ $(round(maxerr; digits=6))")
end
for h in [0.6, 0.4, 0.25, 0.15, 0.1, 0.07, 0.05, 0.03, 0.02, 0.01, 0.005, 0.001]
    msec = (f(1+h)-f(1-h))/(2h)
    println("ab: ", "Derivative at x0 = 1  |  h = $(h)  |  secant ≈ $(round(msec; digits=6)), true = $(round(fp(1.0); digits=6))")
end
