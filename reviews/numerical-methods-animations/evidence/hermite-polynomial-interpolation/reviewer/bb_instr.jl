# hermitepolybb.jl
# Hermite Polynomial animation: the four cubic Hermite basis functions H₀₀, H₁₀, H₀₁, H₁₁
# Builds up their weighted combination to form the Hermite interpolant of eˣ on [0, 1]
# Produces: hermitepolybb.gif

using Plots
gr()

H00(t) =  2t^3 - 3t^2 + 1
H10(t) =   t^3 - 2t^2 + t
H01(t) = -2t^3 + 3t^2
H11(t) =   t^3 - t^2

f(x)  = exp(x)
df(x) = exp(x)

a, b  = 0.0, 1.0
y0, y1   = f(a),  f(b)
dy0, dy1 = df(a), df(b)
h = b - a

t_vals = range(0.0, 1.0, length=400)
x_vals = @. a + h * t_vals

term1 = @. y0    * H00(t_vals)
term2 = @. h * dy0 * H10(t_vals)
term3 = @. y1    * H01(t_vals)
term4 = @. h * dy1 * H11(t_vals)
using Printf
for (nm, s) in [("term1",term1),("t1+t2",term1.+term2),("t1+t2+t3",term1.+term2.+term3),("H",term1.+term2.+term3.+term4)]
    @printf("%-9s min=%.5f (at x=%.4f) max=%.5f  frac of pts below 0.8: %.3f  first x below 0.8: %s\n", nm, minimum(s), x_vals[argmin(s)], maximum(s), count(<(0.8), s)/length(s), string(findfirst(<(0.8), s) === nothing ? "none" : round(x_vals[findfirst(<(0.8), s)],digits=3)))
end
Hs = term1.+term2.+term3.+term4
@printf("H(0)=%.15f e^0=1; H(1)=%.15f e=%.15f\n", Hs[1], Hs[end], exp(1))
@printf("max|H-e^x| on grid = %.6e at x=%.4f\n", maximum(abs.(Hs .- exp.(x_vals))), x_vals[argmax(abs.(Hs .- exp.(x_vals)))])
