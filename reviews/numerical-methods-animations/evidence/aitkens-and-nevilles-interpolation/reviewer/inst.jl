
# --- Neville's algorithm: build full table P[i,j] over a grid of query points ---
# P[i,i](x) = f(x_i)
# P[i,j](x) = [(x-x_i)*P[i+1,j] - (x-x_j)*P[i,j-1]] / (x_j - x_i)
function neville_table(xq, xs::Vector, ys::Vector)
    n = length(xs)
    P = zeros(n, n)
    for i in 1:n
        P[i, i] = ys[i]
    end
    for len in 2:n
        for i in 1:n - len + 1
            j = i + len - 1
            P[i, j] = ((xq - xs[i]) * P[i + 1, j] -
                       (xq - xs[j]) * P[i, j - 1]) / (xs[j] - xs[i])
        end
    end
    return P
end

# Nodes and function values
f(x) = cos(x)
xs   = [0.0, π/4, π/2, 3π/4, π]
ys   = f.(xs)

x_plot = collect(range(-0.1, π + 0.1, length=500))

# For each query point build the interpolant of given degree
function interp_degree(xq, xs, ys, deg)
    # Use first deg+1 nodes: xs[1..deg+1]
    xs_d = xs[1:deg + 1]
    ys_d = ys[1:deg + 1]
    P    = neville_table(xq, xs_d, ys_d)
    return P[1, deg + 1]
end
using Printf
for xq in (1.0, 2.5, -0.1, π + 0.1)
    P = neville_table(xq, xs, ys)
    println("xq = ", xq)
    for i in 1:5
        println(join([@sprintf("%22.16f", P[i,j]) for j in 1:5], " "))
    end
end
# dump all plotted values for every degree
open("julia_vals.txt", "w") do io
    for deg in 0:4, xq in x_plot
        @printf(io, "%d %.17g %.17g\n", deg, xq, interp_degree(xq, xs, ys, deg))
    end
end
for deg in 0:4
    e = maximum(abs.([interp_degree(x, xs, ys, deg) for x in x_plot] .- cos.(x_plot)))
    m = minimum([interp_degree(x, xs, ys, deg) for x in x_plot])
    @printf("deg %d: max|P-cos| on plot grid = %.3e, min P = %.4f\n", deg, e, m)
end
