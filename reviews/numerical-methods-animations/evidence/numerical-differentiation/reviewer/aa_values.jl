# Instrumented copy of numdiffaa.jl computations (no plotting)
using Printf
f(x) = exp(-x) * sin(x)
fp(x) = exp(-x) * (cos(x) - sin(x))
central3(x, h) = (f(x + h) - f(x - h)) / (2h)
hs = [0.5, 0.3, 0.2, 0.1, 0.07, 0.05, 0.03, 0.02, 0.01, 0.005, 0.002, 0.001]
xlims = (0.0, pi)
for h in hs
    xint = range(xlims[1] + h, xlims[2] - h, length=700)
    err = central3.(xint, h) .- fp.(xint)
    maxerr = maximum(abs.(err)); i = argmax(abs.(err))
    @printf("h=%-6g maxerr=%.10e at x=%.5f  title=%s  maxerr/h^2=%.6f\n", h, maxerr, xint[i], string(round(maxerr; digits=6)), maxerr/h^2)
end
