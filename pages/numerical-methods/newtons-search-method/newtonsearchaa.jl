# newtonsearchaa.jl
# Newton's search method animation: Example 5, f(x, y) = 5x^2 + x^4 - 9x^2 y + 3y^2 + 2y^4 + x/4.
# Five runs, one after another: the three minima from (0, 0), (2, 1.5), (-2, 1.5), then the two
# saddle points from (1, 0.8) and (-1, 0.8). Left: Mathews' contour window [-3, 3] x [-0.5, 2] with
# the curves f_x = 0 and f_y = 0 and the five stationary points. Right: a zoom on the current point
# P_j with the contours of f and of the quadratic model Q at P_j, whose stationary point is P_{j+1}.
# The iteration runs in 256-bit BigFloat arithmetic, so every label is correct to the digits shown.
# Produces: newtonsearchaa.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
fmt(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%.4g", Float64(x))
# The iteration is in BigFloat, so no iterate is rounded to zero. The only zeros are exact:
# the start (0, 0) of case (i), f(0, 0) = 0, and y = 0 at P_1 of case (i), because the first
# step from (0, 0) is exactly (-1/40, 0). They are labelled plainly.
fmt0(x) = x == 0 ? "0" : fmt(x)

setprecision(BigFloat, 256)

# --- Function, gradient, Hessian [a b; b c] ---
f(x, y)    = 5x^2 + x^4 - 9x^2 * y + 3y^2 + 2y^4 + x / 4
fx(x, y)   = 4x^3 + 10x - 18x * y + one(x) / 4
fy(x, y)   = -9x^2 + 6y + 8y^3
hess(x, y) = (12x^2 - 18y + 10, -18x, 24y^2 + 6)

eig2(a, b, c) = ((a + c) / 2 - hypot((a - c) / 2, b), (a + c) / 2 + hypot((a - c) / 2, b))
function kind(a, b, c)
    l1, l2 = eig2(a, b, c)
    l1 > 0 ? "positive definite" : (l2 < 0 ? "negative definite" : "indefinite")
end

# Newton step: solve H dP = -grad f (Cramer's rule for the 2 x 2 system)
function newton_step(x, y)
    g1, g2 = fx(x, y), fy(x, y)
    a, b, c = hess(x, y)
    d = a * c - b^2
    return (-(c * g1 - b * g2) / d, -(a * g2 - b * g1) / d)
end

# --- Runs: label, start (decimal strings, as Mathews types them), iterations Mathews prints ---
runs = [("case (i)",   "0",    "0",   4),
        ("case (ii)",  "2",    "1.5", 5),
        ("case (iii)", "-2",   "1.5", 5),
        ("saddle run", "1.0",  "0.8", 3),
        ("saddle run", "-1.0", "0.8", 3)]

sub(k) = join(Char(0x2080 + d) for d in reverse(digits(k)))
startlabel(sx, sy) = "(" * replace(sx, "-" => "−") * ", " * sy * ")"

iters = Vector{Vector{NTuple{2,BigFloat}}}()
limits = NTuple{2,BigFloat}[]
for (name, sx, sy, n) in runs
    P = [(parse(BigFloat, sx), parse(BigFloat, sy))]
    for k in 1:n+1                       # one beyond the table, for the step drawn at j = n
        dx, dy = newton_step(P[end]...)
        push!(P, (P[end][1] + dx, P[end][2] + dy))
    end
    Q = P[end]
    for k in 1:40                        # the limit P*: 40 more steps
        dx, dy = newton_step(Q...)
        Q = (Q[1] + dx, Q[2] + dy)
    end
    push!(iters, P)
    push!(limits, Q)
end

# Stationary points (the five limits) and their type from the Hessian
statkind = [kind(hess(p...)...) for p in limits]
for (i, p) in enumerate(limits)
    l1, l2 = eig2(hess(p...)...)
    @printf("stationary %d: (%.12f, %.12f)  f = %.12f  eig = (%.5g, %.5g)  %s  |grad| = %.3g\n",
            i, p[1], p[2], f(p...), l1, l2, statkind[i], hypot(fx(p...), fy(p...)))
end

# --- Left panel backdrop (Mathews' contour window) ---
xl = (-3.0, 3.0); yl = (-0.5, 2.0)
xg = range(xl..., length=361); yg = range(yl..., length=181)
Zf  = [f(x, y)  for y in yg, x in xg]
Zfx = [fx(x, y) for y in yg, x in xg]
Zfy = [fy(x, y) for y in yg, x in xg]
levels_f = [-1.8, -1.5, -1.0, -0.5, 0.0, 0.5, 1.0, 1.325, 1.6, 1.7927, 2.0, 3.0, 5.0, 8.0,
            12.0, 20.0, 35.0, 60.0, 100.0, 150.0]

function left_panel(r, j)
    name, sx, sy, n = runs[r]
    P = iters[r]
    pj = P[j+1]
    e = hypot(pj[1] - limits[r][1], pj[2] - limits[r][2])
    t1 = "Example 5, $(name) from $(startlabel(sx, sy)), row j = $j"
    t2 = "P$(sub(j)) = ($(fmt0(pj[1])), $(fmt0(pj[2]))),  f(P$(sub(j))) = $(fmt0(f(pj...)))"
    t3 = "‖P$(sub(j)) − P*‖ = $(fmt(e))"
    plt = plot(xlims=xl, ylims=yl, xlabel="x", ylabel="y", title=t1 * "\n" * t2 * "\n" * t3,
               titlefontsize=10, legend=:bottomleft, legendfontsize=7, framestyle=:box,
               grid=false, background_color=:white)
    contour!(plt, xg, yg, Zf; levels=levels_f, linecolor=:gray70, lw=0.7, colorbar=false, label="")
    contour!(plt, xg, yg, Zfx; levels=[0.0], linecolor=:darkorange, lw=1.3, ls=:dash, colorbar=false, label="")
    contour!(plt, xg, yg, Zfy; levels=[0.0], linecolor=:purple, lw=1.3, ls=:dashdot, colorbar=false, label="")
    plot!(plt, [NaN], [NaN]; color=:gray70, lw=0.7, label="contours of f")
    plot!(plt, [NaN], [NaN]; color=:darkorange, lw=1.3, ls=:dash, label="f_x = 0")
    plot!(plt, [NaN], [NaN]; color=:purple, lw=1.3, ls=:dashdot, label="f_y = 0")
    for q in 1:r-1                       # finished runs
        Pq = iters[q][1:runs[q][4]+1]
        plot!(plt, Float64.(first.(Pq)), Float64.(last.(Pq)); color=:steelblue, lw=1.2,
              marker=:circle, ms=2.5, msw=0, label=(q == 1 ? "earlier runs" : ""))
    end
    plot!(plt, Float64.(first.(P[1:j+1])), Float64.(last.(P[1:j+1])); color=:red, lw=1.8,
          marker=:circle, ms=3, msw=0, label="this run, P₀ … P$(sub(j))")
    mins = [p for (p, s) in zip(limits, statkind) if s == "positive definite"]
    sads = [p for (p, s) in zip(limits, statkind) if s == "indefinite"]
    scatter!(plt, Float64.(first.(mins)), Float64.(last.(mins)); marker=:star5, ms=9,
             color=:green3, msc=:black, msw=0.6, label="minimum (H positive definite)")
    scatter!(plt, Float64.(first.(sads)), Float64.(last.(sads)); marker=:xcross, ms=8,
             color=:black, msw=2, label="saddle (H indefinite)")
    scatter!(plt, [Float64(pj[1])], [Float64(pj[2])]; color=:red, ms=6, msc=:white, msw=1, label="")
    return plt
end

# --- Right panel: zoom on P_j, axes in units of a power of ten ---
supdigits = Dict('-' => '⁻', '0' => '⁰', '1' => '¹', '2' => '²', '3' => '³', '4' => '⁴',
                 '5' => '⁵', '6' => '⁶', '7' => '⁷', '8' => '⁸', '9' => '⁹')
sup(m) = join(supdigits[c] for c in string(m))

function zoom_panel(r, j)
    P = iters[r]
    xj, yj = P[j+1]
    dx, dy = P[j+2][1] - xj, P[j+2][2] - yj          # the step Delta P_j = P_{j+1} - P_j
    step = hypot(dx, dy)
    h = 1.4 * step                                   # half-width: P_{j+1} well inside
    m = floor(Int, log10(Float64(h)))
    s = big(10.0)^m                                  # axis unit
    g1, g2 = fx(xj, yj), fy(xj, yj)
    a, b, c = hess(xj, yj)
    l1, l2 = eig2(a, b, c)
    hk = kind(a, b, c)
    N = 121
    u = range(-Float64(h / s), Float64(h / s), length=N)
    Qc = (g1 * dx + g2 * dy) / 2                     # Q(P_{j+1}) - f(P_j)
    F = Matrix{BigFloat}(undef, N, N); Qm = similar(F)
    for (iy, vy) in enumerate(u), (ix, vx) in enumerate(u)
        ddx, ddy = big(vx) * s, big(vy) * s
        Qm[iy, ix] = g1 * ddx + g2 * ddy + (a * ddx^2 + 2b * ddx * ddy + c * ddy^2) / 2 - Qc
        F[iy, ix]  = f(xj + ddx, yj + ddy) - f(xj, yj) - Qc
    end
    M = maximum(abs, Qm)
    lev = [sign(t) * t^2 for t in -8:8] ./ 64         # spacing like equally spaced radii
    qcol = hk == "positive definite" ? :blue : :red
    shape = hk == "positive definite" ? "ellipses" : "hyperbolas"
    unit = "10$(sup(m))"
    t1 = "Zoom on P$(sub(j)): H(P$(sub(j))) is $(hk)"
    t2 = "eigenvalues $(fmt(l1)) and $(fmt(l2))"
    t3 = "Newton step |ΔP$(sub(j))| = $(fmt(step)) to P$(sub(j+1)), the centre of Q"
    plt = plot(xlims=extrema(u), ylims=extrema(u), aspect_ratio=:equal,
               xlabel="(x − x$(sub(j))) / $unit", ylabel="(y − y$(sub(j))) / $unit",
               title=t1 * "\n" * t2 * "\n" * t3, titlefontsize=10, legend=:outerbottom, legendfontsize=7,
               legend_columns=2, framestyle=:box, grid=false, background_color=:white)
    contour!(plt, u, u, Float64.(F ./ M); levels=lev, linecolor=:gray55, lw=1.0, colorbar=false, label="")
    contour!(plt, u, u, Float64.(Qm ./ M); levels=lev, linecolor=qcol, lw=1.4, ls=:dash, colorbar=false, label="")
    plot!(plt, [NaN], [NaN]; color=:gray55, lw=1.0, label="contours of f")
    plot!(plt, [NaN], [NaN]; color=qcol, lw=1.4, ls=:dash, label="quadratic model Q at P$(sub(j)) ($shape)")
    plot!(plt, [0.0, Float64(dx / s)], [0.0, Float64(dy / s)]; color=:black, lw=1.8, arrow=true, label="")
    ps = ((limits[r][1] - xj) / s, (limits[r][2] - yj) / s)
    if abs(ps[1]) <= h / s && abs(ps[2]) <= h / s
        lim_is_min = statkind[r] == "positive definite"
        scatter!(plt, [Float64(ps[1])], [Float64(ps[2])]; marker=(lim_is_min ? :star5 : :xcross),
                 ms=(lim_is_min ? 10 : 9), color=(lim_is_min ? :green3 : :black), msc=:black,
                 msw=(lim_is_min ? 0.6 : 2), label="P* ($(lim_is_min ? "minimum" : "saddle"))")
    end
    scatter!(plt, [0.0], [0.0]; color=:red, ms=6, msc=:white, msw=1, label="P$(sub(j))")
    scatter!(plt, [Float64(dx / s)], [Float64(dy / s)]; color=:white, ms=6, msc=:black, msw=1.5,
             label="P$(sub(j+1)) = stationary point of Q")
    return plt, hk, l1, l2, step
end

# --- Animation: one frame per table row j = 0..n of each run ---
anim = Animation()
for r in eachindex(runs)
    name, sx, sy, n = runs[r]
    println("== $(name) from $(startlabel(sx, sy))")
    for j in 0:n
        L = left_panel(r, j)
        R, hk, l1, l2, step = zoom_panel(r, j)
        pj = iters[r][j+1]
        e = hypot(pj[1] - limits[r][1], pj[2] - limits[r][2])
        @printf("j=%d  P=(%.12f, %.12f)  f=%.12f  e=%.3g  H %s (%.4g, %.4g)  |dP|=%.4g  f(P_{j+1})-f(P_j)=%.4g\n",
                j, pj[1], pj[2], f(pj...), e, hk, l1, l2, step,
                f(iters[r][j+2]...) - f(pj...))
        plt = plot(L, R; layout=@layout([a{0.57w} b]), size=(1280, 680), left_margin=4Plots.mm, top_margin=6Plots.mm,
                   bottom_margin=4Plots.mm)
        frame(anim, plt)
    end
end

gif(anim, joinpath(@__DIR__, "newtonsearchaa.gif"); fps=1)
println("Saved: newtonsearchaa.gif")
