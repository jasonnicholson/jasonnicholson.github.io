# poweraa.jl
# Power Method animation: the power method on Mathews' Example 1,
#   A = [0 11 -5; -2 17 -7; -4 26 -10],  X0 = (1, 1, 1),  tolerance 1e-6,
# one iteration per frame, k = 0, ..., 22 (Mathews' run stops at k = 22).
# New animation: Mathews' Power Method module has no animation.
# Left panel: every normalized X_k has third coordinate 1, so it is a point of
# the plane x3 = 1, drawn in offsets from V1 = (2/5, 3/5, 1). The window zooms
# with every frame so that X_k and X_(k-1) stay visible. The dashed line joins
# V1 to the normalized eigenvector W2 = (1/4, 1/2, 1) for lambda = 2: X0 has no
# component along the third eigenvector (1, 1, 2), so every X_k lies on it.
# Right panel: |c_k - 4|, ||X_k - V1||_2 and the step size of Mathews' test
#   max(|c_k - c_(k-1)|, ||X_k - X_(k-1)||_2) < eps   (c_0 = 0)
# on a log scale.
# The iteration runs in exact rational arithmetic (Rational{BigInt}); norms are
# taken in 256-bit floating point after the exact subtraction.
# Produces: poweraa.gif

using Plots
using Printf
using LinearAlgebra
gr()
setprecision(BigFloat, 256)

const SUPS = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹']
sup(n) = (n < 0 ? "⁻" : "") * join(SUPS[d+1] for d in reverse(digits(abs(n))))
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
const SUBS = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉']
sub(n) = join(SUBS[d+1] for d in reverse(digits(n)))

