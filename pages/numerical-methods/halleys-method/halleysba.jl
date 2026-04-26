# halleysba.jl
# Halley's Method animation: Halley's iteration on f(x) = x³ - 3x + 2, x₀ = -2.2
# Converges to the simple root x = -2 (cubic convergence)
# Produces: halleysba.gif

using Plots
gr()

# --- Parameters ---
f(x)   = x^3 - 3x + 2
fp(x)  = 3x^2 - 3
fpp(x) = 6x

x0      = -2.2
n_iters = 5

xlims = (-3.0, 2.5)
ylims = (-5.0, 8.0)

title_str = "Halley's Method: f(x) = x³ - 3x + 2,  x₀ = -2.2"

# --- Unicode subscript helper ---
const SUB = ["₀","₁","₂","₃","₄","₅","₆","₇","₈","₉","₁₀","₁₁","₁₂"]

# --- Pre-compute Halley iterates ---
xs = Vector{Float64}(undef, n_iters + 1)
xs[1] = x0
for i in 1:n_iters
    fv   = f(xs[i])
    fpv  = fp(xs[i])
    fppv = fpp(xs[i])
    xs[i+1] = xs[i] - 2*fv*fpv / (2*fpv^2 - fv*fppv)
end

# --- Backdrop ---
xplot = range(xlims[1], xlims[2], length=600)

# --- Animation ---
anim = @animate for frame in 0:n_iters
    plot(size=(700, 550), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y", title=title_str,
         legend=:topleft, grid=true, framestyle=:box,
         background_color=:white)

    hline!([0.0]; color=:black, lw=1, label="")
    plot!(xplot, f.(xplot); color=:magenta, lw=2.5, label="y = f(x) = x³ - 3x + 2")

    x_cur  = xs[frame + 1]
    fv     = f(x_cur)
    fpv    = fp(x_cur)
    fppv   = fpp(x_cur)

    # Osculating parabola
    parabola(x) = fv + fpv*(x - x_cur) + 0.5*fppv*(x - x_cur)^2
    plot!(xplot, clamp.(parabola.(xplot), ylims[1], ylims[2]);
          color=:darkorange, lw=1.5, ls=:dash, label="osculatory parabola")

    # Tangent line (Newton)
    tangent(x) = fv + fpv*(x - x_cur)
    plot!(xplot, clamp.(tangent.(xplot), ylims[1], ylims[2]);
          color=:steelblue, lw=1, ls=:dot, label="tangent (Newton direction)")

    # Vertical drop from x_cur to curve
    plot!([x_cur, x_cur], [0.0, fv]; color=:gray, lw=1, ls=:dot, label="")

    # Mark current point on curve
    scatter!([x_cur], [fv]; color=:red, ms=7, label="")

    # Mark x_cur on x-axis
    scatter!([x_cur], [0.0]; color=:red, ms=5, markershape=:diamond, label="")

    if frame < n_iters
        x_next   = xs[frame + 2]
        x_newton = x_cur - fv / fpv

        scatter!([x_newton], [0.0]; color=:steelblue, ms=5, markershape=:diamond,
                 label="Newton xₙ₊₁ ≈ $(round(x_newton; digits=5))")
        scatter!([x_next], [0.0]; color=:darkorange, ms=6, markershape=:diamond,
                 label="Halley xₙ₊₁ ≈ $(round(x_next; digits=6))")
    end

    annotate!(2.3, -4.5,
        text("x$(SUB[frame+1]) = $(round(x_cur; digits=8))", :black, :right, 9))
end

gif(anim, joinpath(@__DIR__, "halleysba.gif"); fps=1)
println("Saved: halleysba.gif")
