# splinequadaa.jl
# Cubic Spline Quadrature animation: full-interval density refinement
# Produces: splinequadaa.gif




f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a, b = 0.0, 2.0

m_seq = collect(3:2:41)

xlims = (0.0, 2.0)
ylims = (0.0, 2.1)
xplot = range(a, b, length=800)

function natural_spline_M(xs, ys)
    n = length(xs)
    if n <= 2
        return zeros(n)
    end

    h = [xs[i + 1] - xs[i] for i in 1:n-1]
    dl = [h[i] for i in 2:n-2]
    d = [2 * (h[i] + h[i + 1]) for i in 1:n-2]
    du = [h[i + 1] for i in 1:n-3]

    rhs = [6 * ((ys[i + 2] - ys[i + 1]) / h[i + 1] - (ys[i + 1] - ys[i]) / h[i]) for i in 1:n-2]

    for i in 2:n-2
        m = dl[i - 1] / d[i - 1]
        d[i] -= m * du[i - 1]
        rhs[i] -= m * rhs[i - 1]
    end

    M_inner = zeros(n - 2)
    M_inner[end] = rhs[end] / d[end]
    for i in n-3:-1:1
        M_inner[i] = (rhs[i] - du[i] * M_inner[i + 1]) / d[i]
    end

    return vcat(0.0, M_inner, 0.0)
end

function spline_eval(xq, xs, ys, M)
    idx = searchsortedlast(xs, xq)
    idx = clamp(idx, 1, length(xs) - 1)

    x0 = xs[idx]
    x1 = xs[idx + 1]
    h = x1 - x0

    a0 = (x1 - xq) / h
    b0 = (xq - x0) / h

    return a0 * ys[idx] + b0 * ys[idx + 1] +
           ((a0^3 - a0) * M[idx] + (b0^3 - b0) * M[idx + 1]) * (h^2 / 6)
end

function spline_integral(xs, ys, M)
    total = 0.0
    for i in 1:length(xs)-1
        h = xs[i + 1] - xs[i]
        total += h * (ys[i] + ys[i + 1]) / 2 - h^3 * (M[i] + M[i + 1]) / 24
    end
    return total
end
using Printf
# derivatives of the piecewise cubic in the script's representation, segment i, local t
function seg_derivs(xs, ys, M, i, xq)
    x0=xs[i]; x1=xs[i+1]; h=x1-x0
    A=(x1-xq)/h; B=(xq-x0)/h
    S = A*ys[i]+B*ys[i+1]+((A^3-A)*M[i]+(B^3-B)*M[i+1])*h^2/6
    S1 = (ys[i+1]-ys[i])/h + (-(3A^2-1)*M[i] + (3B^2-1)*M[i+1])*h/6
    S2 = A*M[i] + B*M[i+1]
    return S,S1,S2
end
open("script_values.txt","w") do io
for m in m_seq
    xs = collect(range(a, b, length=m)); ys = f.(xs); M = natural_spline_M(xs, ys)
    approx = spline_integral(xs, ys, M)
    # interpolation via spline_eval
    interr = maximum(abs(spline_eval(xs[k], xs, ys, M) - ys[k]) for k in 1:m)
    # continuity at interior knots
    c0=0.0; c1=0.0; c2=0.0
    for k in 2:m-1
        L = seg_derivs(xs,ys,M,k-1,xs[k]); R = seg_derivs(xs,ys,M,k,xs[k])
        c0=max(c0,abs(L[1]-R[1])); c1=max(c1,abs(L[2]-R[2])); c2=max(c2,abs(L[3]-R[3]))
    end
    e0 = seg_derivs(xs,ys,M,1,xs[1])[3]; en = seg_derivs(xs,ys,M,m-1,xs[m])[3]
    # integral of spline_eval by fine Simpson as a cross-check of spline_integral formula
    N=200000; xx=range(a,b,length=N+1); hh=(b-a)/N
    s = sum((k==0||k==N ? 1 : (isodd(k) ? 4 : 2))*spline_eval(xx[k+1],xs,ys,M) for k in 0:N)*hh/3
    @printf("m=%2d approx=%.15f round6=%s interr=%.1e C0=%.1e C1=%.1e C2=%.1e S''(a)=%.1e S''(b)=%.1e simpson_of_eval=%.15f\n",
        m, approx, string(round(approx;digits=6)), interr, c0,c1,c2,e0,en,s)
    @printf(io, "%d %.17g\n", m, approx)
end
end
