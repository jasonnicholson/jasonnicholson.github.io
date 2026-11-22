# gausslegendreaa.jl
# Gauss-Legendre Quadrature animation: legacy-style bar visualization
# Produces: gausslegendreaa.gif

using LinearAlgebra
using Plots
gr()

f(x) = 1 + exp(-x) * sin(8 * x^(2 / 3))
a, b = 0.0, 2.0

# Legacy-like progression of quadrature order (sample points)
n_seq = [2, 3, 4, 5, 6, 8, 10, 12, 14, 16,
         18, 20, 24, 28, 32, 36, 40, 44, 48, 56, 64]

xlims = (0.0, 2.0)
ylims = (0.0, 2.1)
xplot = range(a, b, length=800)

function gauss_legendre_nodes_weights(n)
    if n == 1
        return [0.0], [2.0]
    end

    beta = [k / sqrt(4 * k^2 - 1) for k in 1:n-1]
    J = SymTridiagonal(zeros(n), beta)
    eig = eigen(J)

    t = eig.values
    w = 2 .* (eig.vectors[1, :] .^ 2)
    return t, w
end

function gauss_legendre_sum(n)
    t, w = gauss_legendre_nodes_weights(n)
    x = (a + b) / 2 .+ (b - a) / 2 .* t
    wt = (b - a) / 2 .* w
    return x, wt, sum(wt .* f.(x))
end

function weighted_rectangles(xnodes, weights)
    n = length(xnodes)
    bounds = zeros(n + 1)
    bounds[1] = a
    bounds[end] = b
    for i in 1:n-1
        bounds[i + 1] = (xnodes[i] + xnodes[i + 1]) / 2
    end

    widths = [bounds[i + 1] - bounds[i] for i in 1:n]
    heights = [weights[i] * f(xnodes[i]) / widths[i] for i in 1:n]
    return bounds, widths, heights
end

x_ref = collect(range(a, b, length=120001))
y_ref = f.(x_ref)
true_int = (b - a) / (length(x_ref) - 1) *
           (sum(y_ref) - 0.5 * (y_ref[1] + y_ref[end]))
using Printf
@printf("true_int(trap 120001) = %.12f  rounded6=%s\n", true_int, string(round(true_int; digits=6)))
for n in n_seq
    x, wt, s = gauss_legendre_sum(n)
    bounds, widths, heights = weighted_rectangles(x, wt)
    areas = heights .* widths
    @printf("n=%2d I_n=%.12f disp=%s  sum(wt)=%.15f  sorted=%s  maxareaerr=%.2e minwidth=%.3e\n", n, s, string(round(s;digits=6)), sum(wt), issorted(x), maximum(abs.(areas .- wt .* f.(x))), minimum(widths))
end
# dump nodes/weights on [-1,1] for python check
open("nw.txt","w") do io
  for n in [2,3,4,5,8,16,32,64]
    t,w = gauss_legendre_nodes_weights(n)
    for i in 1:n
      @printf(io, "%d %.17e %.17e\n", n, t[i], w[i])
    end
  end
end
