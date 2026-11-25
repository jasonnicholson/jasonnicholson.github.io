# gradientdd.jl
# Steepest Descent - Gradient Search animation: Mathews' Example 4, the rational
# function f(x, y) = (x - y)/(x^2 + y^2 + 2) from P0 = (-3, -2), with Mathews'
# line search and stopping rule (delta = epsilon = 1e-10, work counter 60): 8
# steps, ending on the tolerance test. New: Mathews has no animation of this example.
# Three panels, one line search per frame:
#   left   - fixed window over the whole run;
#   middle - zoom on the current line search, in offsets from the minimum P*,
#            so that steps far too small for the left panel stay visible; cyan
#            contours at Mathews' levels f* + (f(Pk) - f*) {0.1, 0.2, 0.4, 0.6, 0.8},
#            the level curve through Pk in blue and through P(k+1) in orange, and
#            the trial points red (Pk), blue (Pk + h Sk) and green (Pk + 2h Sk), as
#            in Mathews' Example 5 drawing program;
#   right  - phi(gamma) = f(Pk + gamma Sk) on the bracket [0, 2h], the parabola
#            through the three trial values, its vertex h_k (the step taken) and
#            the exact minimum of phi along the line.
# All of it in 256-bit BigFloat arithmetic.
# Produces: gradientdd.gif

using Plots
using Printf
gr()
setprecision(BigFloat, 256)

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0 (exact)" : um(@sprintf("%.4g", Float64(x)))
fmt10(x) = x == 0 ? "0 (exact)" : um(@sprintf("%.10g", Float64(x)))

# ======================= Parameters (this case) =======================
gif_name  = "gradientdd.gif"
title_str = "Gradient method with Mathews' line search, Example 4:  f(x, y) = (x − y) / (x² + y² + 2),  P₀ = (−3, −2)"
f(x, y) = (x - y) / (x^2 + y^2 + 2)
gradf(x, y) = ((-x^2 + 2x * y + y^2 + 2) / (x^2 + y^2 + 2)^2,
               (-x^2 - 2x * y + y^2 - 2) / (x^2 + y^2 + 2)^2)
# runs: starting point, tolerances, the minimum P* the run approaches, f* = f(P*)
runs = [(name = "", X0 = (big(-3), big(-2)), delta = big"1e-10",
         Pstar = (big(-1), big(1)), gap = "f + 1/2", phigap = "φ(γ) + 1/2")]
xlims_L = (-6.5, 1.5)
ylims_L = (-3.0, 3.5)
legend_L = :bottomright
function decorate_L!(p)                      # the mirror line of f
    plot!(p, [-3.0, 3.0], [3.0, -3.0]; color=:gray50, ls=:dot, lw=1, label="mirror line y = −x")
end
# ======================================================================

# Newton's method on grad f = 0: polishes P* to full precision (a no-op when P* is exact)
function polish(P)
    x, y = P
    for _ in 1:100
        g = gradf(x, y)
        e = big"1e-30"                       # Hessian by central differences
        hx = (gradf(x + e, y) .- gradf(x - e, y)) ./ (2e)
        hy = (gradf(x, y + e) .- gradf(x, y - e)) ./ (2e)
        det = hx[1] * hy[2] - hy[1] * hx[2]
        dx = (g[1] * hy[2] - hy[1] * g[2]) / det
        dy = (hx[1] * g[2] - g[1] * hx[2]) / det
        x, y = x - dx, y - dy
    end
    return (x, y)
end

# --- Mathews' line search (Qmin) and outer loop (GradSearch), as on the page ---
addp(P, t, S) = (P[1] + t * S[1], P[2] + t * S[2])
function sdir(P)
    g = gradf(P...)
    n = sqrt(g[1]^2 + g[2]^2)
    return (-g[1] / n, -g[2] / n)
end

struct Step
    run::Int
    k::Int                       # the step from P_k to P_{k+1}
    P::NTuple{2,BigFloat}
    S::NTuple{2,BigFloat}
    hin::BigFloat                # trial step on entry
    moves::String                # 'H' = halve, 'D' = double
    h::BigFloat                  # trial step after the bracketing loop
    Y::NTuple{3,BigFloat}        # phi(0), phi(h), phi(2h)
    hk::BigFloat                 # vertex of the parabola: the step taken
    Pn::NTuple{2,BigFloat}
    gexact::BigFloat             # exact minimum of phi in (0, 2h)
    bracketed::Bool              # false if the loop ended after jmax passes
    count::Int
    hnext::BigFloat
    Err::BigFloat
