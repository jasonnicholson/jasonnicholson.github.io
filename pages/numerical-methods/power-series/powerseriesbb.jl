# powerseriesbb.jl
# Power Series animation: the page's Example 2, Legendre's equation with p = 1,
#   (1 - x^2) y'' - 2x y' + 2y = 0,  y(0) = 1, y'(0) = 0,
# about x0 = 0. Recurrence (4), a_{n+2} = (n-1)/(n+1) a_n, gives
# a_0 = 1 and a_{2k} = -1/(2k-1) (k >= 1), the series of y = 1 - x artanh x,
# which is singular at x = +-1 (the singular points of the equation, R = 1).
# One frame per partial sum S_N(x) = sum_{n=0}^{N} a_n x^n, N = 2, 4, ..., 40,
# drawn against the exact solution in the page's window [-1.2, 1.2] x [-3, 1.5].
# The bottom panel plots the error S_N(x) - y(x) (positive for 0 < |x| < 1) on a
# log scale for |x| < 1, with the tolerance 1e-3 dashed; green shading marks the
# interval about 0 on which the error stays below 1e-3. Beyond |x| = 1 there is
# no solution to compare with and the partial sums run off to -infinity.
# Coefficients are exact rationals; values are computed in 256-bit arithmetic.
# Produces: powerseriesbb.gif

using Plots
using Printf
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

# --- Parameters (the page's Example 2) ---
gif_name = "powerseriesbb.gif"
Ns       = 2:2:40
Nmax     = last(Ns)
tol      = big"1e-3"
xlims    = (-1.2, 1.2)
ylims    = (-3.0, 1.5)
elims    = (1e-12, 1e2)
title_str = "Legendre, p = 1: power series about x₀ = 0 for (1 − x²)y″ − 2xy′ + 2y = 0, y(0) = 1, y′(0) = 0"

# Recurrence (4)
a = zeros(Q, Nmax + 1)
a[1] = 1; a[2] = 0
for n in 0:Nmax-2
    a[n+3] = Q(n - 1, n + 1) * a[n+1]
