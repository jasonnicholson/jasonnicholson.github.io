# eigencc.jl
# Eigenvalues and Eigenvectors animation: Newton-Raphson on the characteristic
# polynomial of Mathews' Example 2, A = [1 2; 1 1],
#   p(lambda) = lambda^2 - 2 lambda - 1,   p'(lambda) = 2 lambda - 2,
#   p_(k+1) = p_k - p(p_k) / p'(p_k),
# with Mathews' two runs: (a) p_0 = -0.5, 4 iterations, toward lambda1 = 1 - sqrt2;
# (b) p_0 = 1.5, 6 iterations, toward lambda2 = 1 + sqrt2. One iteration of
# each run per frame (run (a) stops after k = 4).
# Left panel: p(lambda) with the Newton steps (vertical line to the curve,
# tangent line down to the axis). Right panel (log scale): |e_k| = |p_k - lambda|
# for both runs, filled markers for e_k > 0 and hollow markers for e_k < 0, and
# grey crosses at the quadratic-convergence prediction
#   C e_(k-1)^2,  C = |p''(lambda) / (2 p'(lambda))| = 1/(2 sqrt2).
# The iterations run in exact rational arithmetic (Rational{BigInt}), as the
# page's tables were computed in 50-digit arithmetic; errors are taken in
# 256-bit floating point after the exact iterate.
# New animation: Mathews' Eigenvalues module has no animation.
# Produces: eigencc.gif

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
# 16 significant digits of an exact rational, as in the page's tables: a short
# terminating decimal (-1/2, 3/2, 13/4) is printed exactly, any other value is
# rounded from 256-bit precision with its trailing zeros kept
function terminates(q)
    d = denominator(q)
    while d % 2 == 0; d ÷= 2; end
    while d % 5 == 0; d ÷= 5; end
    d == 1
end
fmt16(q) = um(terminates(q) ? @sprintf("%.16g", BigFloat(q)) : @sprintf("%#.16g", BigFloat(q)))

