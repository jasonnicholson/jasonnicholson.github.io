# picardcc.jl
# Picard Iteration animation: Mathews' Example 7, the system of Example 6,
# x' = x + 2y, y' = -x - y, x(0) = y(0) = 1, in the phase plane. One frame per
# iterate (X_n, Y_n), n = 0, ..., 6, drawn as a parametric curve over
# -2 <= t <= 2 against the exact solution curve (x, y) = (cos t + 3 sin t,
# cos t - 2 sin t) over -pi <= t <= pi, the ellipse x^2 + 2xy + 2y^2 = 5, in
# Mathews' window [-3.2, 3.2] x [-2.3, 2.3]. The right panel is new: the
# distance ||(X_n, Y_n) - (x, y)|| at the same t, on a log scale. The green
# band marks the stretch of t where that distance is <= 0.01.
# The iterates are computed exactly, as polynomials in t with rational
# coefficients (formula (9)); distances are evaluated in 256-bit floating
# point, because near t = 0 they are far below the resolution of double
# precision.
# As in Mathews' graphs, the exact solution is magenta and a red dot marks the
# initial point; the current iterate is blue and the earlier ones gray.
# Produces: picardcc.gif

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

# --- Exact polynomial arithmetic: p[k+1] is the coefficient of t^k ---
const Q = Rational{BigInt}
padd(p, q) = [get(p, i, zero(Q)) + get(q, i, zero(Q)) for i in 1:max(length(p), length(q))]
pscale(c, p) = c .* p
function peval(p, x)                                 # Horner
    s = zero(x)
    for c in reverse(p)
        s = s * x + c
    end
    return s
end
function pint(p, t0)                                 # t -> integral from t0 to t of p
    P = vcat(zero(Q), [p[k] / k for k in 1:length(p)])
    P[1] -= peval(P, Q(t0))
    return P
end

# --- Parameters (Mathews' Example 7) ---
gif_name  = "picardcc.gif"
t0, x0, y0 = Q(0), Q(1), Q(1)
F(X, Y)   = (padd(X, pscale(2, Y)), padd(pscale(-1, X), pscale(-1, Y)))  # (x + 2y, -x - y)
xexact(t) = cos(t) + 3sin(t)
yexact(t) = cos(t) - 2sin(t)
n_max     = 6                                        # Mathews computes n = 0, ..., 6
tol       = 0.01
tlimsQ    = (Q(-2), Q(2))                            # Mathews' parameter range for the iterates
tlims     = Float64.(tlimsQ)
xlims     = (-3.2, 3.2)                              # Mathews' window
ylims     = (-2.3, 2.3)
elims     = (1e-6, 1e1)                              # distance panel (log scale)
title_str = "Picard iteration (Mathews' Example 7):  x′ = x + 2y,  y′ = −x − y,  x(0) = y(0) = 1"

# --- Iterates (X_n, Y_n), formula (9) ---
X = [[x0]]
Y = [[y0]]
for n in 1:n_max
    fx, fy = F(X[end], Y[end])
    push!(X, padd([x0], pint(fx, t0)))
    push!(Y, padd([y0], pint(fy, t0)))
