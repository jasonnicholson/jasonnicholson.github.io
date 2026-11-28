# newtonsearchbb.jl
# Newton's search method animation: Example 6, f(x, y) = (x - y)/(x^2 + y^2 + 2).
# Two runs side by side, k = 0..10: from (-0.3, 0.2) the iterates converge to the minimum (-1, 1)
# (Mathews runs 5 iterations, so this run stops at k = 5); from (-3, 2) they run away to infinity
# (Mathews' 10 iterations). Top left: Mathews' contour window [-4, 4] x [-4, 4]. Top right: a window
# that widens each frame to hold every iterate of the run from (-3, 2). Bottom: the error of the
# converging run and the distance from the origin of the diverging run, on a log scale.
# The iteration runs in 256-bit BigFloat arithmetic, so every label is correct to the digits shown.
# Produces: newtonsearchbb.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
# Here with four significant figures and their trailing zeros kept: the converging run reaches -0.5000 and
# (-1.000, 1.000) to four figures, which must not read as the exact values -1/2 and (-1, 1).
function fmt(x)
    x == 0 && return "0 (double-precision zero)"
    r = round(Float64(x), sigdigits=4)          # four significant figures, as C's "%#.4g"
    e = floor(Int, log10(abs(r)))
    return (e < -4 || e >= 4) ? @sprintf("%.3e", r) : Printf.format(Printf.Format("%.$(3 - e)f"), r)
end

setprecision(BigFloat, 256)

# --- Function, gradient, Hessian [a b; b c] (quotient rule, D = x^2 + y^2 + 2) ---
f(x, y)  = (x - y) / (x^2 + y^2 + 2)
fx(x, y) = -(x^2 - 2x * y - y^2 - 2) / (x^2 + y^2 + 2)^2
fy(x, y) = -(x^2 + 2x * y - y^2 + 2) / (x^2 + y^2 + 2)^2
function hess(x, y)
    D3 = (x^2 + y^2 + 2)^3
    a =  2 * (x^3 - 3x^2 * y - 3x * y^2 + y^3 - 6x + 2y) / D3
    b =  2 * (x^3 + 3x^2 * y - 3x * y^2 - y^3 + 2x - 2y) / D3
    c = -2 * (x^3 - 3x^2 * y - 3x * y^2 + y^3 + 2x - 6y) / D3
    return a, b, c
end

eig2(a, b, c) = ((a + c) / 2 - hypot((a - c) / 2, b), (a + c) / 2 + hypot((a - c) / 2, b))
function kind(a, b, c)
    l1, l2 = eig2(a, b, c)
    l1 > 0 ? "positive definite" : (l2 < 0 ? "negative definite" : "indefinite")
end

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

nA, nB = 5, 10                       # Mathews' iteration counts
A = run_newton("-0.3", "0.2", nA)    # converges to the minimum (-1, 1)
B = run_newton("-3", "2", nB)        # diverges
Pstar = (big(-1), big(1))
eA = [hypot(p[1] - Pstar[1], p[2] - Pstar[2]) for p in A]
rB = [hypot(p...) for p in B]

# Stationary points: (-1, 1) minimum, (1, -1) maximum
for p in ((-1, 1), (1, -1))
    q = big.(p)
    l1, l2 = eig2(hess(q...)...)
    @printf("stationary (%d, %d): f = %.6g  grad = (%.3g, %.3g)  eig = (%.6g, %.6g)  %s\n",
            p..., f(q...), fx(q...), fy(q...), l1, l2, kind(hess(q...)...))
end

# Draw a segment that leaves the window: move an endpoint more than one window span beyond the
# axes back along the segment to that limit. Only the drawn position changes, the line still
# visibly leaves the frame in its true direction, and every label keeps the true value.
function segdraw(p, q, xl, yl)
    wx, wy = xl[2] - xl[1], yl[2] - yl[1]
    lo = (xl[1] - wx, yl[1] - wy); hi = (xl[2] + wx, yl[2] + wy)
    t = 1.0
    for i in 1:2
        d = q[i] - p[i]
        d > 0 && q[i] > hi[i] && (t = min(t, (hi[i] - p[i]) / d))
        d < 0 && q[i] < lo[i] && (t = min(t, (lo[i] - p[i]) / d))
    end
    return (p[1] + t * (q[1] - p[1]), p[2] + t * (q[2] - p[2]))
