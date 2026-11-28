# powellcc.jl
# Powell's Method animation: Rosenbrock's parabolic valley (Powell's Method
# module, Example 4), f(x, y) = 100 (y - x^2)^2 + (1 - x)^2, Powell's method
# from X0 = (0.99, 1.01) for 4 iterations, as in Mathews' run. New: Mathews has
# no animation of this example. Left panel: a fixed window around (1, 1) with
# the valley floor y = x^2; right panel: zoom on the current line search, in
# offsets from the minimum (1, 1), so that the crawl along the valley floor and
# the later searches, which are far too small for the left panel, stay visible.
# Every line search goes to the first local minimum of phi(g) = f(P + g U)
# reached by going downhill from g = 0, as Mathews' FindMinimum started at
# g = 0: march downhill from 0 with doubling steps until phi rises, then a
# golden section search on the bracket. All of it in 256-bit BigFloat.
# Produces: powellcc.gif

using Plots
using Printf
gr()
setprecision(BigFloat, 256)

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0 (exact)" : um(@sprintf("%.4g", Float64(x)))
fmt10(x) = um(@sprintf("%.10g", Float64(x)))

# --- Parameters ---
gif_name = "powellcc.gif"
title_str = "Powell's method on Rosenbrock's valley (Example 4):  f(x, y) = 100 (y − x²)² + (1 − x)²"
f(x, y) = 100 * (y - x^2)^2 + (1 - x)^2
f_rel(u, v) = 100 * (v - 2u - u^2)^2 + u^2   # f(1 + u, 1 + v), no cancellation
xstar = (big(1), big(1))                     # the minimum, f(1, 1) = 0
X0 = (big"0.99", big"1.01")
n_iter = 4                                   # Mathews' Powell[P0, 4]
xlims_L = (0.985, 1.015)
ylims_L = (0.985, 1.015)

# --- Line search: first local minimum downhill from g = 0 ---
function linemin(phi)
    p0 = phi(big(0))
    d = big"1e-40"
    s = phi(d) < p0 ? 1 : phi(-d) < p0 ? -1 : 0
    s == 0 && return big(0)                  # no descent in either direction
    h = big"1e-3"
    while phi(s * h) >= p0                   # first step must go downhill
        h /= 4
        h < big"1e-35" && error("no descent step")
    end
    a, m = big(0), s * h
    fm = phi(m)
    b = 2m
    while (fb = phi(b)) < fm                 # march, doubling the step
        a, m, fm = m, b, fb
        b = m + 2 * (m - a)
        abs(b) > 1e8 && error("no bracket")
    end
    lo, hi = minmax(a, b)                    # phi(m) < phi(a), phi(m) < phi(b)
    r = (sqrt(big(5)) - 1) / 2
    c, dd = hi - r * (hi - lo), lo + r * (hi - lo)
    fc, fd = phi(c), phi(dd)
    for _ in 1:300
        if fc <= fd
            hi, dd, fd = dd, c, fc
            c = hi - r * (hi - lo); fc = phi(c)
        else
            lo, c, fc = c, dd, fd
            dd = lo + r * (hi - lo); fd = phi(dd)
        end
    end
    return (lo + hi) / 2
end

# --- The run (Mathews' basic Powell's method): one record per line search ---
struct Search
    iter::Int
    k::Int
    dogleg::Bool
    start::NTuple{2,BigFloat}
    U::NTuple{2,BigFloat}
    gamma::BigFloat
    stop::NTuple{2,BigFloat}
end
addp(P, g, U) = (P[1] + g * U[1], P[2] + g * U[2])
search(P, U) = linemin(g -> f(addp(P, g, U)...))

searches = Search[]
X = X0
U = [(big(1), big(0)), (big(0), big(1))]
for it in 1:n_iter
    global X, U
    P0 = X
    P = X
    for k in 1:2
        g = search(P, U[k])
        Pn = addp(P, g, U[k])
        push!(searches, Search(it, k, false, P, U[k], g, Pn))
        P = Pn
    end
    U = [U[2], (P[1] - P0[1], P[2] - P0[2])]
    g = search(P0, U[2])
    Xn = addp(P0, g, U[2])
    push!(searches, Search(it, 3, true, P0, U[2], g, Xn))
    X = Xn
