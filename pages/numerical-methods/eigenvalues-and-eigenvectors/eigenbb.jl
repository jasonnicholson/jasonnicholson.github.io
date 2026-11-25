# eigenbb.jl
# Eigenvalues and Eigenvectors animation: the scaled powers of the matrix of
# Mathews' Example 2, A = [1 2; 1 1], from X0 = (1, 0), k = 0, ..., 10, as in
# the page's section "Eigenvectors and the Powers A^j X0":
#   X_k = A X_(k-1) / c_k,  c_k = the component of A X_(k-1) of largest
#   magnitude (always the first here), so X_k = (1, x_k).
# Left panel: the arrow X_k, its components along the eigenvectors
#   X_k = a_k V1 + b_k V2,  V1 = (sqrt2, -1),  V2 = (sqrt2, 1),
#   b_k = (1/sqrt2 + x_k)/2,  a_k = (1/sqrt2 - x_k)/2 = -e_k/2,
# and the earlier tips on the line x1 = 1. The V1 component changes sign and
# shrinks at every step, so X_k turns onto the eigenvector line of V2.
# Right panel (log scale): |e_k| = |x_k - 1/sqrt2| and |c_k - lambda2|, with
# filled markers for positive and hollow markers for negative values, and a
# grey dashed line of slope |lambda1/lambda2| = 3 - 2 sqrt2 per step.
# The iteration runs in exact rational arithmetic (Rational{BigInt}); the
# errors are taken in 256-bit floating point after the exact iterate.
# New animation: Mathews' Eigenvalues module has no animation.
# Produces: eigenbb.gif

using Plots
using Printf
gr()
setprecision(BigFloat, 256)

const SUPS = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹']
sup(n) = (n < 0 ? "⁻" : "") * join(SUPS[d+1] for d in reverse(digits(abs(n))))
const SUBS = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉']
sub(n) = join(SUBS[d+1] for d in reverse(digits(n)))
um(s) = replace(s, "-" => "−")
function tenpow(s)                              # "1.234e-07" -> "1.234 × 10⁻⁷"
    occursin('e', s) || return um(s)
    m, e = split(s, 'e')
    return um(m) * " × 10" * sup(parse(Int, e))
end
# Significant-figure label (exact arithmetic, so a zero is an exact zero)
fmt(x) = x == 0 ? "0 (exact)" : tenpow(@sprintf("%.4g", Float64(x)))
frac(q) = denominator(q) == 1 ? string(numerator(q)) : string(numerator(q), "/", denominator(q))

# --- Parameters ---
A = Rational{BigInt}[1 2; 1 1]
X0 = Rational{BigInt}[1, 0]
kmax = 10
r2 = sqrt(big(2))
lam1, lam2 = 1 - r2, 1 + r2
xstar = 1 / r2                                  # X_k -> (1, 1/sqrt2) = V2/sqrt2
ratio = lam1 / lam2                             # -(3 - 2 sqrt2)
gif_name = "eigenbb.gif"

# --- Exact run ---
Xs = [X0]; cs = Rational{BigInt}[0]; Ys = [X0]  # Ys: unscaled A^k X0
for k in 1:kmax
    Y = A * Xs[end]
    abs(Y[1]) >= abs(Y[2]) || error("largest component is not the first at k = $k")  # tie only at k = 1, Y = (1, 1)
    c = Y[1]
    push!(Xs, Y / c); push!(cs, c); push!(Ys, A * Ys[end])
end
x = [X[2] for X in Xs]
e = [BigFloat(xi) - xstar for xi in x]           # e_0 .. e_kmax
ce = [k == 0 ? big(NaN) : BigFloat(cs[k+1]) - lam2 for k in 0:kmax]
all(sign(e[k+1]) == -sign(e[k]) for k in 1:kmax) || error("e_k does not alternate")

