# trapezoidal2daa.jl
# 2D Trapezoidal rule animation for f(x,y) = 8exp(-x^2 - y^4) on [0,1]x[0,1]
# Produces: trapezoidal2daa.gif



f(x, y) = 8 * exp(-(x^2) - (y^4))
true_val = 5.04756680717

xlims = (0.0, 1.0)
ylims = (0.0, 1.0)
zlims = (0.0, 8.2)

# Include archived checkpoints at 10x10 and 20x20.
n_seq = [2, 4, 6, 8, 10, 12, 16, 20]

function trapezoid2d(n)
    x = range(xlims[1], xlims[2], length=n + 1)
    y = range(ylims[1], ylims[2], length=n + 1)
    hx = (xlims[2] - xlims[1]) / n
    hy = (ylims[2] - ylims[1]) / n

    wx = ones(Float64, n + 1)
    wy = ones(Float64, n + 1)
    wx[1] = 0.5
    wx[end] = 0.5
    wy[1] = 0.5
    wy[end] = 0.5

    s = 0.0
    for i in eachindex(x)
        for j in eachindex(y)
            s += wx[i] * wy[j] * f(x[i], y[j])
        end
    end

    return x, y, hx * hy * s
end

using Printf
for n in n_seq
    _,_,a = trapezoid2d(n); e=abs(a-true_val)
    @printf("T n=%2d  I_T=%.13f  |err|=%.10e  title: I_T=%s |error|=%s\n", n, a, e, string(round(a;digits=9)), string(round(e;digits=9)))
end