end
@assert all(a[2k+1] == -1 // (2k - 1) for k in 1:Nmax÷2)
@assert all(a[n+1] == 0 for n in 1:2:Nmax)
ab = BigFloat.(a)

psum(N, x) = sum(ab[n+1] * x^n for n in 0:N)
yexact(x) = 1 - x * atanh(x)                   # |x| < 1

# --- Grid: step 0.0012 on [-1.2, 1.2], plus points 1 - 10^-k near the poles ---
xb = [big(-6) / 5 + big(12) / 5 * i / 2000 for i in 0:2000]
near = [1 - inv(big(10)^k) for k in 4:10]
xb = sort(unique(vcat(xb, near, -near)))
xb = filter(x -> abs(x) != 1, xb)
xs = Float64.(xb)
inside = abs.(xb) .< 1
yex = [abs(x) < 1 ? Float64(yexact(x)) : NaN for x in xb]
Sv  = [[Float64(psum(N, x)) for x in xb] for N in Ns]
err = [[abs(x) < 1 ? Float64(psum(N, x) - yexact(x)) : NaN for x in xb] for N in Ns]
# positive wherever 256-bit arithmetic resolves it (|x| >= 0.05: error >= 1e-55)
@assert all(all(e > 0 for (e, x) in zip(err[k], xb) if 0.05 <= abs(x) < 1) for k in eachindex(Ns))

# x*: first x > 0 at which the error reaches tol (march in steps of 0.001, bisect).
# The error is an even function of x, so the interval is (-x*, x*).
function xstar(N)
    g(x) = psum(N, x) - yexact(x) - tol
    h = big"0.001"; x = h
    while g(x) < 0
        x += h
    end
    lo, hi = x - h, x
    for _ in 1:120
        m = (lo + hi) / 2
        g(m) < 0 ? (lo = m) : (hi = m)
    end
    return (lo + hi) / 2
end
xst = [xstar(N) for N in Ns]

# --- Report ---
for (k, N) in enumerate(Ns)
    @printf("N = %2d: x* = %s  S_N(1.1) = %s  S_N(-1.1) = %s  S_N(1) = %s\n", N,
            fmtv(xst[k]), fmtv(psum(N, big"1.1")), fmtv(psum(N, big"-1.1")), fmtv(psum(N, big(1))))
end
for (k, N) in enumerate(Ns)       # error below tol again beyond x*? (grid points)
    back = [x for (x, e, x2) in zip(xs, err[k], xb) if abs(x) < 1 && abs(x) > xst[k] && e < tol]
    isempty(back) || println("N = $N: error below tol again at $(length(back)) grid points")
end
# S_N decreasing in N for 0 < |x| (all terms after the first are negative)
@assert all(all(Sv[k+1][i] <= Sv[k][i] for i in eachindex(xs)) for k in 1:length(Ns)-1)
yleave = [x for (x, y) in zip(xs, yex) if !isnan(y) && y < ylims[1]]
@printf("exact solution below the window for |x| >= %s (grid)\n", fmt(minimum(abs.(yleave))))
for (k, N) in enumerate(Ns)
    lo = [x for (x, v) in zip(xs, Sv[k]) if v < ylims[1]]
    isempty(lo) || @printf("N = %2d: S_N below window for |x| >= %s (grid)\n", N, fmt(minimum(abs.(lo))))
end
@printf("max error on grid (|x|<1) over frames: %s\n",
        fmt(maximum(maximum(filter(!isnan, e)) for e in err)))

logdraw(e) = isnan(e) ? NaN : clamp(e, elims[1] / 10, elims[2] * 10)
shade!(p, a, b, yl; label="") = plot!(p, Shape([a, b, b, a], [yl[1], yl[1], yl[2], yl[2]]);
                                      color=:palegreen, alpha=0.45, linealpha=0, label=label)

function draw_frame(k)
    N = Ns[k]
    xk = Float64(xst[k])
    pT = plot(xlims=xlims, ylims=ylims, framestyle=:box, xlabel="x", ylabel="y",
              legend=:bottom, legendfontsize=9, titlefontsize=11, grid=true)
    shade!(pT, -xk, xk, ylims; label="error < 10⁻³")
    vline!(pT, [-1.0, 1.0]; color=:red, ls=:dash, lw=1.5, label="singular points x = ±1")
    plot!(pT, xs, ydraw.(yex, Ref(ylims)); color=:magenta, lw=2.5, label="y = 1 − x artanh x")
    plot!(pT, xs, ydraw.(Sv[k], Ref(ylims)); color=:royalblue, lw=2, label="S$(sub(N))(x)")
    title!(pT, "N = $N:  error < 10⁻³ for |x| < $(fmtv(xst[k]))   (R = 1)")

    pB = plot(xlims=xlims, ylims=elims, yscale=:log10, framestyle=:box, xlabel="x",
              ylabel="S_N(x) − y(x)", legend=:top, legendfontsize=9,
              titlefontsize=11, grid=true, yticks=10.0 .^ (-12:2:2))
    shade!(pB, -xk, xk, elims)
    vline!(pB, [-1.0, 1.0]; color=:red, ls=:dash, lw=1.5, label="")
    for kk in 1:k-1
        plot!(pB, xs, logdraw.(err[kk]); color=:gray80, lw=1, label=kk == 1 ? "earlier N" : "")
    end
    hline!(pB, [1e-3]; color=:darkgreen, ls=:dash, lw=1.5, label="tolerance 10⁻³")
    plot!(pB, xs, logdraw.(err[k]); color=:royalblue, lw=2, label="N = $N")
    title!(pB, "error of S$(sub(N)) for |x| < 1;   beyond: S$(sub(N))(±1.1) = $(fmtv(psum(N, big"1.1")))")
    plot(pT, pB; layout=(2, 1), size=(1000, 820), plot_title=title_str,
         plot_titlefontsize=12, left_margin=5Plots.mm, bottom_margin=3Plots.mm,
         background_color=:white)
end

anim = Animation()
for k in eachindex(Ns)
    draw_frame(k)
    frame(anim)
end
for _ in 1:2                                          # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=2)
println("Saved: ", gif_name)
