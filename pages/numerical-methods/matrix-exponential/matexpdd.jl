# matexpdd.jl
# Matrix Exponential animation: Mathews' Example 5, X' = A X with
#   A = [1 -4 4; 1 -6 4; -1 -1 -1],  eigenvalues -1, -2, -3,
#   eigenvectors v3 = (-2, 2, 3) or (2, -2, -3) for -1, (0, 1, 1) for -2, (1, 3, 2) for -3.
# Left: Mathews' graph, traced in time. The eight solutions X(t) = e^{At} X0 from the
# corners X0 = (±1, ±1, ±1) of the cube (brown dots), for 0 <= t <= 5, in his colours
# and from his view point (2, -4, 1). The dashed line is the eigenvector line through
# (2, -2, -3); the slowest part of X(t) is e^{-t}(x0 - y0 + z0)(2, -2, -3), so every
# solution enters the origin tangent to it. The title gives the largest angle between
# X(t) and that line over the eight solutions.
# Right: the same solutions with the slowest decay removed, e^{t} X(t). It tends to
# (x0 - y0 + z0)(2, -2, -3), which is ±(2, -2, -3) or ±(6, -6, -9) for the corners
# (black circles), because the other parts decay like e^{-t} and e^{-2t}. The title
# gives the largest distance from e^{t} X(t) to its limit over the eight solutions.
# One frame every 0.05 in t (Mathews' sampling step); curves drawn at steps of 0.005
# from the boxed e^{At} on the page, which is checked against the library exp(A t).
# Produces: matexpdd.gif

using Plots
using Printf
using LinearAlgebra
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))        # exact values
fmtv(x) = um(@sprintf("%#.4g", Float64(x)))                      # computed: 4 s.f.

# --- Parameters (Mathews' Example 5) ---
gif_name = "matexpdd.gif"
A = [1.0 -4.0 4.0; 1.0 -6.0 4.0; -1.0 -1.0 -1.0]
function expAt(t)                                   # the boxed e^{At} on the page
    a, b, c = exp(-t), exp(-2t), exp(-3t)
    [2a-c           -2a+2c          2a-2c;
     -2a+5b-3c      2a-7b+6c        -2a+8b-6c;
     -3a+5b-2c      3a-7b+4c        -3a+8b-4c]
end
v3   = [2.0, -2.0, -3.0]
ics  = [[1, 1, 1], [1, 1, -1], [1, -1, 1], [1, -1, -1],
        [-1, 1, 1], [-1, 1, -1], [-1, -1, 1], [-1, -1, -1]]    # Mathews' order
cols = [:orange, :blue, :green, :red, :red, :cyan, :blue, :magenta]  # his gcolor
tmax = 5.0
nfr  = 100                                          # frames at t = k/20, k = 0..100
cam  = (26.565, 12.604)     # ViewPoint (2,-4,1): azimuth atan(2/4), elevation atan(1/sqrt 20)
limL = ((-2.6, 2.6), (-1.05, 1.05), (-1.2, 1.2))
limR = ((-6.5, 6.5), (-6.5, 6.5), (-9.5, 9.5))
title_str = "Matrix exponential, Mathews' Example 5:  A = [1 −4 4; 1 −6 4; −1 −1 −1],  " *
            "eigenvalues −1, −2, −3"

for t in 0:0.01:tmax
    @assert norm(expAt(t) - exp(A * t)) <= 1e-13 * norm(exp(A * t))   # rounding only
end
cs = [x0[1] - x0[2] + x0[3] for x0 in ics]         # x0 - y0 + z0
@assert sort(unique(cs)) == [-3, -1, 1, 3]
lim = [c .* v3 for c in cs]                         # limits of e^t X(t)

ss = range(0, tmax, length=round(Int, tmax / 0.005) + 1)
X  = [[expAt(s) * x0 for s in ss] for x0 in ics]
Y  = [[exp(s) .* p for (s, p) in zip(ss, c)] for c in X]
inside(c, L) = all(L[i][1] <= p[i] <= L[i][2] for p in c for i in 1:3)
@assert all(inside(c, limL) for c in X) && all(inside(c, limR) for c in Y)

cx(c) = getindex.(c, 1); cy(c) = getindex.(c, 2); cz(c) = getindex.(c, 3)
angle_to_line(p) = acosd(min(1.0, abs(dot(p, v3)) / (norm(p) * norm(v3))))

function panel(L, xl, yl, zl, xt, yt, zt)
    plot(xlims=L[1], ylims=L[2], zlims=L[3], camera=cam, legend=false,
         xlabel=xl, ylabel=yl, zlabel=zl, xticks=xt, yticks=yt, zticks=zt,
         titlefontsize=11, grid=true, framestyle=:box)
end

function draw_frame(k)
    t = k / 20
    n = searchsortedlast(ss, t + 1e-12)
    Xt = [expAt(t) * x0 for x0 in ics]
    pL = panel(limL, "x", "y", "z", -2:1:2, -1:0.5:1, -1.5:0.5:1.5)
    plot3d!(pL, [-0.4, 0.4] .* v3[1], [-0.4, 0.4] .* v3[2], [-0.4, 0.4] .* v3[3];
            color=:black, ls=:dash, lw=1.2)
    for (j, c) in enumerate(X)
        plot3d!(pL, cx(c[1:n]), cy(c[1:n]), cz(c[1:n]); color=cols[j], lw=1.5)
    end
    scatter3d!(pL, getindex.(ics, 1), getindex.(ics, 2), getindex.(ics, 3);
               color=:sienna, ms=3.5, msw=0)
    scatter3d!(pL, cx(Xt), cy(Xt), cz(Xt); color=cols, ms=4.5, msc=:black, msw=0.5)
    ang = maximum(angle_to_line.(Xt))
    TL = "t = $(fmt(t)):  X(t) = eᴬᵗX₀,  largest angle to the line = $(fmtv(ang))°"
    title!(pL, TL)

    Yt = [exp(t) .* p for p in Xt]
    pR = panel(limR, "eᵗx", "eᵗy", "eᵗz", -6:3:6, -6:3:6, -9:3:9)
    plot3d!(pR, [-3.1, 3.1] .* v3[1], [-3.1, 3.1] .* v3[2], [-3.1, 3.1] .* v3[3];
            color=:black, ls=:dash, lw=1.2)
    scatter3d!(pR, cx(lim), cy(lim), cz(lim); color=:white, ms=7, msc=:black, msw=1.5)
    for (j, c) in enumerate(Y)
        plot3d!(pR, cx(c[1:n]), cy(c[1:n]), cz(c[1:n]); color=cols[j], lw=1.5)
    end
    scatter3d!(pR, getindex.(ics, 1), getindex.(ics, 2), getindex.(ics, 3);
               color=:sienna, ms=3.5, msw=0)
    scatter3d!(pR, cx(Yt), cy(Yt), cz(Yt); color=cols, ms=4.5, msc=:black, msw=0.5)
    dist = maximum(norm(y - l) for (y, l) in zip(Yt, lim))
    TR = "eᵗX(t) → (x₀ − y₀ + z₀)(2, −2, −3):  largest distance = $(fmtv(dist))"
    title!(pR, TR)
    println("TITLE: ", TL)
    println("TITLE: ", TR)

    plot(pL, pR; layout=(1, 2), size=(1300, 660), plot_title=title_str,
         plot_titlefontsize=12, background_color=:white)
end

anim = Animation()
for k in 0:nfr
    draw_frame(k)
    frame(anim)
end
for _ in 1:8                                          # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=10)
println("Saved: ", gif_name)
