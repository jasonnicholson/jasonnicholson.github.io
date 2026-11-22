using Printf
# newtoncotesaa.jl
# Newton-Cotes animation: Composite Trapezoidal Rule
# Produces: newtoncotesaa.gif


a, b = 0.0, 2.0



function trapezoid_sum(n)
    dx = (b - a) / n
    interior = n > 1 ? sum(f(a + i * dx) for i in 1:n-1) : 0.0
    return dx * (0.5 * f(a) + interior + 0.5 * f(b))
end

# newtoncotesbb.jl
# Newton-Cotes animation: Composite Simpson's Rule (1/3)
# Produces: newtoncotesbb.gif


a, b = 0.0, 2.0



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

# newtoncotescc.jl
# Newton-Cotes animation: Composite Simpson's 3/8 Rule
# Produces: newtoncotescc.gif


a, b = 0.0, 2.0



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

# newtoncotesdd.jl
# Newton-Cotes animation: Composite Boole's Rule
# Produces: newtoncotesdd.gif


a, b = 0.0, 2.0



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

const K = Ref(0)
f(x) = x^K[]
exact(k) = (b^(k+1) - a^(k+1))/(k+1)
for (name, rule, n) in [("trap", trapezoid_sum, 1), ("simp13", simpson_sum, 2), ("simp38", simpson38_sum, 3), ("boole", boole_sum, 4)]
    print(rpad(name,8))
    for k in 0:7
        K[] = k
        @printf(" k=%d:%9.2e", k, rule(n) - exact(k))
    end
    println()
end
