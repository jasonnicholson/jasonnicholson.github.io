# powerbb.jl
# Power Method animation: the power method on Mathews' Example 2, a 6 x 6 matrix
# with eigenvalues 4, 3, 2, 1, -1, -2, from X0 = (1, 1, 1, 1, 1, 1) with
# tolerance 2e-6, one iteration per frame, k = 0, ..., 40 (Mathews' run stops
# at k = 40). New animation: Mathews' Power Method module has no animation.
# Left panel: the six coordinates of X_k as bars, with the coordinates of the
# normalized dominant eigenvector V1 = (1/3, 0, -2/3, 1, 0, 1/3) as black marks.
# Right panel: |c_k - 4| (filled marker where c_k > 4, hollow where c_k < 4;
# c_2 = 4 exactly cannot be drawn on a log axis and is written in the panel),
# ||X_k - V1||_2 and the step size of Mathews' test
#   max(|c_k - c_(k-1)|, ||X_k - X_(k-1)||_2) < eps   (c_0 = 0)
# on a log scale.
# The iteration runs in exact rational arithmetic (Rational{BigInt}); norms are
# taken in 256-bit floating point after the exact subtraction.
# Produces: powerbb.gif

using Plots
using Printf
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
fmtc(x) = x == 0 ? "0" : tenpow(@sprintf("%.10g", Float64(x)))

# --- Parameters (Mathews' Example 2) ---
A = Rational{BigInt}[ 87  270 -12 -49 -276  40;
                     -14  -45   6  10   46  -4;
                     -50 -156   4  25  162 -25;
                      94  294  -5 -47 -306  49;
                       1    1   3   1    0   2;
                      16   48   1  -6  -48   8]
