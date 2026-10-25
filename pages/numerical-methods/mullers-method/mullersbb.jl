# mullersbb.jl
# Muller's Method animation: Example 2
# f(x) = sin(x^2 - 2) * (x^2 - 2), double root at p = sqrt(2)
# Starting values: p0=0.8, p1=0.9, p2=1.0
# Produces: mullersbb.gif

using Plots
gr()

# --- Parameters ---
f(x) = sin(x^2 - 2) * (x^2 - 2)
p_init = [0.8, 0.9, 1.0]   # [p0, p1, p2]
n_iters = 8

xlims = (-1.5, 2.5)
ylims = (-0.2, 2.2)

title_str = "Muller's Method: f(x) = sin(x²-2)·(x²-2)"

# --- Muller's method step ---
function muller_step(p0, p1, p2, f)
    f0, f1, f2 = f(p0), f(p1), f(p2)
    h0 = p1 - p0
    h1 = p2 - p1
    δ0 = (f1 - f0) / h0
    δ1 = (f2 - f1) / h1
    d = (δ1 - δ0) / (h1 + h0)
    b = δ1 + h1 * d
    D = sqrt(complex(b^2 - 4 * f2 * d))
    E = abs(b + D) >= abs(b - D) ? b + D : b - D
    return real(p2 - 2 * f2 / E)
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

    # Parabola through current 3 points
    xpara = range(min(q0, q1, q2) - 0.2, max(q0, q1, q2) + 0.2, length=200)
    ypara = [lagrange_parabola(x, q0, q1, q2, f) for x in xpara]
    ypara_clamped = clamp.(ypara, ylims[1], ylims[2])
    plot!(collect(xpara), ypara_clamped; color=:steelblue, lw=1.5, ls=:dash, label="parabola")

    # Current 3 points
    scatter!([q0, q1], [f(q0), f(q1)]; color=:gray, ms=6, label="")
    scatter!([q2], [f(q2)]; color=:red, ms=7,
             label="p₂ = $(round(q2; digits=5))")
end

gif(anim, joinpath(@__DIR__, "mullersbb.gif"); fps=2)
println("Saved: mullersbb.gif")
