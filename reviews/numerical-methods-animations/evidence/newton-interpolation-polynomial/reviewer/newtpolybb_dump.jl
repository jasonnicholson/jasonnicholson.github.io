# newtpolybb.jl
# Newton Interpolation Polynomial animation: Runge phenomenon
# f(x) = 1/(1+25x²) on [-1, 1] with equally-spaced nodes — shows oscillation at edges
# Produces: newtpolybb.gif

using Plots
gr()

# --- Divided difference table (in-place) ---
function divided_diff(xs::Vector, ys::Vector)
    n = length(xs)
    d = copy(ys)
    coeffs = [d[1]]
    for j in 2:n
        for i in n:-1:j
            d[i] = (d[i] - d[i - 1]) / (xs[i] - xs[i - j + 1])
        end
        push!(coeffs, d[j])
    end
    return coeffs
end

function newton_eval(x, xs::Vector, coeffs::Vector)
    n = length(coeffs)
    val = coeffs[n]
    for i in (n - 1):-1:1
        val = val * (x - xs[i]) + coeffs[i]
    end
    return val
end

f(x) = 1.0 / (1.0 + 25.0 * x^2)          # Runge function

n_max  = 10
all_xs = collect(range(-1.0, 1.0, length=n_max + 1))
all_ys = f.(all_xs)

x_plot = collect(range(-1.0, 1.0, length=600))

c = divided_diff(all_xs, all_ys)
println("coeffs=", c)
P = [newton_eval(x, all_xs, c) for x in x_plot]
println("max|P(node)-y|=", maximum(abs.([newton_eval(x, all_xs, c) for x in all_xs] .- all_ys)))
i = argmax(abs.(P .- f.(x_plot))); println("max|P-f| on plot grid=", abs(P[i]-f(x_plot[i])), " at x=", x_plot[i], " P=", P[i])
