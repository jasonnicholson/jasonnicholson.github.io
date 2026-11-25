# nelderaa.jl
# Nelder-Mead Method animation: Mathews' Example 4, the triangles of his
# subroutine Nelder2D on f(x, y) = x^2 - 4x + y^2 - y - xy from the triangle
# (0, 0), (1.2, 0), (0, 0.8), 15 steps, one step per frame.
# Mathews' graphics program (module Example 4) draws 16 pictures in the window
# [0, 5] x [0, 3]: every triangle so far outlined in blue, the current triangle
# filled cyan and every vertex as a red dot. The left panel keeps that picture
# and adds grey contours of f and the minimum (3, 2). The right panel is new:
# it shows the step just taken, with the triangle before the step (dashed), the
# line from W through M, the test points the subroutine evaluated, in its order
# E, R, C1, C2, and the new triangle.
# The run is computed in exact rational arithmetic with Mathews' subroutine
# rule (accept the first of E, R, C1, C2 whose value is below f(W), else
# shrink toward B). Vertices with equal values are ordered by smaller x, then
# smaller y, as on the page. At step 6 f(R) = f(W) exactly, so the exact run
# contracts where Mathews' floating-point run reflected (see the page).
# The same code as nelderbb.jl, with case = :example4.
# Produces: nelderaa.gif

using Plots
using Printf
gr()

const Q = Rational{BigInt}

# Significant-figure labels ("−" for minus). The run is exact, so a zero is an
# exact zero and every digit printed is correct as rounded.
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
fmt(x) = fmtn(x, 4)                         # values in the text-like labels
fmtc(x) = fmtn(x, 7)                        # coordinates
pt(P) = "(" * fmtc(P[1]) * ", " * fmtc(P[2]) * ")"
# --- Parameters ---
case = :example4                  # :example4 (nelderaa) or :rosenbrock (nelderbb)
if case == :example4
    gif_name = "nelderaa.gif"
    title_str = "Nelder-Mead (Mathews' Example 4):  f(x, y) = x² − 4x + y² − y − xy"
    f(x, y) = x^2 - 4x + y^2 - y - x * y
    xstar, fstar = (3.0, 2.0), -7.0          # ∇f(3, 2) = 0, f(3, 2) = −7
    xstar_lab = "minimum (3, 2)"
    V0 = [(Q(0), Q(0)), (Q(6, 5), Q(0)), (Q(0), Q(4, 5))]
    nsteps, eps = 15, nothing                # Nelder2D[V, 15]: fixed step count
    # Mathews' PlotRange [0, 5] x [0, 3], padded by 0.1 so that the vertices
    # on its edges show whole
    xlims_L, ylims_L = (-0.1, 5.1), (-0.1, 3.1)
    levels_L = fstar .+ [0.1, 0.3, 0.6, 1.0, 1.5, 2.5, 4.0, 6.0, 8.5, 11.5, 15.0]
    valley = false
    legpos = :topleft
    sticky = false                           # a new right-panel window every step
    figsize = (1150, 680)
    fps, hold = 1, 3
else
    gif_name = "nelderbb.gif"
    title_str = "Nelder-Mead on Rosenbrock's valley (Example 2):  f(x, y) = 100(y − x²)² + (1 − x)²"
    f(x, y) = 100 * (y - x^2)^2 + (1 - x)^2
    xstar, fstar = (1.0, 1.0), 0.0           # sum of squares, zero only at (1, 1)
    xstar_lab = "minimum (1, 1)"
    V0 = [(Q(-6, 5), Q(1)), (Q(-1), Q(1)), (Q(-6, 5), Q(6, 5))]
    nsteps, eps = nothing, Q(1, 100000)      # more efficient subroutine, ε = 10⁻⁵
    xlims_L, ylims_L = (-1.5, 1.5), (-0.5, 1.5)
    levels_L = [0.05, 0.2, 0.5, 1, 2, 4, 8, 16, 32, 64, 128, 256, 512]
    valley = true
    legpos = :top
    sticky = true                            # keep the right-panel window while it fits
    figsize = (960, 600)
    fps, hold = 3, 6
