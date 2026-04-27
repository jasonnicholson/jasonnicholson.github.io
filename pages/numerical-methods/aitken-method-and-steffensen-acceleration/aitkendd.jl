# aitkendd.jl
# Aitken/Steffensen animation: Example 4
# Convergence comparison: Newton-Raphson vs Steffensen acceleration
# f(x) = (x^2 - 2)*sin(x^2 - 2),  double root p = sqrt(2),  p0 = 1.0
# Produces: aitkendd.gif

using Plots
gr()

# --- Function and derivative ---
f(x)  = (x^2 - 2) * sin(x^2 - 2)
df(x) = 2x * (sin(x^2 - 2) + (x^2 - 2) * cos(x^2 - 2))

root = sqrt(2.0)
p0   = 1.0

# --- Newton iteration sequence ---
n_newton = 22
xN = Vector{Float64}(undef, n_newton + 1)
xN[1] = p0
for i in 1:n_newton
    dfi = df(xN[i])
    if abs(dfi) < 1e-14
        xN[i+1:end] .= xN[i]
        break
    end
    xN[i+1] = xN[i] - f(xN[i]) / dfi
end

# --- Steffensen (Aitken Δ² on Newton) ---
n_steff = 5
xS = Vector{Float64}(undef, n_steff + 1)
xS[1] = p0
for i in 1:n_steff
    dfi = df(xS[i])
    if abs(dfi) < 1e-14
        xS[i+1:end] .= xS[i]; break
    end
    q1 = xS[i] - f(xS[i]) / dfi
    dfq1 = df(q1)
    if abs(dfq1) < 1e-14
        xS[i+1:end] .= q1; break
    end
    q2 = q1 - f(q1) / dfq1
    denom = q2 - 2*q1 + xS[i]
    if abs(denom) < 1e-15
        xS[i+1:end] .= xS[i]; break
    end
    xS[i+1] = xS[i] - (q1 - xS[i])^2 / denom
end

# --- Log-scale errors ---
clamp_low = 1e-16
errN = [max(abs(x - root), clamp_low) for x in xN]
errS = [max(abs(x - root), clamp_low) for x in xS]
log_errN = log10.(errN)
log_errS = log10.(errS)

ylims_err = (-17.0, 1.0)
title_str = "Newton vs Steffensen: f(x) = (x²−2)sin(x²−2)  (p₀ = 1.0)"

n_frames = n_newton + 1

anim = @animate for frame in 0:n_frames
    plot(size=(700, 520), xlims=(0, n_frames), ylims=ylims_err,
         xlabel="Iteration k", ylabel="log₁₀ |xₖ − √2|",
         title=title_str, legend=:topright,
         grid=true, framestyle=:box, background_color=:white)

    nN = min(frame, n_newton)
    nS = min(frame, n_steff)

    plot!(0:nN, log_errN[1:nN+1];
          color=:steelblue, lw=2, markershape=:circle, ms=5,
          label="Newton (linear conv.)")

    plot!(0:nS, log_errS[1:nS+1];
          color=:red, lw=2, markershape=:diamond, ms=6,
          label="Steffensen (faster conv.)")

    if frame <= n_newton
        annotate!(n_frames * 0.52, -2.0,
            text("Newton k=$(nN): log err = $(round(log_errN[nN+1]; digits=2))", 8, :steelblue, :left))
    end
    if frame <= n_steff
        annotate!(n_frames * 0.52, -4.5,
            text("Steffensen k=$(nS): log err = $(round(log_errS[nS+1]; digits=2))", 8, :red, :left))
    end
end

gif(anim, joinpath(@__DIR__, "aitkendd.gif"); fps=2)
println("Saved: aitkendd.gif")
