# aitkenab.jl
# Aitken/Steffensen animation: Examples 1 & 2 merged (subplot)
# f(x) = x^3 - 3x + 2,  double root p = 1,  x0 = 2.0
# Top panel:    Newton tangent-line path + Steffensen iterates on x-axis
# Bottom panel: log10|error| vs iteration — Newton vs Steffensen
# Produces: aitkenab.gif




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

using Printf
println("Newton iterates (k, x_k, |x_k-p|, ratio)")
for k in 0:length(xN)-1
    e = abs(xN[k+1]-root); r = k>0 ? e/abs(xN[k]-root) : NaN
    @printf("N %2d  %.17g  %.6e  %.6f\n", k, xN[k+1], e, r)
end
println("Steffensen iterates (n, x, |x-p|, log10 err plotted)")
for n in 0:length(xS)-1
    @printf("S %2d  %.17g  %.6e  %.4f\n", n, xS[n+1], abs(xS[n+1]-root), log_errS[n+1])
end
@printf("final Newton log10 err plotted: %.4f\n", log_errN[end])
