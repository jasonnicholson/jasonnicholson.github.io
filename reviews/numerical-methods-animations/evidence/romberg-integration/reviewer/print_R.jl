# rombergaa.jl
# Romberg Integration animation: trapezoidal refinement plus Romberg table
# Produces: rombergaa.gif

using Printf

f(x) = 1 + exp(-x) * sin(8 * x^(2 / 3))
a, b = 0.0, 2.0

m_seq = [2, 3, 5, 9, 17, 33, 65, 129]
n_levels = length(m_seq)

xlims = (0.0, 2.0)
ylims = (0.0, 2.1)
xplot = range(a, b, length=800)

function trapezoid_sum(n)
    dx = (b - a) / n
    interior = n > 1 ? sum(f(a + i * dx) for i in 1:n-1) : 0.0
    return dx * (0.5 * f(a) + interior + 0.5 * f(b))
end

R = fill(NaN, n_levels, n_levels)
for k in 1:n_levels
    n = m_seq[k] - 1
    R[k, 1] = trapezoid_sum(n)
    for j in 2:k
        R[k, j] = R[k, j - 1] + (R[k, j - 1] - R[k - 1, j - 1]) / (4^(j - 1) - 1)
    end
end
for k in 1:n_levels
    println(k, "  ", m_seq[k], "  ", join([@sprintf("%.12f", R[k,j]) for j in 1:k], "  "))
end
# property check of the script's recurrence: R[k,j] exact for polynomials of degree 2j-1, not 2j
for (deg) in 1:9
    g(x) = x^deg
    exact = (2.0^(deg+1))/(deg+1)
    RR = fill(NaN, 6, 6)
    for k in 1:6
        n = 2^(k-1); dx = 2.0/n
        RR[k,1] = dx*(0.5*g(0.0) + sum(g(i*dx) for i in 1:n-1; init=0.0) + 0.5*g(2.0))
        for j in 2:k
            RR[k,j] = RR[k,j-1] + (RR[k,j-1]-RR[k-1,j-1])/(4^(j-1)-1)
        end
    end
    println("deg ", deg, " errs at R[6,j], j=1..6: ", join([@sprintf("%.1e", RR[6,j]-exact) for j in 1:6], " "))
end
