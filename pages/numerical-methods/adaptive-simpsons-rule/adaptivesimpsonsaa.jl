# adaptivesimpsonsaa.jl
# Adaptive Simpson's Rule animation: nonuniform node-set refinement
# Produces: adaptivesimpsonsaa.gif

using Plots
using Printf
gr()

f(x) = 1 + exp(-x) * sin(8 * x^(2 / 3))
a, b = 0.0, 2.0

tol = 1e-3

# Simpson's rule on one panel [p, q] with midpoint m
simpson(p, q) = (q - p) / 6 * (f(p) + 4 * f((p + q) / 2) + f(q))

# Acceptance test (Mathews' Adapt[a, b, tol]): a panel [p, q] with tolerance t is
# accepted when |S(p,m) + S(m,q) - S(p,q)| < t; otherwise it is split at m and
# each half gets tolerance t/2.
accepted(p, q, t) = abs(simpson(p, (p + q) / 2) + simpson((p + q) / 2, q) - simpson(p, q)) < t

panel_nodes(panels) = vcat([[p, (p + q) / 2] for (p, q, _) in panels]..., [panels[end][2]])

# Run the refinement one split per frame: each step splits the widest panel that
# fails the test (leftmost first), so the panels are visited level by level. The
# final partition is the one the recursive routine accepts.
# Exception: Mathews' trace (Example 7) splits [1/2, 1] before [0, 1/2]; following
# it at that one step reproduces all 20 of his node sets.
first_panel = (0.5, 1.0)
function adaptive_node_sets(a, b, tol)
    panels = [(a, b, tol)]
    node_sets = [panel_nodes(panels)]
    splits = Union{Nothing, Tuple{Float64, Float64}}[nothing]
    while true
        failing = [k for (k, (p, q, t)) in enumerate(panels) if !accepted(p, q, t)]
        isempty(failing) && break
        k = first(sort(failing; by=k -> (-(panels[k][2] - panels[k][1]),
                                         (panels[k][1], panels[k][2]) == first_panel ? 0 : 1,
                                         panels[k][1])))
        p, q, t = panels[k]
        m = (p + q) / 2
        panels = vcat(panels[1:k-1], [(p, m, t / 2), (m, q, t / 2)], panels[k+1:end])
        push!(node_sets, panel_nodes(panels))
        push!(splits, (p, q))
    end
    return node_sets, splits
end

node_sets, splits = adaptive_node_sets(a, b, tol)

# exact label for a dyadic node, e.g. 0.0009765625 -> "1/1024"
function frac(x)
    r = Rational(x)
    return denominator(r) == 1 ? string(numerator(r)) : "$(numerator(r))/$(denominator(r))"
end

xlims = (0.0, 2.0)
ylims = (0.0, 2.1)
xplot = range(a, b, length=800)

function poly_coeffs(xs, ys)
    A = [xs[i]^(j - 1) for i in 1:length(xs), j in 1:length(xs)]
    return A \ ys
end

eval_poly(c, x) = sum(c[j] * x^(j - 1) for j in eachindex(c))

function simpson_nonuniform(xs)
    total = 0.0
    for i in 1:2:length(xs)-2
        x0 = xs[i]
        x1 = xs[i + 1]
        x2 = xs[i + 2]
        h = (x2 - x0) / 2
        total += (h / 3) * (f(x0) + 4 * f(x1) + f(x2))
    end
    return total
end

anim = @animate for frame in 0:length(node_sets)
    plot(size=(630, 480), xlims=xlims, ylims=ylims,
         xlabel="", ylabel="", title="Adaptive Simpson's Rule",
         legend=false, grid=false, framestyle=:box,
         background_color=:white)

    if frame > 0
        xs = node_sets[frame]
        for i in 1:2:length(xs)-2
            x0 = xs[i]
            x1 = xs[i + 1]
            x2 = xs[i + 2]

            pnodes = [x0, x1, x2]
            ynodes = [f(x0), f(x1), f(x2)]
            c = poly_coeffs(pnodes, ynodes)

            xp = range(x0, x2, length=60)
            yp = [eval_poly(c, x) for x in xp]

            plot!(xp, yp; fillrange=0.0, fillalpha=0.65,
                  fillcolor=:lightpink, linecolor=:red, lw=0.8)
        end

        # panel boundaries
        for x in xs[1:2:end]
            plot!([x, x], [0.0, f(x)]; color=:red, lw=0.8)
        end
    end

    plot!(xplot, f.(xplot); color=:magenta, lw=2)

    if frame > 0
        # sample points, drawn over the curve
        xs = node_sets[frame]
        scatter!(xs, f.(xs); color=:red, markersize=3, markerstrokewidth=0)

        approx = simpson_nonuniform(xs)
        annotate!(1.15, 1.97, text("Sample Points = $(length(xs))", :black, 10))
        annotate!(1.15, 1.84, text("Approximation = $(@sprintf("%.6f", approx))", :black, 10))
        annotate!(1.15, 1.71, text("tol = $(tol)", :black, 10))
        if splits[frame] !== nothing
            p, q = splits[frame]
            # the two new sample points are the midpoints of the halves
            scatter!([(3p + q) / 4, (p + 3q) / 4], f.([(3p + q) / 4, (p + 3q) / 4]);
                     color=:blue, markersize=5, markerstrokewidth=0)
            annotate!(1.15, 1.58, text("Split [$(frac(p)), $(frac(q))]", :blue, 10))
        end
    end
end

gif(anim, joinpath(@__DIR__, "adaptivesimpsonsaa.gif"); fps=2)
println("Saved: adaptivesimpsonsaa.gif")
