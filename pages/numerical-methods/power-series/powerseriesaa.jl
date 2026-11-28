# powerseriesaa.jl
# Power Series animation: the page's Example 1, Airy's equation y'' = x y about
# x0 = 0 with y(0) = Ai(0), y'(0) = Ai'(0). Recurrence (3),
#   a_2 = 0,  a_{n+2} = a_{n-1} / ((n+2)(n+1)),  n = 1, 2, ...,
# gives the coefficients; one frame per partial sum S_N(x) = sum_{n=0}^{N} a_n x^n,
# N = 3, 6, ..., 120 (each frame adds the two nonzero terms a_{N-2} x^{N-2} and
# a_N x^N), drawn against Ai(x) in the page's window [-10, 3] x [-0.6, 0.8].
# The bottom panel plots the error |S_N(x) - Ai(x)| on a log scale with the
# tolerance 1e-3 dashed; green shading marks the interval about 0 on which the
# error stays below 1e-3 (the page's table for Example 1). R = infinity: the
# series converges for every x, so no radius is drawn.
# The coefficients are exact rationals times Ai(0) and Ai'(0) (from the Gamma
# function); the partial sums are evaluated in 256-bit arithmetic, because at
# x = -10 the terms grow to 2.3e7 before they decay, and the reference Ai(x) is
# SpecialFunctions' airyai for BigFloat (MPFR's mpfr_ai), also in 256-bit arithmetic.
# Produces: powerseriesaa.gif

using Plots
using Printf
using SpecialFunctions
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))
fmtv(x) = um(@sprintf("%#.4g", Float64(x)))                    # computed: 4 s.f.

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))   # 12 -> "₁₂"

setprecision(BigFloat, 256)
const Q = Rational{BigInt}

# --- Parameters (the page's Example 1) ---
gif_name = "powerseriesaa.gif"
Ns       = 3:3:120
Nmax     = last(Ns)
tol      = big"1e-3"
xlims    = (-10.0, 3.0)
ylims    = (-0.6, 0.8)
elims    = (1e-16, 1e8)
title_str = "Power series for Airy's equation y″ = xy about x₀ = 0,  y(0) = Ai(0), y′(0) = Ai′(0)"

# Recurrence (3) for the two basic solutions f (a0 = 1, a1 = 0) and g (a0 = 0, a1 = 1)
function airy_coeffs(a0::Q, a1::Q, N)
    a = zeros(Q, N + 1)
    a[1] = a0
    a[2] = a1
    a[3] = 0                                   # a_2 = 0
    for n in 1:N-2
        a[n+3] = a[n] / ((n + 2) * (n + 1))    # a_{n+2} = a_{n-1} / ((n+2)(n+1))
    end
    return a
end
fco = airy_coeffs(Q(1), Q(0), Nmax)
gco = airy_coeffs(Q(0), Q(1), Nmax)
# check against the product formulas of Step 4 and the coefficients printed there
for k in 0:Nmax÷3
    3k <= Nmax && @assert fco[3k+1] == 1 // prod(Q[(3j - 1) * 3j for j in 1:k]; init=Q(1))
    3k + 1 <= Nmax && @assert gco[3k+2] == 1 // prod(Q[3j * (3j + 1) for j in 1:k]; init=Q(1))
