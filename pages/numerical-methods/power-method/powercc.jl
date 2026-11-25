# powercc.jl
# Power Method animation: the shifted-inverse power method of Mathews' Example 3
# (shift alpha = 4.2) against the plain power method of Example 1, on the same
# matrix A = [0 11 -5; -2 17 -7; -4 26 -10] from the same X0 = (1, 1, 1), both
# with the tolerance 1e-7 of Example 3, one iteration of each per frame.
# New animation: Mathews' Power Method module has no animation.
# The shifted-inverse run is Mathews' InvPowerMeth: (A - alpha I) is factored
# once (here exactly, by Julia's generic LU on Rational{BigInt}), each step
# solves (A - alpha I) Y_k = X_k, c_(k+1) is the coordinate of Y_k of largest
# magnitude, its eigenvalue estimate is alpha + 1/c_(k+1), and it stops when
#   max(|c_(k+1) - c_k|, ||X_(k+1) - X_k||_2) <= eps   (c_0 = 0).
# The plain run is Mathews' PowerMeth with the same eps (its test uses "<").
# Drawn on a log scale: the eigenvalue error |estimate - 4| and the vector error
# ||X_k - V1||_2, V1 = (2/5, 3/5, 1), for both methods.
# All arithmetic is exact (Rational{BigInt}); norms are taken in 256-bit
# floating point after the exact subtraction.
# Produces: powercc.gif

using Plots
using Printf
using LinearAlgebra
gr()
setprecision(BigFloat, 256)

const SUPS = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹']
sup(n) = (n < 0 ? "⁻" : "") * join(SUPS[d+1] for d in reverse(digits(abs(n))))
const SUBS = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉']
sub(n) = join(SUBS[d+1] for d in reverse(digits(n)))
um(s) = replace(s, "-" => "−")
# "1.234e-07" -> "1.234 × 10⁻⁷"
function tenpow(s)
    occursin('e', s) || return um(s)
    m, e = split(s, 'e')
    return um(m) * " × 10" * sup(parse(Int, e))
end
# Significant-figure label (exact arithmetic, so a zero is an exact zero)
fmt(x) = x == 0 ? "0 (exact)" : tenpow(@sprintf("%.4g", Float64(x)))

