# matexpbb.jl
# Matrix Exponential animation: Mathews' Example 3,
#   x' = -x - 2y,  y' = 2x - y,   A = [-1 -2; 2 -1],
#   e^{At} = e^{-t} [cos 2t  -sin 2t; sin 2t  cos 2t]   (a rotation by 2t times e^{-t}).
# Left: Mathews' graph, traced in time. The sixteen solutions X(t) = e^{At} X0 from his
# starting points X0 = 2(cos(k pi/8), sin(k pi/8)), k = 0..15 (brown dots), drawn for
# 0 <= t <= 3.5 in his window [-2, 2]^2 with his colours (red, blue, magenta, green,
# repeated). The dashed circle has radius |X(t)| = 2e^{-t}, on which all sixteen
# current points lie.
# Right: the same sixteen points with the decay factor removed, e^{t} X(t) = R(2t) X0.
# They stay on the circle of radius 2 and turn together through the angle 2t; the
# solution from (2, 0) (larger dot) has its angle shown as a red arc and a spoke; only
# its starting point is marked on the right.
# One frame every 0.05 in t (Mathews samples his 3-D examples at this step); the curves
# are drawn from the closed form at steps of 0.005.
# Produces: matexpbb.gif

using Plots
using Printf
using LinearAlgebra
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))        # exact values
fmtv(x) = um(@sprintf("%#.4g", Float64(x)))                      # computed: 4 s.f.

# --- Parameters (Mathews' Example 3) ---
gif_name = "matexpbb.gif"
A      = [-1.0 -2.0; 2.0 -1.0]
expAt(t) = exp(-t) * [cos(2t) -sin(2t); sin(2t) cos(2t)]   # boxed e^{At} on the page
X0s    = [2 .* [cos(k * π / 8), sin(k * π / 8)] for k in 0:15]
cols   = repeat([:red, :blue, :magenta, :green], 4)          # Mathews' PlotStyle, cycled
tmax   = 3.5
dtf    = 0.05                                                # time between frames
nfr    = round(Int, tmax / dtf)                              # frames at t = k/20, k = 0..70
lims   = (-2.0, 2.0)                                         # Mathews' PlotRange
rlims  = (-2.3, 2.3)                                         # right panel
title_str = "Matrix exponential, Mathews' Example 3:  x′ = −x − 2y,  y′ = 2x − y,  " *
            "eᴬᵗ = e⁻ᵗ × (rotation by 2t)"

# Closed form checked against the matrix exponential of the library (Pade/scaling)
for t in 0:0.01:tmax
    @assert norm(expAt(t) - exp(A * t)) <= 1e-14 * norm(exp(A * t))
end

# Fine curves from the closed form
ss = range(0, tmax, length=round(Int, tmax / 0.005) + 1)
curves = [[expAt(s) * X0 for s in ss] for X0 in X0s]
@assert all(abs(p[1]) <= 2 + 1e-12 && abs(p[2]) <= 2 + 1e-12 for c in curves for p in c)

circ(r) = (r .* cos.(range(0, 2π, length=241)), r .* sin.(range(0, 2π, length=241)))

function draw_frame(k)
    t = k / 20
    n = searchsortedlast(ss, t + 1e-12)
    Xt = [expAt(t) * X0 for X0 in X0s]
    r = 2 * exp(-t)

    pL = plot(xlims=lims, ylims=lims, aspect_ratio=1, framestyle=:box, legend=false,
              xticks=-2:0.5:2, yticks=-2:0.5:2, titlefontsize=11, grid=false,
              xlabel="x", ylabel="y")
    hline!(pL, [0.0]; color=:black, lw=0.5); vline!(pL, [0.0]; color=:black, lw=0.5)
    plot!(pL, circ(r)...; color=:gray50, ls=:dash, lw=1)
    for (j, c) in enumerate(curves)
        plot!(pL, first.(c[1:n]), last.(c[1:n]); color=cols[j], lw=1.5)
    end
    scatter!(pL, first.(X0s), last.(X0s); color=:sienna, ms=4, msw=0)
    scatter!(pL, first.(Xt), last.(Xt); color=cols, ms=5, msc=:black, msw=0.5)
    TL = "t = $(fmt(t)):  X(t) = eᴬᵗX₀,  |X(t)| = 2e⁻ᵗ = $(fmtv(r))"
    title!(pL, TL)

    Yt = [exp(t) .* p for p in Xt]                       # e^{t} X(t) = R(2t) X0
    pR = plot(xlims=rlims, ylims=rlims, aspect_ratio=1, framestyle=:box, legend=false,
              xticks=-2:0.5:2, yticks=-2:0.5:2, titlefontsize=11, grid=false,
              xlabel="eᵗx", ylabel="eᵗy")
    hline!(pR, [0.0]; color=:black, lw=0.5); vline!(pR, [0.0]; color=:black, lw=0.5)
    plot!(pR, circ(2.0)...; color=:gray70, lw=1)
    th = range(0, 2t, length=max(2, round(Int, 2t / 0.01) + 1))
    rr = 0.6 .+ 0.08 .* th ./ (2π)                       # arc spirals out after a full turn
    plot!(pR, rr .* cos.(th), rr .* sin.(th); color=:red, lw=1.5)
    plot!(pR, [0, Yt[1][1]], [0, Yt[1][2]]; color=:red, lw=1.5)
    plot!(pR, [0, 2], [0, 0]; color=:sienna, lw=1, ls=:dash)
    scatter!(pR, [2.0], [0.0]; color=:sienna, ms=4, msw=0)
    scatter!(pR, first.(Yt), last.(Yt); color=cols, ms=5, msc=:black, msw=0.5)
    scatter!(pR, [Yt[1][1]], [Yt[1][2]]; color=:red, ms=8, msc=:black, msw=1.5)
    TR = "decay removed:  eᵗX(t) = (rotation by 2t)X₀,  2t = $(fmt(2t)) rad"
    title!(pR, TR)
    println("TITLE: ", TL)
    println("TITLE: ", TR)

    plot(pL, pR; layout=(1, 2), size=(1150, 600), plot_title=title_str,
         plot_titlefontsize=12, background_color=:white, left_margin=3Plots.mm)
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