end

# first local minimum of phi in (0, b): first sign change of phi' from - to +, then bisection
function exact_linemin(P, S, b)
    dphi(t) = (g = gradf(addp(P, t, S)...); g[1] * S[1] + g[2] * S[2])
    ts = range(big(0), b, length=401)
    i = findfirst(t -> dphi(t) >= 0, ts[2:end])
    lo, hi = ts[i], ts[i+1]
    for _ in 1:300
        m = (lo + hi) / 2
        dphi(m) < 0 ? (lo = m) : (hi = m)
    end
    return (lo + hi) / 2
end

function gradsearch(r, X0, delta, epsilon; maxc=60, jmax=15)
    P = X0; h = big(1); Err = big(1); count = 0; k = 0
    steps = Step[]
    while count < maxc && (h > delta || Err > epsilon)
        S = sdir(P)
        phi(t) = f(addp(P, t, S)...)
        hin = h
        Y0, Y1, Y2 = phi(big(0)), phi(h), phi(2h)
        moves = ""; j = 0; cond = 0
        while j < jmax && cond == 0
            if Y0 <= Y1                      # too long: halve
                Y2 = Y1; h = h / 2; Y1 = phi(h); moves *= "H"
            elseif Y2 < Y1                   # still falling at 2h: double
                Y1 = Y2; h = 2h; Y2 = phi(2h); moves *= "D"
            else                             # 0, h, 2h bracket a minimum
                cond = -1
            end
            j += 1
        end
        hb = h
        hk = hb * (4Y1 - 3Y0 - Y2) / (2 * (2Y1 - Y0 - Y2))      # formula (3)
        Pn = addp(P, hk, S)
        Yn = f(Pn...)
        h = min(hb, abs(hk), abs(hk - hb), abs(hk - 2hb))
        h == 0 && (h = hk)
        es = (abs(Y0 - Yn), abs(Y1 - Yn), abs(Y2 - Yn))
        for e in es
            (e != 0 && e < Err) && (Err = e)
        end
        all(==(0), es) && (Err = big(0))
        count += j + 1
        push!(steps, Step(r, k, P, S, hin, moves, hb, (Y0, Y1, Y2), hk, Pn,
                          exact_linemin(P, S, 2hb), cond == -1, count, h, Err))
        P = Pn; k += 1
    end
    reason = count >= maxc ? "counter $count ≥ $maxc: stop" : "h ≤ δ and Err ≤ ε: stop"
    return steps, reason
end

allsteps = Step[]
reasons = String[]
pstars = NTuple{2,BigFloat}[]
fstars = BigFloat[]
for (r, run) in enumerate(runs)
    st, why = gradsearch(r, run.X0, run.delta, run.delta)
    append!(allsteps, st)
    push!(reasons, why)
    ps = polish(run.Pstar)
    push!(pstars, ps)
    push!(fstars, f(ps...))
end
nsteps(r) = count(s -> s.run == r, allsteps)

sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))
const SUPS = collect("⁰¹²³⁴⁵⁶⁷⁸⁹")
sup(n) = (n < 0 ? "⁻" : "") * join(SUPS[d+1] for d in reverse(digits(abs(n))))
scl(e) = e == 0 ? "" : " × 10" * sup(-e)
gap(r, P) = f(P...) - fstars[r]
dist(r, P) = hypot(P[1] - pstars[r][1], P[2] - pstars[r][2])
function search_str(s)
    m = s.moves
    t = isempty(m) ? "h = $(fmt(s.hin)) brackets at once" :
        all(==('H'), m) ? "h = $(fmt(s.hin)) halved $(length(m))× → h = $(fmt(s.h))" :
        all(==('D'), m) ? "h = $(fmt(s.hin)) doubled $(length(m))× → h = $(fmt(s.h))" :
        "h = $(fmt(s.hin)), moves $m → h = $(fmt(s.h))"
    s.bracketed && return t
    Y0, Y1, Y2 = s.Y
    why = Y0 <= Y1 ? "still φ(h) ≥ φ(0)" : Y2 < Y1 ? "still φ(2h) < φ(h)" : "last pass not yet tested"
    return t * "\n(pass limit $(length(m)) reached, $why)"
end

