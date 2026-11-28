# montecarloaa.jl
# Monte Carlo Integration animation: the sample-mean estimate of Example 3,
# I = ∫₀⁴ √x dx = 16/3, as uniform random points accumulate from n = 2 to
# n = 10000 (one seeded run of Julia's Xoshiro256++ generator, seed 3).
# Top panel: f(x) = √x with the sampled points (x_i, f(x_i)) on the graph and the
# rectangle of base 4 and height = mean of the f(x_i), whose area is the estimate.
# Middle panel: the running estimate with a band of ± one estimated standard
# error, formula (4) of the page. Bottom panel: on log-log axes, the size of the
# actual error, the estimated standard error and the true standard deviation
# 4√2/(3√n), so the 1/√n shrinkage stays visible after the middle panel's band
# has become too narrow to see.
# New animation: Mathews' module has no Monte Carlo animation.
# Produces: montecarloaa.gif

using Plots
using Printf
using Random
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
fmt(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%.4g", x)
fmts(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%+.4g", x)   # signed
fmtr(x) = @sprintf("%#.4g", x)    # ratio: keeps trailing zeros, so 1.00015 prints 1.000

# --- Parameters (Example 3) ---
f(x) = sqrt(x)
a, b = 0.0, 4.0
I_exact = 16 / 3                      # ∫₀⁴ √x dx = (2/3)·4^(3/2)
sd_const = 4 * sqrt(2) / 3            # (b − a)·σ_f with σ_f² = 2/9, so SD = sd_const/√n
seed = 3
N = 10_000

# --- One seeded stream of N uniform points on [a, b] ---
rng = Xoshiro(seed)
xs = a .+ (b - a) .* rand(rng, N)
fx = f.(xs)

# Running sample mean of f and of f², estimate (3) and estimated error (4)
k = 1:N
fbar = cumsum(fx) ./ k
f2bar = cumsum(fx .^ 2) ./ k
Ihat = (b - a) .* fbar
var_hat = f2bar .- fbar .^ 2          # divides by n, as formula (4) does
@assert all(var_hat[2:end] .> 0)
se_hat = [(b - a) * sqrt(var_hat[j] / j) for j in k]   # se_hat[1] = 0: not used
err = Ihat .- I_exact
@assert all(err .!= 0)
sd_true(n) = sd_const / sqrt(n)

# --- Frames: n = 2, ..., 10, then 10 sample sizes per decade up to 10000 ---
ns = unique(vcat(2:10, [round(Int, 10^(1 + j / 10)) for j in 1:30]))
@assert ns[end] == N && all(in(ns), [10, 100, 1000, 10000])
hold = 6                              # extra copies of the last frame

# --- Fixed axes ---
xplot = range(a, b; length=400)
xl_n = (1.6, 1.4e4)
yl_est = (I_exact - 2.0, I_exact + 2.0)
yl_err = (1e-4, 4.0)
title_top = "Example 3: ∫₀⁴ √x dx = 16/3 ≈ 5.333, sample-mean Monte Carlo"

function frame(i)
    n = ns[i]
    nprev = i == 1 ? 0 : ns[i - 1]
    old = 1:nprev
    new = (nprev + 1):n
    est, se, e = Ihat[n], se_hat[n], err[n]

    # Top: graph, points, rectangle of height mean f
    p1 = plot(xlims=(a, b), ylims=(0.0, 2.35), xlabel="x", ylabel="f(x)",
              title=title_top, titlefontsize=10, legend=:topleft,
              legendfontsize=7, framestyle=:box, grid=true)
    plot!(p1, [a, b, b, a, a], [0, 0, fbar[n], fbar[n], 0]; seriestype=:shape,
          fillcolor=RGB(1.0, 0.91, 0.75), linecolor=:darkorange, lw=1.5,
          label="height = mean of f(xᵢ) = $(fmt(fbar[n])), area = estimate = $(fmt(est))")
    hline!(p1, [I_exact / (b - a)]; color=:green, ls=:dash, lw=1.5,
           label="exact mean height 4/3 ≈ 1.333")
    plot!(p1, xplot, f.(xplot); color=:blue, lw=2, label="f(x) = √x")
    if !isempty(old)
        scatter!(p1, xs[old], fx[old]; color=:gray40, ms=2.2, markerstrokewidth=0,
                 label="earlier points (xᵢ, f(xᵢ))")
    end
    scatter!(p1, xs[new], fx[new]; color=:red, ms=length(new) <= 50 ? 3.5 : 2.2,
             markerstrokewidth=0,
             label=length(new) == 1 ? "new point" : "$(length(new)) new points")

    # Middle: running estimate with ± one estimated standard error
    kk = 2:n
    p2 = plot(xscale=:log10, xlims=xl_n, ylims=yl_est, xlabel="n",
              ylabel="estimate", legend=:topright, legendfontsize=7,
              framestyle=:box, grid=true, titlefontsize=10,
              title="n = $n:  estimate $(fmt(est)) ± $(fmt(se)) (est. SE),  error $(fmts(e))")
    plot!(p2, kk, Ihat[kk]; ribbon=se_hat[kk], fillcolor=RGB(1.0, 0.87, 0.70), fillalpha=1, color=:darkorange,
          lw=1.5, label="running estimate ± estimated SE (4)")
    nn = 10 .^ range(log10(2), log10(xl_n[2]); length=300)   # log-spaced, n ≥ 2
    plot!(p2, nn, I_exact .+ sd_true.(nn); color=:gray50, ls=:dot, lw=1.5,
          label="16/3 ± true SD 1.886/√n")
    plot!(p2, nn, I_exact .- sd_true.(nn); color=:gray50, ls=:dot, lw=1.5, label="")
    hline!(p2, [I_exact]; color=:green, ls=:dash, lw=1.5, label="exact 16/3")
    scatter!(p2, [n], [est]; color=:red, ms=4, markerstrokewidth=0, label="")

    # Bottom: log-log sizes
    p3 = plot(xscale=:log10, yscale=:log10, xlims=xl_n, ylims=yl_err, xlabel="n",
              ylabel="size of error", legend=:topright, legendfontsize=7,
              framestyle=:box, grid=true, titlefontsize=10,
              title="n = $n:  |error| = $(fmt(abs(e))) = $(fmtr(abs(e) / se)) estimated SE")
    plot!(p3, nn, sd_true.(nn); color=:black, ls=:dash, lw=1.5,
          label="true SD 4√2/(3√n) = 1.886/√n (slope −1/2)")
    plot!(p3, kk, se_hat[kk]; color=:darkorange, lw=1.8, label="estimated SE (4)")
    plot!(p3, kk, abs.(err[kk]); color=:steelblue, lw=1, label="|estimate − 16/3|")
    scatter!(p3, [n], [abs(e)]; color=:red, ms=4, markerstrokewidth=0, label="")

    plot(p1, p2, p3; layout=@layout([a{0.4h}; b; c]), size=(720, 980),
         background_color=:white, left_margin=3Plots.mm, bottom_margin=1Plots.mm)
end

anim = @animate for i in vcat(1:length(ns), fill(length(ns), hold))
    frame(i)
end

gif(anim, joinpath(@__DIR__, "montecarloaa.gif"); fps=3)
println("Saved: montecarloaa.gif")
