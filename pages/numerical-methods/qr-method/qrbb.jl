# qrbb.jl
# QR Method animation: Mathews' Example 4,
#   A = [4 2 2 1; 2 -3 1 1; 2 1 3 1; 1 1 1 2]  (symmetric, dense).
# The first two frames are the two Householder steps A -> P1 A P1 -> H = P2 (P1 A P1) P2,
# which make the matrix tridiagonal; then one unshifted QR step A_(k+1) = R_k Q_k
# per frame, k = 0, ..., 53 with A_0 = H (Mathews' QRmethod[H, 54] performs 53 steps).
# New animation: Mathews' QR Method module has no animation.
# Left panel: the current matrix as a heat map of log10|a_ij|, each entry printed.
# Right panels: the diagonal entries d_j against the eigenvalues, and on a log scale
# the subdiagonal sizes |e_j| with dashed lines of the predicted slopes
# |lambda_(j+1)/lambda_j|^k, and the largest diagonal error max_j |d_j - lambda_j|.
# Householder vectors: v = x - alpha e1 with alpha = -sign(x1) ||x||, as on the page.
# Every QR factorization uses positive diagonal entries in R (unique), so the signs of
# the off-diagonal entries can differ from Mathews' printouts; their sizes do not.
# Arithmetic: 256-bit BigFloat, Householder QR from LinearAlgebra.
# Produces: qrbb.gif

using Plots
using Printf
using LinearAlgebra
gr()
setprecision(BigFloat, 256)

const SUPS = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹']
sup(n) = (n < 0 ? "⁻" : "") * join(SUPS[d+1] for d in reverse(digits(abs(n))))
um(s) = replace(s, "-" => "−")
function tenpow(s)                         # "1.234e-07" -> "1.234 × 10⁻⁷"
    occursin('e', s) || return um(s)
    m, e = split(s, 'e')
    return um(m) * " × 10" * sup(parse(Int, e))
end
# Significant-figure labels; a value is never rounded to 0 and never printed as -0
fmt(x) = x == 0 ? "0 (rounding-level zero)" : tenpow(@sprintf("%#.4g", Float64(x)))
# two-line form for a heat-map cell: "3.568" over "× 10⁻⁶"
cellfmt(x) = replace(fmt(x), " × " => "\n× ")
fmtd(x) = um(@sprintf("%.6f", Float64(x)))     # diagonal entries, |d| > 0.16 at every k
const SUBS = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉']
sub(n) = join(SUBS[d+1] for d in reverse(digits(n)))

# --- Parameters (Mathews' Example 4) ---
A = BigFloat[4 2 2 1; 2 -3 1 1; 2 1 3 1; 1 1 1 2]
nsteps = 53
s7 = sqrt(big(7))
lam = [4 + s7, -1 - s7, -1 + s7, 4 - s7]           # decreasing |lambda|
ratios = [abs(lam[j+1] / lam[j]) for j in 1:3]
chop = 5e-6                                # Mathews' Chop threshold
blank_tol = big(10)^-60                    # below this an entry is a rounding-level zero
gif_name = "qrbb.gif"
n = 4

# --- Householder reduction to tridiagonal form ---
function householder_step(M, k)
    x = M[k+1:n, k]
    alpha = -sign(x[1]) * norm(x)
    v = zeros(BigFloat, n)
    v[k+1:n] = x
    v[k+1] -= alpha
    P = Matrix{BigFloat}(I, n, n) - 2 * v * v' / dot(v, v)
    return P * M * P
