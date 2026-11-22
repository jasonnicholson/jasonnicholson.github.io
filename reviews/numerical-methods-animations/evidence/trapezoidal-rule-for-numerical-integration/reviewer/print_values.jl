# Copy of trapezoidalaa.jl lines 8-22 (no plotting) printing the script's values
f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a, b = 0.0, 2.0
n_seq = [1, 2, 3, 4, 5, 6, 7, 8, 10, 12, 14, 16, 18, 20, 24, 28, 32, 40, 48, 56, 72, 96, 120]
function trapezoid_sum(n)
    dx = (b - a) / n
    interior = n > 1 ? sum(f(a + i * dx) for i in 1:n-1) : 0.0
    return dx * (0.5 * f(a) + interior + 0.5 * f(b))
end
for n in n_seq
    println(n, " ", n+1, " ", repr(trapezoid_sum(n)), " ", round(trapezoid_sum(n); digits=6))
end
