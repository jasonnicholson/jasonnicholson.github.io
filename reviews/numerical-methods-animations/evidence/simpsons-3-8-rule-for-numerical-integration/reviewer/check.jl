# simpson38aa.jl
# Simpson's 3/8 Rule animation: reconstructed legacy-style density refinement
# Produces: simpson38aa.gif

# using Plots
# gr()

f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a, b = 0.0, 2.0

n_seq = [3, 6, 9, 12, 15, 18, 21, 24, 27, 30, 33, 36,
         42, 48, 54, 60, 66, 72, 81, 90, 99, 108, 120]

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
println("== script values per frame ==")
for n in n_seq
    @printf("%4d  pts=%4d  S=%.12f  shown=%s\n", n, n+1, simpson38_sum(n), string(round(simpson38_sum(n); digits=6)))
end
println("== panel interpolation check (max |p(x_k)-f(x_k)|, max |p - Lagrange| on 90 pts, and panel integral vs 3h/8 formula) ==")
function lagr(xs, ys, x)
    s = 0.0
    for i in 1:4
        L = 1.0
        for j in 1:4
            j == i && continue
            L *= (x - xs[j]) / (xs[i] - xs[j])
        end
        s += ys[i] * L
    end
    s
end
for n in n_seq
    dx = (b - a) / n
    m1 = 0.0; m2 = 0.0; area = 0.0; cover_end = 0.0
    for i in 0:3:n-3
        x0 = a + i*dx; xs = [x0, x0+dx, x0+2dx, x0+3dx]; ys = f.(xs)
        c = poly_coeffs(xs, ys)
        m1 = max(m1, maximum(abs.(eval_poly.(Ref(c), xs) .- ys)))
        xp = range(x0, xs[4], length=90)
        m2 = max(m2, maximum(abs.(eval_poly.(Ref(c), xp) .- lagr.(Ref(xs), Ref(ys), xp))))
        # exact integral of cubic via coefficients
        area += sum(c[j]*(xs[4]^j - x0^j)/j for j in 1:4)
        cover_end = xs[4]
    end
    @printf("%4d  node_resid=%.2e  vsLagrange=%.2e  sum_cubic_areas-S=%.2e  last_panel_end=%.15f\n", n, m1, m2, area - simpson38_sum(n), cover_end)
end