# --- Frames ---
c_x, c_v1, c_v2 = :royalblue, :purple, :darkgreen
ef = Float64.(e); cf = Float64.(ce)
function frame(k)
    xk = Float64(x[k+1])
    b = (1 / sqrt(2) + xk) / 2                   # coefficient of V2
    a = (1 / sqrt(2) - xk) / 2                   # coefficient of V1
    p1 = plot(xlims=(-0.45, 1.55), ylims=(-0.6, 1.2), aspect_ratio=:equal, framestyle=:box,
              legend=:outerbottom, legendcolumns=2, legendfontsize=7, xlabel="x₁", ylabel="x₂", grid=true)
    hline!(p1, [0]; color=:black, lw=0.6, label="")
    vline!(p1, [0]; color=:black, lw=0.6, label="")
    xx = [-0.45, 1.55]
    plot!(p1, xx, xx ./ sqrt(2); color=c_v2, ls=:dash, lw=1.5,
          label="eigenvector line of V₂ = (√2, 1), λ₂ = 1 + √2")
    plot!(p1, xx, -xx ./ sqrt(2); color=c_v1, ls=:dash, lw=1.5,
          label="eigenvector line of V₁ = (√2, −1), λ₁ = 1 − √2")
    vline!(p1, [1]; color=:gray70, lw=1, label="")
    # earlier tips
    if k >= 1
        scatter!(p1, ones(k), Float64.(x[1:k]); color=:gray50, ms=3.5, markerstrokewidth=0,
                 label="X₀, …, Xₖ₋₁")
    end
    # components a V1 and b V2 (parallelogram)
    P2 = b .* [sqrt(2), 1.0]; P1 = a .* [sqrt(2), -1.0]
    plot!(p1, [0, P2[1]], [0, P2[2]]; color=c_v2, lw=2.5, arrow=true, label="bₖV₂")
    # a fixed-size arrowhead on a vector shorter than 0.02 would misdraw it: from
    # k = 3 on (|a_3 V1| = sqrt3 |e_3|/2 = 0.006217) only the legend entry is kept
    small = hypot(P1...) < 0.02
    plot!(p1, small ? [NaN] : [0, P1[1]], small ? [NaN] : [0, P1[2]]; color=c_v1, lw=2.5,
          arrow=!small, label="aₖV₁" * (small ? " (too short to draw)" : ""))
    if !small
        plot!(p1, [P2[1], 1], [P2[2], xk]; color=c_v1, lw=1, ls=:dot, label="")
        plot!(p1, [P1[1], 1], [P1[2], xk]; color=c_v2, lw=1, ls=:dot, label="")
    end
    plot!(p1, [0, 1], [0, xk]; color=c_x, lw=3, arrow=true, label="Xₖ = (1, xₖ) = aₖV₁ + bₖV₂")
    scatter!(p1, [1], [xk]; color=c_x, ms=4, markerstrokewidth=0, label="")

    p2 = plot(xlims=(-0.5, kmax + 0.5), ylims=(1e-8, 10), yscale=:log10, framestyle=:box,
              legend=:bottomleft, legendfontsize=7, xlabel="k", ylabel="error",
              xticks=0:kmax, yticks=10.0 .^ (-8:1), minorgrid=false)
    plot!(p2, 0:kmax, abs(ef[1]) .* abs(Float64(ratio)) .^ (0:kmax); color=:gray, ls=:dash,
          lw=1, label="slope |λ₁/λ₂| = 3 − 2√2 ≈ 0.1716 per step")
    ks = 0:k
    plot!(p2, ks, abs.(ef[ks .+ 1]); color=c_x, lw=1.5, label="|eₖ| = |xₖ − 1/√2|")
    pos = [j for j in ks if ef[j+1] > 0]; neg = [j for j in ks if ef[j+1] < 0]
    scatter!(p2, pos, abs.(ef[pos .+ 1]); color=c_x, ms=5, markerstrokecolor=c_x,
             label="eₖ > 0 (filled)")
    scatter!(p2, neg, abs.(ef[neg .+ 1]); color=:white, ms=5, markerstrokecolor=c_x,
             markerstrokewidth=1.5, label="eₖ < 0 (hollow)")
    if k >= 1
        kc = 1:k
        plot!(p2, kc, abs.(cf[kc .+ 1]); color=:darkorange, lw=1.5, ls=:dot,
              label="|cₖ − λ₂| = 2|eₖ₋₁|")
        pc = [j for j in kc if cf[j+1] > 0]; nc = [j for j in kc if cf[j+1] < 0]
        scatter!(p2, pc, abs.(cf[pc .+ 1]); color=:darkorange, marker=:diamond, ms=5,
                 markerstrokecolor=:darkorange, label="")
        scatter!(p2, nc, abs.(cf[nc .+ 1]); color=:white, marker=:diamond, ms=5,
                 markerstrokecolor=:darkorange, markerstrokewidth=1.5, label="")
    end

    Y = Ys[k+1]
    line1 = "k = $k:  A" * sup(k) * "X₀ = (" * frac(Y[1]) * ", " * frac(Y[2]) * "),  " *
            "Xₖ = (1, " * frac(x[k+1]) * "),  eₖ = " * fmt(e[k+1])
    line2 = k == 0 ? "X₀ = (V₁ + V₂)/(2√2):  a₀ = b₀ = " * fmt(a) :
            "cₖ = " * frac(cs[k+1]) *
            (denominator(cs[k+1]) == 1 ? "" : " = " * @sprintf("%.10g", Float64(cs[k+1]))) *
            ",  cₖ − λ₂ = " * fmt(ce[k+1]) *
            (k >= 1 ? ",  eₖ/eₖ₋₁ = " * fmt(e[k+1] / e[k]) : "") *
            ",  aₖ = " * fmt(-e[k+1] / 2)
    plot(p1, p2; layout=grid(1, 2, widths=[0.5, 0.5]), size=(1100, 680),
         plot_title="Scaled powers of A = [1 2; 1 1] (Mathews' Example 2): Xₖ = A Xₖ₋₁ / cₖ\n" *
                    line1 * "\n" * line2,
         plot_titlefontsize=10, plot_titlevspan=0.13, left_margin=3Plots.mm, bottom_margin=4Plots.mm,
         background_color=:white)
end

frames = vcat(collect(0:kmax), fill(kmax, 3))   # hold the last frame
anim = @animate for k in frames
    frame(k)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: $gif_name  (", length(frames), " frames)")
for k in 0:kmax
    @printf("k=%2d x=%s c=%s e=%.4g c-lam2=%.4g ratio=%s\n", k, frac(x[k+1]), frac(cs[k+1]),
            Float64(e[k+1]), Float64(ce[k+1]), k >= 1 ? @sprintf("%.6g", Float64(e[k+1] / e[k])) : "-")
end
