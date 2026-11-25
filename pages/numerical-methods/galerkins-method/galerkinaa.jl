# galerkinaa.jl
# Galerkin's Method animation: Mathews' Example 2 as his notebook solves it,
# y' + 5y - 1 - x + sin 2x = 0, y(0) = 1, on [0, 3], with the trial solution
# u_n(x) = 1 + c_1 x + ... + c_n x^n. One frame per number of basis functions,
# n = 1, ..., 16 (Mathews uses n = 7).
# Left: u_n against the exact solution, in Mathews' window [0, 3] and with his
# colours (exact magenta, Galerkin solution blue).
# Middle (new): the error |y(x) - u_n(x)| on a log scale.
# Right (new): the largest error on [0, 3] and cond(A_n) (infinity-norm, as
# Mathews computes it) against n, for the Galerkin system solved in 512-bit
# arithmetic and for the same system rounded to double precision and solved
# with Julia's LU solver (A \ B).
# The matrix A is exact (rational entries); the right-hand side B contains
# sin 6 and cos 6 and is computed in 512-bit floating point, as is the solve.
# Produces: galerkinaa.gif

using Plots
using Printf
using LinearAlgebra
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))        # exact values
const SUP = Dict(zip("0123456789-", "⁰¹²³⁴⁵⁶⁷⁸⁹⁻"))
function sci(x)                                                  # computed: 4 s.f.
    x = Float64(x)
    (1e-3 <= abs(x) < 1e4) && return um(@sprintf("%#.4g", x))
    e = floor(Int, log10(abs(x)))
    m = x / 10.0^e
    if abs(round(m, digits=3)) >= 10                             # 9.9996 -> 10.00
        e += 1
        m = x / 10.0^e
    end
    return um(@sprintf("%.3f", m)) * "×10" * join(SUP[c] for c in string(e))
end

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))     # 12 -> "₁₂"

# --- Parameters (Mathews' Example 2, as solved in his notebook) ---
gif_name  = "galerkinaa.gif"
setprecision(BigFloat, 512)
const BF  = BigFloat
a, b      = 0, 3                                     # interval [0, 3]
n_max     = 16
yexact(x) = (116 + 559 * exp(-5x) + 145x + 50cos(2x) - 125sin(2x)) / 725
xlims     = (0.0, 3.0)                               # Mathews' window
ylims     = (0.0, 1.15)                              # every u_n stays inside
elims     = (1e-10, 1.0)                             # error panel (log scale)
title_str = "Galerkin's method (Mathews' Example 2):  y′ + 5y − 1 − x + sin 2x = 0,  y(0) = 1,  " *
            "uₙ(x) = 1 + c₁x + ⋯ + cₙxⁿ"

# --- Galerkin system for the basis x, x^2, ..., x^n (page, Example 2, Step 4) ---
# a_ij = int_0^3 x^i (j x^(j-1) + 5 x^j) dx  (exact rationals)
# b_i  = -int_0^3 x^i (4 - x + sin 2x) dx      (L[1] + f = 5 - 1 - x + sin 2x)
Aq(n) = [Rational{BigInt}(j * big(3)^(i + j), i + j) + Rational{BigInt}(5 * big(3)^(i + j + 1), i + j + 1)
         for i in 1:n, j in 1:n]
# I_i = int_0^3 x^i sin 2x dx and J_i = int_0^3 x^i cos 2x dx by integration by parts
function trig_moments(N)
    I = zeros(BF, N + 1); J = zeros(BF, N + 1)      # I[i+1] = I_i
    s6, c6 = sin(BF(6)), cos(BF(6))
    I[1] = (1 - c6) / 2
    J[1] = s6 / 2
    for i in 1:N
        I[i+1] = -BF(3)^i * c6 / 2 + (BF(i) / 2) * J[i]
        J[i+1] =  BF(3)^i * s6 / 2 - (BF(i) / 2) * I[i]
    end
    return I
end
const Isin = trig_moments(n_max)
Bv(n) = [-(4 * BF(3)^(i + 1) / (i + 1) - BF(3)^(i + 2) / (i + 2) + Isin[i+1]) for i in 1:n]

# Checks against the page: a_11 = 99/2, a_77 = 14348907/2, b_1 = -7.48989, and
# Mathews' coefficients for n = 7.
@assert Aq(7)[1, 1] == 99 // 2 && Aq(7)[7, 7] == 14348907 // 2
@assert abs(Bv(1)[1] - (-9 + 3cos(BF(6)) / 2 - sin(BF(6)) / 4)) < BF(10)^-140
let c7 = BF.(Aq(7)) \ Bv(7)
    mathews = [-3.65784, 6.84171, -7.37284, 4.88613, -1.84964, 0.363990, -0.0289550]
    @assert all(abs.(Float64.(c7) .- mathews) .<= 5e-6 .* abs.(mathews)) "n = 7 coefficients"
end

# --- Solve for n = 1, ..., n_max: 512-bit and double precision ---
cs   = [BF.(Aq(n)) \ Bv(n) for n in 1:n_max]                   # Galerkin coefficients
csd  = [Float64.(Aq(n)) \ Float64.(Bv(n)) for n in 1:n_max]    # double-precision solve
cond_inf = [Float64(opnorm(BF.(Aq(n)), Inf) * opnorm(inv(BF.(Aq(n))), Inf)) for n in 1:n_max]
ueval(c, x) = 1 + x * foldr((ck, s) -> ck + x * s, c; init=zero(x))   # 1 + sum c_j x^j

