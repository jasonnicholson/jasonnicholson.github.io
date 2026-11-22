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
open("bb_values.csv","w") do io
  for k in eachindex(x_vals); println(io, repr(x_vals[k]), ",", repr(term1[k]), ",", repr(term2[k]), ",", repr(term3[k]), ",", repr(term4[k])); end
end