end
function pathdraw(P, xl, yl)
    xs = [P[1][1]]; ys = [P[1][2]]
    for i in 2:length(P)
        inside(p) = xl[1] - (xl[2] - xl[1]) <= p[1] <= xl[2] + (xl[2] - xl[1]) &&
                    yl[1] - (yl[2] - yl[1]) <= p[2] <= yl[2] + (yl[2] - yl[1])
        inside(P[i-1]) || break
        q = segdraw(P[i-1], P[i], xl, yl)
        push!(xs, q[1]); push!(ys, q[2])
    end
    return xs, ys
end

levels_f = sort(vcat(-[0.004, 0.007, 0.012, 0.02, 0.035, 0.06, 0.1, 0.17, 0.3, 0.42, 0.48],
                      [0.004, 0.007, 0.012, 0.02, 0.035, 0.06, 0.1, 0.17, 0.3, 0.42, 0.48]))

function backdrop!(plt, xl, yl)
    xg = range(xl..., length=241); yg = range(yl..., length=241)
    Z = [Float64(f(x, y)) for y in yg, x in xg]
    contour!(plt, xg, yg, Z; levels=levels_f, linecolor=:gray70, lw=0.7, colorbar=false, label="")
    plot!(plt, [NaN], [NaN]; color=:gray70, lw=0.7, label="contours of f")
    scatter!(plt, [-1.0], [1.0]; marker=:star5, ms=9, color=:green3, msc=:black, msw=0.6,
             label="minimum (−1, 1), H = I/4")
    scatter!(plt, [1.0], [-1.0]; marker=:utriangle, ms=7, color=:orange, msc=:black, msw=0.6,
             label="maximum (1, −1), H = −I/4")
end

hk(p) = kind(hess(p...)...)

