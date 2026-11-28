# gaussseidelcc.jl
# Jacobi and Gauss-Seidel Iteration animation: Mathews' Examples 2 and 4, the
# equations of Example 1 listed in a different order,
#   A = [2 8 3 1; 0 2 -1 4; 7 -2 1 2; -1 0 5 2],  b = (-2, 4, 3, 5),
# Jacobi (Example 2) and Gauss-Seidel (Example 4) from P0 = (-1, 1, 0, 1),
# 10 sweeps each as in Mathews, one sweep per frame. Reordering the equations
# does not change the solution x* = (-127, -387, 302, 994)/725, but it puts
# 2, 2, 1, 2 on the diagonal, and both iterations diverge.
# New animation: Mathews' module has no animation.
# Left panel: |x_i| of the current iterates on a log scale; filled markers for
# positive coordinates, hollow markers for negative ones, black marks for |x*_i|.
# A coordinate that is exactly 0 cannot be drawn on a log axis and is named in
# the title instead. Nothing is clamped: every value lies inside the axes.
# Right panel: ||x_k - x*||_2 on a log scale with the slopes rho(B_J)^k and
# rho(B_GS)^k, both larger than 1.
# The iteration runs in exact rational arithmetic (Rational{BigInt}).
# Produces: gaussseidelcc.gif

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

# --- Parameters (Mathews' Examples 2 and 4) ---
A = Rational{BigInt}[2 8 3 1; 0 2 -1 4; 7 -2 1 2; -1 0 5 2]
b = Rational{BigInt}[-2, 4, 3, 5]
P0 = Rational{BigInt}[-1, 1, 0, 1]
xstar = Rational{BigInt}[-127, -387, 302, 994] .// 725
n_iter = 10
gif_name = "gaussseidelcc.gif"
A * xstar == b || error("x* does not solve the system")

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
PJ = [P0]; PG = [P0]
for k in 1:n_iter
    push!(PJ, jacobi_sweep(PJ[end]))
    push!(PG, gs_sweep(PG[end]))
end
eJ = [Float64(norm2(P - xstar)) for P in PJ]
eG = [Float64(norm2(P - xstar)) for P in PG]
# Gauss-Seidel solves the last equation exactly in every sweep
all((A*P)[4] == b[4] for P in PG[2:end]) || error("row 4 residual of Gauss-Seidel is not 0")

Af = Float64.(A)
D = Diagonal(diag(Af)); Lm = -tril(Af, -1); Um = -triu(Af, 1)
rhoJ = maximum(abs.(eigvals(Matrix(D) \ (Lm + Um))))
rhoG = maximum(abs.(eigvals((Matrix(D) - Lm) \ Um)))
println("rho_J = ", rhoJ, "   rho_GS = ", rhoG)

# --- Axes (checked: no value is clamped) ---
ylL = (1e-2, 1e19)                  # headroom above 1e15 for the legend
ylR = (1.0, 1e15)
for P in vcat(PJ, PG), v in P
    v == 0 && continue
    ylL[1] < abs(Float64(v)) < 1e15 || error("left panel value $(Float64(v)) off scale")
end
all(ylR[1] < e < ylR[2] for e in vcat(eJ, eG)) || error("error off scale")
xsf = Float64.(xstar)

