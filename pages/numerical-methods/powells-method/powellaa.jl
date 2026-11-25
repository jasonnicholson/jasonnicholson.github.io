# powellaa.jl
# Powell's Method animation: rebuild of Mathews' Animation 1 (Powell's Method
# module, Example 7), the taxi-cab method on f(x, y) = x^2 - 4x + y^2 - y - xy
# from X0 = (2.55, 1.75). His Example 7 program TaxiCab[P0, 3] collects the
# seven points X0, P1, X1 = P2, P1, X2, P1, X3 of three iterations, and its
# plotting loop draws them (i = 1..7). The animation page it links to was never
# finished (the archived page shows only an "Under Construction" banner), so
# the look follows his Example 7 plotting program: window [2.5, 3.05] x
# [1.6, 2.15], cyan contours at his fixed list of levels, a blue contour of f
# through each point drawn so far, red dots at the points and magenta segments.
# Additions: the dashed line of the current line search and a right panel
# zoomed on the current line search, in offsets from the minimum (3, 2).
# Every line search goes to the first local minimum of phi(g) = f(P + g U)
# reached by going downhill from g = 0, as Mathews' FindMinimum started at
# g = 0. Here phi is a parabola with a positive leading coefficient, so that
# minimum is its vertex, which is computed exactly in rational arithmetic.
# The same code as powellbb.jl, with method = :taxicab.
# Produces: powellaa.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
# (exact rational arithmetic here, so a zero is an exact zero); "−" for minus
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0 (exact)" : um(@sprintf("%.4g", Float64(x)))
# Coordinates: up to 10 significant figures, trailing zeros dropped
fmtc(x) = x == 0 ? "0" : um(@sprintf("%.10g", Float64(x)))
# Direction components: 4 significant figures, exact 0 and 1 printed plainly
fmtd(x) = x == 0 ? "0" : x == 1 ? "1" : um(@sprintf("%.4g", Float64(x)))
# Exact fraction with its decimal value
fmtq(q) = denominator(q) == 1 ? string(numerator(q)) :
          um("$(numerator(q))/$(denominator(q))") * " ≈ $(fmt(q))"

