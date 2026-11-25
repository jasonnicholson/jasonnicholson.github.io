# matexpaa.jl
# Matrix Exponential animation: Mathews' Example 1, the series
#   e^{At} = sum_{n>=0} (At)^n / n!,   A = [2 1; 1 2],
# summed term by term. One frame per partial sum S_N(t) = sum_{n=0}^{N-1} (At)^n/n!
# (the first N terms), N = 1, 2, ..., 20, on 0 <= t <= 2 (the range of the page's
# error table). Top: the diagonal entry (S_N(t))_11 against the exact entry
# (e^{At})_11 = (e^t + e^{3t})/2, on a log scale. Bottom: the error of that entry,
# which is the largest of the four entries' errors, on a log scale. The dotted line
# marks t = 1, the e^A of part (a) and of the page's partial-sum table.
# The powers A^n are formed exactly (integer matrices) and the sums and errors are
# evaluated in 512-bit arithmetic, so the small errors are not lost to rounding.
# Mathews draws no graph for this example, so the window is chosen here.
# Produces: matexpaa.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))
sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))   # 12 -> "₁₂"
fmt9(x) = um(@sprintf("%.9g", Float64(x)))                 # partial sums and e^A: 9 s.f.
const SUP = Dict(zip("-0123456789", "⁻⁰¹²³⁴⁵⁶⁷⁸⁹"))
function fmte(x)                                           # computed errors: 4 s.f.
    s = @sprintf("%#.4g", Float64(x))
    occursin('e', s) || return um(s)
    m, e = split(s, 'e')
    return m * "×10" * map(c -> SUP[c], string(parse(Int, e)))
end

setprecision(BigFloat, 512)

# --- Parameters (Mathews' Example 1) ---
gif_name = "matexpaa.gif"
A     = BigInt[2 1; 1 2]
Ns    = 1:20                       # number of terms in the partial sum
tlims = (0.0, 2.0)
vlims = (0.5, 500.0)               # entry panel (log scale)
elims = (1e-15, 1e3)               # error panel (log scale)
t1    = 1                          # part (a): e^A
title_str = "Series for the matrix exponential (Mathews' Example 1),  A = [2 1; 1 2]\n" *
            "partial sum of the first N terms:  S_N(t) = I + At + (At)²/2! + ⋯ + (At)ᴺ⁻¹/(N−1)!"

# Exact powers A^0 ... A^(Nmax-1), checked against A^n = (1/2)[3^n+1 3^n-1; 3^n-1 3^n+1]
pw = [A^n for n in 0:last(Ns)-1]
for (k, P) in enumerate(pw)
    n = k - 1
    @assert P == [(3^big(n) + 1) (3^big(n) - 1); (3^big(n) - 1) (3^big(n) + 1)] .÷ 2
end

# Partial sum S_N(t), all four entries, in BigFloat
function S(N, t)
    s = zeros(BigFloat, 2, 2)
    term = one(BigFloat)                    # t^n / n!
    for n in 0:N-1
        s .+= pw[n+1] .* term
        term *= t / (n + 1)
    end
    return s
end
E11(t) = (exp(t) + exp(3t)) / 2               # exact (e^{At})_11
E12(t) = (exp(3t) - exp(t)) / 2               # exact (e^{At})_12

# Grid: geometric points from 1e-3 up to the first uniform point, then uniform
nu = 800
tb = vcat([big(10)^e for e in range(-3, log10(2 / nu), length=30)[1:end-1]],
          [BigFloat(2) * i / nu for i in 1:nu])
@assert any(==(BigFloat(t1)), tb)
ts  = Float64.(tb)
ex  = Float64.(E11.(tb))
SN  = [[S(N, t) for t in tb] for N in Ns]
err = [[E11(t) - s[1, 1] for (t, s) in zip(tb, SN[k])] for k in eachindex(Ns)]
# The diagonal error is the largest of the four, and every error is positive (t > 0)
for k in eachindex(Ns), (i, t) in enumerate(tb)
    s = SN[k][i]
    e12 = E12(t) - s[1, 2]
    @assert err[k][i] > 0 && e12 > 0 && err[k][i] >= e12
    @assert s[1, 1] == s[2, 2] && s[1, 2] == s[2, 1]
end
@assert all(maximum(err[k]) < elims[2] for k in eachindex(Ns))
@assert maximum(ex) < vlims[2] && minimum(ex) >= 1

# Values at t = 1 (part (a)), printed for the ledger
i1 = findfirst(==(BigFloat(t1)), tb)
println("exact e^A: ", fmt9(E11(big(1))), "  ", fmt9(E12(big(1))))

# Log panels, drawn position only: a value below the panel is drawn one decade below
# the bottom edge, so the curve visibly leaves the panel there.
logdraw(e, lo) = max(Float64(e), lo / 10)

# --- Animation: one partial sum per frame ---
function draw_frame(k)
    N = Ns[k]
    s1 = SN[k][i1][1, 1]
    e1 = err[k][i1]
    pT = plot(xlims=tlims, ylims=vlims, yscale=:log10, framestyle=:box, xlabel="t",
              ylabel="(1,1) entry", legend=:topleft, legendfontsize=9, titlefontsize=11,
              grid=true, yticks=([1, 10, 100], ["1", "10", "100"]))
    for kk in 1:k-1
        plot!(pT, ts, logdraw.(getindex.(SN[kk], 1, 1), vlims[1]); color=:gray70, lw=1,
              label=kk == 1 ? "earlier partial sums" : "")
    end
    plot!(pT, ts, ex; color=:magenta, lw=2.5, label="exact (eᴬᵗ)₁₁ = (eᵗ + e³ᵗ)/2")
    plot!(pT, ts, logdraw.(getindex.(SN[k], 1, 1), vlims[1]); color=:royalblue, lw=2,
          label="(S$(sub(N))(t))₁₁")
    vline!(pT, [t1]; color=:darkgreen, ls=:dot, lw=1.5, label="")
    scatter!(pT, [t1], [Float64(s1)]; color=:royalblue, ms=5, label="")
    TT = "N = $N term$(N == 1 ? "" : "s"):  (S$(sub(N))(1))₁₁ = $(fmt9(s1)),  exact $(fmt9(E11(big(1))))"
    title!(pT, TT)

    pB = plot(xlims=tlims, ylims=elims, yscale=:log10, framestyle=:box, xlabel="t",
              ylabel="error of the (1,1) entry", legend=:bottomright, legendfontsize=9,
              titlefontsize=11, grid=true, yticks=10.0 .^ (-15:3:3))
    for kk in 1:k-1
        plot!(pB, ts, logdraw.(err[kk], elims[1]); color=:gray70, lw=1,
              label=kk == 1 ? "earlier N" : "")
    end
    plot!(pB, ts, logdraw.(err[k], elims[1]); color=:royalblue, lw=2, label="N = $N")
    vline!(pB, [t1]; color=:darkgreen, ls=:dot, lw=1.5, label="")
    scatter!(pB, [t1], [Float64(e1)]; color=:royalblue, ms=5, label="")
    TB = "error at t = 1:  $(fmte(e1))   (largest of the four entries' errors)"
    title!(pB, TB)
    println("TITLE: ", TT)
    println("TITLE: ", TB)

    plot(pT, pB; layout=(2, 1), size=(900, 900), plot_title=title_str,
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=3Plots.mm,
         background_color=:white)
end

anim = Animation()
for k in eachindex(Ns)
    draw_frame(k)
    frame(anim)
end
for _ in 1:3                                         # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=2)
println("Saved: ", gif_name)
