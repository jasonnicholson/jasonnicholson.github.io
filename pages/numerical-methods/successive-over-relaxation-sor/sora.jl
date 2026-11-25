# sora.jl
# SOR animation: Mathews' Example 1, the 9 x 9 tridiagonal system
#   A = tridiag(1, 2, 1),  b = (1, 2, 3, 4, 5, 4, 3, 2, 1),  x0 = (1, ..., 1),
# solved by Jacobi, Gauss-Seidel and SOR with omega = 3/2, the value Mathews'
# command SORmethod[A, B, P, 1.5, 10] actually uses (his text says 1.25).
# One iteration of each method per frame, k = 0, ..., 20 (Example 1(b)).
# New animation: Mathews' SOR module has no animation.
# Left panel: the nine components of each iterate against the index i, over
# grey bars of the exact solution x* = (1/2, 0, 3/2, 0, 5/2, 0, 3/2, 0, 1/2).
# Right panel: the error ||x_k - x*||_inf of each method on a log scale.
# The iterations run in exact rational arithmetic (Rational{BigInt}); every
# error is exact before it is rounded for display.
# Produces: sora.gif

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
# Significant-figure label (exact arithmetic, so a zero is an exact zero)
fmt(x) = x == 0 ? "0 (exact)" : tenpow(@sprintf("%.4g", Float64(x)))

