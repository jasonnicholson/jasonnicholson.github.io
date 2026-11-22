using LinearAlgebra

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
for (name,f,a,b) in [("sin [0,2pi]",sin,0.0,2π),("cos [0,2pi]",cos,0.0,2π),("sin [0,pi/2]",sin,0.0,π/2),("exp [0,1]",exp,0.0,1.0)]
    println(name); prev=NaN
    xq=collect(range(a,b,length=100001))
    for N in (3,4,5,6,7,9,17,33,65,129,257)
        xs=collect(range(a,b,length=N)); ys=f.(xs); M=natural_spline_M(xs,ys)
        e=maximum(abs.([spline_eval_point(x,xs,ys,M) for x in xq] .- f.(xq)))
        println("  nodes=$N err=$(round(e,sigdigits=4))  ", isnan(prev) ? "" : "ratio=$(round(prev/e,sigdigits=3))"); prev=e
    end
end
