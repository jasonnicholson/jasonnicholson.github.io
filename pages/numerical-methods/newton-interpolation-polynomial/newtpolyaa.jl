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

anim = @animate for n in 0:n_max
    xs_n = all_xs[1:n + 1]
    ys_n = all_ys[1:n + 1]
    coeffs = divided_diff(xs_n, ys_n)
    P = [newton_eval(xi, xs_n, coeffs) for xi in x_plot]

    plot(size=(700, 500),
         xlims=(0.0, 2π), ylims=(-1.6, 1.6),
         xlabel="x", ylabel="y",
         title="Newton Polynomial for cos(x) — degree $n  ($(n+1) node$(n==0 ? "" : "s"))",
         legend=:topright, grid=true, framestyle=:box,
         background_color=:white)

    plot!(x_plot, f.(x_plot); color=:blue, lw=2, label="f(x) = cos(x)")
    plot!(x_plot, P;          color=:red,  lw=2, linestyle=:dash,
          label="P_$n(x)")
    scatter!(xs_n, ys_n; color=:black, ms=6, label="nodes")
end

gif(anim, joinpath(@__DIR__, "newtpolyaa.gif"); fps=1)
println("Saved: newtpolyaa.gif")