# --- Parameters (Mathews' Example 1) ---
const R = Rational{BigInt}
n = 9
A = R[i == j ? 2 : (abs(i - j) == 1 ? 1 : 0) for i in 1:n, j in 1:n]
b = R[1, 2, 3, 4, 5, 4, 3, 2, 1]
x0 = fill(R(1), n)
omega = R(3, 2)
kmax = 20
xstar = R[1//2, 0, 3//2, 0, 5//2, 0, 3//2, 0, 1//2]
A * xstar == b || error("x* does not solve A x = b")
gif_name = "sora.gif"

# --- The three methods (componentwise, as on the page) ---
function jacobi(x)
    [(b[i] - sum(A[i, j] * x[j] for j in 1:n if j != i)) / A[i, i] for i in 1:n]
end
function sor(x, w)                       # w = 1 is Gauss-Seidel
    y = copy(x)
    for i in 1:n
        gs = (b[i] - sum(A[i, j] * y[j] for j in 1:n if j != i)) / A[i, i]
        y[i] = (1 - w) * y[i] + w * gs
    end
    return y
end

XJ = [x0]; XG = [x0]; XS = [x0]
for k in 1:kmax
    push!(XJ, jacobi(XJ[end]))
    push!(XG, sor(XG[end], R(1)))
    push!(XS, sor(XS[end], omega))
end
# Mathews' printed P1 for this run (omega = 1.5): first three components
XS[2][1:3] == R[-1//2, 5//8, 17//32] || error("first SOR sweep differs from Mathews' P1")

errinf(x) = maximum(abs.(x .- xstar))
EJ = [Float64(errinf(x)) for x in XJ]
EG = [Float64(errinf(x)) for x in XG]
ES = [Float64(errinf(x)) for x in XS]
all(e -> e > 0, vcat(EJ, EG, ES)) || error("an exact zero error cannot go on a log axis")

# spectral radii of the iteration matrices (A = D - L - U)
Af = Float64.(A); D = Diagonal(diag(Af)); L = -tril(Af, -1); U = -triu(Af, 1)
rho(T) = maximum(abs.(eigvals(T)))
rhoJ = rho(D \ (L + U))
rhoG = rho((D - L) \ U)
rhoS = rho((D - Float64(omega) * L) \ ((1 - Float64(omega)) * D + Float64(omega) * U))

# axis limits from every value drawn, so nothing is clamped
allv = Float64.(vcat(XJ..., XG..., XS..., xstar))
ylL = (floor(minimum(allv) * 4) / 4 - 0.25, ceil(maximum(allv) * 4) / 4 + 0.75)
emin = minimum(vcat(EJ, EG, ES))
ylR = (10.0^floor(log10(emin)), 10.0^ceil(log10(maximum(vcat(EJ, EG, ES)))))

# --- Frames ---
idx = 1:n
function frame(k)
    pL = plot(xlims=(0.4, n + 0.6), ylims=ylL, xticks=1:n, framestyle=:box,
              xlabel="component index i", ylabel="xᵢ", legend=:topleft,
              legendfontsize=8, titlefontsize=10, grid=false)
    bar!(pL, idx, Float64.(xstar); color=:lightgray, linecolor=:gray, bar_width=0.7,
         label="exact x* = (½, 0, 3/2, 0, 5/2, 0, 3/2, 0, ½)")
    hline!(pL, [0.0]; color=:black, lw=0.5, label="")
    plot!(pL, idx .- 0.2, Float64.(XJ[k+1]); color=:darkorange, lw=1, marker=:circle,
          ms=5, markerstrokewidth=0, label="Jacobi")
    plot!(pL, idx, Float64.(XG[k+1]); color=:seagreen, lw=1, marker=:diamond,
          ms=5, markerstrokewidth=0, label="Gauss-Seidel (ω = 1)")
    plot!(pL, idx .+ 0.2, Float64.(XS[k+1]); color=:royalblue, lw=1.5, marker=:square,
          ms=4.5, markerstrokewidth=0, label="SOR, ω = 1.5")
    title!(pL, k == 0 ? "Starting vector x⁽⁰⁾ = (1, 1, …, 1)" :
                        "Iterates after k = $k sweep" * (k == 1 ? "" : "s"))

    pR = plot(xlims=(-0.5, kmax + 0.5), ylims=ylR, yscale=:log10, framestyle=:box,
              xlabel="iteration k", ylabel="‖x⁽ᵏ⁾ − x*‖∞", legend=:bottomleft,
              legendfontsize=8, titlefontsize=10, xticks=0:2:kmax, minorgrid=false)
    plot!(pR, 0:k, EJ[1:k+1]; color=:darkorange, lw=1.5, marker=:circle, ms=4,
          markerstrokewidth=0, label="Jacobi, ρ = " * fmt(rhoJ))
    plot!(pR, 0:k, EG[1:k+1]; color=:seagreen, lw=1.5, marker=:diamond, ms=4,
          markerstrokewidth=0, label="Gauss-Seidel, ρ = " * fmt(rhoG))
    plot!(pR, 0:k, ES[1:k+1]; color=:royalblue, lw=2, marker=:square, ms=3.5,
          markerstrokewidth=0, label="SOR ω = 1.5, ρ = " * fmt(rhoS))
    title!(pR, "k = $k:  Jacobi " * fmt(EJ[k+1]) * ",  Gauss-Seidel " * fmt(EG[k+1]) *
               ",  SOR " * fmt(ES[k+1]))

    plot(pL, pR; layout=(1, 2), size=(1150, 540),
         plot_title="Mathews' Example 1: tridiag(1, 2, 1) x = (1, 2, 3, 4, 5, 4, 3, 2, 1), Jacobi vs Gauss-Seidel vs SOR (ω = 1.5)",
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white)
end

frames = vcat(collect(0:kmax), fill(kmax, 3))       # hold the last frame
anim = @animate for k in frames
    frame(k)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=2)
println("Saved: $gif_name  (", length(frames), " frames)")
@printf("rho: J %.6f  GS %.6f  SOR %.6f\n", rhoJ, rhoG, rhoS)
@printf("errors k=10: %.6g %.6g %.6g   k=20: %.6g %.6g %.6g\n",
        EJ[11], EG[11], ES[11], EJ[21], EG[21], ES[21])
println("SOR x10 = ", [@sprintf("%.6g", Float64(v)) for v in XS[11]])
println("ylims left ", ylL, "  right ", ylR)
