# newtoncotesaa.jl
# Newton-Cotes animation: Composite Trapezoidal Rule
# Produces: newtoncotesaa.gif

using Plots
gr()

f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a, b = 0.0, 2.0

n_seq = [1, 2, 3, 4, 5, 6, 7, 8, 10, 12, 14, 16,
         20, 24, 28, 32, 40, 48, 56, 64, 72, 88, 104, 120]

xlims = (0.0, 2.0)
ylims = (0.0, 2.1)
xplot = range(a, b, length=800)

function trapezoid_sum(n)
    dx = (b - a) / n
    interior = n > 1 ? sum(f(a + i * dx) for i in 1:n-1) : 0.0
    return dx * (0.5 * f(a) + interior + 0.5 * f(b))
end

for n in n_seq; println(n, " ", n+1, " ", round(trapezoid_sum(n); digits=6), " ", trapezoid_sum(n)); end
