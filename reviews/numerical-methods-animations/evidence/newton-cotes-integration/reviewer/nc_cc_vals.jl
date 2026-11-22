# newtoncotescc.jl
# Newton-Cotes animation: Composite Simpson's 3/8 Rule
# Produces: newtoncotescc.gif

using Plots
gr()

f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a, b = 0.0, 2.0

n_seq = [3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36,
         39, 42, 45, 48, 54, 60, 66, 72, 84, 96, 108, 120]

xlims = (0.0, 2.0)
ylims = (0.0, 2.1)
xplot = range(a, b, length=800)

function poly_coeffs(xs, ys)
    A = [xs[i]^(j - 1) for i in 1:length(xs), j in 1:length(xs)]
    return A \ ys
end

eval_poly(c, x) = sum(c[j] * x^(j - 1) for j in eachindex(c))

function simpson38_sum(n)
    dx = (b - a) / n
    sum_3 = sum(f(a + i * dx) for i in 1:n-1 if i % 3 != 0)
    sum_2 = n > 3 ? sum(f(a + i * dx) for i in 3:3:n-3) : 0.0
    return (3 * dx / 8) * (f(a) + f(b) + 3 * sum_3 + 2 * sum_2)
end

using Printf
const M = 3
for n in n_seq; println(n, " ", n+1, " ", round(simpson38_sum(n); digits=6), " ", simpson38_sum(n)); end
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
    global worst_int = max(worst_int, abs(tot - simpson38_sum(n)))
end
@printf("max node residual %.3e ; max |vandermonde poly - Lagrange| %.3e ; max |∫drawn poly - rule| %.3e\n", worst_node, worst_dev, worst_int)