end
# Check against the page's X_6 and Y_6 (Example 6)
@assert X[7] == Q[1, 3, -1//2, -1//2, 1//24, 1//40, -1//720] "X_6 does not match the page"
@assert Y[7] == Q[1, -2, -1//2, 1//3, 1//24, -1//60, -1//720] "Y_6 does not match the page"

# --- Distances in 256-bit arithmetic on a fine grid ---
setprecision(BigFloat, 256)
N  = 20001
tb = [BigFloat(tlimsQ[1] + (tlimsQ[2] - tlimsQ[1]) * (i - 1) // (N - 1)) for i in 1:N]
xe, ye = xexact.(tb), yexact.(tb)
dist(n, t) = hypot(peval(X[n+1], t) - xexact(t), peval(Y[n+1], t) - yexact(t))
errb = [hypot.(peval.(Ref(X[n+1]), tb) .- xe, peval.(Ref(Y[n+1]), tb) .- ye) for n in 0:n_max]
ts = Float64.(tb)

# Stretches of t where the distance is <= tol: runs of grid points, ends by bisection
function tol_runs(n)
    g(t) = dist(n, t) - tol
    inside = errb[n+1] .<= tol
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
            lo = i == 1 ? tb[1] : edge(tb[i-1], tb[i])
            hi = j == N ? tb[N] : edge(tb[j], tb[j+1])
            push!(runs, (lo, hi))
            i = j + 1
        else
            i += 1
        end
    end
    return runs
end
runs = [tol_runs(n) for n in 0:n_max]
endstr(a) = any(a == BigFloat(e) for e in tlimsQ) ? fmt(a) : fmtv(a)
runs_str(r) = join(["[" * endstr(a) * ", " * endstr(b) * "]" for (a, b) in r], " ∪ ")

maxerr = [maximum(e) for e in errb]
argmx  = [ts[argmax(e)] for e in errb]
for n in 0:n_max
    @printf("n = %d: max distance = %s at t = %s;  distance <= %g for t in %s\n", n,
            fmtv(maxerr[n+1]), fmt(argmx[n+1]), tol, runs_str(runs[n+1]))
end

# Drawing helpers
# Log panel, drawn position only: a distance below the panel (including the exact
# zero at t = 0) is drawn one decade below the bottom edge, so the curve visibly
# leaves the panel there instead of stopping short of it.
logdraw(e) = max(Float64(e), elims[1] / 10)
function shade!(p, r, yl; label="")
    for (k, (a, b)) in enumerate(r)
        plot!(p, Shape([a, b, b, a], [yl[1], yl[1], yl[2], yl[2]]);
              color=:palegreen, alpha=0.45, linealpha=0, label=k == 1 ? label : "")
    end
end
te = range(-pi, pi, length=2001)                     # exact curve, Mathews' -pi..pi
curve(n) = (ydraw.(Float64.(peval.(Ref(X[n+1]), tb)), Ref(xlims)),
            ydraw.(Float64.(peval.(Ref(Y[n+1]), tb)), Ref(ylims)))

# --- Animation: one iterate per frame ---
function draw_frame(n)
    pL = plot(xlims=xlims, ylims=ylims, aspect_ratio=:equal, framestyle=:box,
              xlabel="x", ylabel="y", legend=:bottomleft, legendfontsize=7,
              titlefontsize=10, grid=true)
    # green band under the stretch of the current iterate within tol of the solution
    for (k, (a, b)) in enumerate(runs[n+1])
        idx = findall(t -> a <= t <= b, tb)
        tt = range(a, b, length=max(2, length(idx)))
        plot!(pL, Float64.(peval.(Ref(X[n+1]), tt)), Float64.(peval.(Ref(Y[n+1]), tt));
              color=:palegreen, lw=10, alpha=0.8,
              label=k == 1 ? "distance ≤ $(tol)" : "")
    end
    for k in 0:n-1
        cx, cy = curve(k)
        if k == 0
            scatter!(pL, [Float64(x0)], [Float64(y0)]; color=:gray70, ms=4, msw=0, label="")
        end
        plot!(pL, cx, cy; color=:gray70, lw=1,
              label=k == 1 ? (n == 2 ? "(X₁, Y₁)" : "(X₁, Y₁) … (X$(sub(n-1)), Y$(sub(n-1)))") : "")
    end
    plot!(pL, xexact.(te), yexact.(te); color=:magenta, lw=2.5,
          label="exact (x, y), |t| ≤ π")
    if n == 0
        scatter!(pL, [Float64(x0)], [Float64(y0)]; color=:royalblue, ms=9,
                 label="(X₀, Y₀) = (1, 1) for all t")
    else
        cx, cy = curve(n)
        plot!(pL, cx, cy; color=:royalblue, lw=2.5,
              label="(X$(sub(n)), Y$(sub(n))), |t| ≤ 2")
    end
    scatter!(pL, [Float64(x0)], [Float64(y0)]; color=:red, ms=5,
             label="t = 0: (1, 1)")
    title!(pL, "n = $n:  distance ≤ $(tol) for t in $(runs_str(runs[n+1]))")

    pR = plot(xlims=tlims, ylims=elims, yscale=:log10, framestyle=:box, xlabel="t",
              ylabel="‖(Xₙ, Yₙ) − (x, y)‖", legend=:bottomright, legendfontsize=8,
              titlefontsize=10, grid=true, yticks=10.0 .^ (-6:1))
    shade!(pR, runs[n+1], elims)
    for k in 0:n-1
        plot!(pR, ts, logdraw.(errb[k+1]); color=:gray70, lw=1,
              label=k == 0 ? "earlier iterates" : "")
    end
    hline!(pR, [tol]; color=:darkgreen, ls=:dash, lw=1.5, label="tolerance $(tol)")
    plot!(pR, ts, logdraw.(errb[n+1]); color=:royalblue, lw=2.5,
          label="‖(X$(sub(n)), Y$(sub(n))) − (x, y)‖")
    title!(pR, "max distance on [$(fmt(tlims[1])), $(fmt(tlims[2]))] = " *
               "$(fmtv(maxerr[n+1])) at t = $(fmt(argmx[n+1]))")

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
