# Script's trapezoid_sum (lines 18-22) applied to polynomials on [0,2] with known integrals
a, b = 0.0, 2.0
function trapezoid_sum(f, n)
    dx = (b - a) / n
    interior = n > 1 ? sum(f(a + i * dx) for i in 1:n-1) : 0.0
    return dx * (0.5 * f(a) + interior + 0.5 * f(b))
end
for n in (1, 4)
    println("n=$n  linear 3x+1: ", trapezoid_sum(x->3x+1, n), " exact 8")
    println("n=$n  x^2: ", trapezoid_sum(x->x^2, n), " exact ", 8/3, "  err ", trapezoid_sum(x->x^2, n)-8/3, " predicted -(b-a)h^2/6*... = ", (2/n)^2*2*2/12)
end
# smooth integrand: order check with exp(x) on [0,2]
g(x)=exp(x); Ig=exp(2)-1
for n in (8,16,32,64); println("exp n=$n ratio ", (trapezoid_sum(g,n)-Ig)/(trapezoid_sum(g,2n)-Ig)); end
