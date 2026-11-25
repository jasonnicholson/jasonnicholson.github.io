# gaussseidelbb.jl
# Jacobi and Gauss-Seidel Iteration animation: Mathews' Example 6 (the system of
# Examples 1 and 3), both methods from P0 = (0, -1, 1, 1) with his stopping test
#   stop when ||P_k - P_(k-1)||_2 <= eps = 1e-6   (at most 50 sweeps),
# one sweep per frame, k = 0, ..., 26. Gauss-Seidel stops at k = 14 and Jacobi at
# k = 26, as in Mathews' output.
# New animation: Mathews' module has no animation.
# Left panel: the coordinates of the Jacobi and Gauss-Seidel iterates as bars,
# with the exact solution x* = (-127, -387, 302, 994)/725 as black marks.
# Right panel: ||x_k - x*||_2 and the step ||x_k - x_(k-1)||_2 of the stopping
# test on a log scale, with the slopes rho(B_J)^k and rho(B_GS)^k of the
# iteration matrices B_J = D^(-1)(L + U) and B_GS = (D - L)^(-1) U.
# The iteration runs in exact rational arithmetic (Rational{BigInt}); norms are
# taken in 256-bit floating point after the exact subtraction.
# Produces: gaussseidelbb.gif

using Plots
using Printf
using LinearAlgebra
gr()
setprecision(BigFloat, 256)

const SUPS = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹']
sup(n) = (n < 0 ? "⁻" : "") * join(SUPS[d+1] for d in reverse(digits(abs(n))))
um(s) = replace(s, "-" => "−")
function tenpow(s)
    occursin('e', s) || return um(s)
    m, e = split(s, 'e')
    return um(m) * " × 10" * sup(parse(Int, e))
end
# Significant-figure label (exact arithmetic, so a zero is an exact zero)
fmt(x) = x == 0 ? "0 (exact)" : tenpow(@sprintf("%.4g", Float64(x)))
const SUBS = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉']
sub(n) = join(SUBS[d+1] for d in reverse(digits(n)))

# --- Parameters (Mathews' Examples 1, 3 and 6) ---
A = Rational{BigInt}[7 -2 1 2; 2 8 3 1; -1 0 5 2; 0 2 -1 4]
b = Rational{BigInt}[3, -2, 5, 4]
P0 = Rational{BigInt}[0, -1, 1, 1]
xstar = Rational{BigInt}[-127, -387, 302, 994] .// 725
eps_tol = big(1) // big(10)^6
max_iter = 50
gif_name = "gaussseidelbb.gif"
A * xstar == b || error("x* does not solve the system")

# --- Sweeps (Mathews' loops: Jacobi uses only the old vector, Gauss-Seidel
#     overwrites each coordinate as soon as it is computed) ---
function jacobi_sweep(P)
    n = length(P)
    return [(b[i] - sum(A[i, j] * P[j] for j in 1:n if j != i)) / A[i, i] for i in 1:n]
end
function gs_sweep(P)
    Q = copy(P); n = length(P)
    for i in 1:n
        Q[i] = (b[i] - sum(A[i, j] * Q[j] for j in 1:n if j != i)) / A[i, i]
    end
    return Q
end
norm2(v) = sqrt(sum(BigFloat.(v) .^ 2))
function run(sweep)
    Ps = [P0]; steps = BigFloat[NaN]
    for k in 1:max_iter
        P = sweep(Ps[end])
        push!(steps, norm2(P - Ps[end])); push!(Ps, P)
        steps[end] <= eps_tol && break
    end
    return Ps, steps
end
PJ, sJ = run(jacobi_sweep)
PG, sG = run(gs_sweep)
nJ = length(PJ) - 1; nG = length(PG) - 1
(nJ, nG) == (26, 14) || error("expected Mathews' 26 and 14 sweeps, got $nJ and $nG")
eJ = [Float64(norm2(P - xstar)) for P in PJ]
eG = [Float64(norm2(P - xstar)) for P in PG]
stJ = Float64.(sJ); stG = Float64.(sG)

# spectral radii of the iteration matrices (Float64 eigenvalues)
Af = Float64.(A)
D = Diagonal(diag(Af)); Lm = -tril(Af, -1); Um = -triu(Af, 1)
rhoJ = maximum(abs.(eigvals(Matrix(D) \ (Lm + Um))))
rhoG = maximum(abs.(eigvals((Matrix(D) - Lm) \ Um)))
println("rho_J = ", rhoJ, "   rho_GS = ", rhoG)

