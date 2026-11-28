# jacobibb.jl
# Jacobi's eigenvalue method animation: the cyclic method (row-order sweeps)
# on Mathews' Example 2, the matrix of Example 1,
#   A = [8 -1 3 -1; -1 6 2 0; 3 2 9 1; -1 0 1 7],  eps = 1e-11,  m = 50 sweeps,
# one rotation per frame, k = 0, ..., 20; sweep 5 makes no rotation and ends
# the run (Mathews' JacobiCyclic stopping rule).
# New animation: Mathews' Jacobi module has no animation of this example.
# Left panel: the matrix D_k as a grid of cells. Off-diagonal cells are coloured
# by log10|d_ij|; the diagonal cells (grey) hold the eigenvalue estimates; an
# exact zero is a white cell marked 0. The pair just zeroed is outlined in red.
# Right panel: off(D_k), the magnitude |a_pq| each rotation removes, and the
# threshold eps*sqrt(T/n) of rule (9) (computed at the start of each sweep), on
# a log scale, with the classical run of Example 1 in grey for comparison.
# Each rotation uses formulas (4) of the page (the update R^T D R of rows and
# columns p and q) and stores d_pq = d_qp = 0 exactly, as (4) prescribes;
# Mathews' code leaves a rounding residue there instead. The arithmetic is
# 300-bit BigFloat, as in the page's tables.
# Produces: jacobibb.gif

using Plots
using Printf
using LinearAlgebra
gr()
setprecision(BigFloat, 300)

const SUPS = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹']
sup(n) = (n < 0 ? "⁻" : "") * join(SUPS[d+1] for d in reverse(digits(abs(n))))
um(s) = replace(s, "-" => "−")
# "1.234e-07" -> "1.234 × 10⁻⁷"
function tenpow(s)
    occursin('e', s) || return um(s)
    m, e = split(s, 'e')
    return um(m) * " × 10" * sup(parse(Int, e))
end
# Significant-figure label; zeros in this run are exact (stored, not rounded)
fmt(x) = x == 0 ? "0" : tenpow(@sprintf("%#.4g", Float64(x)))   # 4 significant digits, trailing zeros kept
fmtd(x) = @sprintf("%#.7g", Float64(x))        # diagonal entries, 7 significant digits
const SUBS = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉']
sub(n) = join(SUBS[d+1] for d in reverse(digits(n)))


# --- Parameters (Mathews' Example 2) ---
A0 = BigFloat[8 -1 3 -1; -1 6 2 0; 3 2 9 1; -1 0 1 7]
n = size(A0, 1)
eps_tol = BigFloat(10)^-11
m_sweeps = 50
gif_name = "jacobibb.gif"

# One Jacobi rotation zeroing d_pq (p < q), formulas (4) and (6) of the page
function rotate!(D, V, p, q)
    θ = (D[q, q] - D[p, p]) / (2 * D[p, q])
    t = θ < BigFloat(10)^19 ? 1 / (abs(θ) + sqrt(θ^2 + 1)) : 1 / abs(2θ)
    θ < 0 && (t = -t)
    c = 1 / sqrt(t^2 + 1)
    s = c * t
    app, aqq, apq = D[p, p], D[q, q], D[p, q]
    for j in 1:n
        (j == p || j == q) && continue
        ajp, ajq = D[j, p], D[j, q]
        D[j, p] = D[p, j] = c * ajp - s * ajq
        D[j, q] = D[q, j] = s * ajp + c * ajq
    end
    D[p, p] = c^2 * app + s^2 * aqq - 2c * s * apq
    D[q, q] = s^2 * app + c^2 * aqq + 2c * s * apq
    D[p, q] = D[q, p] = zero(BigFloat)
    for j in 1:n
        vp, vq = V[j, p], V[j, q]
        V[j, p] = c * vp - s * vq
        V[j, q] = s * vp + c * vq
    end
    return nothing
end
offnorm(D) = sqrt(sum(D[i, j]^2 for i in 1:n, j in 1:n if i != j))
rms_diag(D) = sqrt(sum(D[i, i]^2 for i in 1:n) / n)

