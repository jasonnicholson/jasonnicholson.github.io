# Copies the four sum definitions verbatim from riemannaa/bb/cc/dd.jl and prints values; also heights used in drawing
f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a, b = 0.0, 2.0
n_seq = [1, 2, 3, 4, 5, 6, 7, 8, 10, 12, 14, 16,
         20, 24, 28, 32, 40, 48, 56, 64, 72, 88, 104, 120]
left_sum(n) = ((b - a) / n) * sum(f(a + i * (b - a) / n) for i in 0:n-1)
right_sum(n) = ((b - a) / n) * sum(f(a + i * (b - a) / n) for i in 1:n)
function lower_sum(n)
    dx = (b - a) / n
    return dx * sum(min(f(a + (i - 1) * dx), f(a + i * dx)) for i in 1:n)
end
function upper_sum(n)
    dx = (b - a) / n
    return dx * sum(max(f(a + (i - 1) * dx), f(a + i * dx)) for i in 1:n)
end
# drawn-area sums (recompute from drawing loop heights)
function drawn(n, rule)
    dx=(b-a)/n; s=0.0
    for i in 1:n
        xl=a+(i-1)*dx; xr=xl+dx
        h = rule==:L ? f(xl) : rule==:R ? f(xr) : rule==:lo ? min(f(xl),f(xr)) : max(f(xl),f(xr))
        s+=h*dx
    end; s
end
println("n,left,right,lower,upper,maxdiff_drawn_vs_annot")
for n in n_seq
    L,R,lo,up = left_sum(n),right_sum(n),lower_sum(n),upper_sum(n)
    d = maximum(abs.([L-drawn(n,:L),R-drawn(n,:R),lo-drawn(n,:lo),up-drawn(n,:up)]))
    println(join([n, round(L;digits=6), round(R;digits=6), round(lo;digits=6), round(up;digits=6), d], ","))
end
