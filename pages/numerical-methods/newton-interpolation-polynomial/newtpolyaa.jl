# newtpolyaa.jl
# Newton Interpolation Polynomial animation: f(x) = cos(x), nodes x_k = k/5 on [0, 1]
# (Mathews, Newton Polynomials module, Example 1: degrees n = 1, ..., 5 on [x_0, x_n])
# Adds one node per frame, showing the degree-n Newton polynomial built from divided differences.
# Window [-0.5, 2.1] in x follows Mathews' graphs for Example 1.
# Produces: newtpolyaa.gif

using Plots
using Printf
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

n_max  = 5
all_xs = [k / 5 for k in 0:n_max]          # x_k = k/5, k = 0, ..., 5
all_ys = f.(all_xs)

x_plot = collect(range(-0.5, 2.1, length=800))

anim = @animate for n in 1:n_max
    xs_n = all_xs[1:n + 1]
    ys_n = all_ys[1:n + 1]
    coeffs = divided_diff(xs_n, ys_n)
    P = [newton_eval(xi, xs_n, coeffs) for xi in x_plot]

    # largest error between the first and last node, [x_0, x_n] = [0, n/5]
    x_in = range(xs_n[1], xs_n[end], length=4001)
    err  = maximum(abs(newton_eval(xi, xs_n, coeffs) - f(xi)) for xi in x_in)

    plot(size=(700, 500),
         xlims=(-0.5, 2.1), ylims=(-0.6, 1.1),
         xlabel="x", ylabel="y",
         title="Newton polynomial for cos(x), nodes x_k = k/5: degree $n ($(n+1) nodes)\n" *
               @sprintf("new coefficient a_%d = %.6g;  max |P_%d - cos| on [0, %.1f] = %.2e",
                        n, coeffs[end], n, xs_n[end], err),
         titlefontsize=11,
         legend=:bottomleft, grid=true, framestyle=:box,
         background_color=:white)

    vspan!([xs_n[1], xs_n[end]]; color=:gray, alpha=0.15, label="[x_0, x_$n]")
    plot!(x_plot, f.(x_plot); color=:blue, lw=2, label="f(x) = cos(x)")
    plot!(x_plot, P;          color=:red,  lw=2, linestyle=:dash,
          label="P_$n(x)")
    scatter!(xs_n, ys_n; color=:black, ms=6, label="nodes")
end

gif(anim, joinpath(@__DIR__, "newtpolyaa.gif"); fps=1)
println("Saved: newtpolyaa.gif")