end
points = [X0]
append!(points, [s.stop for s in searches])

off(P) = (Float64(P[1] - xstar[1]), Float64(P[2] - xstar[2]))
dist(P) = hypot(P[1] - xstar[1], P[2] - xstar[2])
sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))
const SUPS = collect("⁰¹²³⁴⁵⁶⁷⁸⁹")
sup(n) = (n < 0 ? "⁻" : "") * join(SUPS[d+1] for d in reverse(digits(abs(n))))
pname(s) = s.dogleg ? "X$(sub(s.iter))" : "P$(sub(s.k))"

# Log of the run, for the build ledger
for s in searches
    println("iter $(s.iter) $(pname(s))  γ = ", fmt10(s.gamma), "  point = (",
            @sprintf("%.12f", Float64(s.stop[1])), ", ", @sprintf("%.12f", Float64(s.stop[2])),
            ")  f = ", fmt(f(s.stop...)), "  dist = ", fmt(dist(s.stop)),
            "  y − x² = ", fmt(s.stop[2] - s.stop[1]^2))
end

# --- Backdrop for the left panel ---
xg = range(xlims_L..., length=300)
yg = range(ylims_L..., length=300)
FL = [log10(f(x, y)) for y in yg, x in xg]
FLs = sort(vec(FL))
levL = unique([FLs[round(Int, q * length(FLs))] for q in 0.05:0.05:0.95])
xv = range(sqrt(ylims_L[1]), sqrt(ylims_L[2]), length=200)

seg_color(s) = s.dogleg ? :darkorange : :magenta

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

