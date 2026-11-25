# jacobiaa.jl
# Jacobi's eigenvalue method animation: the classical method (largest
# off-diagonal entry first) on Mathews' Example 1,
#   A = [8 -1 3 -1; -1 6 2 0; 3 2 9 1; -1 0 1 7],  tolerance eps = 1e-11,
# one rotation per frame, k = 0, ..., 20 (Mathews' stopping rule ends the run
# after rotation 20).
# New animation: Mathews' Jacobi module has no animation of this example.
# Left panel: the matrix D_k as a grid of cells. Off-diagonal cells are coloured
# by log10|d_ij|; the diagonal cells (grey) hold the eigenvalue estimates; an
# exact zero is a white cell marked 0. The pair just zeroed is outlined in red.
# Right panel: off(D_k) = sqrt(sum of squares of the off-diagonal entries), the
# magnitude |a_pq| each rotation removes, Mathews' stopping threshold
# eps*sqrt(T/n) and the general bound (8), on a log scale.
# Each rotation uses formulas (4) of the page (the update R^T D R of rows and
# columns p and q) and stores d_pq = d_qp = 0 exactly, as (4) prescribes;
# Mathews' code leaves a rounding residue there instead. The arithmetic is
# 300-bit BigFloat, as in the page's tables.
# Produces: jacobiaa.gif

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

# --- Parameters (Mathews' Example 1) ---
A0 = BigFloat[8 -1 3 -1; -1 6 2 0; 3 2 9 1; -1 0 1 7]
n = size(A0, 1)
eps_tol = BigFloat(10)^-11
gif_name = "jacobiaa.gif"

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

# --- The run: Mathews' JacobiClassic stopping rule ---
D = copy(A0); V = Matrix{BigFloat}(I, n, n)
Ds = [copy(D)]; pairs = Tuple{Int,Int}[(0, 0)]
amax = BigFloat[NaN]; thr = BigFloat[NaN]
while true
    m, p, q = zero(BigFloat), 0, 0
    for i in 1:n-1, j in i+1:n
        if abs(D[i, j]) > m
            m, p, q = abs(D[i, j]), i, j
        end
    end
    rotate!(D, V, p, q)
    push!(Ds, copy(D)); push!(pairs, (p, q)); push!(amax, m)
    push!(thr, eps_tol * rms_diag(D))          # T taken after the rotation
    m < thr[end] && break
    length(Ds) > 200 && error("no stop")
end
K = length(Ds) - 1
K == 20 || error("expected 20 rotations, got $K")
all(Dk == permutedims(Dk) for Dk in Ds) || error("a D_k is not exactly symmetric")
offs = [Float64(offnorm(Dk)) for Dk in Ds]

# colour range for log10|d_ij| covers every nonzero off-diagonal entry
allmag = [abs(Dk[i, j]) for Dk in Ds for i in 1:n for j in 1:n if i != j && Dk[i, j] != 0]
lo_mag, hi_mag = Float64(minimum(allmag)), Float64(maximum(allmag))
clo, chi = floor(log10(lo_mag)), ceil(log10(hi_mag))
println("log10|d_ij| range ", log10(lo_mag), " .. ", log10(hi_mag), "  colour limits ", (clo, chi))

# reference: the general bound (8), off_k <= off_0 (5/6)^(k/2)
bound = offs[1] .* (5 / 6) .^ ((0:K) ./ 2)
all(offs .<= bound .* (1 + 1e-12)) || error("bound (8) violated")

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

function ratepanel(k)
    pR = plot(xlims=(-0.5, K + 0.5), ylims=(1e-18, 1e2), yscale=:log10,
              framestyle=:box, xlabel="rotation k", ylabel="magnitude", left_margin=10Plots.mm,
              legend=:bottomleft, legendfontsize=7, titlefontsize=10,
              yticks=10.0 .^ (-18:2:2), minorgrid=false)
    plot!(pR, 0:K, bound; color=:gray, ls=:dash, lw=1, label="bound (8): off(D₀)·(5/6)ᵏᐟ²")
    if k >= 1
        plot!(pR, 1:k, Float64.(thr[2:k+1]); color=:green, ls=:dot, lw=2,
              label="stopping threshold ε√(T/n)")
        scatter!(pR, 1:k, Float64.(amax[2:k+1]); color=:orange, marker=:utriangle, ms=5,
                 markerstrokewidth=0, label="largest |dᵢⱼ|, removed by rotation k")
    end
    plot!(pR, 0:k, offs[1:k+1]; color=:steelblue, lw=1.5, marker=:circle, ms=4,
          markerstrokewidth=0, label="off(Dₖ)")
    if k == 0
        title!(pR, "k = 0: off(A) = √32 = " * fmt(offs[1]) * "\nlargest off-diagonal entry |a₁₃| = 3")
    else
        p, q = pairs[k+1]
        stop = k == K
        title!(pR, "k = $k: |a" * sub(p) * sub(q) * "| = " * fmt(amax[k+1]) *
                   (stop ? " < " : (amax[k+1] < thr[k+1] ? " < " : " > ")) *
                   "threshold " * fmt(thr[k+1]) * (stop ? ": stop" : "") *
                   "\noff(D" * sub(k) * ") = " * fmt(offs[k+1]))
    end
    return pR
end

frame(k) = plot(matpanel(k), ratepanel(k); layout=(1, 2), size=(1200, 580),
                plot_title="Classical Jacobi, Mathews' Example 1:  A = [8 −1 3 −1; −1 6 2 0; 3 2 9 1; −1 0 1 7],  ε = 10⁻¹¹",
                plot_titlefontsize=11, bottom_margin=5Plots.mm, top_margin=3Plots.mm,
                background_color=:white)

frames = vcat(collect(0:K), fill(K, 3))      # hold the last frame
anim = @animate for k in frames
    frame(k)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=2)
println("Saved: $gif_name  (", length(frames), " frames)")
for k in 0:K
    @printf("k=%2d pair=%s amax=%s thr=%s off=%s diag=%s\n", k, string(pairs[k+1]),
            fmt(amax[k+1]), fmt(thr[k+1]), fmt(offs[k+1]),
            join([@sprintf("%.6f", Float64(Ds[k+1][i, i])) for i in 1:n], ","))
end