function frame(k)
    xJ = PJ[k+1]; xG = PG[k+1]
    pL = plot(xlims=(0.4, 4.6), ylims=ylL, yscale=:log10, framestyle=:box,
              xticks=(1:4, ["x₁", "x₂", "x₃", "x₄"]), ylabel="|xᵢ|",
              yticks=10.0 .^ (-2:2:14), legend=:topleft, legend_columns=2, legendfontsize=7,
              titlefontsize=10, minorgrid=false)
    for i in 1:4
        plot!(pL, [i - 0.4, i + 0.4], [abs(xsf[i]), abs(xsf[i])]; color=:black, lw=2.5,
              label=(i == 1 ? "|x*ᵢ|, x* = (−127, −387, 302, 994)/725" : ""))
    end
    for (P, dx, col, mk, name) in ((xJ, -0.15, :steelblue, :circle, "Jacobi"),
                                   (xG, 0.15, :red, :square, "Gauss–Seidel"))
        pos = [i for i in 1:4 if P[i] > 0]; neg = [i for i in 1:4 if P[i] < 0]
        scatter!(pL, pos .+ dx, [abs(Float64(P[i])) for i in pos]; color=col, marker=mk,
                 ms=7, markerstrokecolor=col, label=name * ", positive xᵢ")
        scatter!(pL, neg .+ dx, [abs(Float64(P[i])) for i in neg]; color=:white, marker=mk,
                 ms=7, markerstrokecolor=col, markerstrokewidth=2, label=name * ", negative xᵢ")
    end
    # exact zeros cannot be drawn on a log axis: name them in the panel
    zJ = ["x" * sub(i) for i in 1:4 if xJ[i] == 0]
    zG = ["x" * sub(i) for i in 1:4 if xG[i] == 0]
    if !isempty(zJ) || !isempty(zG)
        txt = zJ == zG ? join(zJ, ", ") * " = 0 exactly for both methods" :
              "exact zeros: Jacobi " * (isempty(zJ) ? "none" : join(zJ, ", ")) *
              ", Gauss–Seidel " * (isempty(zG) ? "none" : join(zG, ", "))
        annotate!(pL, 2.5, 0.035, text(txt * " (not drawn on the log axis)", 8, :black))
    end
    if k == 0
        title!(pL, "Starting vector x₀ = (−1, 1, 0, 1) for both methods\n ")
    else
        title!(pL, "Jacobi x" * sub(k) * " = (" * join(fmt.(xJ), ", ") * ")" *
                   "\nGauss–Seidel x" * sub(k) * " = (" * join(fmt.(xG), ", ") * ")")
    end

    pR = plot(xlims=(-0.5, n_iter + 0.5), ylims=ylR, yscale=:log10, framestyle=:box,
              xlabel="sweep k", ylabel="‖xₖ − x*‖₂", yticks=10.0 .^ (0:2:14), xticks=0:n_iter,
              legend=:topleft, legendfontsize=7, titlefontsize=10, minorgrid=false)
    ks = 0:n_iter
    plot!(pR, ks, eJ[1] .* rhoJ .^ ks; color=:steelblue, ls=:dash, lw=1, alpha=0.6,
          label="slope ρ(B_J)ᵏ, ρ(B_J) = " * @sprintf("%.4f", rhoJ))
    plot!(pR, ks, eG[1] .* rhoG .^ ks; color=:red, ls=:dash, lw=1, alpha=0.6,
          label="slope ρ(B_GS)ᵏ, ρ(B_GS) = " * @sprintf("%.4f", rhoG))
    plot!(pR, 0:k, eJ[1:k+1]; color=:steelblue, lw=1.8, marker=:circle, ms=4,
          markerstrokewidth=0, label="Jacobi (Example 2)")
    plot!(pR, 0:k, eG[1:k+1]; color=:red, lw=1.8, marker=:square, ms=4,
          markerstrokewidth=0, label="Gauss–Seidel (Example 4)")
    if k == 0
        title!(pR, "k = 0: both errors " * fmt(eJ[1]) * "\n ")
    else
        title!(pR, "k = $k:  Jacobi error " * fmt(eJ[k+1]) * " (ratio " *
                   @sprintf("%.4g", eJ[k+1] / eJ[k]) * ")\nGauss–Seidel error " *
                   fmt(eG[k+1]) * " (ratio " * @sprintf("%.4g", eG[k+1] / eG[k]) * ")")
    end

    plot(pL, pR; layout=(1, 2), size=(1300, 600),
         plot_title="Mathews' Examples 2 and 4 (Example 1 reordered):  A = [2 8 3 1; 0 2 −1 4; 7 −2 1 2; −1 0 5 2],  b = (−2, 4, 3, 5)",
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         top_margin=2Plots.mm, background_color=:white)
end

frames = vcat(collect(0:n_iter), fill(n_iter, 3))     # hold the last frame
anim = @animate for k in frames
    frame(k)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: $gif_name  (", length(frames), " frames)")
println("Jacobi x10 = ", Float64.(PJ[end]), "  error ", eJ[end], "  A x10 = ", Float64.(A * PJ[end]))
println("Gauss-Seidel x10 = ", Float64.(PG[end]), "  error ", eG[end], "  A x10 = ", Float64.(A * PG[end]))
