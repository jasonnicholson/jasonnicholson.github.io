# Instrumented copy of simpsonsaa.jl computation (no plotting)
f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a, b = 0.0, 2.0
n_seq = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 56, 64, 72, 84, 96, 108]
function poly_coeffs(xs, ys)
    A = [xs[i]^(j - 1) for i in 1:length(xs), j in 1:length(xs)]
    return A \ ys
end
eval_poly(c, x) = sum(c[j] * x^(j - 1) for j in eachindex(c))
function simpson_sum(n)
    dx = (b - a) / n
    odd_sum = sum(f(a + i * dx) for i in 1:2:n-1)
    even_sum = n > 2 ? sum(f(a + i * dx) for i in 2:2:n-2) : 0.0
    return (dx / 3) * (f(a) + f(b) + 4 * odd_sum + 2 * even_sum)
end
# panel interpolation check: max residual at nodes, and panel integral of parabola vs Simpson panel
maxres = 0.0; maxpan = 0.0
for n in n_seq
    dx = (b-a)/n; tot = 0.0
    for i in 0:2:n-2
        x0=a+i*dx; x1=x0+dx; x2=x0+2dx
        c = poly_coeffs([x0,x1,x2],[f(x0),f(x1),f(x2)])
        global maxres = max(maxres, maximum(abs.([eval_poly(c,x)-f(x) for x in (x0,x1,x2)])))
        # exact integral of parabola
        tot += sum(c[j]*(x2^j - x0^j)/j for j in 1:3)
    end
    global maxpan = max(maxpan, abs(tot - simpson_sum(n)))
end
println("max node residual of drawn parabolas = ", maxres)
println("max |integral of drawn parabolas - simpson_sum| = ", maxpan)
for n in n_seq
    s = simpson_sum(n)
    println(n, "  ", n+1, "  ", repr(s), "  ", round(s; digits=6))
end
# Property check of simpson_sum weights on polynomials on [0,2] (swap f via a generic version)
function simpson_g(g, a, b, n)
    dx = (b - a) / n
    odd_sum = sum(g(a + i * dx) for i in 1:2:n-1)
    even_sum = n > 2 ? sum(g(a + i * dx) for i in 2:2:n-2) : 0.0
    return (dx / 3) * (g(a) + g(b) + 4 * odd_sum + 2 * even_sum)
end
for k in 0:5, n in (2,6)
    ex = (2.0^(k+1))/(k+1)
    println("x^$k n=$n: S=", simpson_g(x->x^k,0.0,2.0,n), " exact=", ex, " err=", simpson_g(x->x^k,0.0,2.0,n)-ex)
end
