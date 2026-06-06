# regulafalsibb.jl
# Regula Falsi (False Position) animation: f(x) = x - cos(x), [a, b] = [0, 1]
# Classic example showing "one-sided" convergence: left endpoint stays fixed at 0.
# The successive c points converge from the right.
# Root: x* ≈ 0.7391 (Dottie number)
# Produces: regulafalsibb.gif

using Plots
gr()

# --- Parameters ---
f(x) = x - cos(x)
a0, b0 = 0.0, 1.0
n_iters = 10

xlims = (-0.2, 1.3)
ylims = (-1.2, 0.5)

title_str = "Regula Falsi: f(x) = x − cos(x)"

# --- Regula Falsi: c = (a*f(b) - b*f(a)) / (f(b) - f(a)) ---
as = Vector{Float64}(undef, n_iters + 1)
bs = Vector{Float64}(undef, n_iters + 1)
cs = Vector{Float64}(undef, n_iters)
as[1] = a0
bs[1] = b0
for i in 1:n_iters
    a, b = as[i], bs[i]
    c = (a * f(b) - b * f(a)) / (f(b) - f(a))
    cs[i] = c
    if f(a) * f(c) < 0
        as[i+1] = a
        bs[i+1] = c
    else
        as[i+1] = c
        bs[i+1] = b
    end
end

# --- Backdrop ---
xplot = range(xlims[1], xlims[2], length=500)

# --- Animation ---
anim = @animate for frame in 0:n_iters
    a_cur = as[frame + 1]
    b_cur = bs[frame + 1]

    plot(
        size        = (600, 600),
        xlims       = xlims,
        ylims       = ylims,
        xlabel      = "x",
        ylabel      = "y",
        title       = title_str,
        legend      = :bottomright,
        grid        = true,
        framestyle  = :box,
        background_color = :white,
    )

    # y = 0
    hline!([0.0]; color=:black, lw=1, label="")

    # f(x) curve
    plot!(xplot, f.(xplot); color=:magenta, lw=2, label="y = f(x) = x − cos(x)")

    # Current bracket shading
    bracket_xs = [a_cur, b_cur, b_cur, a_cur, a_cur]
    bracket_ys = [ylims[1], ylims[1], ylims[2], ylims[2], ylims[1]]
    plot!(bracket_xs, bracket_ys; fill=true, fillalpha=0.10, fillcolor=:steelblue,
          lw=0, label="")

    # Bracket endpoints on curve
    scatter!([a_cur, b_cur], [f(a_cur), f(b_cur)]; color=:steelblue, ms=6, label="bracket [a, b]")

    if frame > 0
        # Previous secant intercepts (gray)
        for k in 1:(frame - 1)
            scatter!([cs[k]], [0.0]; color=:gray, ms=4, marker=:diamond, label="", alpha=0.5)
        end

        # Current secant line
        a_prev, b_prev = as[frame], bs[frame]
        slope = (f(b_prev) - f(a_prev)) / (b_prev - a_prev)
        sec_y(x) = f(a_prev) + slope * (x - a_prev)
        plot!(collect(xlims), sec_y.(collect(xlims));
              color=:steelblue, lw=1.5, ls=:dash, label="secant")

        # Current false position point
        c_cur = cs[frame]
        scatter!([c_cur], [0.0]; color=:red, ms=8, marker=:diamond,
                 label="c_$(frame) = $(round(c_cur; digits=6))")
        plot!([c_cur, c_cur], [0.0, f(c_cur)]; color=:red, lw=1, ls=:dot, label="")
        scatter!([c_cur], [f(c_cur)]; color=:red, ms=6, label="")
    else
        annotate!(
            (a0 + b0) / 2, ylims[2] * 0.85,
            text("Initial bracket [$a0, $b0]", :center, 9, :steelblue)
        )
    end
end

gif(anim, joinpath(@__DIR__, "regulafalsibb.gif"); fps=2)
println("Saved: regulafalsibb.gif")
