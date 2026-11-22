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
f(x) = sin(x)
x_plot = collect(range(0.0, 2π, length=600))
xfine = collect(range(0.0, 2π, length=200001))
for nn in [3,4,5,6,7,9,17,33,65,129]
    xs = collect(range(0.0, 2π, length=nn)); ys = f.(xs)
    M = natural_spline_M(xs, ys)
    S = [spline_eval_point(xq, xs, ys, M) for xq in x_plot]
    err = maximum(abs.(S .- f.(x_plot)))
    Sf = [spline_eval_point(xq, xs, ys, M) for xq in xfine]
    errf = maximum(abs.(Sf .- f.(xfine)))
    println("nn=$nn h=$(round(2π/(nn-1),digits=5)) err600=$(err) errfine=$(errf) title=$(round(err, sigdigits=3))")
    if nn <= 9
        println("   M = ", M)
        # interpolation & continuity checks
        nint = nn-1
        interp = maximum(abs(spline_eval_point(xs[i], xs, ys, M) - ys[i]) for i in 1:nn)
        # one-sided derivatives at interior knots via piecewise formula
        d1(i,x) = begin hi=xs[i+1]-xs[i]; -M[i]/(2hi)*(xs[i+1]-x)^2 + M[i+1]/(2hi)*(x-xs[i])^2 - (ys[i]/hi - M[i]*hi/6) + (ys[i+1]/hi - M[i+1]*hi/6) end
        d2(i,x) = begin hi=xs[i+1]-xs[i]; M[i]/hi*(xs[i+1]-x) + M[i+1]/hi*(x-xs[i]) end
        jump1 = nint>1 ? maximum(abs(d1(k-1,xs[k]) - d1(k,xs[k])) for k in 2:nint) : 0.0
        jump2 = nint>1 ? maximum(abs(d2(k-1,xs[k]) - d2(k,xs[k])) for k in 2:nint) : 0.0
        println("   interp_err=$interp  S' jump=$jump1  S'' jump=$jump2  S''(a)=$(d2(1,xs[1])) S''(b)=$(d2(nint,xs[end]))")
    end
end