end

# --- Mathews' subroutine, one step, exact ---
fP(P) = f(P[1], P[2])
mid(P, R) = ((P[1] + R[1]) / 2, (P[2] + R[2]) / 2)
sortv(V) = sort(V; by=P -> (fP(P), P[1], P[2]))

struct Step
    old::Vector{NTuple{2,Q}}                     # B, G, W before the step
    M::NTuple{2,Q}
    tested::Vector{Tuple{String,NTuple{2,Q},Q}}  # name, point, f, in test order
    move::String
    new::Vector{NTuple{2,Q}}                     # B, G, W after the step
end

function improve(B, G, W)
    M = mid(B, G)
    R = (M[1] + (M[1] - W[1]), M[2] + (M[2] - W[2]))
    E = (R[1] + (R[1] - M[1]), R[2] + (R[2] - M[2]))
    C1, C2 = mid(M, W), mid(M, R)
    fW = fP(W)
    tested = Tuple{String,NTuple{2,Q},Q}[]
    for (name, P, mv) in (("E", E, "expand"), ("R", R, "reflect"),
                          ("C₁", C1, "contract to C₁"), ("C₂", C2, "contract to C₂"))
        push!(tested, (name, P, fP(P)))
        if fP(P) < fW
            return Step([B, G, W], M, tested, mv, sortv([B, G, P]))
        end
    end
    return Step([B, G, W], M, tested, "shrink", sortv([B, mid(B, G), mid(B, W)]))
end

# --- The run ---
tri = [sortv(V0)]
steps = Step[]
let k = 1
    while true
        B, G, W = tri[end]
        if eps === nothing
            k > nsteps && break
        else
            # Mathews: While[Or[And[Fw > Fb + eps, k < 100], k < 2], Improve; k++]
            ((fP(W) > fP(B) + eps && k < 100) || k < 2) || break
        end
        s = improve(B, G, W)
        push!(steps, s)
        push!(tri, s.new)
        k += 1
    end
end
nst = length(steps)

# Log of the run, for the build ledger
println("k  move  B  f(B)  G  f(G)  W  f(W)")
for (k, T) in enumerate(tri)
    mv = k == 1 ? "start" : steps[k-1].move
    println(k - 1, "  ", mv, "  ", join(["$(pt(P)) $(fmtc(fP(P)))" for P in T], "  "))
end
for (k, s) in enumerate(steps)
    println("step $k: f(W) = ", fmtc(fP(s.old[3])), "  ",
            join(["$(n) $(pt(P)) $(fmtc(v))" for (n, P, v) in s.tested], "; "))
end

# --- Drawing helpers ---
F(x, y) = Float64(f(x, y))
fl(P) = (Float64(P[1]), Float64(P[2]))
tx(T) = [Float64(P[1]) for P in [T; T[1:1]]]
ty(T) = [Float64(P[2]) for P in [T; T[1:1]]]

xg = range(xlims_L..., length=300)
yg = range(ylims_L..., length=300)
FL = [F(x, y) for y in yg, x in xg]

function left_panel(k)
    p = plot(xlims=xlims_L, ylims=ylims_L, aspect_ratio=:equal, framestyle=:box,
             xlabel="x", ylabel="y", legend=legpos, legendfontsize=7,
             titlefontsize=10, grid=false)
    contour!(p, xg, yg, FL; levels=levels_L, color=:gray70, lw=0.7, colorbar=false)
    if valley
        xv = range(xlims_L..., length=200)
        plot!(p, xv, xv .^ 2; color=:gray40, ls=:dot, lw=1.2, label="valley floor y = x²")
    end
    T = tri[k+1]
    plot!(p, Shape(tx(T)[1:3], ty(T)[1:3]); color=:cyan, lc=:blue, lw=1.5,
          label="current triangle")
    for j in 0:k
        plot!(p, tx(tri[j+1]), ty(tri[j+1]); color=:blue, lw=0.8,
              label=(j == 0 ? "triangles so far" : ""))
    end
    vs = unique(vcat(tri[1:k+1]...))
    scatter!(p, [Float64(P[1]) for P in vs], [Float64(P[2]) for P in vs]; color=:red,
             ms=3, msw=0, label="vertices")
    scatter!(p, [xstar[1]], [xstar[2]]; color=:green, marker=:xcross, ms=7, msw=2,
             label=xstar_lab)
    B = T[1]
    head = k == 0 ? "Start" : "Step $k of $nst: $(steps[k].move)"
    title!(p, head * "\nB = $(pt(B)),  f(B) = $(fmtc(fP(B)))")
    return p
