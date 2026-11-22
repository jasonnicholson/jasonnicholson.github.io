# Same Method A iteration, f evaluated in factored form (proposed fix) and in BigFloat
for (name, f, fp, m) in (("bb factored", x->(x-1)^2*(x+2), x->3x^2-3, 2),
                         ("dd factored", x->(x-1)^3*(x+2), x->(x-1)^2*(4x+5), 3))
    x = 1.3; print(name, ": ")
    for i in 1:5; x = x - m*f(x)/fp(x); print(round(x;digits=6), "  "); end; println()
end
fe(x) = x^4 - x^3 - 3x^2 + 5x - 2
x3 = 1.000000641886474
println("dd: Float64 expanded f(x3) = ", fe(x3), ";  exact f(x3) = ", Float64((big(x3)-1)^3*(big(x3)+2)))