X0 = ones(Rational{BigInt}, 6)
eps_tol = big(2) // big(10)^6
max_iter = 50
lambda1 = big(4) // 1
V1 = Rational{BigInt}[1//3, 0, -2//3, 1, 0, 1//3]      # (1, 0, -2, 3, 0, 1) / 3
gif_name = "powerbb.gif"
A * V1 == lambda1 * V1 || error("V1 is not an eigenvector for 4")

# Mathews' maxsize: the coordinate of largest magnitude, the positive one on a tie
function maxsize(y)
    s = sort(y)
    return abs(s[end]) >= abs(s[1]) ? s[end] : s[1]
end
norm2(v) = sqrt(sum(BigFloat.(v) .^ 2))

# --- The run ---
Xs = [X0]
cs = Rational{BigInt}[0]                       # c_0 = 0
steps = BigFloat[NaN]
k_stop = 0
for k in 1:max_iter
    Y = A * Xs[end]
    c = maxsize(Y)
    X = Y / c
    step = max(BigFloat(abs(c - cs[end])), norm2(X - Xs[end]))
    push!(Xs, X); push!(cs, c); push!(steps, step)
    if step < eps_tol
        global k_stop = k
        break
    end
end
k_stop == 40 || error("expected Mathews' 40 iterations, got $k_stop")

ks = 0:k_stop
cerr = [k == 0 ? NaN : Float64(cs[k+1] - lambda1) for k in ks]   # exact c_k - 4
verr = [Float64(norm2(Xs[k+1] - V1)) for k in ks]
stp = [Float64(steps[k+1]) for k in ks]

# --- Frames ---
labels = ["x₁", "x₂", "x₃", "x₄", "x₅", "x₆"]
function frame(k)
    Xk = Float64.(Xs[k+1])
    # Left: bars
    pL = plot(xlims=(0.4, 6.6), ylims=(-0.8, 1.15), framestyle=:box,
              xticks=(1:6, labels), ylabel="coordinate value",
              legend=:bottomright, legendfontsize=7, titlefontsize=10, grid=false)
    hline!(pL, [0.0]; color=:black, lw=0.8, label="")
    bar!(pL, 1:6, Xk; bar_width=0.6, color=:steelblue, linecolor=:steelblue,
         label="X" * sub(k))
    for i in 1:6
        v = Float64(V1[i])
        plot!(pL, [i - 0.4, i + 0.4], [v, v]; color=:black, lw=2.5,
              label=(i == 1 ? "V₁ = (⅓, 0, −⅔, 1, 0, ⅓)" : ""))
    end
    title!(pL, "Coordinates of X" * sub(k) *
               "\nx₂ = " * fmt(Xs[k+1][2]) * ",  x₅ = " * fmt(Xs[k+1][5]))

    # Right: errors on a log scale
    pR = plot(xlims=(-0.5, k_stop + 0.5), ylims=(1e-13, 1e3), yscale=:log10,
              framestyle=:box, xlabel="iteration k", ylabel="size",
              legend=:bottomleft, legendfontsize=7, titlefontsize=10,
              yticks=10.0 .^ (-12:3:3), minorgrid=false)
    hline!(pR, [Float64(eps_tol)]; color=:green, ls=:dot, lw=1.5,
           label="tolerance ε = 2 × 10⁻⁶")
    if k >= 1
        plot!(pR, 1:k, stp[2:k+1]; color=:purple, lw=1.5, marker=:utriangle, ms=4,
              markerstrokewidth=0, label="step max(|cₖ − cₖ₋₁|, ‖Xₖ − Xₖ₋₁‖₂)")
        # |c_k - 4| on the log axis; the exact zero at k = 2 is left out of the line
        kk = [j for j in 1:k if cerr[j+1] != 0]
        kc = [j for j in 1:k]
        yline = [cerr[j+1] == 0 ? NaN : abs(cerr[j+1]) for j in kc]
        plot!(pR, kc, yline; color=:orange, lw=1, label="")
        kp = [j for j in kk if cerr[j+1] > 0]
        kn = [j for j in kk if cerr[j+1] < 0]
        scatter!(pR, kp, abs.(cerr[kp .+ 1]); color=:orange, ms=4.5,
                 markerstrokecolor=:orange, label="|cₖ − 4|, cₖ > 4")
        if !isempty(kn)
            scatter!(pR, kn, abs.(cerr[kn .+ 1]); color=:white, ms=4.5,
                     markerstrokecolor=:orange, markerstrokewidth=1.5,
                     label="|cₖ − 4|, cₖ < 4")
        end
        if k >= 2
            annotate!(pR, 9.0, 60.0, text("c₂ = 4 exactly: |c₂ − 4| = 0 has no point on the log axis",
                                          7, :left, :darkorange))
        end
    end
    plot!(pR, 0:k, verr[1:k+1]; color=:steelblue, lw=1.5, marker=:square, ms=3.5,
          markerstrokewidth=0, label="‖Xₖ − V₁‖₂")
    if k == 0
        title!(pR, "k = 0: X₀ = (1, 1, 1, 1, 1, 1), c₀ = 0\n‖X₀ − V₁‖₂ = " * fmt(verr[1]))
    else
        # c_k to 10 significant figures, left out once that would round it to 4
        cstr = fmtc(cs[k+1]) == "4" && cs[k+1] != 4 ? "" : "c" * sub(k) * " = " * fmtc(cs[k+1]) * ", "
        title!(pR, "k = $k: " * cstr * "c" * sub(k) * " − 4 = " * fmt(cerr[k+1]) *
                   "\nstep = " * fmt(stp[k+1]) *
                   (k == k_stop ? " < ε: stop" : "") *
                   ",  ‖X" * sub(k) * " − V₁‖₂ = " * fmt(verr[k+1]))
    end

    plot(pL, pR; layout=(1, 2), size=(1150, 560),
         plot_title="Power method, Mathews' Example 2:  6 × 6 matrix, eigenvalues 4, 3, 2, 1, −1, −2,  X₀ = (1, 1, 1, 1, 1, 1)",
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white)
end

frames = vcat(collect(0:k_stop), fill(k_stop, 3))     # hold the last frame
anim = @animate for k in frames
    frame(k)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=3)
println("Saved: $gif_name  (", length(frames), " frames)")
println("c_40 - 4 = ", cerr[end], "  ||X40-V1|| = ", verr[end], "  step40 = ", stp[end])
