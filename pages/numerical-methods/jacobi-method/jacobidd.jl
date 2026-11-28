# jacobidd.jl
# Jacobi's eigenvalue method animation: Mathews' "eigenvalue movie" matrix
# (Example 6) rerun to convergence. Same picture as jacobicc.jl (the matrix as
# a surface u = d_ij over the grid of indices (i, j), vertical range -4 to 14,
# drawn at the start and after every rotation), for
#   A = [8 -1 3 -4 4; -1 6 2 0 5; 3 2 9 1 1; -4 0 1 7 0; 4 5 1 0 1],
# but with the page's tolerance eps = 1e-11 instead of Mathews' 0.2, at most
# m = 50 sweeps. The run makes 39 rotations in 6 sweeps (10, 10, 10, 8, 1, 0).
# New animation: Mathews ran this matrix only with eps = 0.2.
# Left: the surface; red markers show the pair just zeroed.
# Top right: off(D_k), the magnitude |a_pq| each rotation removes, the sweep
# threshold eps*sqrt(T/n) of rule (9) and the largest off-diagonal entry left,
# on a log scale. Bottom right: the diagonal entries of D_k (coloured dots,
# one colour per position) against the eigenvalues of A (black ticks).
# Each rotation uses formulas (4) of the page and stores d_pq = d_qp = 0
# exactly; the arithmetic is 300-bit BigFloat. The eigenvalues of A for the
# ticks come from LinearAlgebra.eigvals in double precision.
# Produces: jacobidd.gif

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
fmtd(x) = @sprintf("%.7g", Float64(x))         # diagonal entries, 7 significant digits
const SUBS = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉']
sub(n) = join(SUBS[d+1] for d in reverse(digits(n)))


# --- Parameters (Mathews' Example 6) ---
A0 = BigFloat[8 -1 3 -4 4; -1 6 2 0 5; 3 2 9 1 1; -4 0 1 7 0; 4 5 1 0 1]
n = size(A0, 1)
eps_tol = BigFloat(10)^-11
eps_label = "ε = 10⁻¹¹"
m_sweeps = 50
expect = (39, 6)                   # (rotations, sweeps) of this run
zl = (-4.0, 14.0)                  # Mathews' PlotRange
fps_out = 3
gif_name = "jacobidd.gif"

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
maxoff(D) = maximum(abs(D[i, j]) for i in 1:n, j in 1:n if i != j)

# --- The cyclic run: Mathews' JacobiCyclic (JacobiMovie draws after each rotation) ---
D = copy(A0); V = Matrix{BigFloat}(I, n, n)
Ds = [copy(D)]; pairs = Tuple{Int,Int}[(0, 0)]; sweepof = [0]
apq = BigFloat[NaN]; thr = BigFloat[NaN]
sweepthr = BigFloat[]
nsweeps = 0
while nsweeps < m_sweeps
    global nsweeps += 1
    T = eps_tol * rms_diag(D)                   # threshold fixed for the sweep
    push!(sweepthr, T)
    rotated = false
    for p in 1:n-1, q in p+1:n
        if abs(D[p, q]) > T
            a = abs(D[p, q])
            rotate!(D, V, p, q)
            push!(Ds, copy(D)); push!(pairs, (p, q)); push!(sweepof, nsweeps)
            push!(apq, a); push!(thr, T)
            rotated = true
        end
    end
    rotated || break
end
K = length(Ds) - 1
(K, nsweeps) == expect || error("expected $expect (rotations, sweeps), got $((K, nsweeps))")
all(Dk == permutedims(Dk) for Dk in Ds) || error("a D_k is not exactly symmetric")
offs = [Float64(offnorm(Dk)) for Dk in Ds]
mxs = [Float64(maxoff(Dk)) for Dk in Ds]
firstk = [findfirst(==(s), sweepof) - 1 for s in 1:nsweeps-1]   # first rotation k of each sweep
lam = sort(eigvals(Symmetric(Float64.(A0))))

# no entry may leave Mathews' vertical range
for Dk in Ds
    all(zl[1] .<= Float64.(Dk) .<= zl[2]) || error("an entry leaves the range $zl")
end
ylo = 10.0^floor(log10(min(minimum(mxs), minimum(Float64.(sweepthr)), offs[end])))
yhi = 10.0^ceil(log10(maximum(offs)))

# --- Frames ---
const DIAGCOLS = [:royalblue, :darkorange, :forestgreen, :crimson, :purple]

function surfpanel(k)
    Dk = Float64.(Ds[k+1])
    # surface(x, y, Z) puts Z[j, i] at (x[i], y[j]); pass the transpose so that
    # d_ij is drawn at (i, j) (D_k is exactly symmetric here, so this is a formality)
    ps = surface(1:n, 1:n, permutedims(Dk); zlims=zl, clims=zl, c=:viridis,
                 camera=(30, 30), xlabel="i", ylabel="j", zlabel="dᵢⱼ",
                 xticks=1:n, yticks=1:n, zticks=-4:2:14, colorbar=false,
                 titlefontsize=10)
    plot3d!(ps, 1:n, 1:n, [Dk[i, i] for i in 1:n]; color=:black, lw=2.5,
            marker=:circle, ms=3, label="")
    if k >= 1
        p, q = pairs[k+1]
        scatter3d!(ps, [p, q], [q, p], [0.0, 0.0]; color=:red, ms=6, markerstrokewidth=0,
                   label="")
        title!(ps, "u = dᵢⱼ after rotation $k (sweep $(sweepof[k+1])),\nwhich zeroed d" *
                   sub(p) * sub(q) * " = d" * sub(q) * sub(p) * " (red); black: the diagonal")
    else
        title!(ps, "u = aᵢⱼ, the matrix A (black: the diagonal)\nvertical range −4 to 14, as in Mathews' movie")
    end
    return ps