anim = Animation()
for k in 0:nB
    kA = min(k, nA)
    pA = A[kA+1]; pB = B[k+1]
    PAf = [Float64.(p) for p in A[1:kA+1]]; PBf = [Float64.(p) for p in B[1:k+1]]

    # Top left: Mathews' window
    xl = (-4.0, 4.0); yl = (-4.0, 4.0)
    tA2 = k <= nA ?
        "P$(sub(k)) = ($(fmt(pA[1])), $(fmt(pA[2]))),  f = $(fmt(f(pA...))),  H $(hk(pA))" :
        "stopped at k = 5, as Mathews: P₅ = ($(fmt(pA[1])), $(fmt(pA[2])))"
    tA3 = "‖P$(sub(kA)) − (−1, 1)‖ = $(fmt(eA[kA+1]))"
    L = plot(xlims=xl, ylims=yl, aspect_ratio=:equal, xlabel="x", ylabel="y",
             title="Mathews' window, k = $k.  Run from (−0.3, 0.2):\n" * tA2 * "\n" * tA3,
             titlefontsize=10, legend=:bottomright, legendfontsize=7, framestyle=:box,
             grid=false, background_color=:white)
    backdrop!(L, xl, yl)
    plot!(L, first.(PAf), last.(PAf); color=:blue, lw=1.8, marker=:circle, ms=3.5, msw=0,
          label="from (−0.3, 0.2)")
    bx, by = pathdraw(PBf, xl, yl)
    plot!(L, bx, by; color=:red, lw=1.8, marker=:circle, ms=3.5, msw=0, label="from (−3, 2)")
    scatter!(L, [PAf[end][1]], [PAf[end][2]]; color=:blue, ms=6, msc=:white, msw=1, label="")
    if xl[1] <= PBf[end][1] <= xl[2] && yl[1] <= PBf[end][2] <= yl[2]
        scatter!(L, [PBf[end][1]], [PBf[end][2]]; color=:red, ms=6, msc=:white, msw=1, label="")
    else
        annotate!(L, -3.9, 3.6, text("P$(sub(k)) from (−3, 2) is off this plot →\n" *
                  "see the widening window", 8, :red, :left))
    end

    # Top right: window that widens to hold every iterate of the run from (-3, 2)
    R = max(6.0, 1.12 * maximum(hypot(p...) for p in PBf))
    xr = (-R, 0.25R); yr = (-0.45R, 0.8R)
    ratio = k == 0 ? "" : ",  ‖P$(sub(k))‖ / ‖P$(sub(k-1))‖ = $(fmt(rB[k+1] / rB[k]))"
    tB2 = "P$(sub(k)) = ($(fmt(pB[1])), $(fmt(pB[2]))),  f = $(fmt(f(pB...))),  H $(hk(pB))"
    tB3 = "‖P$(sub(k))‖ = $(fmt(rB[k+1]))" * ratio
    Rp = plot(xlims=xr, ylims=yr, aspect_ratio=:equal, xlabel="x", ylabel="y",
              title="Widening window, k = $k.  Run from (−3, 2):\n" * tB2 * "\n" * tB3,
              titlefontsize=10, legend=:bottomleft, legendfontsize=7, framestyle=:box,
              grid=false, background_color=:white)
    backdrop!(Rp, xr, yr)
    plot!(Rp, [-4, 4, 4, -4, -4], [-4, -4, 4, 4, -4]; color=:black, ls=:dot, lw=1,
          label="Mathews' window")
    plot!(Rp, first.(PAf), last.(PAf); color=:blue, lw=1.5, label="from (−0.3, 0.2)")
    plot!(Rp, first.(PBf), last.(PBf); color=:red, lw=1.8, marker=:circle, ms=3.5, msw=0,
          label="from (−3, 2)")
    scatter!(Rp, [PBf[end][1]], [PBf[end][2]]; color=:red, ms=6, msc=:white, msw=1, label="")

    # Bottom: log-scale distances
    D = plot(xlims=(-0.3, nB + 0.3), ylims=(1e-16, 1e3), yscale=:log10, xticks=0:nB,
             yticks=10.0 .^ (-15:3:3), xlabel="k", ylabel="distance",
             title="Error ‖P_k − (−1, 1)‖ of the run from (−0.3, 0.2) and distance ‖P_k‖ from the origin of the run from (−3, 2)",
             titlefontsize=10, legend=:left, legendfontsize=8, framestyle=:box,
             background_color=:white)
    plot!(D, 0:kA, Float64.(eA[1:kA+1]); color=:blue, lw=1.8, marker=:circle, ms=4, msw=0,
          label="‖P_k − (−1, 1)‖, from (−0.3, 0.2)")
    plot!(D, 0:k, Float64.(rB[1:k+1]); color=:red, lw=1.8, marker=:circle, ms=4, msw=0,
          label="‖P_k‖, from (−3, 2)")

    @printf("k=%2d  A: P=(%.12f, %.12f) f=%.12f e=%.3g H %s | B: P=(%.6f, %.6f) f=%.6f |P|=%.4g ratio=%s H %s  B left Mathews window: %s\n",
            k, pA[1], pA[2], f(pA...), eA[kA+1], hk(pA), pB[1], pB[2], f(pB...), rB[k+1],
            k == 0 ? "-" : @sprintf("%.5g", rB[k+1] / rB[k]), hk(pB),
            !(abs(pB[1]) <= 4 && abs(pB[2]) <= 4))
    plt = plot(L, Rp, D; layout=@layout([a b; c{0.28h}]), size=(1250, 1000),
               left_margin=5Plots.mm, top_margin=3Plots.mm)
    frame(anim, plt)
end

gif(anim, joinpath(@__DIR__, "newtonsearchbb.gif"); fps=1)
println("Saved: newtonsearchbb.gif")
