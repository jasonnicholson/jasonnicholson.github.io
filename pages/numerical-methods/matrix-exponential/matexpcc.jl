# matexpcc.jl
# Matrix Exponential animation: Mathews' Example 4, X' = A X with
#   A = [-1 -2 2; 1 -4 2; -1 -3 1],  eigenvalues -2 and -1 ± 2i.
# Left: Mathews' graph, traced in time. The eight solutions X(t) = e^{At} X0 from the
# corners X0 = (±1, ±1, ±1) of the cube (brown dots), for 0 <= t <= 4, in his colours
# and from his view point (2, -4, 1). They spiral in to the origin. The difference
# x - y = e^{-2t}(x0 - y0) is the distance (times sqrt 2) from the plane x = y, in
# which the solution turns at 2 radians per unit time and decays like e^{-t}.
# Right: the same solutions with the in-plane decay removed, e^{t} X(t), seen edge on
# to the plane x = y (looking along (1, 1, 0)): horizontal coordinate e^{t}(x - y)/sqrt 2,
# the signed distance from that plane, and vertical coordinate e^{t} z. The plane is the
# vertical axis. The distance e^{t}(x - y)/sqrt 2 = e^{-t}(x0 - y0)/sqrt 2 dies out, and
# each solution settles into the plane, where e^{t} X(t) turns round an ellipse with
# period pi (seen edge on, its height e^{t} z oscillates).
# One frame every 0.05 in t (Mathews' sampling step); curves drawn at steps of 0.005
# from the boxed e^{At} on the page, which is checked against the library exp(A t).
# Produces: matexpcc.gif

using Plots
using Printf
using LinearAlgebra
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))        # exact values
fmtv(x) = um(@sprintf("%#.4g", Float64(x)))                      # computed: 4 s.f.

# --- Parameters (Mathews' Example 4) ---
gif_name = "matexpcc.gif"
A = [-1.0 -2.0 2.0; 1.0 -4.0 2.0; -1.0 -3.0 1.0]
function expAt(t)                                   # the boxed e^{At} on the page
    c, s, e1, e2 = cos(2t), sin(2t), exp(-t), exp(-2t)
    [e1*c          -e1*s          e1*s;
     e1*c-e2       e2-e1*s        e1*s;
     e1*(c-s)-e2   e2-e1*(c+s)    e1*(c+s)]
end
ics  = [[1, 1, 1], [1, 1, -1], [1, -1, 1], [1, -1, -1],
        [-1, 1, 1], [-1, 1, -1], [-1, -1, 1], [-1, -1, -1]]    # Mathews' order
cols = [:orange, :blue, :green, :red, :red, :cyan, :blue, :magenta]  # his gcolor
tmax = 4.0
nfr  = 80                                           # frames at t = k/20, k = 0..80
camM = (26.565, 12.604)     # ViewPoint (2,-4,1): azimuth atan(2/4), elevation atan(1/sqrt 20)
limL = ((-1.5, 1.5), (-1.05, 1.05), (-2.0, 2.0))
limR = ((-1.6, 1.6), (-3.8, 3.8))       # (e^t(x - y)/sqrt 2, e^t z)
title_str = "Matrix exponential, Mathews' Example 4:  A = [−1 −2 2; 1 −4 2; −1 −3 1],  " *
            "eigenvalues −2, −1 ± 2i"

for t in 0:0.01:tmax
    @assert norm(expAt(t) - exp(A * t)) <= 1e-14 * norm(exp(A * t))
end

ss = range(0, tmax, length=round(Int, tmax / 0.005) + 1)
X  = [[expAt(s) * x0 for s in ss] for x0 in ics]
Y  = [[exp(s) .* p for (s, p) in zip(ss, c)] for c in X]
inside(c, L) = all(L[i][1] <= p[i] <= L[i][2] for p in c for i in eachindex(L))
edge(p) = [(p[1] - p[2]) / sqrt(2), p[3]]           # edge-on view of the plane x = y
@assert all(inside(c, limL) for c in X) && all(inside(edge.(c), limR) for c in Y)

cx(c) = getindex.(c, 1); cy(c) = getindex.(c, 2); cz(c) = getindex.(c, 3)

function panel(L, cam, xl, yl, zl, xt, yt, zt)
    plot(xlims=L[1], ylims=L[2], zlims=L[3], camera=cam, legend=false,
         xlabel=xl, ylabel=yl, zlabel=zl, xticks=xt, yticks=yt, zticks=zt,
         titlefontsize=11, grid=true, framestyle=:box)
end

function draw_frame(k)
    t = k / 20
    n = searchsortedlast(ss, t + 1e-12)
    pL = panel(limL, camM, "x", "y", "z", -1:0.5:1, -1:0.5:1, -1.5:0.5:1.5)
    for (j, c) in enumerate(X)
        plot3d!(pL, cx(c[1:n]), cy(c[1:n]), cz(c[1:n]); color=cols[j], lw=1.5)
    end
    scatter3d!(pL, getindex.(ics, 1), getindex.(ics, 2), getindex.(ics, 3);
               color=:sienna, ms=3.5, msw=0)
    Xt = [expAt(t) * x0 for x0 in ics]
    scatter3d!(pL, cx(Xt), cy(Xt), cz(Xt); color=cols, ms=4.5, msc=:black, msw=0.5)
    TL = "t = $(fmt(t)):  X(t) = eᴬᵗX₀,  largest |x − y| = 2e⁻²ᵗ = $(fmtv(2exp(-2t)))"
    title!(pL, TL)

    pR = plot(xlims=limR[1], ylims=limR[2], legend=false, framestyle=:box, grid=true,
              xlabel="eᵗ(x − y)/√2  (signed distance from the plane x = y)", ylabel="eᵗz",
              titlefontsize=11, xticks=-1.5:0.5:1.5, yticks=-3:1:3)
    vline!(pR, [0.0]; color=:gray40, ls=:dash, lw=1.5)
    for (j, c) in enumerate(Y)
        e = edge.(c[1:n])
        plot!(pR, first.(e), last.(e); color=cols[j], lw=1.5)
    end
    e0 = edge.(ics)
    scatter!(pR, first.(e0), last.(e0); color=:sienna, ms=3.5, msw=0)
    Yt = [edge(exp(t) .* p) for p in Xt]
    scatter!(pR, first.(Yt), last.(Yt); color=cols, ms=4.5, msc=:black, msw=0.5)
    TR = "eᵗX(t), plane x = y edge on:  largest distance √2e⁻ᵗ = $(fmtv(sqrt(2)*exp(-t)))"
    title!(pR, TR)
    println("TITLE: ", TL)
    println("TITLE: ", TR)

    plot(pL, pR; layout=grid(1, 2, widths=[0.55, 0.45]), size=(1300, 640), plot_title=title_str,
         plot_titlefontsize=12, background_color=:white, bottom_margin=6Plots.mm)
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
