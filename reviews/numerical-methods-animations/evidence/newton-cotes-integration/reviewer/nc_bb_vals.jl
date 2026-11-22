# newtoncotesbb.jl
# Newton-Cotes animation: Composite Simpson's Rule (1/3)
# Produces: newtoncotesbb.gif

using Plots
gr()

f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a, b = 0.0, 2.0

n_seq = [2, 4, 6, 8, 10, 12, 14, 16, 18, 20,
         22, 24, 26, 28, 30, 32, 34, 36, 38, 40]

xlims = (0.0, 2.0)
ylims = (0.0, 2.1)
xplot = range(a, b, length=800)

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

using Printf
const M = 2
for n in n_seq; println(n, " ", n+1, " ", round(simpson_sum(n); digits=6), " ", simpson_sum(n)); end
# interpolant checks: node residual, max deviation from barycentric Lagrange interpolant, integral of drawn polynomial vs rule
lag(xs, ys, t) = sum(ys[k]*prod((t-xs[j])/(xs[k]-xs[j]) for j in eachindex(xs) if j!=k) for k in eachindex(xs))
worst_node = 0.0; worst_dev = 0.0; worst_int = 0.0
for n in n_seq
    dx = (b-a)/n
    tot = 0.0
    for i in 0:M:n-M
        xs = [a + (i+j)*dx for j in 0:M]   # same node construction as script: x0 + j*dx
        xs = [xs[1] + j*dx for j in 0:M]
        ys = f.(xs)
        c = poly_coeffs(xs, ys)
        global worst_node = max(worst_node, maximum(abs(eval_poly(c, xs[k]) - ys[k]) for k in eachindex(xs)))
        xp = range(xs[1], xs[end], length=101)
        global worst_dev = max(worst_dev, maximum(abs(eval_poly(c,t) - lag(xs,ys,t)) for t in xp))
        # exact integral of drawn monomial poly over the panel
        tot += sum(c[j]*(xs[end]^j - xs[1]^j)/j for j in eachindex(c))
    end
    global worst_int = max(worst_int, abs(tot - simpson_sum(n)))
end
@printf("max node residual %.3e ; max |vandermonde poly - Lagrange| %.3e ; max |∫drawn poly - rule| %.3e\n", worst_node, worst_dev, worst_int)
