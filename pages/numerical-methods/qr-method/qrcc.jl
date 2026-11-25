# qrcc.jl
# QR Method animation: the QR method with shifts and deflation on Mathews' Example 5
# (the tridiagonal H of Example 4), tolerance eps = 1e-5, against the unshifted run.
# Mathews' QRshift program: for the active m x m block B (start B = H, sigma = 0),
#   while |B[m, m-1]| > eps (at most 10 times):
#     s = root of the trailing 2 x 2 block's characteristic equation closest to B[m, m],
#     sigma += s,  B - s I = Q R,  B = R Q;
#   then store sigma as an eigenvalue and drop the last row and column (deflation).
# For the final 2 x 2 block the program sets lambda_1 = sigma - s + (other root).
# One frame per shifted step or deflation. New animation: Mathews' QR Method module
# has no animation.
# Left panel: B + sigma I on the active block (orthogonally similar to the active part
# of H, so its diagonal tends to the eigenvalues), deflated eigenvalues in grey.
# Right panel: on a log scale, the last subdiagonal entry of the active block after
# each shifted step, beside the unshifted |e_3| of Example 4 (53 steps).
# Every factorization uses positive diagonal entries in R.
# Arithmetic: 256-bit BigFloat, Householder QR from LinearAlgebra.
# Produces: qrcc.gif

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
fmts(x) = tenpow(@sprintf("%.7g", Float64(x)))  # shifts and running sums
cellfmt(x) = replace(fmt(x), " × " => "\n× ")
fmtd(x) = um(@sprintf("%.6f", Float64(x)))     # diagonal entries of B + sigma I, |.| > 1.3
const SUBS = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉']
sub(n) = join(SUBS[d+1] for d in reverse(digits(n)))

