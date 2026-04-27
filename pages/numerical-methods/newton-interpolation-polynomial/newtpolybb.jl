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

anim = @animate for n in 0:n_max
    xs_n = all_xs[1:n + 1]
    ys_n = all_ys[1:n + 1]
    coeffs = divided_diff(xs_n, ys_n)
    P = clamp.([newton_eval(xi, xs_n, coeffs) for xi in x_plot], -2.5, 2.5)

    plot(size=(700, 500),
         xlims=(-1.0, 1.0), ylims=(-1.5, 2.0),
         xlabel="x", ylabel="y",
         title="Runge Phenomenon: Newton Polynomial, degree $n  ($(n+1) node$(n==0 ? "" : "s"))",
         legend=:topright, grid=true, framestyle=:box,
         background_color=:white)

    plot!(x_plot, f.(x_plot); color=:blue, lw=2,
          label="f(x) = 1/(1+25x²)")
    plot!(x_plot, P;          color=:red,  lw=2, linestyle=:dash,
          label="P_$n(x) (Newton)")
    scatter!(xs_n, ys_n; color=:black, ms=5, label="nodes")
end

gif(anim, joinpath(@__DIR__, "newtpolybb.gif"); fps=1)
println("Saved: newtpolybb.gif")