end

# Right-panel windows, squares of half-width h about a centre c.
# sticky = false: a new window every step, around the triangles before and
#   after the step, M and every test point, padded.
# sticky = true: a window around the triangles before and after the step
#   (h = 1.5 x their extent) is kept from one frame to the next while those
#   triangles lie inside its middle 90% and fill at least 20% of its width, so
#   the view jumps only now and then. A rejected test point outside the window
#   is not drawn.
function extent(pts)
    xs = [Float64(P[1]) for P in pts]; ys = [Float64(P[2]) for P in pts]
    c = ((minimum(xs) + maximum(xs)) / 2, (minimum(ys) + maximum(ys)) / 2)
    return c, max(maximum(xs) - minimum(xs), maximum(ys) - minimum(ys))
end
tri_points(k) = k == 0 ? tri[1] : vcat(steps[k].old, steps[k].new)
step_points(k) = k == 0 ? tri[1] :
    vcat(tri_points(k), [steps[k].M], [P for (_, P, _) in steps[k].tested])
windows = Tuple{NTuple{2,Float64},Float64}[]
for k in 0:nst
    if !sticky
        c, span = extent(step_points(k))
        push!(windows, (c, 0.58 * span))
        continue
    end
    c, span = extent(tri_points(k))
    if !isempty(windows)
        c0, h0 = windows[end]
        inside = all(abs(Float64(P[1]) - c0[1]) <= 0.9h0 && abs(Float64(P[2]) - c0[2]) <= 0.9h0
                     for P in tri_points(k))
        if inside && span >= 0.2 * 2h0
            push!(windows, (c0, h0))
            continue
        end
    end
    push!(windows, (c, 1.5 * span))
end