# --- Frames ---
xs_f = Float64.(xstar)
function frame(k)
    kJ = min(k, nJ); kG = min(k, nG)
    xJ = Float64.(PJ[kJ+1]); xG = Float64.(PG[kG+1])
    # Left: bars
    pL = plot(xlims=(0.4, 4.6), ylims=(-1.2, 2.0), framestyle=:box,
              xticks=(1:4, ["x₁", "x₂", "x₃", "x₄"]), ylabel="value",
              legend=:topleft, legendfontsize=8, titlefontsize=10, grid=true,
              gridalpha=0.25)
    hline!(pL, [0.0]; color=:black, lw=0.5, label="")
    bar!(pL, (1:4) .- 0.18, xJ; bar_width=0.34, color=:steelblue, linecolor=:steelblue,
         label="Jacobi x" * sub(kJ))
    bar!(pL, (1:4) .+ 0.18, xG; bar_width=0.34, color=:red, linecolor=:red, alpha=0.8,
         label="Gauss–Seidel x" * sub(kG) * (k > nG ? " (stopped)" : ""))
    for i in 1:4
        plot!(pL, [i - 0.42, i + 0.42], [xs_f[i], xs_f[i]]; color=:black, lw=2.5,
              label=(i == 1 ? "x* = (−127, −387, 302, 994)/725" : ""))
    end
    if k == 0
        title!(pL, "Starting vector x₀ = (0, −1, 1, 1) for both methods\n ")
    else
        title!(pL, "Jacobi x" * sub(kJ) * " = (" * join(fmt.(xJ), ", ") * ")" *
                   "\nGauss–Seidel x" * sub(kG) * " = (" * join(fmt.(xG), ", ") * ")")
    end

    # Right: log-scale errors
    pR = plot(xlims=(-0.5, nJ + 0.5), ylims=(1e-8, 10.0), yscale=:log10,
              framestyle=:box, xlabel="sweep k", ylabel="size (2-norm)",
              legend=:bottomleft, legendfontsize=7, titlefontsize=10,
              yticks=10.0 .^ (-8:0), minorgrid=false)
    hline!(pR, [1e-6]; color=:green, ls=:dot, lw=1.5, label="tolerance ε = 10⁻⁶")
    plot!(pR, 0:nJ, eJ[1] .* rhoJ .^ (0:nJ); color=:steelblue, ls=:dash, lw=1, alpha=0.5,
          label="slope ρ(B_J)ᵏ, ρ(B_J) = " * @sprintf("%.4f", rhoJ))
    plot!(pR, 0:nG, eG[1] .* rhoG .^ (0:nG); color=:red, ls=:dash, lw=1, alpha=0.5,
          label="slope ρ(B_GS)ᵏ, ρ(B_GS) = " * @sprintf("%.4f", rhoG))
    if kJ >= 1
        plot!(pR, 1:kJ, stJ[2:kJ+1]; color=:steelblue, ls=:dot, lw=1.2, marker=:utriangle,
              ms=3.5, markerstrokewidth=0, label="Jacobi step ‖xₖ − xₖ₋₁‖₂")
        plot!(pR, 1:kG, stG[2:kG+1]; color=:red, ls=:dot, lw=1.2, marker=:utriangle,
              ms=3.5, markerstrokewidth=0, label="Gauss–Seidel step")
    end
    plot!(pR, 0:kJ, eJ[1:kJ+1]; color=:steelblue, lw=1.8, marker=:circle, ms=4,
          markerstrokewidth=0, label="Jacobi error ‖xₖ − x*‖₂")
    plot!(pR, 0:kG, eG[1:kG+1]; color=:red, lw=1.8, marker=:square, ms=4,
          markerstrokewidth=0, label="Gauss–Seidel error")
    if k == 0
        title!(pR, "k = 0: both errors " * fmt(eJ[1]) * "\n ")
    else
        tJ = "k = $k:  Jacobi: error " * fmt(eJ[kJ+1]) * ", step " * fmt(stJ[kJ+1]) *
             (kJ == nJ ? " ≤ ε: stops at k = $nJ" : "")
        tG = "Gauss–Seidel: error " * fmt(eG[kG+1]) * ", step " * fmt(stG[kG+1]) *
             (kG == nG ? " ≤ ε: stops at k = $nG" : "")
        title!(pR, tJ * "\n" * tG)
    end

    plot(pL, pR; layout=(1, 2), size=(1300, 600),
         plot_title="Jacobi and Gauss–Seidel, Mathews' Example 6:  A = [7 −2 1 2; 2 8 3 1; −1 0 5 2; 0 2 −1 4],  b = (3, −2, 5, 4),  x₀ = (0, −1, 1, 1)",
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         top_margin=2Plots.mm, background_color=:white)
end

frames = vcat(collect(0:nJ), fill(nJ, 3))     # hold the last frame
anim = @animate for k in frames
    frame(k)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=2)
println("Saved: $gif_name  (", length(frames), " frames)")
println("Jacobi: k = $nJ, error ", eJ[end], ", step ", stJ[end], ", x = ", Float64.(PJ[end]))
println("Gauss-Seidel: k = $nG, error ", eG[end], ", step ", stG[end], ", x = ", Float64.(PG[end]))
