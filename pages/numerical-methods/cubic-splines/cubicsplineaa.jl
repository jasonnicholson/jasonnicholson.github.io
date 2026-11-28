# cubicsplineaa.jl
# Cubic Splines animation: natural cubic spline approximating sin(x) with increasing data points
# Shows n = 3, 4, 5, 6, 7, 9 equally-spaced nodes; each frame recomputes the full spline
# Produces: cubicsplineaa.gif

using Plots
using LinearAlgebra
gr()

# Solve for second-derivative vector M (natural BC: M[1]=M[end]=0)
function natural_spline_M(xs::Vector, ys::Vector)
    n = length(xs) - 1       # number of intervals
    h = diff(xs)

    # Tridiagonal system for M[2..n] (indices 2..n in 1-based, i.e. interior nodes)
    if n < 2
        return zeros(n + 1)
    end
    m = n - 1
    A = zeros(m, m)
    b = zeros(m)
    for j in 1:m
        A[j, j] = 2.0 * (h[j] + h[j + 1])
        j > 1   && (A[j, j - 1] = h[j])
        j < m   && (A[j, j + 1] = h[j + 1])
        b[j] = 6.0 * ((ys[j + 2] - ys[j + 1]) / h[j + 1] -
                       (ys[j + 1] - ys[j])     / h[j])
    end
    M = zeros(n + 1)
    M[2:n] = A \ b
    return M
end

# Evaluate spline at a single point x (find interval by binary search)
function spline_eval_point(xq, xs, ys, M)
    n = length(xs) - 1
    i = searchsortedlast(xs, xq)
    i = clamp(i, 1, n)
    hi = xs[i + 1] - xs[i]
    t1 = xs[i + 1] - xq
    t2 = xq - xs[i]
    return (M[i] / (6hi)) * t1^3 + (M[i + 1] / (6hi)) * t2^3 +
           (ys[i] / hi - M[i] * hi / 6) * t1 +
           (ys[i + 1] / hi - M[i + 1] * hi / 6) * t2
end

f(x) = sin(x)

x_plot = collect(range(0.0, 2π, length=600))

n_node_list = [3, 4, 5, 6, 7, 9]

anim = @animate for nn in n_node_list
    xs = collect(range(0.0, 2π, length=nn))
    ys = f.(xs)
    M  = natural_spline_M(xs, ys)
    S  = [spline_eval_point(xq, xs, ys, M) for xq in x_plot]
    err = maximum(abs.(S .- f.(x_plot)))

    plot(size=(700, 500),
         xlims=(0.0, 2π), ylims=(-1.4, 1.4),
         xlabel="x", ylabel="y",
         title="Natural Cubic Spline for sin(x) — $nn nodes  (max err ≈ $(round(err, sigdigits=3)))",
         legend=:topright, grid=true, framestyle=:box,
         background_color=:white)

    plot!(x_plot, f.(x_plot); color=:blue, lw=2,        label="f(x) = sin(x)")
    plot!(x_plot, S;          color=:red,  lw=2, linestyle=:dash,
          label="S(x) — cubic spline")
    scatter!(xs, ys; color=:black, ms=6, label="data nodes")
end

gif(anim, joinpath(@__DIR__, "cubicsplineaa.gif"); fps=2)
println("Saved: cubicsplineaa.gif")
