# lagrangeaa.jl
# Lagrange polynomial animation: approximating f(x) = 1/(1-x) with increasing degree
# Produces: lagrangeaa.gif

using Plots
gr()

# --- Function and parameters ---
f(x) = 1.0 / (1.0 - x)

# Equally spaced nodes on [-0.8, 0.8] (avoid singularity at x=1)
node_xs = range(-0.8, 0.8, length=10) |> collect
node_ys = f.(node_xs)

xlims = (-1.5, 1.5)
ylims = (-2.0, 10.0)
xplot = range(-0.99, 0.99, length=600)
xplot_all = range(xlims[1], xlims[2], length=600)

# --- Lagrange polynomial of degree n through first n+1 nodes ---
function lagrange_eval(x, xs, ys)
    n = length(xs)
    result = 0.0
    for i in 1:n
        # Basis polynomial l_i
        li = 1.0
        for j in 1:n
            j == i && continue
            li *= (x - xs[j]) / (xs[i] - xs[j])
        end
        result += ys[i] * li
    end
    return result
end

colors = [:blue, :green, :darkorange, :purple, :red, :teal, :brown, :navy, :olive]

# Start from degree 1 (2 nodes), go up to degree 9 (10 nodes)
anim = @animate for frame in 1:9
    n_nodes = frame + 1  # degree frame uses frame+1 nodes
    xs = node_xs[1:n_nodes]
    ys_nodes = node_ys[1:n_nodes]

    plot(size=(640, 480), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y",
         title="Lagrange Polynomial: f(x) = 1/(1−x), degree $(frame)",
         legend=:topleft, grid=true, framestyle=:box,
         background_color=:white)

    # Convergence radius boundary
    vline!([-1.0, 1.0]; color=:lightgray, lw=1, ls=:dash, label="")

    # True function
    yclip = clamp.(f.(xplot), ylims[1], ylims[2])
    plot!(collect(xplot), yclip; color=:magenta, lw=2.5, label="f(x) = 1/(1−x)")

    # Lagrange polynomial
    ylp = clamp.([lagrange_eval(x, xs, ys_nodes) for x in xplot_all], ylims[1], ylims[2])
    plot!(collect(xplot_all), ylp; color=colors[frame], lw=2, label="P_{$(frame)}(x)")

    # Interpolation nodes
    scatter!(xs, ys_nodes; color=:red, ms=5, label="nodes")
end

gif(anim, joinpath(@__DIR__, "lagrangeaa.gif"); fps=2)
println("Saved: lagrangeaa.gif")
