# mullerscc.jl
# Muller's Method animation: Example 3
# f(x) = x^6 - 7x^4 + 15x^2 - 9 = (x^2-1)(x^2-3)^2
# Double root at p = sqrt(3) ≈ 1.7321 (Mathews' problem statement says "near x = 2")
# Starting values: p0=1.3, p1=1.4, p2=1.5
# The three points close in on sqrt(3), so each frame is zoomed to the current
# points and the next iterate, as in mullersbb.jl, and an inset shows the
# step from p2 to the parabola's axis crossing.
# Produces: mullerscc.gif

using Plots
using Printf
gr()

# --- Parameters ---
f(x) = x^6 - 7x^4 + 15x^2 - 9
p_init = [1.3, 1.4, 1.5]   # [p0, p1, p2]
n_iters = 8

title_str = "Muller's Method: f(x) = x⁶ - 7x⁴ + 15x² - 9"

# --- Muller's method step ---
# Parabola through the three points: P(x) = f2 + b (x - p2) + d (x - p2)^2.
# Its discriminant is positive at every step for these starting values, so the
# real root nearest p2 is Muller's next iterate; a negative discriminant
# (complex next iterate) is reported as an error rather than silently dropped.
function muller_step(p0, p1, p2, f)
    f0, f1, f2 = f(p0), f(p1), f(p2)
    h0 = p1 - p0
    h1 = p2 - p1
    δ0 = (f1 - f0) / h0
    δ1 = (f2 - f1) / h1
    d = (δ1 - δ0) / (h1 + h0)
    b = δ1 + h1 * d
    disc = b^2 - 4 * f2 * d
    disc < 0 && error("Muller step has complex roots (discriminant = $disc)")
    D = sqrt(disc)
    E = abs(b + D) >= abs(b - D) ? b + D : b - D
    return p2 - 2 * f2 / E
end

# --- Lagrange parabola through 3 points ---
function lagrange_parabola(x, p0, p1, p2, f)
    f0, f1, f2 = f(p0), f(p1), f(p2)
    L0 = (x - p1) * (x - p2) / ((p0 - p1) * (p0 - p2))
    L1 = (x - p0) * (x - p2) / ((p1 - p0) * (p1 - p2))
    L2 = (x - p0) * (x - p1) / ((p2 - p0) * (p2 - p1))
    return f0 * L0 + f1 * L1 + f2 * L2
end

# --- Pre-compute all iterates ---
history = Vector{NTuple{3,Float64}}(undef, n_iters + 1)
history[1] = (p_init[1], p_init[2], p_init[3])
for i in 1:n_iters
    (q0, q1, q2) = history[i]
    q3 = muller_step(q0, q1, q2, f)
    history[i+1] = (q1, q2, q3)
end

# --- Animation ---
# Main panel: zoomed to the current triple and the next iterate q3 (where the
# parabola crosses the x-axis), with y scaled to max |f(q)|.
# Inset: zoomed to the step from q2 to q3, with y scaled to f(q2).
anim = @animate for frame in 1:(n_iters + 1)
    (q0, q1, q2) = history[frame]
    q3 = muller_step(q0, q1, q2, f)

    xlo, xhi = min(q0, q1, q2, q3), max(q0, q1, q2, q3)
    δ = 0.08 * (xhi - xlo)
    xlims = (xlo - δ, xhi + δ)
    Y = maximum(abs, f.((q0, q1, q2)))
    ylims = (-0.08 * Y, 1.12 * Y)
    xplot = range(xlims[1], xlims[2], length=400)

    plot(size=(640, 500), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="f(x)", title=title_str,
         legend=:bottomleft, grid=true, framestyle=:box,
         background_color=:white)

    # Zero line
    hline!([0.0]; color=:black, lw=1, label="")

    # Function curve
    plot!(xplot, f.(xplot); color=:magenta, lw=2, label="f(x)")

    # Parabola through current 3 points, across the window, which includes its
    # axis crossing (the next iterate)
    P(x) = lagrange_parabola(x, q0, q1, q2, f)
    plot!(collect(xplot), P.(xplot); color=:steelblue, lw=1.5, ls=:dash, label="parabola")
    # The parabola's axis crossing becomes the next p₂
    scatter!([q3], [0.0]; color=:white, markerstrokecolor=:red,
             markerstrokewidth=2, ms=6, label="axis crossing = next p₂")

    # Current 3 points
    scatter!([q0, q1], [f(q0), f(q1)]; color=:gray, ms=6, label="")
    scatter!([q2], [f(q2)]; color=:red, ms=7,
             label="p₂ = $(round(q2; digits=5))")

    # Inset: view of the step from p₂ to the axis crossing, placed
    # clear of f, the parabola and the points in every frame
    s = q3 - q2
    xin = range(q2 - 0.15s, q3 + 0.8s, length=300)
    F = f(q2)
    plot!(; inset=(1, bbox(0.60, 0.12, 0.36, 0.28)), subplot=2,
          xlims=(q2 - 0.15s, q3 + 0.8s), ylims=(-0.25F, 1.15F), ticks=false,
          framestyle=:box, legend=false, background_color_inside=:white,
          title=@sprintf("step to next p₂: %.2e", s), titlefontsize=9)
    hline!([0.0]; color=:black, lw=1, subplot=2)
    plot!(collect(xin), f.(xin); color=:magenta, lw=2, subplot=2)
    plot!(collect(xin), P.(xin); color=:steelblue, lw=1.5, ls=:dash, subplot=2)
    scatter!([q2], [F]; color=:red, ms=7, subplot=2)
    scatter!([q3], [0.0]; color=:white, markerstrokecolor=:red,
             markerstrokewidth=2, ms=6, subplot=2)
end

gif(anim, joinpath(@__DIR__, "mullerscc.gif"); fps=2)
println("Saved: mullerscc.gif")
