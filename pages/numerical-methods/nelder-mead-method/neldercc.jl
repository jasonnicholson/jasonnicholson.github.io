# neldercc.jl
# Nelder-Mead Method animation: Mathews' Exercise 3, three searches on
# f(x, y) = 5x^2 + x^4 - 9x^2 y + 3y^2 + 2y^4 + x/4, which has three local
# minima. Mathews runs his more efficient subroutine with eps = 1e-5 (stop when
# f(W) <= f(B) + eps) from three small triangles:
#   (i)   (0, -0.2), (0.1, 0.1), (-0.1, 0.1)      near (0, 0)
#   (ii)  (1.9, 1.5), (2.0, 1.4), (2.0, 1.6)      near (2, 1.5)
#   (iii) (-1.9, 1.5), (-2.0, 1.4), (-2.0, 1.6)   near (-2, 1.5)
# Mathews has no animation of this exercise; this one is new. The three
# searches advance together, one step per frame, and a search that has met
# its stopping test stays where it stopped. The top panel shows Mathews'
# contour window [-3, 3] x [-0.5, 2] with the three local minima and the two
# saddle points; the bottom panels zoom on each search.
# The runs are computed in exact rational arithmetic with Mathews' subroutine
# rule (accept the first of E, R, C1, C2 whose value is below f(W), else
# shrink toward B). Vertices with equal values are ordered by smaller x, then
# smaller y, as on the page. The stationary points are found by Newton's
# method in 256-bit arithmetic from rough starting points.
# Produces: neldercc.gif

using Plots
using Printf
using LinearAlgebra
gr()

const Q = Rational{BigInt}

# Significant-figure labels ("−" for minus). The runs are exact, so every
# digit printed is correct as rounded.
um(s) = replace(s, "-" => "−")
const SUPS = collect("⁰¹²³⁴⁵⁶⁷⁸⁹")
sup(n) = (n < 0 ? "⁻" : "") * join(SUPS[d+1] for d in reverse(digits(abs(n))))
function fmtn(x, d)
    x == 0 && return "0"
    s = @sprintf("%.*g", d, Float64(x))
    m = match(r"^(-?[0-9.]+)e([+-][0-9]+)$", s)
    m === nothing && return um(s)
    return um(m[1]) * "×10" * sup(parse(Int, m[2]))
end
fmt(x) = fmtn(x, 4)
fmtc(x) = fmtn(x, 7)
pt(P) = "(" * fmtc(P[1]) * ", " * fmtc(P[2]) * ")"

# --- Parameters ---
gif_name = "neldercc.gif"
title_str = "Nelder-Mead (Mathews' Exercise 3):  f(x, y) = 5x² + x⁴ − 9x²y + 3y² + 2y⁴ + x/4,  ε = 10⁻⁵"
f(x, y) = 5x^2 + x^4 - 9x^2 * y + 3y^2 + 2y^4 + x / 4
eps = Q(1, 100000)
cases = [("(i)", [(Q(0), Q(-1, 5)), (Q(1, 10), Q(1, 10)), (Q(-1, 10), Q(1, 10))]),
         ("(ii)", [(Q(19, 10), Q(3, 2)), (Q(2), Q(7, 5)), (Q(2), Q(8, 5))]),
         ("(iii)", [(Q(-19, 10), Q(3, 2)), (Q(-2), Q(7, 5)), (Q(-2), Q(8, 5))])]
case_col = [:purple, :darkorange, :teal]
xlims_T, ylims_T = (-3.0, 3.0), (-0.5, 2.0)      # Mathews' contour window
levels_T = [-1.8, -1.6, -1.3, -1.0, -0.6, -0.3, 0.0, 0.3, 0.7, 1.0, 1.4, 1.8,
            2.5, 3.5, 5.0, 7.0, 10.0, 15.0, 22.0, 32.0, 45.0]
fps, hold = 2, 4