function right_panel(k)
    T = k == 0 ? tri[1] : steps[k].new
    c, h = windows[k+1]
    xl, yl = (c[1] - h, c[1] + h), (c[2] - h, c[2] + h)
    p = plot(xlims=xl, ylims=yl, aspect_ratio=:equal, framestyle=:box,
             xlabel="x", ylabel="y", legend=:outerbottom, legend_columns=2,
             legendfontsize=7, titlefontsize=9, grid=false,
             top_margin=3Plots.mm)
    ug = range(xl..., length=200); vg = range(yl..., length=200)
    G = [F(x, y) for y in vg, x in ug]
    Gs = sort(vec(G))
    lev = unique([Gs[round(Int, q * length(Gs))] for q in 0.1:0.1:0.9])
    contour!(p, ug, vg, G; levels=lev, color=:gray75, lw=0.7, colorbar=false)
    if valley
        xv = range(xl..., length=200)
        plot!(p, xv, xv .^ 2; color=:gray40, ls=:dot, lw=1.2, label="")
    end
    if xl[1] < xstar[1] < xl[2] && yl[1] < xstar[2] < yl[2]
        scatter!(p, [xstar[1]], [xstar[2]]; color=:green, marker=:xcross, ms=7, msw=2,
                 label=xstar_lab)
    end
    off = 0.025 * 2h
    # labels only for points inside the window (annotations are not clipped)
    inwin(P) = xl[1] < P[1] < xl[2] && yl[1] < P[2] < yl[2]
    lab!(P, s, col) = inwin(P) && annotate!(p, Float64(P[1]) + off, Float64(P[2]) + off,
                                            text(s, 9, col, :left, :bottom))
    plot!(p, Shape(tx(T)[1:3], ty(T)[1:3]); color=:cyan, lc=:blue, lw=1.8,
          label=(k == 0 ? "starting triangle" : "after the step"))
    if k == 0
        for (n, P) in zip(("B", "G", "W"), T)
            lab!(P, n, :black)
        end
        scatter!(p, [Float64(P[1]) for P in T], [Float64(P[2]) for P in T]; color=:red,
                 ms=5, msw=0, label="vertices")
        ttl = "Starting triangle\n" *
              "f(B) = $(fmtc(fP(T[1]))),  f(G) = $(fmtc(fP(T[2]))),  f(W) = $(fmtc(fP(T[3])))"
    else
        s = steps[k]
        O = s.old
        plot!(p, tx(O), ty(O); color=:blue, ls=:dash, lw=1.2,
              label="before the step (B, G, W)")
        # the line W -> M -> E on which the test points lie
        Wp, Ep = fl(O[3]), fl(s.tested[1][2])
        plot!(p, [Wp[1], Ep[1]], [Wp[2], Ep[2]]; color=:gray35, ls=:dot, lw=1.2,
              label="line W → M")
        for (n, P) in zip(("B", "G", "W"), O)
            lab!(P, n, :blue)
        end
        scatter!(p, [Float64(P[1]) for P in O], [Float64(P[2]) for P in O]; color=:red,
                 ms=5, msw=0, label="")
        scatter!(p, [Float64(s.M[1])], [Float64(s.M[2])]; color=:black, ms=3, msw=0,
                 label="M = (B + G)/2")
        lab!(s.M, "M", :black)
        nt = length(s.tested)
        shown_rej = false
        for (i, (n, P, v)) in enumerate(s.tested)
            ok = (i == nt && s.move != "shrink")
            lb = ok ? "test point accepted" : (shown_rej ? "" : "test point rejected")
            ok || (shown_rej = true)
            scatter!(p, [Float64(P[1])], [Float64(P[2])];
                     color=(ok ? :darkorange : :white), msc=:darkorange,
                     marker=(ok ? :star5 : :circle), ms=(ok ? 9 : 6), msw=1.5, label=lb)
            lab!(P, n, :darkorange)
        end
        if s.move == "shrink"
            scatter!(p, [Float64(P[1]) for P in s.new[2:3]], [Float64(P[2]) for P in s.new[2:3]];
                     color=:darkorange, ms=6, msw=0, label="shrunk vertices")
        end
        # Test results: f(W) printed once, with enough digits that every
        # unequal pair of values prints unequal
        fW = fP(O[3])
        d = 7
        while d < 30 && any(v != fW && fmtn(v, d) == fmtn(fW, d) for (_, _, v) in s.tested)
            d += 1
        end
        parts = String[]
        for (n, P, v) in s.tested
            rel = v < fW ? "<" : v == fW ? "=" : ">"
            push!(parts, "f($n) = $(fmtn(v, d)) $rel f(W)")
        end
        lines = length(parts) <= 2 ? [join(parts, ",  ")] :
                [join(parts[1:2], ",  "), join(parts[3:end], ",  ")]
        lines[end] *= "  →  " * s.move
        ttl = "Step $k: f(W) = $(fmtn(fW, d))\n" * join(lines, "\n")
    end
    title!(p, ttl)
    return p
end

function draw_frame(k)
    plot(left_panel(k), right_panel(k); layout=(1, 2), size=figsize,
         plot_title=title_str, plot_titlefontsize=12, left_margin=4Plots.mm,
         bottom_margin=4Plots.mm, background_color=:white)
end

anim = Animation()
for k in 0:nst
    draw_frame(k)
    frame(anim)
end
for _ in 1:hold                     # hold the last frame
    frame(anim)
end

gif(anim, joinpath(@__DIR__, gif_name); fps=fps)
println("Saved: ", gif_name)
