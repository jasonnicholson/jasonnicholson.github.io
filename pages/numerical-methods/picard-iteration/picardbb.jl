# picardbb.jl
# Picard Iteration animation: Mathews' Example 4, y' = -2xy, y(1) = 1. One
# frame per iterate Y_0, ..., Y_6, drawn against the exact solution
# y = e^(1 - x^2) on Mathews' graphing window [-1.7, 1.7] x [0, 2.75]. The
# right panel is new: the error |y(x) - Y_n(x)| on a log scale. Shading marks
# where |y - Y_n| <= 0.01. Because Y_n and y depend on x only through x^2, the
# error is even in x, and the iterates are as accurate near x = -1 as near the
# initial point x0 = 1.
# The iterates are computed exactly, as polynomials with rational
# coefficients; errors are evaluated in 256-bit floating point, because near
# x = +-1 they are far below the resolution of double precision.
# As in Mathews' graphs, the exact solution is magenta and a red dot marks the
# initial point; the current iterate is blue and the earlier ones gray.
# Produces: picardbb.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))      # exact values
fmtv(x) = um(@sprintf("%#.4g", Float64(x)))                    # computed: 4 s.f.

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))   # 3 -> "₃"

# --- Exact polynomial arithmetic: p[k+1] is the coefficient of x^k ---
const Q = Rational{BigInt}
padd(p, q) = [get(p, i, zero(Q)) + get(q, i, zero(Q)) for i in 1:max(length(p), length(q))]
pscale(c, p) = c .* p
pmulx(p) = vcat(zero(Q), p)                          # x * p(x)
function peval(p, x)                                 # Horner
    s = zero(x)
    for c in reverse(p)
        s = s * x + c
    end
    return s
end
function pint(p, x0)                                 # x -> integral from x0 to x of p
    P = vcat(zero(Q), [p[k] / k for k in 1:length(p)])
    P[1] -= peval(P, Q(x0))
    return P
end

