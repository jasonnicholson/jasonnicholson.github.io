f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a, b = 0.0, 2.0
n_seq = [1, 2, 3, 4, 5, 6, 7, 8, 10, 12, 14, 16, 20, 24, 28, 32, 40, 48, 56, 64, 72, 88, 104, 120]
function midpoint_sum(n)
    dx = (b - a) / n
    return dx * sum(f(a + (i + 0.5) * dx) for i in 0:n-1)
end
for n in n_seq
    dx=(b-a)/n
    hs=[f(a+(i+0.5)*dx) for i in 0:n-1]
    println(n, " ", round(midpoint_sum(n); digits=6), " ", repr(midpoint_sum(n)), " maxh=", maximum(hs))
end
xs=range(a,b,length=800); println("max f on grid ", maximum(f.(xs)), " min ", minimum(f.(xs)))