# --- Parameters (Mathews' Examples 1 and 3) ---
A = Rational{BigInt}[0 11 -5; -2 17 -7; -4 26 -10]
X0 = Rational{BigInt}[1, 1, 1]
alpha = big(21) // 5                           # 4.2
eps_tol = big(1) // big(10)^7
max_iter = 50
lambda1 = big(4) // 1
V1 = Rational{BigInt}[2//5, 3//5, 1]
gif_name = "powercc.gif"

function maxsize(y)                            # Mathews' maxsize
    s = sort(y)
    return abs(s[end]) >= abs(s[1]) ? s[end] : s[1]
end
norm2(v) = sqrt(sum(BigFloat.(v) .^ 2))

# --- Plain power method (test "<") ---
function plain()
    Xs = [X0]; est = Rational{BigInt}[0]; c0 = big(0) // 1
    for k in 1:max_iter
        Y = A * Xs[end]; c = maxsize(Y); X = Y / c
        step = max(BigFloat(abs(c - c0)), norm2(X - Xs[end]))
        push!(Xs, X); push!(est, c); c0 = c
        step < eps_tol && return Xs, est, k
    end
    error("plain run did not stop")
end

# --- Shifted-inverse power method (test "<=") ---
function shifted_inverse()
    F = lu(A - alpha * I)                       # factored once, exactly
    Xs = [X0]; est = Rational{BigInt}[0]; c0 = big(0) // 1
    for k in 1:max_iter
        Y = F \ Xs[end]
        (A - alpha * I) * Y == Xs[end] || error("inexact solve")
        c = maxsize(Y); X = Y / c
        step = max(BigFloat(abs(c - c0)), norm2(X - Xs[end]))
        push!(Xs, X); push!(est, alpha + 1 / c); c0 = c
        step <= eps_tol && return Xs, est, k
    end
    error("shifted-inverse run did not stop")
end

Xp, ep, kp = plain()
Xi, ei, ki = shifted_inverse()
(kp, ki) == (25, 10) || error("expected 25 and 10 iterations, got $kp and $ki")

perr = [Float64(ep[k+1] - lambda1) for k in 0:kp]      # index 1 (k = 0) unused
pverr = [Float64(norm2(Xp[k+1] - V1)) for k in 0:kp]
ierr = [Float64(ei[k+1] - lambda1) for k in 0:ki]
iverr = [Float64(norm2(Xi[k+1] - V1)) for k in 0:ki]
all(>(0), perr[2:end]) && all(>(0), ierr[2:end]) || error("an error is not positive")

# --- Frames ---
c_pl, c_si = :darkorange, :royalblue
function frame(k)
    p = plot(xlims=(-0.5, kp + 0.5), ylims=(1e-12, 1e2), yscale=:log10,
             framestyle=:box, xlabel="iteration k", ylabel="error",
             legend=:bottomleft, legendfontsize=8, titlefontsize=10,
             yticks=10.0 .^ (-12:2:2), minorgrid=false, size=(900, 600),
             left_margin=4Plots.mm, bottom_margin=4Plots.mm, background_color=:white)
    # reference slopes through the last points of each run
    plot!(p, 0:kp, perr[end] .* 2.0 .^ (kp .- (0:kp)); color=:gray, ls=:dash, lw=1,
          label="slopes (½)ᵏ and (1/11)ᵏ")
    plot!(p, 0:ki, ierr[end] .* 11.0 .^ (ki .- (0:ki)); color=:gray, ls=:dash, lw=1,
          label="")
    kpd = min(k, kp); kid = min(k, ki)
    plot!(p, 0:kpd, pverr[1:kpd+1]; color=c_pl, ls=:dot, lw=1.5, marker=:square, ms=3,
          markerstrokewidth=0, label="power method: ‖Xₖ − V₁‖₂")
    plot!(p, 0:kid, iverr[1:kid+1]; color=c_si, ls=:dot, lw=1.5, marker=:square, ms=3,
          markerstrokewidth=0, label="shifted inverse: ‖Xₖ − V₁‖₂")
    if k >= 1
        plot!(p, 1:kpd, perr[2:kpd+1]; color=c_pl, lw=2, marker=:circle, ms=4.5,
              markerstrokewidth=0, label="power method: cₖ − 4")
        plot!(p, 1:kid, ierr[2:kid+1]; color=c_si, lw=2, marker=:diamond, ms=5,
              markerstrokewidth=0, label="shifted inverse: α + 1/cₖ − 4")
    end
    if k >= ki
        vline!(p, [ki]; color=c_si, lw=1, ls=:dashdot, label="")
        annotate!(p, ki + 0.3, 3e1, text("shifted inverse stops, k = $ki", 8, :left, c_si))
    end
    if k >= kp
        vline!(p, [kp]; color=c_pl, lw=1, ls=:dashdot, label="")
        annotate!(p, kp - 0.3, 3e1, text("power method stops, k = $kp", 8, :right, c_pl))
    end
    line1 = "k = $k:  "
    if k == 0
        line1 *= "X₀ = (1, 1, 1) for both,  ‖X₀ − V₁‖₂ = " * fmt(pverr[1])
        line2 = "power method: Yₖ = A Xₖ;   shifted inverse: solve (A − 4.2 I) Yₖ = Xₖ"
    else
        line1 *= "power method cₖ − 4 = " * fmt(perr[kpd+1]) *
                 (k > kp ? " (stopped at k = $kp)" : "")
        line2 = "shifted inverse α + 1/cₖ − 4 = " * fmt(ierr[kid+1]) *
                (k > ki ? " (stopped at k = $ki)" : "")
    end
    title!(p, "Power method vs shifted-inverse power method (α = 4.2), Mathews' Examples 1 and 3\n" *
              line1 * "\n" * line2)
    p
end

frames = vcat(collect(0:kp), fill(kp, 3))     # hold the last frame
anim = @animate for k in frames
    frame(k)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=2)
println("Saved: $gif_name  (", length(frames), " frames)")
println("plain k=$kp err ", perr[end], " verr ", pverr[end])
println("inverse k=$ki err ", ierr[end], " verr ", iverr[end])
