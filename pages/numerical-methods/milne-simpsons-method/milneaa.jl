# milneaa.jl
# Milne-Simpson's Method animation: y' = 1 - t*cbrt(y), y(0) = 1 on [0, 5]
# (Mathews, Milne-Simpson module, Example 11, and his animation Milneaa.gif).
# One frame per number of subintervals m, with Mathews' 21 values of m from 12
# to 150. Top panel, as in Mathews' animation: the computed points (t_k, y_k)
# joined by a magenta polyline, the initial point as a red dot, m and the end
# value y_m. New here: a reference solution curve, markers on the RK4 starting
# values, and a lower panel with the error |e_k| on a log scale.
# The cube root is the real cube root (cbrt), which reproduces the y(5) values
# printed on Mathews' frames once a run goes negative.
# Produces: milneaa.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
fmt(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%.4g", x)
# end values to 7 significant figures, trailing zeros kept (the Float64 run and
# the reference are both accurate far beyond this)
fmt7(x) = @sprintf("%#.7g", x)
sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))   # 12 -> "₁₂"

# --- Parameters ---
f(t, y) = 1 - t * cbrt(y)        # real cube root
a, b, alpha = 0.0, 5.0, 1.0
ms = [12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60,
      70, 80, 90, 100, 120, 150]   # the m values on Mathews' frames
ylims_top = (-0.9, 2.1)          # holds every computed y_k (min -0.757, max 1.927)
ylims_err = (1e-12, 10.0)        # holds every |e_k|, k >= 1 (min 1.6e-11, max 1.92)
level = 0.01                     # error level marked in the lower panel

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

# --- Reference solution at the grid points: RK4 in BigFloat with K and 2K
# substeps per grid step, combined by Richardson extrapolation (error ~1e-16) ---
setprecision(BigFloat, 128)
function rk4fine(m, K)
    H = big(b - a) / m; h = H / K
    y = big(alpha); out = [y]
    for k in 0:m-1, j in 0:K-1
        t = big(a) + k * H + j * h
        k1 = h * f(t, y); k2 = h * f(t + h / 2, y + k1 / 2)
        k3 = h * f(t + h / 2, y + k2 / 2); k4 = h * f(t + h, y + k3)
        y += (k1 + 2k2 + 2k3 + k4) / 6
        j == K - 1 && push!(out, y)
    end
    out
end
function reference(m)
    K = cld(6000, m)
    (16 .* rk4fine(m, 2K) .- rk4fine(m, K)) ./ 15
end

# smooth reference curve for drawing (Float64 RK4 on a fine grid)
function curve(n)
    h = (b - a) / n; t = collect(range(a, b, length=n + 1)); y = zeros(n + 1); y[1] = alpha
    for i in 1:n
        k1 = h * f(t[i], y[i]); k2 = h * f(t[i] + h / 2, y[i] + k1 / 2)
        k3 = h * f(t[i] + h / 2, y[i] + k2 / 2); k4 = h * f(t[i] + h, y[i] + k3)
        y[i+1] = y[i] + (k1 + 2k2 + 2k3 + k4) / 6
    end
    t, y
end
tc, yc = curve(2000)
yref_end = Float64(reference(12)[end])   # y(5)

# --- Pre-compute every run ---
runs = map(ms) do m
    t, y = milne(m)
    r = reference(m)
    e = Float64.(r .- big.(y))           # e_k = y(t_k) - y_k, differenced in BigFloat
    @assert minimum(y) > ylims_top[1] && maximum(y) < ylims_top[2]
    @assert all(ylims_err[1] .< abs.(e[2:end]) .< ylims_err[2])
    (m=m, t=t, y=y, e=e)
end

# --- Animation: one frame per m, last frame held ---
frames = vcat(1:length(ms), fill(length(ms), 2))
anim = @animate for i in frames
    R = runs[i]; m = R.m
    kmax = argmax(abs.(R.e))
    p1 = plot(xlims=(a, b), ylims=ylims_top, xlabel="", ylabel="y",
              title="Milne-Simpson: y′ = 1 − t ∛y, y(0) = 1,  m = $m, h = 5/$m",
              titlefontsize=11, legend=:bottomleft, legendfontsize=8,
              grid=true, framestyle=:box, background_color=:white)
    plot!(p1, tc, yc; color=:green, lw=1.5, label="reference solution")
    plot!(p1, R.t, R.y; color=:magenta, lw=2, marker=:circle, ms=2.5,
          markerstrokewidth=0, label="Milne-Simpson (tₖ, yₖ)")
    scatter!(p1, R.t[2:4], R.y[2:4]; color=:orange, ms=4, markerstrokewidth=0.5,
             label="RK4 starting values y₁, y₂, y₃")
    scatter!(p1, [a], [alpha]; color=:red, ms=5, markerstrokewidth=0, label="y(0) = 1")
    annotate!(p1, 1.75, 1.95, text("computed y$(sub(m)) = $(fmt7(R.y[end]))", 10, :left))
    annotate!(p1, 1.75, 1.72, text("reference y(5) = $(fmt7(yref_end))", 10, :left))

    p2 = plot(xlims=(a, b), ylims=ylims_err, yscale=:log10, xlabel="t",
              ylabel="|eₖ|", yticks=10.0 .^ (-12:3:0),
              title="e$(sub(m)) = y(5) − y$(sub(m)) = $(fmt(R.e[end])),   max |eₖ| = $(fmt(abs(R.e[kmax]))) at t = $(fmt(R.t[kmax]))",
              titlefontsize=9, legend=:topleft, legendfontsize=8,
              grid=true, framestyle=:box, background_color=:white)
    hline!(p2, [level]; color=:gray, ls=:dash, lw=1, label="|e| = 0.01")
    plot!(p2, R.t[2:end], abs.(R.e[2:end]); color=:magenta, lw=1.5, marker=:circle,
          ms=2, markerstrokewidth=0, label="|eₖ| = |y(tₖ) − yₖ|, k ≥ 1")

    plot(p1, p2; layout=grid(2, 1, heights=[0.62, 0.38]), size=(640, 720),
         left_margin=3Plots.mm)
end

gif(anim, joinpath(@__DIR__, "milneaa.gif"); fps=1)
println("Saved: milneaa.gif")
