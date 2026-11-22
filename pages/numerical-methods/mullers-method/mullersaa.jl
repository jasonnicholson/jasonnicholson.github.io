# mullersaa.jl
# Muller's Method animation: Example 1
# f(x) = x^3 - 3x + 2 = (x-1)^2 (x+2), double root at p=1
# Starting values: p0=2.2, p1=2.1, p2=2.0
# With these starting values the parabola through the three points never
# reaches the x-axis: its discriminant is negative at every step, so Muller's
# next iterate would be complex. This animation instead takes the real part of
# that complex root, which is the x-coordinate of the parabola's vertex.
# Produces: mullersaa.gif

using Plots
gr()

# --- Parameters ---
f(x) = x^3 - 3x + 2
p_init = [2.2, 2.1, 2.0]   # [p0, p1, p2]
n_iters = 8

xlims = (-2.5, 2.5)
ylims = (-8.0, 7.0)   # upper limit above f(p0) = f(2.2) = 6.048

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

# --- Backdrop ---
xplot = range(xlims[1], xlims[2], length=400)

# --- Animation ---
anim = @animate for frame in 1:(n_iters + 1)
    (q0, q1, q2) = history[frame]

    plot(size=(640, 500), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="f(x)", title=title_str,
         legend=:topleft, grid=true, framestyle=:box,
         background_color=:white)

    # Zero line
    hline!([0.0]; color=:black, lw=1, label="")

    # Function curve
    plot!(xplot, f.(xplot); color=:magenta, lw=2, label="f(x)")

    # Parabola through current 3 points (drawn far enough to include the next iterate)
    q3, disc = muller_step(q0, q1, q2, f)
    xpara = range(min(q0, q1, q2, q3) - 0.3, max(q0, q1, q2, q3) + 0.3, length=200)
    ypara = [lagrange_parabola(x, q0, q1, q2, f) for x in xpara]
    ypara_clamped = clamp.(ypara, ylims[1], ylims[2])
    plot!(collect(xpara), ypara_clamped; color=:steelblue, lw=1.5, ls=:dash,
          label=disc < 0 ? "parabola (no real root)" : "parabola")
    if disc < 0
        # The vertex of the parabola becomes the next p₂
        scatter!([q3], [lagrange_parabola(q3, q0, q1, q2, f)]; color=:white,
                 markerstrokecolor=:red, markerstrokewidth=2, ms=6,
                 label="vertex = next p₂")
    end

    # Current 3 points
    scatter!([q0, q1], [f(q0), f(q1)]; color=:gray, ms=6, label="")
    scatter!([q2], [f(q2)]; color=:red, ms=7,
             label="p₂ = $(round(q2; digits=5))")
end

gif(anim, joinpath(@__DIR__, "mullersaa.gif"); fps=2)
println("Saved: mullersaa.gif")
