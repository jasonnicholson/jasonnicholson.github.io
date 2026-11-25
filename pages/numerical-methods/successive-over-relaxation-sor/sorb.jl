# sorb.jl
# SOR animation: sweep of the relaxation parameter omega on Mathews' Example 1,
#   A = tridiag(1, 2, 1),  b = (1, 2, 3, 4, 5, 4, 3, 2, 1),  x0 = (1, ..., 1).
# One value of omega per frame: omega = 0.10, 0.15, ..., 1.95, with the optimal
# omega_opt = 2 / (1 + sqrt(1 - rho_J^2)) = 2 / (1 + sin(pi/10)) inserted in order.
# New animation: Mathews' SOR module has no animation.
# Left panel: the error ||x_k - x*||_inf of SOR with the current omega, on a log
#   scale, until it first falls below the tolerance 1e-6 (earlier omegas in grey).
# Top right: the spectral radius rho(T_omega) of the SOR iteration matrix.
# Bottom right: the number of sweeps needed to reach the tolerance, against omega.
# Double-precision arithmetic (the tolerance is far above rounding level).
# Produces: sorb.gif

using Plots
using Printf
using LinearAlgebra
gr()

const SUPS = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹']
sup(n) = (n < 0 ? "⁻" : "") * join(SUPS[d+1] for d in reverse(digits(abs(n))))
um(s) = replace(s, "-" => "−")
function tenpow(s)                      # "1.234e-07" -> "1.234 × 10⁻⁷"
    occursin('e', s) || return um(s)
    m, e = split(s, 'e')
    return um(m) * " × 10" * sup(parse(Int, e))
end
# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
fmt(x) = x == 0 ? "0 (double-precision zero)" : tenpow(@sprintf("%.4g", x))

# --- Parameters (Mathews' Example 1) ---
n = 9
A = [i == j ? 2.0 : (abs(i - j) == 1 ? 1.0 : 0.0) for i in 1:n, j in 1:n]
b = [1.0, 2, 3, 4, 5, 4, 3, 2, 1]
x0 = ones(n)
xstar = [0.5, 0, 1.5, 0, 2.5, 0, 1.5, 0, 0.5]
tol = 1e-6
kmax = 10_000
kwin = 150                               # iterations shown in the left panel
gif_name = "sorb.gif"

D = Diagonal(diag(A)); L = -tril(A, -1); U = -triu(A, 1)
rho(T) = maximum(abs.(eigvals(T)))
Tsor(w) = (D - w * L) \ ((1 - w) * D + w * U)
rhoJ = rho(D \ (L + U))
abs(rhoJ - cos(pi / 10)) < 1e-12 || error("rho_J differs from cos(pi/10)")
wopt = 2 / (1 + sqrt(1 - rhoJ^2))

ws = sort(vcat(collect(0.10:0.05:1.95), wopt))

# --- SOR sweeps until the tolerance is met ---
function sor_run(w)
    x = copy(x0)
    errs = [maximum(abs.(x .- xstar))]
    for k in 1:kmax
        for i in 1:n
            s = b[i]
            i > 1 && (s -= A[i, i-1] * x[i-1])
            i < n && (s -= A[i, i+1] * x[i+1])
            x[i] = (1 - w) * x[i] + w * s / A[i, i]
        end
        push!(errs, maximum(abs.(x .- xstar)))
        errs[end] < tol && return errs
    end
    error("no convergence within $kmax sweeps for omega = $w")
end
runs = [sor_run(w) for w in ws]
counts = [length(e) - 1 for e in runs]
rhos = [rho(Tsor(w)) for w in ws]
all(e -> all(>(0), e), runs) || error("an exact zero error cannot go on a log axis")

# spectral-radius curve on a fine grid (with omega_opt and omega = 1 on it)
wf = sort(vcat(collect(0.01:0.005:1.99), wopt, 1.0))
rf = [rho(Tsor(w)) for w in wf]

ibest = argmin(counts)
iopt = findfirst(==(wopt), ws)
ylE = (1e-7, 10.0)