# Legend corner whose legend-sized box covers the fewest of the drawn points
function legend_corner(xs, ys, xl, yl; w=0.45, hgt=0.34)
    best, bestn = :bottomright, typemax(Int)
    for (pos, cx, cy) in ((:bottomright, 1, 0), (:topright, 1, 1), (:bottomleft, 0, 0), (:topleft, 0, 1))
        n = 0
        for (x, y) in zip(xs, ys)
            u = (x - xl[1]) / (xl[2] - xl[1]); v = (y - yl[1]) / (yl[2] - yl[1])
            (0 <= u <= 1 && 0 <= v <= 1) || continue
            n += ((cx == 1 ? u >= 1 - w : u <= w) && (cy == 1 ? v >= 1 - hgt : v <= hgt))
        end
        n < bestn && ((best, bestn) = (pos, n))
    end
    return best
end
sample_seg(a, b) = ([a[1] + t * (b[1] - a[1]) for t in 0:0.02:1], [a[2] + t * (b[2] - a[2]) for t in 0:0.02:1])

# Log of the run, for the build ledger
for (r, run) in enumerate(runs)
    println("run $r $(run.name)  P* = (", fmt10(pstars[r][1]), ", ", fmt10(pstars[r][2]),
            ")  f* = ", fmt10(fstars[r]), "  ", reasons[r])
end
for s in allsteps
    println("run $(s.run) k=$(s.k)  h_in=", fmt10(s.hin), " moves=", s.moves, " h=", fmt10(s.h),
            " bracketed=", s.bracketed, " h_k=", fmt10(s.hk), " gamma*=", fmt10(s.gexact), "  P_k+1=(",
            fmt10(s.Pn[1]), ", ", fmt10(s.Pn[2]), ")  f=", fmt10(f(s.Pn...)),
            "  gap=", fmt(gap(s.run, s.Pn)), "  dist=", fmt(dist(s.run, s.Pn)),
            "  dx=", fmt(s.Pn[1] - pstars[s.run][1]), " dy=", fmt(s.Pn[2] - pstars[s.run][2]),
            "  count=", s.count, " h_next=", fmt(s.hnext), " Err=", fmt(s.Err))
end

# --- Backdrop for the left panel ---
xg = range(xlims_L..., length=300)
yg = range(ylims_L..., length=300)
FL = [f(x, y) for y in yg, x in xg]
fsmin = minimum(Float64.(fstars))
GL = log10.(max.(FL .- fsmin, 1e-12))
Gs = sort(vec(GL))
levL = unique([Gs[round(Int, q * length(Gs))] for q in 0.04:0.06:0.94])

# Ends of the part of the line P + t U inside the box xl x yl (slab method)
function line_in_box(P, U, xl, yl)
    t1, t2 = -Inf, Inf
    for (p, u, l) in ((P[1], U[1], xl), (P[2], U[2], yl))
        u == 0 && continue
        a, b = minmax((l[1] - p) / u, (l[2] - p) / u)
        t1, t2 = max(t1, a), min(t2, b)
    end
    return [P[1] + t1 * U[1], P[1] + t2 * U[1]], [P[2] + t1 * U[2], P[2] + t2 * U[2]]
end

F64(P) = (Float64(P[1]), Float64(P[2]))

