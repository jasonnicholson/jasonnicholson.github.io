# mullersaa.jl
# Muller's Method animation: Example 1
# f(x) = x^3 - 3x + 2 = (x-1)^2 (x+2), double root at p=1
# Starting values: p0=2.2, p1=2.1, p2=2.0
# With these starting values the parabola through the three points never
# reaches the x-axis: its discriminant is negative at every step, so Muller's
# next iterate would be complex. This animation instead takes the real part of
# that complex root, which is the x-coordinate of the parabola's vertex.
# The vertex height shrinks from 0.8 to about 5e-13 over the frames, so each
# frame is zoomed to the current points and an inset shows the vertex.
# The run stops after 7 steps (8 frames): an 8th step, in a 9th frame, would
# have a vertex height (about 1e-17) below the rounding error of f near the
# double root.
# Produces: mullersaa.gif

using Plots
using Printf
gr()

# --- Parameters ---
f(x) = x^3 - 3x + 2
p_init = [2.2, 2.1, 2.0]   # [p0, p1, p2]
n_iters = 7

title_str = "Muller's Method: f(x) = x³ - 3x + 2"

# --- Muller's method step ---
# Parabola through the three points: P(x) = f2 + b (x - p2) + d (x - p2)^2.
# Returns (next iterate, discriminant b^2 - 4 f2 d).
function muller_step(p0, p1, p2, f)
    f0, f1, f2 = f(p0), f(p1), f(p2)
    h0 = p1 - p0
    h1 = p2 - p1
    δ0 = (f1 - f0) / h0
    δ1 = (f2 - f1) / h1
    d = (δ1 - δ0) / (h1 + h0)
    b = δ1 + h1 * d
    disc = b^2 - 4 * f2 * d
    if disc < 0
        # No real root: Muller's root p2 - 2 f2 / (b ± i sqrt(-disc)) is complex.
        # Variant used here: take its real part, p2 - b / (2d), the parabola's vertex.
        return p2 - b / (2 * d), disc
    end
    D = sqrt(disc)
    E = abs(b + D) >= abs(b - D) ? b + D : b - D
    return p2 - 2 * f2 / E, disc
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
    q3, _ = muller_step(q0, q1, q2, f)
    history[i+1] = (q1, q2, q3)
end

# --- Animation ---
# Main panel: zoomed to the current triple and the vertex, y scaled to max |f(q)|.
# Inset: zoomed to the vertex, y scaled to the vertex height h, so the gap
# between the parabola and the x-axis is visible in every frame.
anim = @animate for frame in 1:(n_iters + 1)
    (q0, q1, q2) = history[frame]
    q3, disc = muller_step(q0, q1, q2, f)
    P(x) = lagrange_parabola(x, q0, q1, q2, f)
    h = P(q3)   # vertex height (disc < 0 in every frame)
    a = (P(q3 + 1) + P(q3 - 1)) / 2 - h   # leading coefficient of the parabola

    xlo, xhi = min(q0, q1, q2, q3), max(q0, q1, q2, q3)
    δ = 0.08 * (xhi - xlo)
    xlims = (xlo - δ, xhi + δ)
    Y = maximum(abs, f.((q0, q1, q2)))
    ylims = (-0.08 * Y, 1.12 * Y)
    xplot = range(xlims[1], xlims[2], length=400)

    plot(size=(640, 500), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="f(x)", title=title_str,
         legend=:bottomright, grid=true, framestyle=:box,
         background_color=:white)

    # Zero line
    hline!([0.0]; color=:black, lw=1, label="")

    # Function curve
    plot!(xplot, f.(xplot); color=:magenta, lw=2, label="f(x)")

    # Parabola through current 3 points
    plot!(collect(xplot), P.(xplot); color=:steelblue, lw=1.5, ls=:dash,
          label=disc < 0 ? "parabola (no real root)" : "parabola")
    # The vertex of the parabola becomes the next p₂
    scatter!([q3], [h]; color=:white, markerstrokecolor=:red,
             markerstrokewidth=2, ms=6, label="vertex = next p₂")

    # Current 3 points
    scatter!([q0, q1], [f(q0), f(q1)]; color=:gray, ms=6, label="")
    scatter!([q2], [f(q2)]; color=:red, ms=7,
             label=@sprintf("p₂ = %.10g", q2))

    # Inset: view around the vertex
    w = 1.4 * sqrt(2h / a)
    xin = range(q3 - w, q3 + w, length=300)
    plot!(; inset=(1, bbox(0.04, 0.10, 0.40, 0.38)), subplot=2,
          xlims=(q3 - w, q3 + w), ylims=(-0.8h, 3h), ticks=false,
          framestyle=:box, legend=false, background_color_inside=:white,
          title=@sprintf("near vertex: height %.2e", h), titlefontsize=9)
    hline!([0.0]; color=:black, lw=1, subplot=2)
    plot!(collect(xin), f.(xin); color=:magenta, lw=2, subplot=2)
    plot!(collect(xin), P.(xin); color=:steelblue, lw=1.5, ls=:dash, subplot=2)
    scatter!([q3], [h]; color=:white, markerstrokecolor=:red,
             markerstrokewidth=2, ms=6, subplot=2)
end

gif(anim, joinpath(@__DIR__, "mullersaa.gif"); fps=2)
println("Saved: mullersaa.gif")