# --- Parameters ---
method = :taxicab             # :taxicab (Example 7) or :powell (Example 8)
gif_name = "powellaa.gif"
title_str = "Taxi-cab method (Mathews' Example 7):  f(x, y) = x² − 4x + y² − y − xy"
f(x, y) = x^2 - 4x + y^2 - y - x * y
xstar = (3//1, 2//1)          # the minimum: ∇f(3, 2) = 0, Hessian [2 -1; -1 2]
fstar = -7//1
X0 = (51//20, 7//4)           # (2.55, 1.75)
n_points = 7                  # Mathews' plot loop draws points i = 1, ..., 7
xlims_L = (2.5, 3.05)         # Mathews' PlotRange
ylims_L = (1.6, 2.15)
# Mathews' contval2: the cyan contour levels of his plotting programs
contval2 = [-6.6915, -6.7305, -6.7695, -6.8085, -6.8475, -6.868625, -6.88975,
            -6.910875, -6.932, -6.95313, -6.96016, -6.96719, -6.97422, -6.98125,
            -6.98828, -6.99048, -6.99268, -6.99487, -6.99707, -6.9978, -6.9985,
            -6.99927, -6.99982, -6.99995]

# --- Exact line search ---
# phi(g) = f(P + g U) is a parabola a g^2 + b g + c. Its first local minimum
# downhill from g = 0 is the vertex g = -b/(2a) (and g = 0 when b = 0).
function linemin(P, U)
    phi(g) = f(P[1] + g * U[1], P[2] + g * U[2])
    p0, pp, pm = phi(0//1), phi(1//1), phi(-1//1)
    a = (pp + pm - 2p0) / 2
    b = (pp - pm) / 2
    a > 0 || error("phi is not a convex parabola along U = $U")
    return b == 0 ? 0//1 : -b / (2a)
end

# --- The run: one record per line search ---
struct Search
    iter::Int
    k::Int                    # search number within the iteration
    dogleg::Bool              # true for Powell's search along P_n - P_0
    start::NTuple{2,Rational{BigInt}}
    U::NTuple{2,Rational{BigInt}}
    gamma::Rational{BigInt}
    stop::NTuple{2,Rational{BigInt}}
end
addp(P, g, U) = (P[1] + g * U[1], P[2] + g * U[2])

searches = Search[]
X = big.(X0)
U = [(big(1//1), big(0//1)), (big(0//1), big(1//1))]   # columns of U = I
iter = 0
while length(searches) < n_points - 1
    global X, U, iter
    iter += 1
    P0 = X
    P = X
    for k in 1:2
        g = linemin(P, U[k])
        Pn = addp(P, g, U[k])
        push!(searches, Search(iter, k, false, P, U[k], g, Pn))
        P = Pn
    end
    if method == :powell
        U = [U[2], (P[1] - P0[1], P[2] - P0[2])]       # U1 = U2, U2 = P2 - P0
        g = linemin(P0, U[2])
        Xn = addp(P0, g, U[2])
        push!(searches, Search(iter, 3, true, P0, U[2], g, Xn))
        X = Xn
    else
        X = P
    end
end
searches = searches[1:n_points-1]
points = [big.(X0)]
append!(points, [s.stop for s in searches])

# Names of the points, as on the page
function pname(s::Search)
    if s.dogleg
        return "X$(sub(s.iter))"
    elseif method == :taxicab && s.k == 2
        return "X$(sub(s.iter)) = P₂"
    else
        return "P$(sub(s.k))"
    end
end
sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))
const SUPS = collect("⁰¹²³⁴⁵⁶⁷⁸⁹")
sup(n) = (n < 0 ? "⁻" : "") * join(SUPS[d+1] for d in reverse(digits(abs(n))))

# Log of each run, for the build ledger
for s in searches
    println("iter $(s.iter) search $(s.k)$(s.dogleg ? " (dog-leg)" : "")  γ = $(s.gamma) ≈ ",
            Float64(s.gamma), "  point = (", fmtc(s.stop[1]), ", ", fmtc(s.stop[2]),
            ")  f + 7 = ", fmt(f(s.stop...) - fstar))
end

# --- Backdrop for the left panel (Mathews' view) ---
xg = range(xlims_L..., length=300)
yg = range(ylims_L..., length=300)
FL = [f(x, y) for y in yg, x in xg]
fl(P) = Float64(f(P...))

# Offsets from the minimum, and f - f* in those offsets (no cancellation)
g_rel(u, v) = u^2 + v^2 - u * v          # f(3 + u, 2 + v) + 7
off(P) = (Float64(P[1] - xstar[1]), Float64(P[2] - xstar[2]))

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
    # j = 0: the start; j >= 1: line search j has just been made
    s = j >= 1 ? searches[j] : nothing

    # ---------- Left panel: Mathews' window ----------
    pL = plot(xlims=xlims_L, ylims=ylims_L, aspect_ratio=:equal, framestyle=:box,
              xlabel="x", ylabel="y", legend=:topleft, legendfontsize=7,
              titlefontsize=10, grid=false)
    contour!(pL, xg, yg, FL; levels=contval2, color=:cyan, lw=0.8, colorbar=false,
             label="")
    lev = sort(unique([fl(P) for P in points[1:j+1] if f(P...) != fstar]))
    if !isempty(lev)
        contour!(pL, xg, yg, FL; levels=lev, color=:blue, lw=1.2, colorbar=false, label="")
    end
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
            lab = method == :powell ? "search along U₁, U₂" : "search along E₁, E₂"
            shown_sweep = true
        end
        plot!(pL, Float64.([si.start[1], si.stop[1]]), Float64.([si.start[2], si.stop[2]]);
              color=seg_color(si), lw=(i == j ? 2.5 : 1.5), label=lab)
    end
    scatter!(pL, [Float64(P[1]) for P in points[1:j+1]], [Float64(P[2]) for P in points[1:j+1]];
             color=:red, ms=4, msw=0, label="points")
    if s === nothing
        title!(pL, "Start\nX₀ = (2.55, 1.75)")
    else
        Ustr = "(" * fmtd(s.U[1]) * ", " * fmtd(s.U[2]) * ")"
        what = s.dogleg ? "dog-leg search\nalong U₂ = P₂ − P₀ = $Ustr" :
               "search $(s.k)\nalong $(method == :powell ? "U" : "E")$(sub(s.k)) = $Ustr"
        title!(pL, "Iteration $(s.iter), $what")
    end

    # ---------- Right panel: zoom on the current line search ----------
    A = j == 0 ? off(points[1]) : off(s.start)
    B = j == 0 ? (0.0, 0.0) : off(s.stop)
    # square window around the start, the new point and the minimum (0, 0)
    bx = extrema((A[1], B[1], 0.0))
    by = extrema((A[2], B[2], 0.0))
    c = ((bx[1] + bx[2]) / 2, (by[1] + by[2]) / 2)
    h = 0.6 * max(bx[2] - bx[1], by[2] - by[1])
    e = floor(Int, log10(h))
    sc = 10.0^(-e)
    xl = ((c[1] - h) * sc, (c[1] + h) * sc)
    yl = ((c[2] - h) * sc, (c[2] + h) * sc)
    ug = range(c[1] - h, c[1] + h, length=300)
    vg = range(c[2] - h, c[2] + h, length=300)
    G = [log10(max(g_rel(u, v), 1e-300)) for v in vg, u in ug]
    # cyan levels at evenly spaced quantiles of log10(f + 7) over the window
    Gs = sort(vec(G))
    levR = unique([Gs[round(Int, q * length(Gs))] for q in 0.06:0.06:0.96])
    scl(e) = e == 0 ? "" : " × 10" * sup(-e)
    pR = plot(xlims=xl, ylims=yl, aspect_ratio=:equal, framestyle=:box,
              xlabel="(x − 3)" * scl(e), ylabel="(y − 2)" * scl(e),
              legend=:topleft, legendfontsize=7, titlefontsize=10, grid=false)
    contour!(pR, ug .* sc, vg .* sc, G; levels=levR,
             color=:cyan, lw=0.8, colorbar=false, label="")
    if s !== nothing
        lx, ly = line_in_box(A, Float64.(s.U), (c[1] - h, c[1] + h), (c[2] - h, c[2] + h))
        plot!(pR, lx .* sc, ly .* sc; color=:gray40, ls=:dash, lw=1, label="")
        for i in 1:j
            si = searches[i]
            a, b = off(si.start), off(si.stop)
            plot!(pR, [a[1], b[1]] .* sc, [a[2], b[2]] .* sc; color=seg_color(si),
                  lw=(i == j ? 2.5 : 1.5), label="")
        end
        gB = g_rel(B...)
        if f(s.stop...) != fstar
            contour!(pR, ug .* sc, vg .* sc, G; levels=[log10(gB)], color=:blue, lw=1.2,
                     colorbar=false, label="")
        end
        # earlier points that fall in the zoom window
        prev = [off(P) for P in points[1:j]]
        scatter!(pR, [p[1] * sc for p in prev], [p[2] * sc for p in prev]; color=:red,
                 ms=3, msw=0, label="")
        scatter!(pR, [A[1] * sc], [A[2] * sc]; color=:white, msc=:red, ms=6, msw=1.5,
                 label="start of search")
    end
    scatter!(pR, [0.0], [0.0]; color=:green, marker=:xcross, ms=7, msw=2,
             label="minimum (3, 2)")
    if s === nothing
        scatter!(pR, [A[1] * sc], [A[2] * sc]; color=:red, ms=6, msw=0, label="X₀")
    else
        scatter!(pR, [B[1] * sc], [B[2] * sc]; color=:red, ms=6, msw=0, label="new point")
    end
    if s === nothing
        title!(pR, "Zoom on X₀ and the minimum\nf(X₀) + 7 = $(fmt(f(X0...) - fstar))")
    else
        P = s.stop
        title!(pR, "γ = $(fmtq(s.gamma))\n" *
                   "$(pname(s)) = ($(fmtc(P[1])), $(fmtc(P[2]))),  f + 7 = $(fmt(f(P...) - fstar))")
    end

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
