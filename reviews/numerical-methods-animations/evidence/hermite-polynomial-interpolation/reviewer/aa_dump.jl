# hermitepolyaa.jl
# Hermite Polynomial animation: piecewise cubic Hermite interpolation of sin(x) on [0, 2π]
# Doubles the number of intervals each frame (n = 1, 2, 4, 8), showing convergence
# Produces: hermitepolyaa.gif

using Plots
gr()

# Cubic Hermite basis functions on local parameter t ∈ [0, 1]
H00(t) =  2t^3 - 3t^2 + 1
H10(t) =   t^3 - 2t^2 + t
H01(t) = -2t^3 + 3t^2
H11(t) =   t^3 - t^2

# Evaluate piecewise cubic Hermite at points xs_query
# xs_nodes: breakpoints (length n_intervals+1)
# ys, dys: function values and derivatives at nodes
function hermite_eval(xs_query, xs_nodes, ys, dys)
    n = length(xs_nodes) - 1      # number of intervals
    result = similar(xs_query)
    for (k, xq) in enumerate(xs_query)
        # Find which interval xq belongs to
        i = searchsortedlast(xs_nodes, xq)
        i = clamp(i, 1, n)
        a, b = xs_nodes[i], xs_nodes[i + 1]
        h = b - a
        t = (xq - a) / h
        result[k] = ys[i]    * H00(t) +
                    h * dys[i]   * H10(t) +
                    ys[i + 1] * H01(t) +
                    h * dys[i + 1] * H11(t)
    end
    return result
end

f(x)  = sin(x)
df(x) = cos(x)

x_plot = collect(range(0.0, 2π, length=600))
n_intervals_list = [1, 2, 4, 8]

open("aa_values.csv","w") do io
  for n in n_intervals_list
    xs_nodes = collect(range(0.0, 2π, length=n + 1))
    H = hermite_eval(x_plot, xs_nodes, f.(xs_nodes), df.(xs_nodes))
    for k in eachindex(x_plot); println(io, n, ",", repr(x_plot[k]), ",", repr(H[k])); end
  end
end