# --- Frames ---
function frame(j)
    w, e, c, r = ws[j], runs[j], counts[j], rhos[j]
    isopt = j == iopt
    wlab = isopt ? "optimal ω = " * fmt(w) : @sprintf("ω = %.2f", w)

    # Left: error history for this omega (earlier omegas in grey)
    pE = plot(xlims=(0, kwin), ylims=ylE, yscale=:log10, framestyle=:box,
              xlabel="sweep k", ylabel="‖x⁽ᵏ⁾ − x*‖∞", legend=:topright,
              legendfontsize=8, titlefontsize=10, yticks=10.0 .^ (-7:1), minorgrid=false)
    for i in 1:j-1
        m = min(counts[i], kwin)
        plot!(pE, 0:m, runs[i][1:m+1]; color=:gray80, lw=0.7, label="")
    end
    hline!(pE, [tol]; color=:green, ls=:dot, lw=1.5, label="tolerance 10⁻⁶")
    m = min(c, kwin)
    # reference slope rho^k through the last plotted error
    kr = 0:kwin
    plot!(pE, kr, e[m+1] .* r .^ (kr .- m); color=:black, ls=:dash, lw=1,
          label="slope ρ(ω)ᵏ")
    plot!(pE, 0:m, e[1:m+1]; color=:royalblue, lw=2, label="SOR, " * wlab)
    if c <= kwin
        scatter!(pE, [c], [e[end]]; color=:red, ms=5, markerstrokewidth=0,
                 label="first below 10⁻⁶ at k = $c")
    else
        plot!(pE, [NaN], [NaN]; color=:white, label="(reaches 10⁻⁶ at k = $c, off the right)")
    end
    title!(pE, "SOR on Example 1, " * wlab * ":  ρ(ω) = " * fmt(r) *
               ",  $c sweeps to reach 10⁻⁶")

    # Top right: spectral radius of T_omega
    pR = plot(xlims=(0, 2), ylims=(0, 1.05), framestyle=:box, xlabel="ω",
              ylabel="ρ(ω)", legend=:bottomleft, legendfontsize=7,
              titlefontsize=10, xticks=0:0.25:2)
    plot!(pR, wf, rf; color=:purple, lw=1.5, label="spectral radius of the SOR matrix")
    vline!(pR, [wopt]; color=:black, ls=:dash, lw=1, label="optimal ω = " * fmt(wopt))
    scatter!(pR, [1.0], [rf[findfirst(==(1.0), wf)]]; color=:seagreen, marker=:diamond,
             ms=5, markerstrokewidth=0, label="ω = 1 (Gauss-Seidel)")
    scatter!(pR, [w], [r]; color=:red, ms=6, markerstrokewidth=0, label="")
    title!(pR, "ρ(ω) = " * fmt(r) * " at " * wlab)

    # Bottom right: sweeps to tolerance, filled in as omega increases
    pC = plot(xlims=(0, 2), ylims=(10, 5000), yscale=:log10, framestyle=:box,
              xlabel="ω", ylabel="sweeps to reach 10⁻⁶", legend=:top,
              legendfontsize=7, titlefontsize=10, xticks=0:0.25:2,
              yticks=([10, 30, 100, 300, 1000, 3000], ["10", "30", "100", "300", "1000", "3000"]),
              minorgrid=false)
    vline!(pC, [wopt]; color=:black, ls=:dash, lw=1, label="optimal ω")
    plot!(pC, ws[1:j], counts[1:j]; color=:royalblue, lw=1, marker=:circle, ms=3.5,
          markerstrokewidth=0, label="")
    scatter!(pC, [w], [c]; color=:red, ms=6, markerstrokewidth=0, label="")
    if j >= ibest
        scatter!(pC, [ws[ibest]], [counts[ibest]]; color=:gold, marker=:star5, ms=9,
                 markerstrokewidth=0.5, label="fewest: $(counts[ibest]) at optimal ω")
    end
    title!(pC, "$c sweeps at " * wlab)

    l = @layout [a{0.55w} grid(2, 1)]
    plot(pE, pR, pC; layout=l, size=(1150, 600),
         plot_title="SOR on Mathews' Example 1 (tridiag(1, 2, 1), x⁽⁰⁾ = (1, …, 1)): how the speed depends on ω",
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=4Plots.mm,
         background_color=:white)
end

frames = vcat(collect(1:length(ws)), fill(length(ws), 3))
anim = @animate for j in frames
    frame(j)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=3)
println("Saved: $gif_name  (", length(frames), " frames)")
@printf("rho_J = %.10f  omega_opt = %.10f  rho(T_opt) = %.10f\n", rhoJ, wopt, rhos[iopt])
for (w, c, r) in zip(ws, counts, rhos)
    @printf("  omega = %.4f  sweeps = %5d  rho = %.6f\n", w, c, r)
end
println("fewest sweeps: ", counts[ibest], " at omega = ", ws[ibest])