# --- Parameters (Mathews' Example 2) ---
p(x) = x^2 - 2x - 1
dp(x) = 2x - 2
r2 = sqrt(big(2))
lam = (a = 1 - r2, b = 1 + r2)
runs = (a = (p0 = big(-1) // 2, n = 4), b = (p0 = big(3) // 2, n = 6))
C = 1 / (2 * r2)                                # 0.3536
kmax = 6
gif_name = "eigencc.gif"

function newton(p0, n)
    ps = [p0]
    for _ in 1:n
        x = ps[end]
        push!(ps, x - p(x) // dp(x))
    end
    ps
end
pa = newton(runs.a.p0, runs.a.n)
pb = newton(runs.b.p0, runs.b.n)
ea = [BigFloat(x) - lam.a for x in pa]
eb = [BigFloat(x) - lam.b for x in pb]
(pa[2], pa[3], pb[2], pb[3]) == (-5 // 12, -169 // 408, 13 // 4, 185 // 72) ||
    error("first iterates differ from the page")
all(<(0), ea) || error("run (a) is not below lambda1")
all(>(0), eb[2:end]) || error("run (b) is not above lambda2 after the first step")

# --- Frames ---
xl = (-1.5, 4.0); yl = (-2.5, 7.0)
c_a, c_b = :darkorange, :royalblue
xlz = (-0.52, -0.39); ylz = (-0.06, 0.32)     # zoom window around lambda1
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

function steps!(plt, ps, k, col)
    for j in 1:min(k, length(ps) - 1)
        x0 = Float64(ps[j]); x1 = Float64(ps[j+1]); y0 = p(x0)
        last = j == min(k, length(ps) - 1)
        plot!(plt, [x0, x0], [0, y0]; color=col, ls=:dot, lw=1.2, label="")
        plot!(plt, [x0, x1], [y0, 0]; color=col, lw=last ? 2.2 : 1.2, alpha=last ? 1 : 0.6,
              label="")
    end
    xc = Float64(ps[min(k, length(ps) - 1)+1])
    scatter!(plt, [xc], [0]; color=col, ms=4, markerstrokecolor=:black, label="")
end

function curvepanel(xlim, ylim, k, ttl)
    plt = plot(xlims=xlim, ylims=ylim, framestyle=:box, legend=(ttl == "full view" ? :top : false),
               legendfontsize=7, xlabel="λ", ylabel="p(λ)", grid=true, title=ttl, titlefontsize=8)
    hline!(plt, [0]; color=:black, lw=0.8, label="")
    xx = range(xlim..., length=600)
    plot!(plt, xx, ydraw.(p.(xx), Ref(ylim)); color=:black, lw=1.2, label="p(λ) = λ² − 2λ − 1")
    plot!(plt, [NaN], [NaN]; color=c_a, lw=2, label="run (a): p₀ = −0.5")
    plot!(plt, [NaN], [NaN]; color=c_b, lw=2, label="run (b): p₀ = 1.5")
    # roots first, as large diamonds, so that an iterate on a root stays visible
    # as a smaller dot inside its diamond
    scatter!(plt, [Float64(lam.a), Float64(lam.b)], [0, 0]; marker=:diamond, ms=10,
             markercolor=:white, markerstrokecolor=:black, markerstrokewidth=1.5,
             label="λ₁ = 1 − √2,  λ₂ = 1 + √2")
    if k == 0
        scatter!(plt, [-0.5, 1.5], [0, 0]; color=[c_a, c_b], ms=4, markerstrokecolor=:black, label="")
    else
        steps!(plt, pa, k, c_a); steps!(plt, pb, k, c_b)
    end
    plt
end

function frame(k)
    p1 = curvepanel(xl, yl, k, "full view")
    p3 = curvepanel(xlz, ylz, k, "zoom near λ₁ (run (a))")
    p2 = plot(xlims=(-0.5, kmax + 0.5), ylims=(1e-32, 1e1), yscale=:log10, framestyle=:box,
              legend=:bottomleft, legendfontsize=7, xlabel="k", ylabel="|eₖ| = |pₖ − λ|",
              xticks=0:kmax, yticks=10.0 .^ (-32:4:0), minorgrid=false)
    for (e, col, nm, n) in ((ea, c_a, "run (a)", runs.a.n), (eb, c_b, "run (b)", runs.b.n))
        kk = 0:min(k, n)
        ef = Float64.(abs.(e[kk .+ 1]))
        plot!(p2, kk, ef; color=col, lw=1.5, label=nm)
        pos = [j for j in kk if e[j+1] > 0]; neg = [j for j in kk if e[j+1] < 0]
        scatter!(p2, pos, Float64.(abs.(e[pos .+ 1])); color=col, ms=5, markerstrokecolor=col,
                 label="")
        scatter!(p2, neg, Float64.(abs.(e[neg .+ 1])); color=:white, ms=5, markerstrokecolor=col,
                 markerstrokewidth=1.5, label="")
        if length(kk) >= 2
            kp = kk[2:end]
            scatter!(p2, kp, Float64.(C .* e[kp] .^ 2); color=:gray40, marker=:xcross, ms=5,
                     label="")
        end
    end
    plot!(p2, [NaN], [NaN]; seriestype=:scatter, color=:gray40, marker=:xcross, ms=5,
          label="prediction C e²ₖ₋₁, C = 1/(2√2) ≈ 0.3536")
    plot!(p2, [NaN], [NaN]; seriestype=:scatter, color=:gray, ms=5, label="eₖ > 0 (filled)")
    plot!(p2, [NaN], [NaN]; seriestype=:scatter, color=:white, markerstrokecolor=:gray,
          markerstrokewidth=1.5, ms=5, label="eₖ < 0 (hollow)")

    function line(nm, ps, e, n)
        j = min(k, n)
        s = "run $nm: p" * sub(j) * " = " * fmt16(ps[j+1]) * ",  e" * sub(j) * " = " * fmt(e[j+1])
        s *= j >= 1 ? ",  e" * sub(j) * "/e" * sub(j - 1) * "² = " *
                      um(@sprintf("%.4f", Float64(e[j+1] / e[j]^2))) : ""
        s *= k > n ? "  (stopped at k = $n)" : ""
        s
    end
    plot(p1, p3, p2; layout=@layout([grid(2, 1, heights=[0.62, 0.38]) b]), size=(1100, 720),
         plot_title="Newton–Raphson on p(λ) = det(A − λI), A = [1 2; 1 1] (Mathews' Example 2),  k = $k\n" *
                    line("(a)", pa, ea, runs.a.n) * "\n" * line("(b)", pb, eb, runs.b.n),
         plot_titlefontsize=10, plot_titlevspan=0.13, left_margin=3Plots.mm,
         bottom_margin=4Plots.mm, background_color=:white)
end

frames = vcat(collect(0:kmax), fill(kmax, 3))   # hold the last frame
anim = @animate for k in frames
    frame(k)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: $gif_name  (", length(frames), " frames)")
for (nm, ps, e) in (("a", pa, ea), ("b", pb, eb))
    for k in eachindex(ps)
        @printf("run %s k=%d p=%s  p(p)=%.4g  e=%.4g  ratio=%s\n", nm, k - 1, fmt16(ps[k]),
                Float64(p(ps[k])), Float64(e[k]),
                k >= 2 ? @sprintf("%.4f", Float64(e[k] / e[k-1]^2)) : "-")
    end
end
