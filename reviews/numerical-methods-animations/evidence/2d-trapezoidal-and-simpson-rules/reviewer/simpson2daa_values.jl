# simpson2daa.jl
# 2D Simpson rule animation for f(x,y) = 8exp(-x^2 - y^4) on [0,1]x[0,1]
# Produces: simpson2daa.gif



f(x, y) = 8 * exp(-(x^2) - (y^4))
true_val = 5.04756680717

xlims = (0.0, 1.0)
ylims = (0.0, 1.0)
zlims = (0.0, 8.2)

# Even panel counts for Simpson in each direction, including legacy checkpoints.
n_seq = [2, 4, 6, 8, 10, 12, 16, 20]

function simpson2d(n)
    x = range(xlims[1], xlims[2], length=n + 1)
    y = range(ylims[1], ylims[2], length=n + 1)
    hx = (xlims[2] - xlims[1]) / n
    hy = (ylims[2] - ylims[1]) / n

    ax = ones(Float64, n + 1)
    ay = ones(Float64, n + 1)
    for i in 2:n
        # Array index i corresponds to node number (i-1) on [0,n].
        ax[i] = isodd(i - 1) ? 4.0 : 2.0
        ay[i] = isodd(i - 1) ? 4.0 : 2.0
    end

    s = 0.0
    for i in eachindex(x)
        for j in eachindex(y)
            s += ax[i] * ay[j] * f(x[i], y[j])
        end
    end

    return x, y, (hx * hy / 9.0) * s
end
using Printf
for n in n_seq
    _,_,a = simpson2d(n); e=abs(a-true_val)
    @printf("S n=%2d  I_S=%.13f  |err|=%.10e  title: I_S=%s |error|=%s\n", n, a, e, string(round(a;digits=9)), string(round(e;digits=9)))
end
