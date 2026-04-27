# hermitepolyaa.jl
# Hermite Polynomial animation: piecewise cubic Hermite interpolation of sin(x) on [0, 2π]
# Doubles the number of intervals each frame (n = 1, 2, 4, 8), showing convergence
# Produces: hermitepolyaa.gif

using Plots
gr()

# Cubic Hermite basis functions on local parameter t ∈ [0, 1]
H00(t) =  2t^3 - 3t^2 + 1
H10(t) =   t^3 - 2t^2 + t
H01(t) = -2t^3 + 3t^2
H11(t) =   t^3 - t^2

# Evaluate piecewise cubic Hermite at points xs_query
# xs_nodes: breakpoints (length n_intervals+1)
# ys, dys: function values and derivatives at nodes
function hermite_eval(xs_query, xs_nodes, ys, dys)
    n = length(xs_nodes) - 1      # number of intervals
    result = similar(xs_query)
    for (k, xq) in enumerate(xs_query)
        # Find which interval xq belongs to
        i = searchsortedlast(xs_nodes, xq)
        i = clamp(i, 1, n)
        a, b = xs_nodes[i], xs_nodes[i + 1]
        h = b - a
        t = (xq - a) / h
        result[k] = ys[i]    * H00(t) +
                    h * dys[i]   * H10(t) +
                    ys[i + 1] * H01(t) +
                    h * dys[i + 1] * H11(t)
    end
    return result
end

f(x)  = sin(x)
df(x) = cos(x)

x_plot = collect(range(0.0, 2π, length=600))
n_intervals_list = [1, 2, 4, 8]

anim = @animate for n in n_intervals_list
    xs_nodes = collect(range(0.0, 2π, length=n + 1))
    ys  = f.(xs_nodes)
    dys = df.(xs_nodes)

    H = hermite_eval(x_plot, xs_nodes, ys, dys)
    err = maximum(abs.(H .- f.(x_plot)))

    plot(size=(700, 500),
         xlims=(0.0, 2π), ylims=(-1.4, 1.4),
         xlabel="x", ylabel="y",
         title="Piecewise Cubic Hermite for sin(x) — $n interval$(n==1 ? "" : "s")  (max err ≈ $(round(err, sigdigits=3)))",
         legend=:topright, grid=true, framestyle=:box,
         background_color=:white)

    plot!(x_plot, f.(x_plot); color=:blue, lw=2, label="f(x) = sin(x)")
    plot!(x_plot, H;          color=:red,  lw=2, linestyle=:dash,
          label="Hermite H(x)  (n = $n)")
    scatter!(xs_nodes, ys; color=:black, ms=6, label="nodes")
    # Show slope markers as short arrows at each node
    for i in eachindex(xs_nodes)
        dx_arrow = 0.15
        x0, y0 = xs_nodes[i], ys[i]
        slope = dys[i]
        annotate!(x0, y0,
                  text("→", :center, :gray, 8))   # lightweight indicator
    end
end

gif(anim, joinpath(@__DIR__, "hermitepolyaa.gif"); fps=1)
println("Saved: hermitepolyaa.gif")