# --- Errors on a 6001-point grid, largest error refined by golden-section search ---
N  = 6001
xb = [BF(a) + BF(b - a) * (k - 1) / (N - 1) for k in 1:N]
yb = yexact.(xb)
err(c) = [yb[k] - ueval(c, xb[k]) for k in 1:N]
function maxabs(c)
    g(x) = abs(yexact(x) - ueval(c, x))
    e = abs.(err(c))
    k = argmax(e)
    lo, hi = xb[max(k - 1, 1)], xb[min(k + 1, N)]
    φ = (sqrt(BF(5)) - 1) / 2
    for _ in 1:200
        m1 = hi - φ * (hi - lo); m2 = lo + φ * (hi - lo)
        g(m1) >= g(m2) ? (hi = m2) : (lo = m1)
    end
    xm = (lo + hi) / 2
    return max(g(xm), e[k]), (g(xm) >= e[k] ? xm : xb[k])
end
errs  = [err(c) for c in cs]
errsd = [err(BF.(c)) for c in csd]
mx    = [maxabs(c) for c in cs]
mxd   = [maxabs(BF.(c)) for c in csd]
maxerr  = [m[1] for m in mx]
argmaxx = [m[2] for m in mx]
maxerrd = [m[1] for m in mxd]
for n in 1:n_max
    @printf("n = %2d: max|y - u_n| = %s at x = %.4f;  double-precision solve: %s;  cond_inf(A) = %s\n",
            n, sci(maxerr[n]), Float64(argmaxx[n]), sci(maxerrd[n]), sci(cond_inf[n]))
end

# A 1×1 matrix has condition number exactly 1
condstr(n) = n == 1 ? "1" : sci(cond_inf[n])
let us = [Float64(ueval(c, x)) for c in cs for x in xb]
    @printf("range of u_n over [0, 3], n = 1..%d: [%.4f, %.4f]\n", n_max, minimum(us), maximum(us))
end

# Drawing helpers
xs = Float64.(xb)
ys = Float64.(yb)
# Log panel, drawn position only: an error below the panel (including the exact
# zero at x = 0 and at every sign change) is drawn one decade below the bottom
# edge, so the curve visibly leaves the panel there.
logdraw(e) = max(Float64(abs(e)), elims[1] / 10)

# --- Animation: one value of n per frame ---
function draw_frame(n)
    pL = plot(xlims=xlims, ylims=ylims, framestyle=:box, xlabel="x", ylabel="y",
              legend=:top, legendfontsize=8, titlefontsize=10, grid=true)
    for k in 1:n-1
        plot!(pL, xs, ydraw.(Float64.(ueval.(Ref(cs[k]), xb)), Ref(ylims)); color=:gray75, lw=1,
              label=k == 1 ? (n == 2 ? "u₁" : "u₁ … u$(sub(n-1))") : "")
    end
    plot!(pL, xs, ys; color=:magenta, lw=2.5, label="exact y")
    plot!(pL, xs, ydraw.(Float64.(ueval.(Ref(cs[n]), xb)), Ref(ylims)); color=:royalblue,
          lw=2.5, label="Galerkin u$(sub(n))")
    scatter!(pL, [0.0], [1.0]; color=:red, ms=4, label="y(0) = 1")
    title!(pL, n == 1 ? "n = 1 basis function, x" : n == 2 ? "n = 2 basis functions, x and x²" :
               "n = $n basis functions, x, x², …, x" * join(SUP[c] for c in string(n)))

    pM = plot(xlims=xlims, ylims=elims, yscale=:log10, framestyle=:box, xlabel="x",
              ylabel="|y(x) − uₙ(x)|", legend=:bottomright, legendfontsize=8,
              titlefontsize=10, grid=true, yticks=10.0 .^ (-10:0))
    plot!(pM, xs, logdraw.(errsd[n]); color=:darkorange, lw=1.5, ls=:dash,
          label="double-precision solve")
    plot!(pM, xs, logdraw.(errs[n]); color=:royalblue, lw=2, label="|y − u$(sub(n))|")
    title!(pM, "max |y − u$(sub(n))| on [0, 3] = $(sci(maxerr[n]))")

    pR = plot(xlims=(0.5, n_max + 0.5), ylims=elims, yscale=:log10, framestyle=:box,
              title="cond∞(A$(sub(n))) = $(condstr(n))",
              xlabel="n", ylabel="largest error on [0, 3]", legend=:bottom,
              legendfontsize=8, titlefontsize=10, grid=true, yticks=10.0 .^ (-10:0),
              xticks=1:n_max, right_margin=14Plots.mm)
    scatter!(pR, 1:n, Float64.(maxerr[1:n]); color=:royalblue, ms=5, label="Galerkin (512-bit solve)")
    scatter!(pR, 1:n, Float64.(maxerrd[1:n]); color=:darkorange, ms=4, marker=:diamond,
             label="double-precision solve")
    plot!(pR, [NaN], [NaN]; color=:purple, marker=:utriangle, lw=1, label="cond∞(Aₙ), right axis")
    pT = twinx(pR)
    plot!(pT, 1:n, cond_inf[1:n]; title="", color=:purple, marker=:utriangle, ms=4, lw=1, yscale=:log10,
          ylims=(1.0, 1e30), yticks=10.0 .^ (0:5:30), xlims=(0.5, n_max + 0.5), label="",
          ylabel="cond∞(Aₙ)", grid=false)

    plot(pL, pM, pR; layout=(1, 3), size=(1500, 520), plot_title=title_str,
         plot_titlefontsize=12, left_margin=6Plots.mm, bottom_margin=6Plots.mm,
         background_color=:white)
end

anim = Animation()
for n in 1:n_max
    draw_frame(n)
    frame(anim)
end
for _ in 1:2                                         # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: ", gif_name)