# --- The cyclic run: Mathews' JacobiCyclic ---
D = copy(A0); V = Matrix{BigFloat}(I, n, n)
Ds = [copy(D)]; pairs = Tuple{Int,Int}[(0, 0)]; sweepof = [0]
apq = BigFloat[NaN]; thr = BigFloat[NaN]
skipped = Dict{Int,Vector{Tuple{Int,Int}}}()   # pairs below the threshold, per sweep
sweepthr = BigFloat[]
nsweeps = 0
while nsweeps < m_sweeps
    global nsweeps += 1
    T = eps_tol * rms_diag(D)                   # threshold fixed for the sweep
    push!(sweepthr, T)
    rotated = false
    skipped[nsweeps] = Tuple{Int,Int}[]
    for p in 1:n-1, q in p+1:n
        if abs(D[p, q]) > T
            a = abs(D[p, q])
            rotate!(D, V, p, q)
            push!(Ds, copy(D)); push!(pairs, (p, q)); push!(sweepof, nsweeps)
            push!(apq, a); push!(thr, T)
            rotated = true
        else
            push!(skipped[nsweeps], (p, q))
        end
    end
    rotated || break
end
K = length(Ds) - 1
(K == 20 && nsweeps == 5) || error("expected 20 rotations in 5 sweeps, got $K, $nsweeps")
all(Dk == permutedims(Dk) for Dk in Ds) || error("a D_k is not exactly symmetric")
offs = [Float64(offnorm(Dk)) for Dk in Ds]
firstk = [findfirst(==(s), sweepof) - 1 for s in 1:nsweeps-1]   # first rotation k of each sweep

# --- The classical run of Example 1, for comparison ---
Dc = copy(A0); Vc = Matrix{BigFloat}(I, n, n); offc = [offnorm(Dc)]
while true
    mx, p, q = zero(BigFloat), 0, 0
    for i in 1:n-1, j in i+1:n
        abs(Dc[i, j]) > mx && ((mx, p, q) = (abs(Dc[i, j]), i, j))
    end
    rotate!(Dc, Vc, p, q)
    push!(offc, offnorm(Dc))
    mx < eps_tol * rms_diag(Dc) && break
end
length(offc) == 21 || error("classical run should take 20 rotations")
offc = Float64.(offc)

# colour range for log10|d_ij| covers every nonzero off-diagonal entry
allmag = [abs(Dk[i, j]) for Dk in Ds for i in 1:n for j in 1:n if i != j && Dk[i, j] != 0]
lo_mag, hi_mag = Float64(minimum(allmag)), Float64(maximum(allmag))
clo, chi = floor(log10(lo_mag)), ceil(log10(hi_mag))
println("log10|d_ij| range ", log10(lo_mag), " .. ", log10(hi_mag), "  colour limits ", (clo, chi))

pairstr(v) = join(["(" * string(p) * "," * string(q) * ")" for (p, q) in v], ", ")

# --- Frames ---
function matpanel(k)
    Dk = Ds[k+1]
    Z = fill(NaN, n, n)
    for i in 1:n, j in 1:n
        if i != j && Dk[i, j] != 0
            Z[i, j] = log10(Float64(abs(Dk[i, j])))
        end
    end
    pL = heatmap(1:n, 1:n, Z; yflip=true, c=:viridis, clims=(clo, chi),
                 aspect_ratio=:equal, xlims=(0.5, n + 0.5), ylims=(0.5, n + 0.5),
                 xticks=(1:n, ["j = $j" for j in 1:n]), yticks=(1:n, ["i = $i" for i in 1:n]),
                 colorbar_title="log₁₀|dᵢⱼ|  (off-diagonal)", framestyle=:box, grid=false,
                 titlefontsize=10, tickfontsize=8)
    for i in 1:n                                   # diagonal cells in grey
        plot!(pL, Shape([i - 0.5, i + 0.5, i + 0.5, i - 0.5], [i - 0.5, i - 0.5, i + 0.5, i + 0.5]);
              color=:gray85, linecolor=:gray85, label="")
    end
    for i in 1:n, j in 1:n
        v = Dk[i, j]
        if i == j
            annotate!(pL, j, i, text(fmtd(v), 8, :black, :center))
            continue
        elseif v == 0
            col = :black
        else
            col = Z[i, j] > clo + 0.6 * (chi - clo) ? :black : :white
        end
        annotate!(pL, j, i, text(fmt(v), 8, col, :center))
    end
    if k >= 1
        p, q = pairs[k+1]
        for (i, j) in ((p, q), (q, p))
            plot!(pL, [j - 0.47, j + 0.47, j + 0.47, j - 0.47, j - 0.47],
                  [i - 0.47, i - 0.47, i + 0.47, i + 0.47, i - 0.47];
                  color=:red, lw=3, label="")
        end
        title!(pL, "D" * sub(k) * " after rotation $k, which zeroed d" * sub(p) * sub(q) *
                   " = d" * sub(q) * sub(p) * "\n(red; white cells are exact zeros, grey = diagonal)")
    else
        title!(pL, "D₀ = A\n(white cells are exact zeros, grey = diagonal)")
    end
    return pL
