# milnebb.jl
# Milne-Simpson's Method animation: weak stability on y' = 30 - 5y, y(0) = 1 on
# [0, 5], exact solution y = 6 - 5 exp(-5t) (Mathews, Milne-Simpson module,
# Examples 5-8). New animation, no Mathews original: his Examples 7 and 8 are
# static plots of |e_k| for h = 0.1 and h = 0.05. Here both runs advance
# together, 0.1 in t per frame, on a log scale, and the marker fill shows the
# sign of e_k, which |e_k| alone hides.
# Produces: milnebb.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
fmt(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%.4g", x)

# --- Parameters ---
lambda = -5.0
f(t, y) = 30 + lambda * y
yexact(t) = 6 - 5 * exp(lambda * t)
a, b, alpha = 0.0, 5.0, 1.0
ms = [50, 100]                     # Mathews' runs: h = 0.1 and h = 0.05
colors = [:blue, :orangered]
ylims = (1e-9, 1e-2)               # holds every |e_k|, k >= 1 (min 6.9e-9, max 3.3e-3)
dt_frame = 0.1                     # t advanced per frame
n_hold = 8                         # extra copies of the last frame

# --- Milne-Simpson: RK4 start, then predict-evaluate-correct-evaluate ---
function milne(m)
    h = (b - a) / m
    t = [a + k * h for k in 0:m]
    y = zeros(m + 1); y[1] = alpha
    for i in 1:3
        k1 = h * f(t[i], y[i])
        k2 = h * f(t[i] + h / 2, y[i] + k1 / 2)
        k3 = h * f(t[i] + h / 2, y[i] + k2 / 2)
        k4 = h * f(t[i] + h, y[i] + k3)
        y[i+1] = y[i] + (k1 + 2k2 + 2k3 + k4) / 6
    end
    F = zeros(m + 1)
    for j in 1:4
        F[j] = f(t[j], y[j])
    end
    for k in 4:m                  # index k holds t_{k-1}; this computes index k + 1
        p = y[k-3] + 4h / 3 * (2F[k-2] - F[k-1] + 2F[k])
        y[k+1] = y[k-1] + h / 3 * (F[k-1] + 4F[k] + f(t[k+1], p))
        F[k+1] = f(t[k+1], y[k+1])
    end
    t, y
end

# e_k = y(t_k) - y_k: the exact value and the difference in BigFloat, because
# y_k is close to 6 and e_k is as small as 1e-8
runs = map(ms) do m
    t, y = milne(m)
    e = [Float64(yexact(big(t[k])) - big(y[k])) for k in eachindex(t)]
    @assert all(ylims[1] .< abs.(e[2:end]) .< ylims[2])
    (m=m, h=(b - a) / m, t=t, e=e)
end

nframes = round(Int, (b - a) / dt_frame)
frames = vcat(1:nframes, fill(nframes, n_hold))
anim = @animate for j in frames
    tnow = j * dt_frame
    plot(size=(640, 520), xlims=(a, b), ylims=ylims, yscale=:log10,
         yticks=10.0 .^ (-9:-2), xlabel="t", ylabel="|eₖ| = |y(tₖ) − yₖ|",
         title="Milne-Simpson errors, y′ = 30 − 5y, y(0) = 1, t ≤ $(fmt(tnow))",
         titlefontsize=11, legend=:bottomleft, legendfontsize=8,
         grid=true, framestyle=:box, background_color=:white)
    for (R, c) in zip(runs, colors)
        n = round(Int, tnow / R.h)              # points k = 1, ..., n
        k = 2:(n + 1)
        ae = abs.(R.e[k]); pos = R.e[k] .> 0
        plot!(R.t[k], ae; color=c, lw=1.2,
              label="h = $(R.h) (m = $(R.m)),  hλ = $(R.h * lambda)")
        scatter!(R.t[k][pos], ae[pos]; color=c, markerstrokecolor=c, ms=3.5, label="")
        scatter!(R.t[k][.!pos], ae[.!pos]; color=:white, markerstrokecolor=c,
                 markerstrokewidth=1.2, ms=3.5, label="")
    end
    scatter!([NaN], [NaN]; color=:gray30, markerstrokecolor=:gray30, ms=3.5, label="filled: eₖ > 0")
    scatter!([NaN], [NaN]; color=:white, markerstrokecolor=:gray30, markerstrokewidth=1.2,
             ms=3.5, label="open: eₖ < 0")
    for (i, R) in enumerate(runs)
        n = round(Int, tnow / R.h)
        annotate!(2.3, 10.0^(-2.35 - 0.35 * (i - 1)),
                  text("h = $(R.h):  e = $(fmt(R.e[n+1])) at t = $(fmt(R.t[n+1]))", 9, :left, colors[i]))
    end
end

gif(anim, joinpath(@__DIR__, "milnebb.gif"); fps=5)
println("Saved: milnebb.gif")
