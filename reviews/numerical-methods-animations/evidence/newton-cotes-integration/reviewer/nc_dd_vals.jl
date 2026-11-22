# newtoncotesdd.jl
# Newton-Cotes animation: Composite Boole's Rule
# Produces: newtoncotesdd.gif

using Plots
gr()

f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a, b = 0.0, 2.0

n_seq = [4, 8, 12, 16, 20, 24, 28, 32, 36, 40, 44, 48,
         52, 56, 60, 64, 72, 80, 88, 96, 104, 112, 116, 120]

xlims = (0.0, 2.0)
ylims = (0.0, 2.1)
xplot = range(a, b, length=800)

function poly_coeffs(xs, ys)
    A = [xs[i]^(j - 1) for i in 1:length(xs), j in 1:length(xs)]
    return A \ ys
end

eval_poly(c, x) = sum(c[j] * x^(j - 1) for j in eachindex(c))

function boole_sum(n)
    dx = (b - a) / n
    total = 0.0
    for i in 0:4:n-4
        x0 = a + i * dx
        total += (2 * dx / 45) * (
            7 * f(x0) +
            32 * f(x0 + dx) +
            12 * f(x0 + 2 * dx) +
            32 * f(x0 + 3 * dx) +
            7 * f(x0 + 4 * dx)
        )
    end
    return total
end

using Printf
const M = 4
for n in n_seq; println(n, " ", n+1, " ", round(boole_sum(n); digits=6), " ", boole_sum(n)); end
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
    global worst_int = max(worst_int, abs(tot - boole_sum(n)))
end
@printf("max node residual %.3e ; max |vandermonde poly - Lagrange| %.3e ; max |∫drawn poly - rule| %.3e\n", worst_node, worst_dev, worst_int)
