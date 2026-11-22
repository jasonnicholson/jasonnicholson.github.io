# newtpolyaa.jl
# Newton Interpolation Polynomial animation: f(x) = cos(x) on [0, 2π]
# Adds one equally-spaced node per frame, showing degree-n Newton polynomial
# Produces: newtpolyaa.gif

using Plots
gr()

# --- Divided difference table ---
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

# --- Evaluate Newton polynomial (Horner form) ---
function newton_eval(x, xs::Vector, coeffs::Vector)
    n = length(coeffs)
    val = coeffs[n]
    for i in (n - 1):-1:1
        val = val * (x - xs[i]) + coeffs[i]
    end
    return val
end

f(x) = cos(x)

n_max  = 6
all_xs = collect(range(0.0, 2π, length=n_max + 1))
all_ys = f.(all_xs)

x_plot = collect(range(0.0, 2π, length=600))

c = divided_diff(all_xs, all_ys)
println("coeffs=", c)
P = [newton_eval(x, all_xs, c) for x in x_plot]
println("max|P(node)-y|=", maximum(abs.([newton_eval(x, all_xs, c) for x in all_xs] .- all_ys)))
i = argmax(abs.(P .- f.(x_plot))); println("max|P-f| on plot grid=", abs(P[i]-f(x_plot[i])), " at x=", x_plot[i], " P=", P[i])