# --- Parameters (Mathews' Example 4) ---
gif_name  = "picardbb.gif"
x0, y0    = Q(1), Q(1)
f(xp, yp) = pscale(-2, pmulx(yp))                    # f(t, y) = -2ty, on polynomials
yexact(x) = exp(1 - x^2)
n_max     = 6                                        # Mathews computes Y_0, ..., Y_6
tol       = 0.01
xlimsQ    = (Q(-17//10), Q(17//10))                  # Mathews' window, exact ends
xlims     = Float64.(xlimsQ)
ylims     = (0.0, 2.75)
elims     = (1e-6, 1e1)                              # error panel (log scale)
title_str = "Picard iteration (Mathews' Example 4):  y′ = −2xy,  y(1) = 1,  exact y = e¹⁻ˣ²"
exact_lbl = "y = e¹⁻ˣ² (exact)"

# --- Iterates Y_0, ..., Y_n_max ---
xpoly = [zero(Q), one(Q)]
Y = [[y0]]
for n in 1:n_max
    push!(Y, padd([y0], pint(f(xpoly, Y[end]), x0)))
end
# Check against the page's formula (7): Y_n = sum_{k=0}^n (1 - x^2)^k / k!
w = [Q(1), Q(0), Q(-1)]                              # w = 1 - x^2
function pmul(p, q)
    r = zeros(Q, length(p) + length(q) - 1)
    for i in eachindex(p), j in eachindex(q)
        r[i+j-1] += p[i] * q[j]
    end
    return r
end
trim(p) = (q = copy(p); while length(q) > 1 && q[end] == 0; pop!(q); end; q)
for n in 0:n_max
    c, wk = [Q(0)], [Q(1)]
    for k in 0:n
        c = padd(c, pscale(1 // factorial(big(k)), wk))
        wk = pmul(wk, w)
    end
    @assert trim(Y[n+1]) == trim(c) "Y_$n does not match formula (7)"
end

# Interval list, ends to 4 significant figures (an end of the window is exact)
endstr(a) = any(a == BigFloat(e) for e in xlimsQ) ? fmt(a) : fmtv(a)
runs_str(r) = join(["[" * endstr(a) * ", " * endstr(b) * "]" for (a, b) in r], " ∪ ")

# --- Errors in 256-bit arithmetic on a fine grid ---
setprecision(BigFloat, 256)
N  = 20001
xb = [BigFloat(xlimsQ[1] + (xlimsQ[2] - xlimsQ[1]) * (i - 1) // (N - 1)) for i in 1:N]
# By (7), Y_n(±1) = 1 = y(±1) for every n (w = 0 there), so the error is exactly
# zero at x = ±1. Neither point is on the grid; add them so that the drawn error
# reaches zero there instead of stopping at the nearest grid point.
for z in (Q(-1), Q(1))
    @assert all(peval(p, z) == 1 for p in Y)
end
xb = sort(vcat(xb, BigFloat(-1), BigFloat(1)))
N  = length(xb)
yb = yexact.(xb)
errb = [yb .- peval.(Ref(p), xb) for p in Y]         # y - Y_n
xs = Float64.(xb)
ys = Float64.(yb)

# Intervals where |y - Y_n| <= tol: runs of grid points, ends refined by bisection
function tol_runs(p)
    g(x) = abs(yexact(x) - peval(p, x)) - tol
    inside = [g(x) <= 0 for x in xb]
    runs = Tuple{BigFloat,BigFloat}[]
    i = 1
    while i <= N
        if inside[i]
            j = i
            while j < N && inside[j+1]
                j += 1
            end
            function edge(a, b)                      # g(a), g(b) of opposite sign
                ga = g(a)
                for _ in 1:80
                    m = (a + b) / 2
                    gm = g(m)
                    (gm <= 0) == (ga <= 0) ? (a = m; ga = gm) : (b = m)
                end
                return (a + b) / 2
            end
            lo = i == 1 ? xb[1] : edge(xb[i-1], xb[i])
            hi = j == N ? xb[N] : edge(xb[j], xb[j+1])
            push!(runs, (lo, hi))
            i = j + 1
        else
            i += 1
        end
    end
    return runs
end
runs = [tol_runs(p) for p in Y]

maxerr = [maximum(abs.(e)) for e in errb]
# Every grid point where the largest error is attained (ties: both ends in Example 4)
function maxlocs(e)
    a = abs.(e)
    m = maximum(a)
    l = xs[findall(v -> v >= m * (1 - big(1e-40)), a)]
    return length(l) == 2 && l[1] == -l[2] ? "±" * fmt(l[2]) : join(fmt.(l), ", ")
end
argmx  = [maxlocs(e) for e in errb]
for n in 0:n_max
    @printf("n = %d: max |y - Y_n| = %s at x = %s;  |y - Y_n| <= %g on %s\n", n,
            fmtv(maxerr[n+1]), argmx[n+1], tol,
            runs_str(runs[n+1]))
end

# Drawing helpers
# Log panel, drawn position only: an error below the panel (including the exact
# zero at x0) is drawn one decade below the bottom edge, so the curve visibly
# leaves the panel there instead of stopping short of it.
logdraw(e) = max(Float64(abs(e)), elims[1] / 10)
function shade!(p, r, yl; label="")
    for (k, (a, b)) in enumerate(r)
        plot!(p, Shape([a, b, b, a], [yl[1], yl[1], yl[2], yl[2]]);
              color=:palegreen, alpha=0.45, linealpha=0, label=k == 1 ? label : "")
    end
end

# --- Animation: one iterate per frame ---
function draw_frame(n)
    pL = plot(xlims=xlims, ylims=ylims, framestyle=:box, xlabel="x", ylabel="y",
              legend=:bottom, legendfontsize=8, titlefontsize=10, grid=true)
    shade!(pL, runs[n+1], ylims; label="|y − Y$(sub(n))| ≤ $(tol)")
    for k in 0:n-1
        plot!(pL, xs, ydraw.(Float64.(peval.(Ref(Y[k+1]), xb)), Ref(ylims));
              color=:gray70, lw=1, label=k == 0 ? (n == 1 ? "Y₀" : "Y₀ … Y$(sub(n-1))") : "")
    end
    plot!(pL, xs, ydraw.(ys, Ref(ylims)); color=:magenta, lw=2.5, label=exact_lbl)
    plot!(pL, xs, ydraw.(Float64.(peval.(Ref(Y[n+1]), xb)), Ref(ylims));
          color=:royalblue, lw=2.5, label="Y$(sub(n))")
    scatter!(pL, [Float64(x0)], [Float64(y0)]; color=:red, ms=5,
             label="(x₀, y₀) = ($(fmt(x0)), $(fmt(y0)))")
    title!(pL, "n = $n:  |y − Y$(sub(n))| ≤ $(tol) on $(runs_str(runs[n+1]))")

    pR = plot(xlims=xlims, ylims=elims, yscale=:log10, framestyle=:box, xlabel="x",
              ylabel="|y(x) − Yₙ(x)|", legend=:bottom, legendfontsize=8,
              titlefontsize=10, grid=true, yticks=10.0 .^ (-6:2))
    shade!(pR, runs[n+1], elims)
    for k in 0:n-1
        plot!(pR, xs, logdraw.(errb[k+1]); color=:gray70, lw=1,
              label=k == 0 ? "earlier iterates" : "")
    end
    hline!(pR, [tol]; color=:darkgreen, ls=:dash, lw=1.5, label="tolerance $(tol)")
    plot!(pR, xs, logdraw.(errb[n+1]); color=:royalblue, lw=2.5, label="|y − Y$(sub(n))|")
    title!(pR, "max |y − Y$(sub(n))| on [$(fmt(xlims[1])), $(fmt(xlims[2]))] = " *
               "$(fmtv(maxerr[n+1])) at x = $(argmx[n+1])")

    plot(pL, pR; layout=(1, 2), size=(1150, 520), plot_title=title_str,
         plot_titlefontsize=12, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white)
end

anim = Animation()
for n in 0:n_max
    draw_frame(n)
    frame(anim)
end
for _ in 1:2                                         # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: ", gif_name)