function draw_frame(i)
    s = allsteps[i]
    r = s.run
    ps = pstars[r]
    run = runs[r]
    last_of_run = i == length(allsteps) || allsteps[i+1].run != r

    # ---------- Left panel: fixed window ----------
    pL = plot(xlims=xlims_L, ylims=ylims_L, aspect_ratio=:equal, framestyle=:box,
              xlabel="x", ylabel="y", legend=legend_L, legendfontsize=7,
              titlefontsize=10, grid=false)
    contour!(pL, xg, yg, GL; levels=levL, color=:cyan, lw=0.8, colorbar=false, label="")
    decorate_L!(pL)
    lv = log10(max(Float64(gap(r, s.P)) + Float64(fstars[r]) - fsmin, 1e-12))
    contour!(pL, xg, yg, GL; levels=[lv], color=:blue, lw=1.2, colorbar=false, label="")
    lx, ly = line_in_box(F64(s.P), F64(s.S), xlims_L, ylims_L)
    plot!(pL, lx, ly; color=:gray40, ls=:dash, lw=1, label="search line through Pₖ")
    first_seg = true
    for t in allsteps[1:i]
        plot!(pL, Float64.([t.P[1], t.Pn[1]]), Float64.([t.P[2], t.Pn[2]]);
              color=:magenta, lw=(t === s ? 2.5 : 1.5), label=(first_seg ? "steps" : ""))
        first_seg = false
    end
    pts = vcat([F64(t.P) for t in allsteps[1:i]], [F64(s.Pn)])
    scatter!(pL, first.(pts), last.(pts); color=:red, ms=3.5, msw=0, label="points Pₖ")
    for (q, pq) in enumerate(pstars)
        scatter!(pL, [Float64(pq[1])], [Float64(pq[2])]; color=:green, marker=:xcross,
                 ms=6, msw=2, label=(q == 1 ? "minimum P*" : ""))
    end
    ttl = "$(run.name)Step $(s.k + 1) of $(nsteps(r)): P$(sub(s.k)) → P$(sub(s.k + 1))\n" *
          "work counter = $(s.count)" * (last_of_run ? "  ($(reasons[r]))" : "")
    title!(pL, ttl)

    # ---------- Middle panel: zoom on the current line search ----------
    off(P) = (Float64(P[1] - ps[1]), Float64(P[2] - ps[2]))
    A = off(s.P)
    B = off(addp(s.P, 2s.h, s.S))
    bx = extrema((A[1], B[1])); by = extrema((A[2], B[2]))
    c = ((bx[1] + bx[2]) / 2, (by[1] + by[2]) / 2)
    hw = 0.62 * max(bx[2] - bx[1], by[2] - by[1])
    e = floor(Int, log10(hw))
    sc = 10.0^(-e)
    xl = ((c[1] - hw) * sc, (c[1] + hw) * sc)
    yl = ((c[2] - hw) * sc, (c[2] + hw) * sc)
    ug = range(c[1] - hw, c[1] + hw, length=401)
    vg = range(c[2] - hw, c[2] + hw, length=401)
    G = [Float64(f(ps[1] + big(u), ps[2] + big(v)) - fstars[r]) for v in vg, u in ug]
    g0 = Float64(gap(r, s.P)); g1 = Float64(gap(r, s.Pn))
    T1 = off(addp(s.P, s.h, s.S))
    X = off(addp(s.P, s.gexact, s.S))
    N = off(s.Pn)
    avx, avy = Float64[0.0, T1[1], X[1], N[1]], Float64[0.0, T1[2], X[2], N[2]]
    for (a, b) in [(A, B); [(off(t.P), off(t.Pn)) for t in allsteps[1:i] if t.run == r]]
        sx, sy = sample_seg(a, b)
        append!(avx, sx); append!(avy, sy)
    end
    legM = legend_corner(avx .* sc, avy .* sc, xl, yl)
    pM = plot(xlims=xl, ylims=yl, aspect_ratio=:equal, framestyle=:box,
              xlabel="(x − x*)" * scl(e), ylabel="(y − y*)" * scl(e),
              legend=legM, legendfontsize=7, titlefontsize=10, grid=false)
    contour!(pM, ug .* sc, vg .* sc, G; levels=g0 .* [0.1, 0.2, 0.4, 0.6, 0.8], color=:cyan,
             lw=0.8, colorbar=false, label="")
    contour!(pM, ug .* sc, vg .* sc, G; levels=[g0], color=:blue, lw=1.4, colorbar=false, label="")
    g1 > 0 && contour!(pM, ug .* sc, vg .* sc, G; levels=[g1], color=:darkorange, lw=1.4,
                       colorbar=false, label="")
    lx, ly = line_in_box(A, F64(s.S), (c[1] - hw, c[1] + hw), (c[2] - hw, c[2] + hw))
    plot!(pM, lx .* sc, ly .* sc; color=:gray40, ls=:dash, lw=1, label="")
    plot!(pM, [A[1], B[1]] .* sc, [A[2], B[2]] .* sc; color=:pink, lw=5, label="γ from 0 to 2h")
    for t in allsteps[1:i]
        t.run == r || continue
        a, b = off(t.P), off(t.Pn)
        plot!(pM, [a[1], b[1]] .* sc, [a[2], b[2]] .* sc; color=:magenta,
              lw=(t === s ? 2.5 : 1.5), label="")
    end
    scatter!(pM, [A[1] * sc], [A[2] * sc]; color=:red, ms=6, msw=0, label="Pₖ  (γ = 0)")
    scatter!(pM, [T1[1] * sc], [T1[2] * sc]; color=:blue, ms=6, msw=0, label="Pₖ + hSₖ")
    scatter!(pM, [B[1] * sc], [B[2] * sc]; color=:green, ms=6, msw=0, label="Pₖ + 2hSₖ")
    scatter!(pM, [X[1] * sc], [X[2] * sc]; color=:black, marker=:xcross, ms=7, msw=1.5,
             label="exact minimum on the line")
    scatter!(pM, [N[1] * sc], [N[2] * sc]; color=:red, ms=7, msw=1.5, msc=:black,
             label="Pₖ₊₁ = Pₖ + hₖSₖ")
    if xl[1] <= 0 <= xl[2] && yl[1] <= 0 <= yl[2]
        scatter!(pM, [0.0], [0.0]; color=:green, marker=:xcross, ms=7, msw=2, label="")
    end
    title!(pM, "P$(sub(s.k + 1)): x − x* = $(fmt(s.Pn[1] - ps[1])),  y − y* = $(fmt(s.Pn[2] - ps[2]))\n" *
               "$(run.gap) = $(fmt(gap(r, s.Pn))),  distance to P* = $(fmt(dist(r, s.Pn)))")

    # ---------- Right panel: phi on the bracket ----------
    eg = floor(Int, log10(Float64(2s.h)))
    sg = 10.0^(-eg)
    Y = Float64.(s.Y .- fstars[r])
    phi(t) = f(addp(s.P, t, s.S)...) - fstars[r]
    ts = range(big(0), 2.15 * s.h, length=241)
    ph = Float64.(phi.(ts))
    hb = Float64(s.h)
    # parabola through (0, Y0), (h, Y1), (2h, Y2) (Newton form)
    par(t) = Y[1] + (Y[2] - Y[1]) / hb * t + (Y[3] - 2Y[2] + Y[1]) / (2hb^2) * t * (t - hb)
    tf = Float64.(ts)
    gv = Float64(phi(s.hk)); gx = Float64(phi(s.gexact))
    ytop = max(Y[1], Y[3]); ybot = min(minimum(ph[tf .<= 2hb]), par(Float64(s.hk)), gv, gx)
    ey = floor(Int, log10(max(abs(ytop), abs(ybot))))
    sy = 10.0^(-ey)
    rng = ytop - ybot
    pR = plot(xlims=(0, 2.15hb * sg), ylims=((ybot - 0.08rng) * sy, (ytop + 0.4rng) * sy),
              framestyle=:box, xlabel="γ" * scl(eg), ylabel="($(run.phigap))" * scl(ey),
              legend=:top, legendfontsize=7, titlefontsize=10, grid=false,
              top_margin=(s.bracketed ? 6 : 10) * Plots.mm)
    plot!(pR, tf .* sg, ph .* sy; color=:black, lw=1.5, label="φ(γ) = f(Pₖ + γSₖ)")
    plot!(pR, tf .* sg, par.(tf) .* sy; color=:purple, ls=:dash, lw=1.2, label="parabola, formula (3)")
    scatter!(pR, [0.0], [Y[1] * sy]; color=:red, ms=6, msw=0, label="")
    scatter!(pR, [hb * sg], [Y[2] * sy]; color=:blue, ms=6, msw=0, label="")
    scatter!(pR, [2hb * sg], [Y[3] * sy]; color=:green, ms=6, msw=0, label="")
    scatter!(pR, [Float64(s.gexact) * sg], [gx * sy]; color=:black, marker=:xcross, ms=7,
             msw=1.5, label="")
    scatter!(pR, [Float64(s.hk) * sg], [gv * sy]; color=:red, ms=7, msw=1.5, msc=:black,
             label="")
    title!(pR, "Line search: $(search_str(s))\n" *
               "vertex hₖ = $(fmt(s.hk)),  minimum of φ at γ = $(fmt(s.gexact))")

    plot(pL, pM, pR; layout=(1, 3), size=(1560, 600), plot_title=title_str,
         plot_titlefontsize=12, left_margin=5Plots.mm, bottom_margin=6Plots.mm,
         background_color=:white)
end

anim = Animation()
for i in eachindex(allsteps)
    draw_frame(i)
    frame(anim)
end
for _ in 1:3                       # hold the last frame
    frame(anim)
end

gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: ", gif_name)
