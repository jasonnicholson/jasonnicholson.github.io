# newtonsearchcc.jl
# Newton's search method animation: Example 4, Rosenbrock's function f(x, y) = 100(y - x^2)^2 + (1 - x)^2.
# Two runs side by side, k = 0..5: Mathews' start (0.99, 1.01), and (1.8, 1.2), the start of his
# FindMinimum comparison. Each panel shows the contours of f, the valley floor y = x^2 and the
# minimum (1, 1); the titles give P_k, f(P_k), the distance to (1, 1) and the type of the Hessian.
# Bottom: f(P_k) of both runs on a log scale; from (1.8, 1.2) it rises at k = 2.
# The iteration runs in 256-bit BigFloat arithmetic, so every label is correct to the digits shown.
# Produces: newtonsearchcc.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
# Here with four significant figures and their trailing zeros kept: both runs reach (1.000, 1.000) to four
# figures, which must not read as the exact minimum (1, 1).
function fmt(x)
    x == 0 && return "0 (double-precision zero)"
    r = round(Float64(x), sigdigits=4)          # four significant figures, as C's "%#.4g"
    e = floor(Int, log10(abs(r)))
    return (e < -4 || e >= 4) ? @sprintf("%.3e", r) : Printf.format(Printf.Format("%.$(3 - e)f"), r)
end

setprecision(BigFloat, 256)

# --- Function, gradient, Hessian [a b; b c] ---
f(x, y)    = 100 * (y - x^2)^2 + (1 - x)^2
fx(x, y)   = -400x * (y - x^2) - 2 * (1 - x)
fy(x, y)   = 200 * (y - x^2)
hess(x, y) = (1200x^2 - 400y + 2, -400x, 200 * one(x))

eig2(a, b, c) = ((a + c) / 2 - hypot((a - c) / 2, b), (a + c) / 2 + hypot((a - c) / 2, b))
function kind(a, b, c)
    l1, l2 = eig2(a, b, c)
    l1 > 0 ? "positive definite" : (l2 < 0 ? "negative definite" : "indefinite")
end
hk(p) = kind(hess(p...)...)

function newton_step(x, y)
    g1, g2 = fx(x, y), fy(x, y)
    a, b, c = hess(x, y)
    d = a * c - b^2
    return (-(c * g1 - b * g2) / d, -(a * g2 - b * g1) / d)
end

function run_newton(sx, sy, n)
    P = [(parse(BigFloat, sx), parse(BigFloat, sy))]
    for k in 1:n
        dx, dy = newton_step(P[end]...)
        push!(P, (P[end][1] + dx, P[end][2] + dy))
    end
    return P
end

sub(k) = join(Char(0x2080 + d) for d in reverse(digits(k)))

n = 5
A = run_newton("0.99", "1.01", n)    # Mathews' Example 4
B = run_newton("1.8", "1.2", n)      # start of Mathews' FindMinimum comparison
dist(p) = hypot(p[1] - 1, p[2] - 1)
fA = [f(p...) for p in A]; fB = [f(p...) for p in B]

# Log-spaced contour levels (f runs from 0 to over 1000 in the wide window)
levels_wide  = 10.0 .^ (-2:0.5:3.5)
levels_close = 10.0 .^ (-6:0.5:0)

function panel(P, k, xl, yl, levs, label, col, legpos)
    xg = range(xl..., length=241); yg = range(yl..., length=241)
    Z = [f(x, y) for y in yg, x in xg]
    p = P[k+1]
    t2 = "P$(sub(k)) = ($(fmt(p[1])), $(fmt(p[2]))),  f(P$(sub(k))) = $(fmt(f(p...)))"
    t3 = "‖P$(sub(k)) − (1, 1)‖ = $(fmt(dist(p))),  H(P$(sub(k))) $(hk(p))"
    plt = plot(xlims=xl, ylims=yl, xlabel="x", ylabel="y",
               title="Run from $label, k = $k\n" * t2 * "\n" * t3,
               titlefontsize=10, legend=legpos, legendfontsize=7, framestyle=:box,
               grid=false, background_color=:white)
    contour!(plt, xg, yg, Z; levels=levs, linecolor=:gray70, lw=0.7, colorbar=false, label="")
    plot!(plt, [NaN], [NaN]; color=:gray70, lw=0.7, label="contours of f (log-spaced levels)")
    xv = range(xl..., length=200)
    plot!(plt, xv, xv .^ 2; color=:darkorange, lw=1.3, ls=:dash, label="valley floor y = x²")
    scatter!(plt, [1.0], [1.0]; marker=:star5, ms=10, color=:green3, msc=:black, msw=0.6,
             label="minimum (1, 1)")
    Pf = [Float64.(q) for q in P[1:k+1]]
    plot!(plt, first.(Pf), last.(Pf); color=col, lw=1.8, marker=:circle, ms=3.5, msw=0,
          label="P₀ … P$(sub(k))")
    scatter!(plt, [Pf[end][1]], [Pf[end][2]]; color=col, ms=6, msc=:white, msw=1, label="")
    return plt
end

anim = Animation()
for k in 0:n
    L = panel(A, k, (0.984, 1.004), (0.97, 1.015), levels_close, "(0.99, 1.01)", :blue, :bottomright)
    R = panel(B, k, (0.5, 2.0), (0.0, 3.5), levels_wide, "(1.8, 1.2)", :red, :topleft)
    D = plot(xlims=(-0.3, n + 0.3), ylims=(1e-52, 1e4), yscale=:log10, xticks=0:n,
             yticks=10.0 .^ (-50:10:0), xlabel="k", ylabel="f(P_k)",
             title="f(P_k) on a log scale (f ≥ 0, minimum value 0)", titlefontsize=10,
             legend=:bottomleft, legendfontsize=8, framestyle=:box, background_color=:white)
    plot!(D, 0:k, Float64.(fA[1:k+1]); color=:blue, lw=1.8, marker=:circle, ms=4, msw=0,
          label="from (0.99, 1.01)")
    plot!(D, 0:k, Float64.(fB[1:k+1]); color=:red, lw=1.8, marker=:circle, ms=4, msw=0,
          label="from (1.8, 1.2)")
    if k >= 2      # the one step on which f goes up
        annotate!(D, 2.12, Float64(fB[3]), text("from (1.8, 1.2), f rises: f(P₁) = $(fmt(fB[2])), f(P₂) = $(fmt(fB[3]))",
                  8, :red, :left))
    end
    for (nm, P, fs) in (("A", A, fA), ("B", B, fB))
        p = P[k+1]
        l1, l2 = eig2(hess(p...)...)
        @printf("k=%d %s: P=(%.12f, %.12f) f=%.4g dist=%.3g H %s (%.4g, %.4g) y-x^2=%.3g %s\n",
                k, nm, p[1], p[2], fs[k+1], dist(p), hk(p), l1, l2, p[2] - p[1]^2,
                k == 0 ? "" : (fs[k+1] < fs[k] ? "f decreased" : "f INCREASED"))
    end
    plt = plot(L, R, D; layout=@layout([a b; c{0.28h}]), size=(1250, 1000),
               left_margin=5Plots.mm, top_margin=3Plots.mm)
    frame(anim, plt)
end

gif(anim, joinpath(@__DIR__, "newtonsearchcc.gif"); fps=1)
println("Saved: newtonsearchcc.gif")