end

function ratepanel(k, ended)
    pR = plot(xlims=(-0.5, K + 0.5), ylims=(1e-18, 1e2), yscale=:log10,
              framestyle=:box, xlabel="rotation k", ylabel="magnitude", left_margin=10Plots.mm,
              legend=:bottomleft, legendfontsize=7, titlefontsize=10,
              yticks=10.0 .^ (-18:2:2), minorgrid=false)
    plot!(pR, 0:K, offc; color=:gray70, lw=1.5, marker=:circle, ms=3, markerstrokewidth=0,
          label="off(Dₖ), classical run of Example 1")
    for (s, k1) in enumerate(firstk)
        k1 <= max(k, 1) || continue
        k2 = s < length(firstk) ? firstk[s+1] - 1 : K     # last rotation of sweep s
        vline!(pR, [k1 - 0.5]; color=:gray50, ls=:dot, lw=1, label="")
        annotate!(pR, (k1 + k2) / 2, 3e-18, text("sweep $s", 7, :gray30, :center))
    end
    if k >= 1
        plot!(pR, 1:k, Float64.(thr[2:k+1]); color=:green, ls=:dot, lw=2, seriestype=:steppost,
              label="threshold ε√(T/n) of rule (9)")
        scatter!(pR, 1:k, Float64.(apq[2:k+1]); color=:orange, marker=:utriangle, ms=5,
                 markerstrokewidth=0, label="|a_pq| zeroed by rotation k")
    end
    plot!(pR, 0:k, offs[1:k+1]; color=:steelblue, lw=1.5, marker=:circle, ms=4,
          markerstrokewidth=0, label="off(Dₖ), cyclic")
    if k == 0
        title!(pR, "k = 0: off(A) = √32 = " * fmt(offs[1]) *
                   "\nsweep 1 threshold ε√(T/n) = " * fmt(sweepthr[1]))
    elseif ended
        title!(pR, "sweep 4 skips " * pairstr(skipped[4]) *
                   "\nsweep 5: no entry above " * fmt(sweepthr[5]) * ": stop after 20 rotations")
    else
        p, q = pairs[k+1]
        title!(pR, "k = $k (sweep $(sweepof[k+1])): |a" * sub(p) * sub(q) * "| = " * fmt(apq[k+1]) *
                   " > threshold " * fmt(thr[k+1]) *
                   "\noff(D" * sub(k) * ") = " * fmt(offs[k+1]))
    end
    return pR
end

frame(k, ended) = plot(matpanel(k), ratepanel(k, ended); layout=(1, 2), size=(1200, 580),
                plot_title="Cyclic Jacobi, Mathews' Example 2:  A = [8 −1 3 −1; −1 6 2 0; 3 2 9 1; −1 0 1 7],  ε = 10⁻¹¹",
                plot_titlefontsize=11, bottom_margin=5Plots.mm, top_margin=3Plots.mm,
                background_color=:white)

frames = vcat([(k, false) for k in 0:K], fill((K, true), 4))   # end: sweep 5 finds nothing
anim = @animate for (k, ended) in frames
    frame(k, ended)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=2)
println("Saved: $gif_name  (", length(frames), " frames)")
for k in 0:K
    @printf("k=%2d sweep=%d pair=%s apq=%s thr=%s off=%s diag=%s\n", k, sweepof[k+1], string(pairs[k+1]),
            fmt(apq[k+1]), fmt(thr[k+1]), fmt(offs[k+1]),
            join([@sprintf("%.6f", Float64(Ds[k+1][i, i])) for i in 1:n], ","))
end
println("sweep thresholds ", fmt.(sweepthr), "  skipped ", skipped)
println("classical off ", fmt.(offc))