end

function ratepanel(k, ended)
    pR = plot(xlims=(-0.5, K + 0.5), ylims=(ylo, yhi), yscale=:log10,
              framestyle=:box, xlabel="rotation k", ylabel="magnitude",
              legend=:outerright, legendfontsize=7, titlefontsize=10, minorgrid=false,
              top_margin=4Plots.mm)
    for (s, k1) in enumerate(firstk)
        k1 <= max(k, 1) || continue
        k2 = s < length(firstk) ? firstk[s+1] - 1 : K     # last rotation of sweep s
        vline!(pR, [k1 - 0.5]; color=:gray50, ls=:dot, lw=1, label="")
        annotate!(pR, (k1 + k2) / 2, yhi / 2, text(k2 - k1 >= 3 ? "sweep $s" : "$s", 7, :gray30, :center))
    end
    if k >= 1
        plot!(pR, 1:k, Float64.(thr[2:k+1]); color=:green, ls=:dot, lw=2, seriestype=:steppost,
              label="sweep threshold ε√(T/n)")
        scatter!(pR, 1:k, Float64.(apq[2:k+1]); color=:orange, marker=:utriangle, ms=5,
                 markerstrokewidth=0, label="|a_pq| zeroed by rotation k")
    end
    plot!(pR, 0:k, mxs[1:k+1]; color=:purple, lw=1, marker=:diamond, ms=3.5,
          markerstrokewidth=0, label="largest |dᵢⱼ|, i ≠ j")
    plot!(pR, 0:k, offs[1:k+1]; color=:steelblue, lw=1.5, marker=:circle, ms=4,
          markerstrokewidth=0, label="off(Dₖ)")
    if k == 0
        title!(pR, "k = 0: off(A) = " * fmt(offs[1]) *
                   "\nsweep 1 threshold ε√(T/n) = " * fmt(sweepthr[1]))
    elseif ended
        title!(pR, "sweep $nsweeps: largest |dᵢⱼ| = " * fmt(mxs[end]) * " < threshold " *
                   fmt(sweepthr[end]) * "\nno rotation: stop after $K rotations in $nsweeps sweeps")
    else
        p, q = pairs[k+1]
        title!(pR, "k = $k: |a" * sub(p) * sub(q) * "| = " * fmt(apq[k+1]) *
                   " > threshold " * fmt(thr[k+1]) * " (sweep $(sweepof[k+1]))" *
                   "\noff(D" * sub(k) * ") = " * fmt(offs[k+1]))
    end
    return pR
end

function diagpanel(k)
    Dk = Float64.(Ds[k+1])
    pD = plot(xlims=(-5, 15), ylims=(-0.6, 1.2), yticks=false, framestyle=:box,
              xlabel="value", legend=:outerright, legendfontsize=7, titlefontsize=10,
              xticks=-4:2:14, grid=false)
    for (r, l) in enumerate(lam)
        plot!(pD, [l, l], [-0.5, 0.5]; color=:black, lw=2, label=(r == 1 ? "eigenvalues of A" : ""))
    end
    for i in 1:n
        scatter!(pD, [Dk[i, i]], [0.0]; color=DIAGCOLS[i], ms=7, markerstrokewidth=0,
                 label="d" * sub(i) * sub(i) * " = " * fmt(Dk[i, i]))
    end
    title!(pD, "Diagonal of D" * sub(k) * " (dots) and the eigenvalues of A (ticks)")
    return pD
end

function frame(k, ended)
    l = @layout [a{0.47w} grid(2, 1, heights=[0.6, 0.4])]
    plot(surfpanel(k), ratepanel(k, ended), diagpanel(k); layout=l, size=(1250, 620),
         plot_title="Matrix of Mathews' eigenvalue movie (Example 6) rerun, cyclic Jacobi, " * eps_label *
                    ":  A = [8 −1 3 −4 4; −1 6 2 0 5; 3 2 9 1 1; −4 0 1 7 0; 4 5 1 0 1]",
         plot_titlefontsize=11, bottom_margin=4Plots.mm, left_margin=3Plots.mm,
         background_color=:white)
end

frames = vcat([(k, false) for k in 0:K], fill((K, true), 4))   # end: last sweep finds nothing
anim = @animate for (k, ended) in frames
    frame(k, ended)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=fps_out)
println("Saved: $gif_name  (", length(frames), " frames)")
for k in 0:K
    @printf("k=%2d sweep=%d pair=%s apq=%s thr=%s off=%s maxoff=%s diag=%s\n", k, sweepof[k+1],
            string(pairs[k+1]), fmt(apq[k+1]), fmt(thr[k+1]), fmt(offs[k+1]), fmt(mxs[k+1]),
            join([fmt(Ds[k+1][i, i]) for i in 1:n], ","))
end
println("sweep thresholds ", fmt.(sweepthr), "  eigenvalues ", lam)
println("entry range ", minimum(minimum(Float64.(Dk)) for Dk in Ds), " .. ", maximum(maximum(Float64.(Dk)) for Dk in Ds))