end
@assert fco[[1, 4, 7, 10]] == Q[1, 1//6, 1//180, 1//12960]
@assert gco[[2, 5, 8, 11]] == Q[1, 1//12, 1//504, 1//45360]
@assert all(fco[n+1] == 0 for n in 0:Nmax if n % 3 != 0)
@assert all(gco[n+1] == 0 for n in 0:Nmax if n % 3 != 1)

Ai0  = 1 / (big(3)^(big(2) / 3) * gamma(big(2) / 3))
Aip0 = -1 / (big(3)^(big(1) / 3) * gamma(big(1) / 3))
@assert abs(Ai0 - airyai(BigFloat(0))) < big"1e-70"          # MPFR mpfr_ai
@assert abs(Aip0 - airyaiprime(0.0)) < 1e-15                   # double precision
coef = [Ai0 * BigFloat(fco[n+1]) + Aip0 * BigFloat(gco[n+1]) for n in 0:Nmax]

# All partial sums S_0..S_Nmax at x (cumulative sums of the terms a_n x^n)
function psums(x::BigFloat)
    S = Vector{BigFloat}(undef, Nmax + 1)
    s = zero(BigFloat); p = one(BigFloat)
    for n in 0:Nmax
        s += coef[n+1] * p
        S[n+1] = s
        p *= x
    end
    return S
end
psum(N, x) = psums(x)[N+1]

# --- Grid: step 0.005 on [-10, 3] ---
xb  = [big(-10) + big(13) * i / 2600 for i in 0:2600]
xs  = Float64.(xb)
yex = airyai.(xb)
Sall = psums.(xb)                                  # Sall[i][N+1]
err = [[Float64(abs(Sall[i][N+1] - yex[i])) for i in eachindex(xb)] for N in Ns]
Sv  = [[Float64(Sall[i][N+1]) for i in eachindex(xb)] for N in Ns]

# Interval about 0 on which the error is below tol: march out from 0 on each side
# in steps of 0.001, then bisect; clipped to the window if no crossing in it.
function edge(N, dir)
    g(x) = abs(psum(N, x) - airyai(x)) - tol
    h = big"0.001" * dir
    x = zero(BigFloat)
    lim = dir > 0 ? big(xlims[2]) : big(xlims[1])
    while g(x) < 0
        x += h
        (dir > 0 ? x > lim : x < lim) && return (lim, false)   # no crossing in window
    end
    lo, hi = x - h, x
    for _ in 1:120
        m = (lo + hi) / 2
        g(m) < 0 ? (lo = m) : (hi = m)
    end
    return ((lo + hi) / 2, true)
end
edges = [(edge(N, -1), edge(N, 1)) for N in Ns]

# --- Report ---
for (k, N) in enumerate(Ns)
    (a, ca), (b, cb) = edges[k]
    i10 = 1                                          # x = -10
    out = any(v -> v < ylims[1] || v > ylims[2], Sv[k])
    @printf("N = %3d: err<1e-3 on [%s%s, %s%s]  err(-10) = %s  err(3) = %s  S_N leaves window: %s",
            N, fmt(a), ca ? "" : "(edge)", fmt(b), cb ? "" : "(edge)",
            fmt(err[k][i10]), fmt(err[k][end]), out)
    if out
        xo = xs[findall(v -> v < ylims[1] || v > ylims[2], Sv[k])]
        @printf("  (outside for x in %s .. %s, %s)", fmt(minimum(xo)), fmt(maximum(xo)),
                any(x -> x > 0, xo) ? "incl. right" : "left only")
    end
    println()
end
# Does the error dip below tol again outside the shaded interval? (grid points)
for (k, N) in enumerate(Ns)
    (a, _), (b, _) = edges[k]
    back = [x for (x, e) in zip(xs, err[k]) if (x < a - 1e-9 || x > b + 1e-9) && e < tol]
    isempty(back) || @printf("N = %d: error below tol again at %d grid points in [%s, %s]\n",
                             N, length(back), fmt(first(back)), fmt(last(back)))
end
@printf("max error on grid over all frames: %s\n", fmt(maximum(maximum.(err))))
@printf("min error on grid over all frames: %s\n", fmt(minimum(minimum.(err))))

# Log panel, drawn position only: an error below the panel is drawn one decade
# below the bottom edge, so the curve visibly leaves the panel there.
logdraw(e) = max(e, elims[1] / 10)
shade!(p, a, b, yl; label="") = plot!(p, Shape([a, b, b, a], [yl[1], yl[1], yl[2], yl[2]]);
                                      color=:palegreen, alpha=0.45, linealpha=0, label=label)

function draw_frame(k)
    N = Ns[k]
    (a, ca), (b, cb) = edges[k]
    a, b = Float64(a), Float64(b)
    ivl = ca && cb ? "on [$(fmtv(a)), $(fmtv(b))]" :
          ca       ? "from x = $(fmtv(a)) to the right edge" :
                     "on the whole window"
    pT = plot(xlims=xlims, ylims=ylims, framestyle=:box, xlabel="x", ylabel="y",
              legend=:bottomright, legendfontsize=9, titlefontsize=11, grid=true)
    shade!(pT, a, b, ylims; label="error < 10⁻³")
    hline!(pT, [0.0]; color=:black, lw=0.5, label="")
    plot!(pT, xs, Float64.(yex); color=:magenta, lw=2.5, label="Ai(x)")
    plot!(pT, xs, ydraw.(Sv[k], Ref(ylims)); color=:royalblue, lw=2, label="S$(sub(N))(x)")
    title!(pT, "N = $N:  error < 10⁻³ $ivl   (R = ∞)")

    pB = plot(xlims=xlims, ylims=elims, yscale=:log10, framestyle=:box, xlabel="x",
              ylabel="|S_N(x) − Ai(x)|", legend=:top, legendfontsize=9,
              titlefontsize=11, grid=true, yticks=10.0 .^ (-16:4:8))
    shade!(pB, a, b, elims)
    for kk in 1:k-1
        plot!(pB, xs, logdraw.(err[kk]); color=:gray80, lw=1, label=kk == 1 ? "earlier N" : "")
    end
    hline!(pB, [1e-3]; color=:darkgreen, ls=:dash, lw=1.5, label="tolerance 10⁻³")
    plot!(pB, xs, logdraw.(err[k]); color=:royalblue, lw=2, label="N = $N")
    title!(pB, "error of S$(sub(N)) at x = −10: $(fmt(err[k][1]))")
    plot(pT, pB; layout=(2, 1), size=(1000, 820), plot_title=title_str,
         plot_titlefontsize=12, left_margin=5Plots.mm, bottom_margin=3Plots.mm,
         background_color=:white)
end

anim = Animation()
for k in eachindex(Ns)
    draw_frame(k)
    frame(anim)
end
for _ in 1:3                                          # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=3)
println("Saved: ", gif_name)
