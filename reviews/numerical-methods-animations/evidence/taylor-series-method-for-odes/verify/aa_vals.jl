# taylorderivativeaa.jl
# Taylor Series Method (Order 3) for ODE animation: y' = 1 - t*y^(1/3), y(0)=1
# Produces: taylorderivativeaa.gif
# Note: prefix "taylor" used for this topic's scripts




# --- ODE and parameters ---
# y' = f = 1 - t*y^(1/3)
# Taylor Order 3 requires y'', y''' expressed in terms of t and y
# y'  = 1 - t * y^(1/3)
# y'' = -y^(1/3) - t * (1/3) * y^(-2/3) * y'
# y''' = -(1/3)*y^(-2/3)*y' - (1/3)*y^(-2/3)*y' - t*( (1/3)*(-2/3)*y^(-5/3)*(y')^2 + (1/3)*y^(-2/3)*y'' )
# Simplified:
function taylor3_step(t, y, h)
    yp = y^(1/3)  # safe cube root for y>0
    yd1 = 1.0 - t * yp
    yd2 = -yp - t * (1.0/3) * y^(-2/3) * yd1
    yd3_coeff1 = -(2.0/3) * y^(-2/3) * yd1
    yd3_coeff2 = -t * ((-2.0/9) * y^(-5/3) * yd1^2 + (1.0/3) * y^(-2/3) * yd2)
    yd3 = yd3_coeff1 + yd3_coeff2
    return y + h*yd1 + (h^2/2)*yd2 + (h^3/6)*yd3
end

t0, y0 = 0.0, 1.0
T  = 5.0
n  = 20
h  = (T - t0) / n

xlims = (0.0, 5.0)
ylims = (0.0, 1.8)

title_str = "Taylor Method (n=3): y' = 1 - t·y^{1/3},  y(0) = 1"

# --- Compute solution ---
ts = Vector{Float64}(undef, n+1)
ys = Vector{Float64}(undef, n+1)
ts[1] = t0;  ys[1] = y0
for i in 1:n
    ts[i+1] = ts[i] + h
    ys[i+1] = taylor3_step(ts[i], ys[i], h)
end

for i in eachindex(ts); println(ts[i], " ", repr(ys[i])); end