end
A1 = householder_step(A, 1)
H = householder_step(A1, 2)
Hexact = BigFloat[4 -3 0 0; -3 2 sqrt(big(10)) 0; 0 sqrt(big(10)) -7//5 -1//5; 0 0 -1//5 7//5]
maximum(abs.(H - Hexact)) < blank_tol || error("H differs from Mathews' H")

function qrpos(M)                          # QR with positive diagonal in R
    F = qr(M)
    Q = Matrix(F.Q)
    R = Matrix(F.R)
    s = [r < 0 ? -one(r) : one(r) for r in diag(R)]
    return Q .* s', s .* R
end

# --- The QR run ---
As = [H]
for k in 1:nsteps
    Q, R = qrpos(As[end])
    push!(As, R * Q)
end
offband = maximum(abs(M[i, j]) for M in As for i in 1:n for j in 1:n if abs(i - j) > 1)
asym = maximum(abs(M[i, j] - M[j, i]) for M in As for i in 1:n for j in 1:n)
(offband < blank_tol && asym < blank_tol) || error("iterates left symmetric tridiagonal form")
ks = 0:nsteps
d = [Float64(As[k+1][j, j]) for k in ks, j in 1:n]
e = [Float64(abs(As[k+1][j+1, j])) for k in ks, j in 1:n-1]
derr = [Float64(maximum(abs(As[k+1][j, j] - lam[j]) for j in 1:n)) for k in ks]
kfirst = findfirst(k -> maximum(e[k+1, :]) < chop, ks) - 1
kfirst == 53 || error("expected all |e_j| < 5e-6 first at step 53, got $kfirst")

# --- Panels ---
const CL = (-18.0, 1.0)                    # colour range of log10|a_ij|; min over the run is -17.5
minimum(log10.(e)) > CL[1] || error("colour range clips an entry")
cols = [:royalblue, :darkorange, :seagreen, :crimson]

function matpanel(M, ttl)
    Z = [abs(M[i, j]) < blank_tol ? NaN : log10(Float64(abs(M[i, j]))) for i in 1:n, j in 1:n]
    p = heatmap(1:n, 1:n, Z; yflip=true, c=:viridis, clims=CL, aspect_ratio=:equal,
                xlims=(0.5, n + 0.5), ylims=(0.5, n + 0.5), xticks=1:n, yticks=1:n,
                framestyle=:box, colorbar_title="log₁₀ |aᵢⱼ|", titlefontsize=10,
                xlabel="column j", ylabel="row i", title=ttl)
    for i in 1:n, j in 1:n
        isnan(Z[i, j]) && continue
        lbl = i == j ? fmtd(M[i, j]) : cellfmt(M[i, j])
        tc = Z[i, j] < -7 ? :white : :black
        annotate!(p, j, i, text(lbl, 8, tc))
    end
    return p
end

function diagpanel(k)                      # k < 0: Householder stage, no QR steps yet
    p = plot(xlims=(-0.5, nsteps + 0.5), ylims=(-4.5, 7.5), framestyle=:box,
             xlabel="QR step k", ylabel="diagonal entry", legend=:outerright,
             legendfontsize=7, titlefontsize=10,
             title=(k < 0 ? "Eigenvalues λⱼ (dashed); QR steps start from H" :
                    "Diagonal dⱼ of A" * sub(k) * " and the eigenvalues λⱼ (dashed)"))
    for j in 1:n
        hline!(p, [Float64(lam[j])]; color=cols[j], ls=:dash, lw=1,
               label="λ" * sub(j) * " = " * fmtd(lam[j]))
    end
    k < 0 && return p
    for j in 1:n
        plot!(p, 0:k, d[1:k+1, j]; color=cols[j], lw=1.5, marker=:circle, ms=2.5,
              markerstrokewidth=0, label="d" * sub(j))
    end
    return p
end

function logpanel(k)
    p = plot(xlims=(-0.5, nsteps + 0.5), ylims=(1e-18, 1e1), yscale=:log10,
             yticks=10.0 .^ (-18:3:0), framestyle=:box, minorgrid=false,
             xlabel="QR step k", ylabel="size", legend=:outerright, legendfontsize=7,
             titlefontsize=10,
             title=(k < 0 ? "Householder stage: no QR step yet" :
                    "k = $k:  |e₁| = " * fmt(e[k+1, 1]) * ",  |e₂| = " * fmt(e[k+1, 2]) *
                    ",  |e₃| = " * fmt(e[k+1, 3])))
    hline!(p, [chop]; color=:gray, ls=:dot, lw=1.5, label="Chop threshold 5 × 10⁻⁶")
    k < 0 && return p
    for j in 1:n-1                         # predicted slopes, through the last value
        plot!(p, ks, e[end, j] .* ratios[j] .^ (ks .- nsteps); color=cols[j], ls=:dash,
              lw=0.8, alpha=0.6,
              label="slope " * @sprintf("%.4f", ratios[j]) * " = |λ" * sub(j + 1) * "/λ" * sub(j) * "|")
    end
    for j in 1:n-1
        plot!(p, 0:k, e[1:k+1, j]; color=cols[j], lw=1.5, marker=:circle, ms=2.5,
              markerstrokewidth=0, label="|e" * sub(j) * "|, entry (" * string(j + 1) * ", " * string(j) * ")")
    end
    plot!(p, 0:k, derr[1:k+1]; color=:black, lw=1.2, marker=:diamond, ms=2.5,
          markerstrokewidth=0, label="max |dⱼ − λⱼ| = " * fmt(derr[k+1]))
    return p
end

function frame(stage)                      # stage -2, -1: Householder; k >= 0: QR step k
    if stage == -2
        mp = matpanel(A, "Given A (dense, symmetric)")
    elseif stage == -1
        mp = matpanel(A1, "Householder step 1: P₁AP₁\n(zeros below the subdiagonal in column 1)")
    else
        mp = matpanel(As[stage+1], stage == 0 ?
                      "Householder step 2: H = P₂(P₁AP₁)P₂\nis tridiagonal; QR starts from A₀ = H" :
                      "A" * sub(stage) * "  (blank cells: zero)")
    end
    l = @layout [a{0.41w} [b; c]]
    plot(mp, diagpanel(stage), logpanel(stage); layout=l, size=(1250, 720),
         plot_title="Householder reduction, then the unshifted QR method:  Mathews' Example 4,  A = [4 2 2 1; 2 −3 1 1; 2 1 3 1; 1 1 1 2]",
         plot_titlefontsize=11, left_margin=4Plots.mm, bottom_margin=4Plots.mm,
         background_color=:white)
end

frames = vcat([-2, -2, -1, -1], collect(ks), fill(nsteps, 4))   # hold the Householder frames and the last
anim = @animate for s in frames
    frame(s)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=3)
println("Saved: $gif_name  (", length(frames), " frames)")
println("offband ", Float64(offband), "  asym ", Float64(asym), "  |H - Hexact| ", Float64(maximum(abs.(H - Hexact))))
println("A1 = ", Float64.(A1))
println("e at 53: ", e[end, :], "  derr 53: ", derr[end])
println("ratios last step: ", [e[end, j] / e[end-1, j] for j in 1:3])
