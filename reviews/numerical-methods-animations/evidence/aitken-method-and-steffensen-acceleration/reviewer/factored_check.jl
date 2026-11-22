# What the Steffensen loop gives in Float64 if f, f' are evaluated in factored form (for the suggested fix)
using Printf
function steff(f, df, x0, n, p)
    xs = [x0]
    for i in 1:n
        a = xs[end]; d = df(a)
        if f(a) == 0 || d == 0; push!(xs, a); continue; end
        q1 = a - f(a)/d; q2 = q1 - f(q1)/df(q1); den = q2 - 2q1 + a
        push!(xs, den == 0 ? a : a - (q1-a)^2/den)
    end
    [@sprintf("%.2e", abs(x-p)) for x in xs]
end
println("case1 factored: ", steff(x->(x-1)^2*(x+2), x->3*(x-1)*(x+1), 2.0, 7, 1.0))
println("case3 factored: ", steff(x->(x^2-1)*(x^2-3)^2, x->2x*(x^2-3)*(3x^2-5), 1.5, 6, sqrt(3.0)))
# rounding noise of the expanded polynomial near the root
f1(x) = x^3 - 3x + 2
println("case1 expanded f at 1+6.556e-9: ", f1(0.99999999344396751), "  true (x-1)^2(x+2) = ", (0.99999999344396751-1)^2*(0.99999999344396751+2))