function draw_frame(j)
    s = j >= 1 ? searches[j] : nothing
    cur = points[j+1]

    # ---------- Left panel: fixed window ----------
    pL = plot(xlims=xlims_L, ylims=ylims_L, aspect_ratio=:equal, framestyle=:box,
              xlabel="x", ylabel="y", legend=:bottomright, legendfontsize=7,
              titlefontsize=10, grid=false)
    contour!(pL, xg, yg, FL; levels=levL, color=:cyan, lw=0.8, colorbar=false, label="")
    plot!(pL, xv, xv .^ 2; color=:black, ls=:dot, lw=1, label="valley floor y = x²")
    contour!(pL, xg, yg, FL; levels=[log10(Float64(f(cur...)))], color=:blue, lw=1.2,
             colorbar=false, label="")
    if s !== nothing
        lx, ly = line_in_box(Float64.(s.start), Float64.(s.U), xlims_L, ylims_L)
        plot!(pL, lx, ly; color=:gray40, ls=:dash, lw=1, label="current search line")
    end
    shown_sweep = shown_dog = false
    for i in 1:j
        si = searches[i]
        lab = ""
        if si.dogleg && !shown_dog
            lab = "dog-leg search (from P₀)"; shown_dog = true
        elseif !si.dogleg && !shown_sweep
            lab = "search along U₁, U₂"; shown_sweep = true
        end
        plot!(pL, Float64.([si.start[1], si.stop[1]]), Float64.([si.start[2], si.stop[2]]);
              color=seg_color(si), lw=(i == j ? 2.5 : 1.5), label=lab)
    end
    scatter!(pL, [Float64(P[1]) for P in points[1:j+1]], [Float64(P[2]) for P in points[1:j+1]];
             color=:red, ms=4, msw=0, label="points")
    scatter!(pL, [1.0], [1.0]; color=:green, marker=:xcross, ms=6, msw=2, label="minimum (1, 1)")
    if s === nothing
        title!(pL, "Start\nX₀ = (0.99, 1.01)")
    else
        Ustr = "(" * join((u == 0 ? "0" : u == 1 ? "1" : fmt(u) for u in s.U), ", ") * ")"
        what = s.dogleg ? "dog-leg search\nalong U₂ = P₂ − P₀ = $Ustr" :
               "search $(s.k)\nalong U$(sub(s.k)) = $Ustr"
        title!(pL, "Iteration $(s.iter), $what")
    end

    # ---------- Right panel: zoom on the current line search ----------
    A = j == 0 ? off(X0) : off(s.start)
    B = j == 0 ? off(X0) : off(s.stop)
    # square window around the search (at the start: around X0 and the minimum)
    bx = j == 0 ? extrema((A[1], 0.0)) : extrema((A[1], B[1]))
    by = j == 0 ? extrema((A[2], 0.0)) : extrema((A[2], B[2]))
    c = ((bx[1] + bx[2]) / 2, (by[1] + by[2]) / 2)
    h = 0.6 * max(bx[2] - bx[1], by[2] - by[1])
    e = floor(Int, log10(h))
    sc = 10.0^(-e)
    xl = ((c[1] - h) * sc, (c[1] + h) * sc)
    yl = ((c[2] - h) * sc, (c[2] + h) * sc)
    ug = range(c[1] - h, c[1] + h, length=300)
    vg = range(c[2] - h, c[2] + h, length=300)
    G = [log10(max(f_rel(u, v), 1e-300)) for v in vg, u in ug]
    Gs = sort(vec(G))
    levR = unique([Gs[round(Int, q * length(Gs))] for q in 0.06:0.06:0.96])
    scl(e) = e == 0 ? "" : " × 10" * sup(-e)
    pR = plot(xlims=xl, ylims=yl, aspect_ratio=:equal, framestyle=:box,
              xlabel="(x − 1)" * scl(e), ylabel="(y − 1)" * scl(e),
              legend=(j == 0 ? :topright : :bottomright), legendfontsize=7, titlefontsize=10, grid=false)
    contour!(pR, ug .* sc, vg .* sc, G; levels=levR, color=:cyan, lw=0.8, colorbar=false,
             label="")
    plot!(pR, ug .* sc, (2 .* ug .+ ug .^ 2) .* sc; color=:black, ls=:dot, lw=1, label="")
    if s !== nothing
        lx, ly = line_in_box(A, Float64.(s.U), (c[1] - h, c[1] + h), (c[2] - h, c[2] + h))
        plot!(pR, lx .* sc, ly .* sc; color=:gray40, ls=:dash, lw=1, label="")
        for i in 1:j
            si = searches[i]
            a, b = off(si.start), off(si.stop)
            plot!(pR, [a[1], b[1]] .* sc, [a[2], b[2]] .* sc; color=seg_color(si),
                  lw=(i == j ? 2.5 : 1.5), label="")
        end
        contour!(pR, ug .* sc, vg .* sc, G; levels=[log10(f_rel(B...))], color=:blue,
                 lw=1.2, colorbar=false, label="")
        prev = [off(P) for P in points[1:j]]
        scatter!(pR, [p[1] * sc for p in prev], [p[2] * sc for p in prev]; color=:red,
                 ms=3, msw=0, label="")
        scatter!(pR, [A[1] * sc], [A[2] * sc]; color=:white, msc=:red, ms=6, msw=1.5,
                 label="start of search")
        scatter!(pR, [B[1] * sc], [B[2] * sc]; color=:red, ms=6, msw=0, label="new point")
    else
        scatter!(pR, [A[1] * sc], [A[2] * sc]; color=:red, ms=6, msw=0, label="X₀")
    end
    if xl[1] <= 0 <= xl[2] && yl[1] <= 0 <= yl[2]
        scatter!(pR, [0.0], [0.0]; color=:green, marker=:xcross, ms=7, msw=2,
                 label="minimum (1, 1)")
    end
    nm = s === nothing ? "X₀" : pname(s)
    gl = s === nothing ? "Start\n" : "γ = $(fmt10(s.gamma))\n"
    title!(pR, "$(gl)$nm: x − 1 = $(fmt(cur[1] - 1)),  y − 1 = $(fmt(cur[2] - 1))\n" *
               "f = $(fmt(f(cur...))),  distance to (1, 1) = $(fmt(dist(cur)))")

    plot(pL, pR; layout=(1, 2), size=(1100, 620), plot_title=title_str,
         plot_titlefontsize=12, left_margin=4Plots.mm, bottom_margin=4Plots.mm,
         background_color=:white)
end

anim = Animation()
for j in 0:length(searches)
    draw_frame(j)
    frame(anim)
end
for _ in 1:3                       # hold the last frame
    frame(anim)
end

gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: ", gif_name)