# --- Parameters (Mathews' Example 5) ---
r10 = sqrt(big(10))
H = BigFloat[4 -3 0 0; -3 2 r10 0; 0 r10 -7//5 -1//5; 0 0 -1//5 7//5]
epsl = big(1) / 10^5
maxit = 10
n = 4
s7 = sqrt(big(7))
lam = [4 + s7, -1 - s7, -1 + s7, 4 - s7]           # decreasing |lambda|
blank_tol = big(10)^-60                    # below this an entry is a rounding-level zero
nunsh = 53                                 # unshifted steps of Example 4
gif_name = "qrcc.gif"

function qrpos(M)                          # QR with positive diagonal in R
    F = qr(M)
    Q = Matrix(F.Q)
    R = Matrix(F.R)
    s = [r < 0 ? -one(r) : one(r) for r in diag(R)]
    return Q .* s', s .* R
end
function shift2(B, m)                      # roots of (4), the one closest to B[m, m]
    a, b, c = B[m-1, m-1], B[m, m], B[m, m-1]
    tr, det = a + b, a * b - c^2
    disc = sqrt(tr^2 / 4 - det)
    roots = [tr / 2 - disc, tr / 2 + disc]
    j = abs(roots[1] - b) <= abs(roots[2] - b) ? 1 : 2
    return roots[j], roots[3-j]
end

# --- The shifted run, recording one state per frame ---
# state: (kind, m, B, sigma, step, s, stored eigenvalues, last-subdiagonal history)
states = []
stored = Dict{Int,BigFloat}()
B = copy(H); sigma = big(0); step = 0
hist = Tuple{Int,Int,BigFloat}[]          # (block size m, step, |B[m, m-1]|)
push!(hist, (4, 0, abs(B[4, 3])))
push!(states, (:start, 4, copy(B), sigma, 0, big(0), copy(stored), length(hist)))
lastroots = (big(0), big(0))
for m in n:-1:2
    global B, sigma, step, lastroots
    B = B[1:m, 1:m]
    i = 1
    while i <= maxit && abs(B[m, m-1]) > epsl
        s, other = shift2(B, m)
        sigma += s
        step += 1
        Q, R = qrpos(B - s * I)
        B = R * Q
        lastroots = (s, other)
        push!(hist, (m, step, abs(B[m, m-1])))
        push!(states, (:step, m, copy(B), sigma, step, s, copy(stored), length(hist)))
        i += 1
    end
    stored[m] = sigma                      # Mathews: A1[m, m] = sum
    if m > 2
        push!(hist, (m - 1, step, abs(B[m-1, m-2])))
        push!(states, (:deflate, m - 1, copy(B[1:m-1, 1:m-1]), sigma, step, big(0), copy(stored), length(hist)))
    end
end
stored[1] = sigma - lastroots[1] + lastroots[2]  # Mathews: A1[1,1] = sum - s + other root
push!(states, (:final, 0, B, sigma, step, big(0), copy(stored), length(hist)))
step == 5 || error("expected five shifted steps, got $step")
offband = maximum(abs(st[3][i, j]) for st in states if st[1] == :step
                  for i in 1:st[2] for j in 1:st[2] if abs(i - j) > 1; init=big(0))
asym = maximum(abs(st[3][i, j] - st[3][j, i]) for st in states if st[1] == :step
               for i in 1:st[2] for j in 1:st[2])
(offband < blank_tol && asym < blank_tol) || error("iterates left symmetric tridiagonal form")
println("offband ", Float64(offband), "  asym ", Float64(asym))
lamc = [stored[j] for j in 1:n]
errs = Float64.(abs.(lamc .- lam))
println("eigenvalues ", Float64.(lamc), "  errors ", errs)
println("history ", [(m, k, Float64(v)) for (m, k, v) in hist])

# --- The unshifted run of Example 4, for comparison ---
Au = copy(H)
e3u = [Float64(abs(Au[4, 3]))]
for k in 1:nunsh
    global Au
    Q, R = qrpos(Au)
    Au = R * Q
    push!(e3u, Float64(abs(Au[4, 3])))
end

# --- Panels ---
const CL = (-18.0, 1.0)
blkcol = Dict(4 => :royalblue, 3 => :darkorange, 2 => :seagreen)

function matpanel(st)
    kind, m, Bs, sg, stp, s, sto, nh = st
    mm = kind == :final ? 0 : m            # size of the active block
    T = fill(big(NaN), n, n)
    for i in 1:mm, j in 1:mm
        T[i, j] = Bs[i, j] + (i == j ? sg : 0)
    end
    Z = [isnan(T[i, j]) || abs(T[i, j]) < blank_tol ? NaN : log10(Float64(abs(T[i, j]))) for i in 1:n, j in 1:n]
    ttl = kind == :start ? "A₁ = H, σ = 0: active block 4 × 4" :
          kind == :step ? "A" * sub(stp + 1) * " + σI after step $stp, σ = " * fmtd(sg) :
          kind == :deflate ? "Deflated: active block now $m × $m" :
          "All four eigenvalues found"
    p = heatmap(1:n, 1:n, Z; yflip=true, c=:viridis, clims=CL, aspect_ratio=:equal,
                xlims=(0.5, n + 0.5), ylims=(0.5, n + 0.5), xticks=1:n, yticks=1:n,
                framestyle=:box, colorbar_title="log₁₀ |aᵢⱼ|", titlefontsize=10,
                xlabel="column j", ylabel="row i",
                title=ttl * "\n(blank: zero or dropped; grey: stored eigenvalue)")
    for i in 1:n, j in 1:n
        isnan(Z[i, j]) && continue
        lbl = i == j ? fmtd(T[i, j]) : cellfmt(T[i, j])
        tc = Z[i, j] < -7 ? :white : :black
        annotate!(p, j, i, text(lbl, 8, tc))
    end
    for (j, v) in sto                      # stored eigenvalues, grey cells
        plot!(p, Shape([j - 0.5, j + 0.5, j + 0.5, j - 0.5], [j - 0.5, j - 0.5, j + 0.5, j + 0.5]);
              fillcolor=:lightgray, linecolor=:gray, label="")
        annotate!(p, j, j, text("λ" * sub(j) * " =\n" * fmtd(v), 8, :black))
    end
    if mm >= 2                             # outline the active block
        plot!(p, [0.5, mm + 0.5, mm + 0.5, 0.5, 0.5], [0.5, 0.5, mm + 0.5, mm + 0.5, 0.5];
              color=:red, lw=2.5, label="")
    end
    return p
end

function logpanel(st, idx)
    kind, m, Bs, sg, stp, s, sto, nh = st
    ylo = 1e-18
    p = plot(xlims=(-0.5, nunsh + 0.5), ylims=(ylo, 1e1), yscale=:log10,
             yticks=10.0 .^ (-18:3:0), framestyle=:box, minorgrid=false,
             xlabel="QR step", ylabel="last subdiagonal entry of the active block",
             legend=:bottomright, legendfontsize=8, titlefontsize=10)
    hline!(p, [Float64(epsl)]; color=:gray, ls=:dot, lw=1.5, label="tolerance ε = 10⁻⁵")
    plot!(p, 0:nunsh, e3u; color=:gray, lw=1.2, marker=:circle, ms=2, markerstrokewidth=0,
          label="unshifted |e₃| (Example 4): " * fmt(e3u[end]) * " after $nunsh steps")
    # shifted history up to the current step
    for mb in (4, 3, 2)
        pts = [(k, v) for (mm, k, v) in hist[1:nh] if mm == mb]
        isempty(pts) && continue
        xs = [k for (k, v) in pts]
        vs = [Float64(v) for (k, v) in pts]
        vis = [v >= blank_tol for (k, v) in pts]
        lab = "shifted, $mb × $mb block: |e" * sub(mb - 1) * "|"
        plot!(p, xs[vis], vs[vis]; color=blkcol[mb], lw=2, marker=:circle, ms=5,
              markerstrokewidth=0, label=lab)
        for (x, v, ok) in zip(xs, vs, vis)  # rounding-level zero: arrow at the axis edge
            ok && continue
            plot!(p, [x - 1, x], [Float64(vs[findlast(vis)]), ylo]; color=blkcol[mb], lw=2,
                  ls=:dash, label="")
            scatter!(p, [x], [ylo * 1.6]; color=blkcol[mb], marker=:dtriangle, ms=8,
                     markerstrokewidth=0,
                     label="after step $x: below 10⁻⁶⁰ (0 in exact arithmetic)")
        end
    end
    ttl = if kind == :start
        "Start: σ = 0,  |e₃| = " * fmt(abs(Bs[4, 3])) * " > ε"
    elseif kind == :step
        e = abs(Bs[m, m-1])
        "Step $stp ($m × $m block): shift s" * sub(stp) * " = " * fmts(s) * ",  σ = " * fmts(sg) *
        ",\n|e" * sub(m - 1) * "|" * (e < blank_tol ? " below 10⁻⁶⁰ (rounding level) ≤ ε" :
        " = " * fmt(e) * (e <= epsl ? " ≤ ε" : " > ε"))
    elseif kind == :deflate
        "Deflate: λ" * sub(m + 1) * " = σ = " * fmts(sg) * ";\nnext block $m × $m, |e" * sub(m - 1) *
        "| = " * fmt(abs(Bs[m, m-1])) * " > ε"
    else
        "λ₂ = σ = " * fmts(lamc[2]) * ",  λ₁ = σ − s₅ + other root = " * fmts(lamc[1]) *
        "\nfive shifted steps against 53 unshifted"
    end
    title!(p, ttl)
    return p
end

function frame(idx)
    st = states[idx]
    l = @layout [a{0.43w} b]
    plot(matpanel(st), logpanel(st, idx); layout=l, size=(1250, 620),
         plot_title="QR method with shifts and deflation, Mathews' Example 5 (H of Example 4), ε = 10⁻⁵",
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white)
end

frames = vcat(collect(1:length(states)), fill(length(states), 3))   # hold the last frame
anim = @animate for idx in frames
    frame(idx)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: $gif_name  (", length(frames), " frames)")
println("shifts and sums: ", [(st[5], Float64(st[6]), Float64(st[4])) for st in states if st[1] == :step])
println("unshifted e3 at 53: ", e3u[end])