# --- Stationary points: Newton's method on the gradient, 256-bit ---
setprecision(BigFloat, 256)
grad(x, y) = [10x + 4x^3 - 18x * y + one(x) / 4, -9x^2 + 6y + 8y^3]
hess(x, y) = [10 + 12x^2 - 18y  -18x; -18x  6 + 24y^2]
function newton(x, y)
    z = BigFloat[x, y]
    for _ in 1:60
        z -= hess(z...) \ grad(z...)
    end
    norm(grad(z...)) < 1e-60 || error("Newton did not converge from ($x, $y)")
    return z
end
minima = [newton(0.0, 0.0), newton(2.15, 1.59), newton(-2.18, 1.61)]
saddles = [newton(-0.9, 0.72), newton(0.97, 0.78)]
for (nm, Z) in (("minimum", minima), ("saddle", saddles))
    for z in Z
        ev = eigvals(Float64.(hess(z...)))
        println(nm, " (", @sprintf("%.6f, %.6f", z...), ")  f = ", @sprintf("%.6f", f(z...)),
                "  Hessian eigenvalues ", ev)
    end
end

# --- Mathews' subroutine, exact ---
fP(P) = f(P[1], P[2])
mid(P, R) = ((P[1] + R[1]) / 2, (P[2] + R[2]) / 2)
sortv(V) = sort(V; by=P -> (fP(P), P[1], P[2]))
function improve(B, G, W)
    M = mid(B, G)
    R = (M[1] + (M[1] - W[1]), M[2] + (M[2] - W[2]))
    E = (R[1] + (R[1] - M[1]), R[2] + (R[2] - M[2]))
    fW = fP(W)
    for (P, mv) in ((E, "expand"), (R, "reflect"), (mid(M, W), "contract to C₁"),
                    (mid(M, R), "contract to C₂"))
        fP(P) < fW && return sortv([B, G, P]), mv
    end
    return sortv([B, mid(B, G), mid(B, W)]), "shrink"
end
function run(V0)
    tri = [sortv(V0)]; moves = ["start"]
    k = 1
    # Mathews: While[Or[And[Fw > Fb + eps, k < 100], k < 2], Improve; k++]
    while (fP(tri[end][3]) > fP(tri[end][1]) + eps && k < 100) || k < 2
        T, mv = improve(tri[end]...)
        push!(tri, T); push!(moves, mv)
        k += 1
    end
    return tri, moves
end
runs = [run(V) for (_, V) in cases]
nmax = maximum(length(r[1]) - 1 for r in runs)

for (c, (tri, moves)) in zip(cases, runs)
    B, G, W = tri[end]
    println(c[1], ": ", length(tri) - 1, " steps, B = ", pt(B), ", f(B) = ",
            fmtn(fP(B), 11), ", f(W) − f(B) = ", fmt(fP(W) - fP(B)))
    for (k, T) in enumerate(tri)
        println("  ", k - 1, " ", moves[k], "  ", join(["$(pt(P)) $(fmtc(fP(P)))" for P in T], "  "))
    end
end

# --- Drawing ---
F(x, y) = Float64(f(x, y))
tx(T) = [Float64(P[1]) for P in [T; T[1:1]]]
ty(T) = [Float64(P[2]) for P in [T; T[1:1]]]
xg = range(xlims_T..., length=400)
yg = range(ylims_T..., length=200)
FT = [F(x, y) for y in yg, x in xg]

function top_panel(k)
    p = plot(xlims=xlims_T, ylims=ylims_T, aspect_ratio=:equal, framestyle=:box,
             xlabel="x", ylabel="y", legend=:outerright, legendfontsize=8,
             titlefontsize=10, grid=false)
    contour!(p, xg, yg, FT; levels=levels_T, color=:gray70, lw=0.7, colorbar=false)
    for (i, (tri, _)) in enumerate(runs)
        kk = min(k, length(tri) - 1)
        T = tri[kk+1]
        plot!(p, Shape(tx(T)[1:3], ty(T)[1:3]); color=:cyan, lc=case_col[i], lw=1.5,
              label="")
        for j in 0:kk
            plot!(p, tx(tri[j+1]), ty(tri[j+1]); color=case_col[i], lw=(j == kk ? 1.5 : 0.6),
                  label=(j == 0 ? "search $(cases[i][1])" : ""))
        end
    end
    scatter!(p, [Float64(z[1]) for z in minima], [Float64(z[2]) for z in minima];
             color=:green, marker=:xcross, ms=7, msw=2, label="local minima")
    scatter!(p, [Float64(z[1]) for z in saddles], [Float64(z[2]) for z in saddles];
             color=:black, marker=:diamond, ms=5, msw=0, label="saddle points")
    title!(p, k == 0 ? "Starting triangles" : "Step $k")
    return p
