# halleysaa.jl
# Halley's Method animation: Newton-Raphson on f(x) = x² - 2, x₀ = 2
# Shows tangent-line construction converging to √2 (quadratic convergence)
# Produces: halleysaa.gif

using Plots
gr()

# --- Parameters ---
f(x)  = x^2 - 2
fp(x) = 2x

x0      = 2.0
n_iters = 6

xlims = (1.0, 2.6)
ylims = (-2.5, 4.5)

title_str = "Newton-Raphson: f(x) = x² - 2,  x₀ = 2"

# --- Unicode subscript helper ---
const SUB = ["₀","₁","₂","₃","₄","₅","₆","₇","₈","₉","₁₀","₁₁","₁₂"]

# --- Pre-compute Newton iterates ---
xs = Vector{Float64}(undef, n_iters + 1)
xs[1] = x0
for i in 1:n_iters
    xs[i+1] = xs[i] - f(xs[i]) / fp(xs[i])
end

# --- Backdrop ---
xplot = range(xlims[1], xlims[2], length=400)

# --- Animation (one tangent step per frame) ---
anim = @animate for frame in 0:n_iters
    plot(size=(700, 550), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y", title=title_str,
         legend=:topleft, grid=true, framestyle=:box,
         background_color=:white)

    hline!([0.0]; color=:black, lw=1, label="")
    plot!(xplot, f.(xplot); color=:magenta, lw=2.5, label="y = f(x) = x² - 2")

    x_cur = xs[frame + 1]
    f_cur = f(x_cur)
    fp_cur = fp(x_cur)

    # Tangent line: y = f_cur + fp_cur*(x - x_cur) → zeros at x_cur - f_cur/fp_cur
    x_next = x_cur - f_cur / fp_cur
    # Draw tangent line across visible domain
    tangent(x) = f_cur + fp_cur * (x - x_cur)
    plot!(xplot, tangent.(xplot); color=:steelblue, lw=1.5, ls=:dash, label="tangent at x$(SUB[frame+1])")

    # Vertical drop from x_cur to curve
    plot!([x_cur, x_cur], [0.0, f_cur]; color=:gray, lw=1, ls=:dot, label="")

    # Mark current point on curve
    scatter!([x_cur], [f_cur]; color=:red, ms=7, label="")

    # Mark x_cur on x-axis
    scatter!([x_cur], [0.0]; color=:red, ms=5, markershape=:diamond, label="")

    # Mark x_next on x-axis (next iterate, where tangent hits zero)
    if frame < n_iters
        scatter!([x_next], [0.0]; color=:orange, ms=5, markershape=:diamond,
                 label="x$(SUB[frame+2]) ≈ $(round(x_next; digits=6))")
    end

    annotate!(2.5, -2.0,
        text("x$(SUB[frame+1]) = $(round(x_cur; digits=8))", :black, :right, 9))
end

gif(anim, joinpath(@__DIR__, "halleysaa.gif"); fps=1)
println("Saved: halleysaa.gif")
