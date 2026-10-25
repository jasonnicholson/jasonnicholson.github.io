# aitkenab.jl
# Aitken/Steffensen animation: Examples 1 & 2 merged (subplot)
# f(x) = x^3 - 3x + 2,  double root p = 1,  x0 = 2.0
# Top panel:    Newton tangent-line path + Steffensen iterates on x-axis
# Bottom panel: log10|error| vs iteration — Newton vs Steffensen
# Produces: aitkenab.gif

using Plots
gr()

# --- Function and derivative ---
f(x)  = x^3 - 3x + 2
df(x) = 3x^2 - 3

root = 1.0
x0   = 2.0

n_total   = 22
n_tangent = n_total

xlims_curve = (-0.3, 2.6)
ylims_curve = (-0.8, 5.5)

# ── Newton iterates ───────────────────────────────────────────────────────────
xN = Vector{Float64}(undef, n_total + 1)
xN[1] = x0
for i in 1:n_total
    xN[i+1] = xN[i] - f(xN[i]) / df(xN[i])
end

# ── Steffensen iterates ───────────────────────────────────────────────────────
n_steff = 7
xS = Vector{Float64}(undef, n_steff + 1)
xS[1] = x0
for i in 1:n_steff
    q1 = xS[i] - f(xS[i]) / df(xS[i])
    q2 = q1    - f(q1)    / df(q1)
    denom = q2 - 2*q1 + xS[i]
    if abs(denom) < 1e-15
        xS[i+1:end] .= xS[i]; break
    end
    xS[i+1] = xS[i] - (q1 - xS[i])^2 / denom
end

# ── Tangent-line cobweb path (Newton) ────────────────────────────────────────
path_x = [xN[1]]; path_y = [0.0]
for i in 1:n_tangent
    push!(path_x, xN[i], xN[i+1])
    push!(path_y, f(xN[i]), 0.0)
end

# ── Log-error sequences ───────────────────────────────────────────────────────
clamp_low = 1e-16
errN     = [max(abs(x - root), clamp_low) for x in xN]
errS     = [max(abs(x - root), clamp_low) for x in xS]
log_errN = log10.(errN)
log_errS = log10.(errS)

xplot = range(xlims_curve[1], xlims_curve[2], length=500)

# ── Animation ────────────────────────────────────────────────────────────────
anim = @animate for frame in 0:n_total

    nS = min(frame, n_steff)

    # — Top panel: Newton tangent-line path + Steffensen iterates —
    p1 = plot(size=(680, 420), xlims=xlims_curve, ylims=ylims_curve,
              xlabel="x", ylabel="y",
              title="Newton (blue) vs Steffensen (red): f(x) = x³−3x+2  (p = 1)",
              legend=:topleft, grid=true, framestyle=:box,
              background_color=:white)
    hline!(p1, [0.0]; color=:black, lw=1, label="")
    plot!(p1, xplot, f.(xplot); color=:magenta, lw=2, label="y = f(x)")
    # Newton tangent-line cobweb
    n_pts = 1 + 2 * frame
    if n_pts >= 2
        plot!(p1, path_x[1:n_pts], path_y[1:n_pts];
              color=:steelblue, lw=1.5, label="")
    end
    x_cur = xN[frame + 1]
    scatter!(p1, [x_cur], [0.0]; color=:steelblue, ms=6, markershape=:circle,
             label="Newton x_$(frame) = $(round(x_cur; digits=6))")
    # Steffensen iterates accumulated on x-axis
    scatter!(p1, xS[1:nS+1], zeros(nS+1); color=:red, ms=7,
             markershape=:diamond, label="Steffensen ($(nS) steps)")
    if nS > 0
        xs_cur = xS[nS + 1]
        annotate!(p1, xs_cur, 0.25,
            text("S_$(nS)=$(round(xs_cur; digits=5))", 7, :red, :center))
    end

    # — Bottom panel: convergence comparison —
    p2 = plot(size=(680, 420), xlims=(0, n_total), ylims=(-17.0, 1.0),
              xlabel="Iteration k", ylabel="log₁₀ |xₖ − 1|",
              title="Newton vs Steffensen convergence",
              legend=:topright, grid=true, framestyle=:box,
              background_color=:white)
    plot!(p2, 0:frame, log_errN[1:frame+1];
          color=:steelblue, lw=2, markershape=:circle, ms=4, label="Newton")
    plot!(p2, 0:nS, log_errS[1:nS+1];
          color=:red, lw=2, markershape=:diamond, ms=5, label="Steffensen")

    plot(p1, p2; layout=(2, 1), size=(680, 880))
end

gif(anim, joinpath(@__DIR__, "aitkenab.gif"); fps=2)
println("Saved: aitkenab.gif")
