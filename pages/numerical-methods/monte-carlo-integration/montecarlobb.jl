# montecarlobb.jl
# Monte Carlo Integration animation: Example 14, the quintuple integral
#   I = ∫ √(6 − x² − y² − z² − u² − w²) dV over [0,0.7]×[0,0.8]×[0,0.9]×[0,1]×[0,1.1],
# estimated by sample-mean Monte Carlo as uniform random points in the box
# accumulate from n = 2 to n = 16807 (one seeded run of Julia's Xoshiro256++
# generator, seed 14), against the product midpoint rule with m = 2, ..., 7
# midpoints per axis, which uses n = m⁵ = 32, 243, 1024, 3125, 7776, 16807 points.
# Top panel: the running Monte Carlo estimate with a band of ± one estimated
# standard error (formula (7) of the page), the reference value and the midpoint
# values, each shown once the run has reached its n. Bottom panel: on log-log
# axes, the size of the Monte Carlo error, its estimated standard error, the true
# standard deviation V·σ_f/√n (slope −1/2) and the midpoint errors.
# New animation: Mathews' module has no Monte Carlo animation.
# Produces: montecarlobb.gif

using Plots
using Printf
using Random
using LinearAlgebra
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
fmt(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%.4g", x)
fmts(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%+.4g", x)   # signed
fmtr(x) = @sprintf("%#.4g", x)    # ratio: keeps trailing zeros, so 1.00015 prints 1.000
fmt8(x) = @sprintf("%.8g", x)         # estimates: enough digits to show the error

# --- Parameters (Example 14) ---
const d = 5
widths = (0.7, 0.8, 0.9, 1.0, 1.1)    # box [0, wⱼ] in each coordinate
V = prod(widths)                      # volume 0.5544
f(X) = sqrt(6 - sum(abs2, X))
seed = 14
N = 16807                             # = 7⁵, the largest midpoint n
ms = 2:7

# --- Reference value: tensor-product Gauss–Legendre, 16 nodes per axis ---
# (Golub–Welsch: nodes are eigenvalues of the Jacobi matrix, weights 2·v₁²)
function gauss_legendre(q)
    β = [j / sqrt(4j^2 - 1) for j in 1:(q - 1)]
    E = eigen(SymTridiagonal(zeros(q), β))
    E.values, 2 .* E.vectors[1, :] .^ 2
end
function tensor_gl(q)
    t, wt = gauss_legendre(q)
    s = 0.0
    for J in CartesianIndices(ntuple(_ -> q, d))
        X = ntuple(j -> widths[j] * (t[J[j]] + 1) / 2, d)
        s += prod(wt[J[j]] for j in 1:d) * f(X)
    end
    s * V / 2^d
end
I_ref = tensor_gl(16)
@assert abs(I_ref - tensor_gl(12)) < 1e-11

# True standard deviation of the estimate: V·σ_f/√n, with the exact mean of
# f² = 6 − Σ wⱼ²/3 (a polynomial) and the reference value for the mean of f
mean_f2 = 6 - sum(abs2, widths) / 3
sd_const = V * sqrt(mean_f2 - (I_ref / V)^2)
sd_true(n) = sd_const / sqrt(n)

# --- Product midpoint rule with m midpoints per axis, n = m⁵ points ---
function midpoint(m)
    s = 0.0
    for J in CartesianIndices(ntuple(_ -> m, d))
        s += f(ntuple(j -> widths[j] * (J[j] - 0.5) / m, d))
    end
    V * s / m^d
end
n_mid = [m^d for m in ms]
M_mid = [midpoint(m) for m in ms]
e_mid = M_mid .- I_ref
@assert n_mid[end] == N && all(e_mid .> 0)

# --- One seeded stream of N uniform points in the box ---
rng = Xoshiro(seed)
U = rand(rng, d, N)                   # column i is the i-th point, scaled below
fx = [f(ntuple(j -> widths[j] * U[j, i], d)) for i in 1:N]

k = 1:N
fbar = cumsum(fx) ./ k
f2bar = cumsum(fx .^ 2) ./ k
Ihat = V .* fbar
var_hat = f2bar .- fbar .^ 2          # divides by n, as formula (7) does
@assert all(var_hat[2:end] .> 0)
se_hat = [V * sqrt(var_hat[j] / j) for j in k]         # se_hat[1] = 0: not used
err = Ihat .- I_ref
@assert all(err .!= 0)

# --- Frames: n = 2, ..., 10, ten sample sizes per decade, and every m⁵ ---
ns = sort(unique(vcat(2:10, [round(Int, 10^(1 + j / 10)) for j in 1:32], n_mid)))
@assert ns[end] == N
hold = 6

# --- Fixed axes ---
xl_n = (1.6, 2.4e4)
yl_est = (I_ref - 0.07, I_ref + 0.07)
yl_err = (1e-5, 0.3)
nn = 10 .^ range(log10(2), log10(xl_n[2]); length=300)
title_top = "Example 14: 5-D ∫ √(6 − x² − y² − z² − u² − w²) dV over\n" *
            "[0,0.7]×[0,0.8]×[0,0.9]×[0,1]×[0,1.1] ≈ $(fmt8(I_ref))"

function frame(i)
    n = ns[i]
    est, se, e = Ihat[n], se_hat[n], err[n]
    shown = findall(<=(n), n_mid)     # midpoint values reached so far
    kk = 2:n
    # Every frame has the same number of title lines, so the panels do not move
    mtxt = isempty(shown) ? "\nmidpoint rule: first value at n = 2⁵ = 32" :
        "\nmidpoint m = $(ms[shown[end]]) (n = $(n_mid[shown[end]])): " *
        "$(fmt8(M_mid[shown[end]])), error $(fmts(e_mid[shown[end]]))"
    # on the frames where n = m⁵, compare the two errors at equal n
    jm = findfirst(==(n), n_mid)
    mcmp = jm === nothing ? "\n(errors compared at equal n on the frames n = m⁵)" :
        "\nequal n = $(n_mid[jm]): |Monte Carlo error| $(abs(e) < e_mid[jm] ? "<" : ">") " *
        "midpoint error $(fmt(e_mid[jm])) (m = $(ms[jm]))"

    p1 = plot(xscale=:log10, xlims=xl_n, ylims=yl_est, xlabel="n (function evaluations)",
              ylabel="value", legend=:topright, legendfontsize=7, framestyle=:box,
              grid=true, titlefontsize=9,
              title=title_top * "\nMonte Carlo n = $n: $(fmt8(est)) ± $(fmt(se)) " *
                    "(est. SE), error $(fmts(e))" * mtxt)
    plot!(p1, kk, Ihat[kk]; ribbon=se_hat[kk], fillcolor=RGB(1.0, 0.87, 0.70), fillalpha=1, color=:darkorange,
          lw=1.5, label="Monte Carlo estimate ± estimated SE (7)")
    plot!(p1, nn, I_ref .+ sd_true.(nn); color=:gray50, ls=:dot, lw=1.5,
          label="reference ± true SD $(fmt(sd_const))/√n")
    plot!(p1, nn, I_ref .- sd_true.(nn); color=:gray50, ls=:dot, lw=1.5, label="")
    hline!(p1, [I_ref]; color=:green, ls=:dash, lw=1.5,
           label="reference $(fmt8(I_ref)) (Gauss–Legendre)")
    if !isempty(shown)
        plot!(p1, n_mid[shown], M_mid[shown]; color=:purple, lw=1.5, marker=:diamond,
              ms=5, markerstrokewidth=0, label="midpoint rule, n = m⁵")
    end
    scatter!(p1, [n], [est]; color=:red, ms=4, markerstrokewidth=0, label="")

    p2 = plot(xscale=:log10, yscale=:log10, xlims=xl_n, ylims=yl_err,
              xlabel="n (function evaluations)", ylabel="size of error",
              legend=:topright, legendfontsize=7, framestyle=:box, grid=true,
              titlefontsize=9,
              title="n = $n:  Monte Carlo |error| = $(fmt(abs(e))) = " *
                    "$(fmtr(abs(e) / se)) estimated SE" * mcmp)
    plot!(p2, nn, sd_true.(nn); color=:black, ls=:dash, lw=1.5,
          label="Monte Carlo true SD $(fmt(sd_const))/√n (slope −1/2)")
    plot!(p2, kk, se_hat[kk]; color=:darkorange, lw=1.8, label="estimated SE (7)")
    plot!(p2, kk, abs.(err[kk]); color=:steelblue, lw=1, label="|Monte Carlo error|")
    if !isempty(shown)
        plot!(p2, n_mid[shown], e_mid[shown]; color=:purple, lw=1.5, marker=:diamond,
              ms=5, markerstrokewidth=0, label="midpoint error (all > 0)")
    end
    scatter!(p2, [n], [abs(e)]; color=:red, ms=4, markerstrokewidth=0, label="")

    plot(p1, p2; layout=@layout([a; b]), size=(720, 860), background_color=:white,
         left_margin=3Plots.mm)
end

anim = @animate for i in vcat(1:length(ns), fill(length(ns), hold))
    frame(i)
end

gif(anim, joinpath(@__DIR__, "montecarlobb.gif"); fps=3)
println("Saved: montecarlobb.gif")
@printf("I_ref = %.12f, sd_const = %.8f\n", I_ref, sd_const)
for (m, n, M, em) in zip(ms, n_mid, M_mid, e_mid)
    @printf("m = %d  n = %5d  midpoint = %.10f  error = %+.4e  MC error = %+.4e  est SE = %.4e  SD = %.4e\n",
            m, n, M, em, err[n], se_hat[n], sd_true(n))
end
