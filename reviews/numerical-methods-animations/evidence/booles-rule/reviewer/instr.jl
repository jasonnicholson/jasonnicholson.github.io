# boolesaa.jl
# Boole's Rule animation: full-interval density refinement
# Produces: boolesaa.gif

using Plots
gr()

f(x) = exp(-x) * sin(8 * x^(2 / 3)) + 1
a, b = 0.0, 2.0

n_seq = [4, 8, 12, 16, 20, 24, 28, 32, 36, 40,
         44, 48, 52, 56, 60, 64, 72, 80, 88, 96,
         104, 112, 120]

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
        x1 = x0 + dx
        x2 = x0 + 2 * dx
        x3 = x0 + 3 * dx
        x4 = x0 + 4 * dx
        total += (2 * dx / 45) * (7 * f(x0) + 32 * f(x1) + 12 * f(x2) + 32 * f(x3) + 7 * f(x4))
    end
    return total
end
# --- reviewer instrumentation: values and panel checks (no rendering) ---
using Printf
lag(xs, ys, x) = sum(ys[i]*prod((x - xs[j])/(xs[i]-xs[j]) for j in 1:5 if j != i) for i in 1:5)
for n in n_seq
    dx = (b - a) / n
    maxnode = 0.0; maxlag = 0.0; ymin = Inf; ymax = -Inf
    for i in 0:4:n-4
        x0 = a + i*dx
        xs = [x0 + k*dx for k in 0:4]; ys = f.(xs)
        c = poly_coeffs(xs, ys)
        maxnode = max(maxnode, maximum(abs.([eval_poly(c, x) for x in xs] .- ys)))
        xp = range(x0, xs[5], length=100)
        yp = [eval_poly(c, x) for x in xp]
        maxlag = max(maxlag, maximum(abs.(yp .- [lag(xs, ys, x) for x in xp])))
        ymin = min(ymin, minimum(yp)); ymax = max(ymax, maximum(yp))
        # panel integral equals Boole block?
    end
    @printf("n=%4d pts=%4d approx=%.10f shown=%s node_resid=%.1e vs_lagrange=%.1e panel_y=[%.3f, %.3f]\n",
            n, n+1, boole_sum(n), string(round(boole_sum(n); digits=6)), maxnode, maxlag, ymin, ymax)
end
println("f range on plot grid: ", extrema(f.(xplot)))
