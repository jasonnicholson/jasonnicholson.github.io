# gausslegendreaa.jl
# Gauss-Legendre Quadrature animation: legacy-style bar visualization
# (bar i has width w_i and height f(x_i), so its area is w_i f(x_i))
# Produces: gausslegendreaa.gif

using LinearAlgebra
using Plots
using Printf
gr()

f(x) = 1 + exp(-x) * sin(8 * x^(2 / 3))
a, b = 0.0, 2.0

# Legacy-like progression of quadrature order (sample points)
n_seq = [2, 3, 4, 5, 6, 8, 10, 12, 14, 16,
         18, 20, 24, 28, 32, 36, 40, 44, 48, 56, 64]

xlims = (0.0, 2.0)
ylims = (0.0, 2.1)
xplot = range(a, b, length=800)

function gauss_legendre_nodes_weights(n)
    if n == 1
        return [0.0], [2.0]
    end

    beta = [k / sqrt(4 * k^2 - 1) for k in 1:n-1]
    J = SymTridiagonal(zeros(n), beta)
    eig = eigen(J)

    t = eig.values
    w = 2 .* (eig.vectors[1, :] .^ 2)
    return t, w
end

function gauss_legendre_sum(n)
    t, w = gauss_legendre_nodes_weights(n)
    x = (a + b) / 2 .+ (b - a) / 2 .* t
    wt = (b - a) / 2 .* w
    return x, wt, sum(wt .* f.(x))
end

function weighted_rectangles(xnodes, weights)
    # Cells of width w_i laid end to end from a (cumulative weights); each
    # node x_i lies inside its own cell. Bar height is the sample f(x_i).
    bounds = a .+ [0.0; cumsum(weights)]
    widths = copy(weights)
    heights = f.(xnodes)
    return bounds, widths, heights
end

x_ref = collect(range(a, b, length=120001))
y_ref = f.(x_ref)
true_int = (b - a) / (length(x_ref) - 1) *
           (sum(y_ref) - 0.5 * (y_ref[1] + y_ref[end]))

frame_states = Any[:intro1, :intro2, :intro3]
append!(frame_states, n_seq)

anim = @animate for state in frame_states
    plot(size=(630, 480), xlims=xlims, ylims=ylims,
         xlabel="", ylabel="", title="",
         legend=false, grid=false, framestyle=:box,
         background_color=:white,
         xticks=0.5:0.5:2.0, yticks=0.5:0.5:2.0,
         tickfontsize=7)

    sample_text = ""
    approx_text = ""
    intro_text1 = ""
    intro_text2 = ""
    intro_text3 = ""
    sample_x = Float64[]

    if state isa Int
        n = state
        x_nodes, w_nodes, approx = gauss_legendre_sum(n)
        bounds, widths, heights = weighted_rectangles(x_nodes, w_nodes)

        for i in eachindex(x_nodes)
            xl = bounds[i]
            xr = bounds[i + 1]
            h = heights[i]
            plot!([xl, xr, xr, xl], [0.0, 0.0, h, h];
                seriestype=:shape, fillcolor=:lightpink, fillalpha=0.5,
                  linecolor=:red, lw=0.8)
        end

        sample_x = x_nodes
        sample_text = "Sample Points = $n"
        approx_text = @sprintf("Approximation = %.6f", approx)
    elseif state == :intro2
        intro_text1 = "True"
        intro_text2 = "Numerical Quadrature"
        intro_text3 = @sprintf("I = %.6f", true_int)
    end

    plot!(xplot, f.(xplot); color=:magenta, lw=2)
    # Red dot at each sample (x_i, f(x_i)) on the top edge of its bar
    if !isempty(sample_x)
        scatter!(sample_x, f.(sample_x); color=:red, markersize=3,
                 markerstrokewidth=0)
    end

    annotate!(0.24, 2.02, text("Y = exp(-x) sin(8*x^(2/3)) + 1", :black, 7))
    annotate!(1.20, 2.02, text("Gauss-Legendre Rule", :black, 12))
    annotate!(1.20, 1.88, text("For", :black, 12))
    annotate!(1.20, 1.74, text("Numerical Quadrature", :black, 12))

    if !isempty(sample_text)
        annotate!(1.20, 1.60, text(sample_text, :black, 10))
        annotate!(1.20, 1.46, text(approx_text, :black, 10))
    elseif !isempty(intro_text1)
        annotate!(1.20, 1.60, text(intro_text1, :black, 10))
        annotate!(1.20, 1.46, text(intro_text2, :black, 10))
        annotate!(1.20, 1.32, text(intro_text3, :black, 10))
    end
end

gif(anim, joinpath(@__DIR__, "gausslegendreaa.gif"); fps=2)
println("Saved: gausslegendreaa.gif")