end

function zoom_panel(i, k)
    tri, moves = runs[i]
    n = length(tri) - 1
    kk = min(k, n)
    T = tri[kk+1]
    zmin = Float64.(minima[i])
    # square window around the current triangle and the local minimum, padded
    pts = [Float64.(collect(P)) for P in T]
    push!(pts, zmin)
    xs = [q[1] for q in pts]; ys = [q[2] for q in pts]
    c = ((minimum(xs) + maximum(xs)) / 2, (minimum(ys) + maximum(ys)) / 2)
    h = 0.62 * max(maximum(xs) - minimum(xs), maximum(ys) - minimum(ys))
    xl, yl = (c[1] - h, c[1] + h), (c[2] - h, c[2] + h)
    p = plot(xlims=xl, ylims=yl, aspect_ratio=:equal, framestyle=:box,
             xlabel="x", ylabel="y", legend=false, titlefontsize=9, grid=false,
             tickfontsize=7, xrotation=30)
    ug = range(xl..., length=150); vg = range(yl..., length=150)
    G = [F(x, y) for y in vg, x in ug]
    Gs = sort(vec(G))
    lev = unique([Gs[round(Int, q * length(Gs))] for q in 0.1:0.1:0.9])
    contour!(p, ug, vg, G; levels=lev, color=:gray75, lw=0.7, colorbar=false)
    for j in 0:kk-1
        plot!(p, tx(tri[j+1]), ty(tri[j+1]); color=case_col[i], lw=0.8)
    end
    plot!(p, Shape(tx(T)[1:3], ty(T)[1:3]); color=:cyan, lc=case_col[i], lw=1.8)
    vs = unique(vcat(tri[1:kk+1]...))
    vs = [P for P in vs if xl[1] < P[1] < xl[2] && yl[1] < P[2] < yl[2]]
    scatter!(p, [Float64(P[1]) for P in vs], [Float64(P[2]) for P in vs]; color=:red,
             ms=3, msw=0)
    scatter!(p, [zmin[1]], [zmin[2]]; color=:green, marker=:xcross, ms=7, msw=2)
    B, G3, W = T
    if k == 0
        head = "Search $(cases[i][1]): start"
    elseif k < n
        head = "Search $(cases[i][1]), step $k: $(moves[k+1])"
    elseif k == n
        head = "Search $(cases[i][1]), step $k: $(moves[k+1]), stops"
    else
        head = "Search $(cases[i][1]): stopped after $n steps"
    end
    title!(p, head * "\nB = $(pt(B))\nf(B) = $(fmtn(fP(B), 8))\nf(W) − f(B) = $(fmt(fP(W) - fP(B)))")
    return p
end

l = @layout [a{0.52h}; [b c d]]
function draw_frame(k)
    plot(top_panel(k), zoom_panel(1, k), zoom_panel(2, k), zoom_panel(3, k);
         layout=l, size=(1150, 930), plot_title=title_str, plot_titlefontsize=12,
         left_margin=3Plots.mm, right_margin=3Plots.mm, bottom_margin=3Plots.mm, background_color=:white)
end

anim = Animation()
for k in 0:nmax
    draw_frame(k)
    frame(anim)
end
for _ in 1:hold                     # hold the last frame
    frame(anim)
end

gif(anim, joinpath(@__DIR__, gif_name); fps=fps)
println("Saved: ", gif_name)