# --- Parameters (Mathews' Example 1) ---
A = Rational{BigInt}[0 11 -5; -2 17 -7; -4 26 -10]
X0 = Rational{BigInt}[1, 1, 1]
eps_tol = big(1) // big(10)^6
max_iter = 50
lambda1 = big(4) // 1
V1 = Rational{BigInt}[2//5, 3//5, 1]           # eigenvector (2, 3, 5) / 5
W2 = Rational{BigInt}[1//4, 1//2, 1]           # eigenvector (1, 2, 4) / 4, lambda = 2
gif_name = "poweraa.gif"

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
k_stop == 22 || error("expected Mathews' 22 iterations, got $k_stop")
all(X[3] == 1 for X in Xs) || error("third coordinate is not 1 at every step")

ks = 0:k_stop
cerr = [k == 0 ? NaN : Float64(cs[k+1] - lambda1) for k in ks]   # exact c_k - 4
verr = [Float64(norm2(Xs[k+1] - V1)) for k in ks]
stp = [Float64(steps[k+1]) for k in ks]
# every X_k on the line through V1 and W2 (exact check)
d = W2 - V1
all((X[1] - V1[1]) * d[2] == (X[2] - V1[2]) * d[1] for X in Xs) ||
    error("an iterate is off the line through V1 and W2")

# --- Frames ---
function frame(k)
    # Left: plane x3 = 1, offsets from V1, zoomed on X_(k-1) and X_k
    ref = Xs[max(k, 1)]                        # X_(k-1) for k >= 1, X_0 for k = 0
    ox, oy = Float64(ref[1] - V1[1]), Float64(ref[2] - V1[2])
    e = -floor(Int, log10(ox))
    s = 10.0^e
    xl = (-0.35 * ox * s, 1.25 * ox * s)
    yl = (-0.35 * oy * s - 0.25 * ox * s, 1.25 * oy * s + 0.25 * ox * s)
    scl = e == 0 ? "" : " × 10" * sup(e)
    pL = plot(xlims=xl, ylims=yl, aspect_ratio=:equal, framestyle=:box,
              xlabel="(x₁ − 0.4)" * scl, ylabel="(x₂ − 0.6)" * scl,
              legend=:topleft, legendfontsize=7, titlefontsize=10, grid=false)
    # line through W2 and V1, drawn across the window
    dx, dy = Float64(d[1]), Float64(d[2])
    L = max(abs(xl[1]), abs(xl[2])) / (abs(dx) * s)
    plot!(pL, [-L * dx * s, L * dx * s], [-L * dy * s, L * dy * s];
          color=:gray, ls=:dash, lw=1, label="line through W₂ and V₁")
    if xl[1] <= dx * s                         # W2 is inside the window (k = 0, 1)
        scatter!(pL, [dx * s], [dy * s]; color=:gray, marker=:diamond, ms=6,
                 markerstrokewidth=0, label="W₂ = (¼, ½, 1), eigenvector for λ = 2")
    end
    # path X_0, ..., X_k
    px = [Float64(Xs[j+1][1] - V1[1]) * s for j in 0:k]
    py = [Float64(Xs[j+1][2] - V1[2]) * s for j in 0:k]
    if k >= 1
        scatter!(pL, px[1:end-1], py[1:end-1]; color=:steelblue, ms=4,
                 markerstrokewidth=0, label=(k == 1 ? "X₀" : "X₀, …, X" * sub(k - 1)))
    end
    scatter!(pL, [px[end]], [py[end]]; color=:red, ms=6, markerstrokewidth=0,
             label="X" * sub(k))
    scatter!(pL, [0.0], [0.0]; color=:black, marker=:star5, ms=8,
             label="V₁ = (0.4, 0.6, 1)")
    Xk = Xs[k+1]
    title!(pL, (k == 0 ? "Plane x₃ = 1, offsets from V₁" :
                "Plane x₃ = 1, zoomed on X" * sub(k - 1) * " and X" * sub(k)) *
               "\nX" * sub(k) * " = (" * fmtc(Xk[1]) * ", " * fmtc(Xk[2]) * ", 1)")

    # Right: errors on a log scale
    pR = plot(xlims=(-0.5, k_stop + 0.5), ylims=(1e-8, 1e2), yscale=:log10,
              framestyle=:box, xlabel="iteration k", ylabel="size",
              legend=:topright, legendfontsize=7, titlefontsize=10,
              yticks=10.0 .^ (-8:2:2), minorgrid=false)
    hline!(pR, [Float64(eps_tol)]; color=:green, ls=:dot, lw=1.5, label="tolerance ε = 10⁻⁶")
    # reference slope (1/2)^k through the last vector error
    kr = 0:k_stop
    plot!(pR, kr, verr[end] .* 2.0 .^ (k_stop .- kr); color=:gray, ls=:dash, lw=1,
          label="slope (½)ᵏ = |λ₂/λ₁|ᵏ")
    if k >= 1
        plot!(pR, 1:k, stp[2:k+1]; color=:purple, lw=1.5, marker=:utriangle, ms=4,
              markerstrokewidth=0, label="step max(|cₖ − cₖ₋₁|, ‖Xₖ − Xₖ₋₁‖₂)")
        plot!(pR, 1:k, cerr[2:k+1]; color=:orange, lw=1.5, marker=:circle, ms=4,
              markerstrokewidth=0, label="cₖ − 4")
    end
    plot!(pR, 0:k, verr[1:k+1]; color=:steelblue, lw=1.5, marker=:square, ms=3.5,
          markerstrokewidth=0, label="‖Xₖ − V₁‖₂")
    if k == 0
        title!(pR, "k = 0: X₀ = (1, 1, 1), c₀ = 0\n‖X₀ − V₁‖₂ = " * fmt(verr[1]))
    else
        title!(pR, "k = $k: c" * sub(k) * " = " * fmtc(cs[k+1]) *
                   ", c" * sub(k) * " − 4 = " * fmt(cerr[k+1]) *
                   "\nstep = " * fmt(stp[k+1]) *
                   (k == k_stop ? " < ε: stop" : "") *
                   ",  ‖X" * sub(k) * " − V₁‖₂ = " * fmt(verr[k+1]))
    end

    plot(pL, pR; layout=(1, 2), size=(1150, 560),
         plot_title="Power method, Mathews' Example 1:  A = [0 11 −5; −2 17 −7; −4 26 −10],  X₀ = (1, 1, 1)",
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white)
end

frames = vcat(collect(0:k_stop), fill(k_stop, 3))     # hold the last frame
anim = @animate for k in frames
    frame(k)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=2)
println("Saved: $gif_name  (", length(frames), " frames)")
println("c_22 - 4 = ", Float64(cs[end] - 4), "  ||X22-V1|| = ", verr[end], "  step22 = ", stp[end])
