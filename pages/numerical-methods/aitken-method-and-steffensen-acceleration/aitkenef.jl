# aitkenef.jl
# Aitken/Steffensen animation: Examples 5 & 6 merged (subplot)
# f(x) = x^6 - 7x^4 + 15x^2 - 9 = (x^2-1)(x^2-3)^2
# double root p = sqrt(3),  x0 = 1.5
# Top panel:    Newton tangent-line path + Steffensen iterates on x-axis
# Bottom panel: log10|error| vs iteration — Newton vs Steffensen
# Produces: aitkenef.gif

using Plots
gr()

# --- Function and derivative ---
f(x)  = x^6 - 7x^4 + 15x^2 - 9
df(x) = 6x^5 - 28x^3 + 30x

root = sqrt(3.0)
x0   = 1.5

n_total   = 22
n_tangent = n_total

xlims_curve = (0.6, 2.6)
ylims_curve = (-2.5, 4.5)

# ── Newton iterates ──────────────────────────────────────────────────────────
xN = Vector{Float64}(undef, n_total + 1)
xN[1] = x0
for i in 1:n_total
    dfi = df(xN[i])
    if abs(dfi) < 1e-14
        xN[i+1:end] .= xN[i]; break
    end
    xN[i+1] = xN[i] - f(xN[i]) / dfi
end

# ── Steffensen iterates ──────────────────────────────────────────────────────
n_steff = 6
xS = Vector{Float64}(undef, n_steff + 1)
xS[1] = x0
for i in 1:n_steff
    dfi = df(xS[i])
    if abs(dfi) < 1e-14; xS[i+1:end] .= xS[i]; break; end
    q1 = xS[i] - f(xS[i]) / dfi
    dfq1 = df(q1)
    if abs(dfq1) < 1e-14; xS[i+1:end] .= q1; break; end
    q2 = q1 - f(q1) / dfq1
    denom = q2 - 2*q1 + xS[i]
    if abs(denom) < 1e-15; xS[i+1:end] .= xS[i]; break; end
    xS[i+1] = xS[i] - (q1 - xS[i])^2 / denom
end

# ── Tangent-line path ────────────────────────────────────────────────────────
path_x = [xN[1]]; path_y = [0.0]
for i in 1:n_tangent
    push!(path_x, xN[i], xN[i+1])
    push!(path_y, f(xN[i]), 0.0)
end

# ── Log-error sequences ──────────────────────────────────────────────────────
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
              title="Newton (blue) vs Steffensen (red): f(x) = x⁶−7x⁴+15x²−9  (p = √3)",
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
        annotate!(p1, xs_cur, 0.2,
            text("S_$(nS)=$(round(xs_cur; digits=5))", 7, :red, :center))
    end

    # — Bottom panel: convergence comparison —
    p2 = plot(size=(680, 420), xlims=(0, n_total), ylims=(-17.0, 1.0),
              xlabel="Iteration k", ylabel="log₁₀ |xₖ − √3|",
              title="Newton vs Steffensen convergence",
              legend=:topright, grid=true, framestyle=:box,
              background_color=:white)
    plot!(p2, 0:frame, log_errN[1:frame+1];
          color=:steelblue, lw=2, markershape=:circle, ms=4, label="Newton")
    plot!(p2, 0:nS, log_errS[1:nS+1];
          color=:red, lw=2, markershape=:diamond, ms=5, label="Steffensen")

    plot(p1, p2; layout=(2, 1), size=(680, 880))
end

gif(anim, joinpath(@__DIR__, "aitkenef.gif"); fps=2)
println("Saved: aitkenef.gif")
