# bezieraa.jl
# Bézier Curve animation: de Casteljau construction for a cubic Bézier
# Control points (Mathews, Bézier Curve module, Example 3): P0=(2,2), P1=(1,1.5), P2=(3.5,0), P3=(4,1)
# Animates parameter t ∈ [0,1], showing intermediate points and the curve being traced
# Produces: bezieraa.gif

using Plots
gr()

# Control points as 2-vectors
P = [[2.0, 2.0], [1.0, 1.5], [3.5, 0.0], [4.0, 1.0]]

# Number of samples on the full curve t ∈ [0,1] (the trace up to t uses a proportional share)
n_curve = 300

function decasteljau_point(pts, t)
    pts_cur = deepcopy(pts)
    while length(pts_cur) > 1
        pts_cur = [(1 - t) .* pts_cur[i] .+ t .* pts_cur[i + 1]
                   for i in 1:length(pts_cur) - 1]
    end
    return pts_cur[1]
end

# Control polygon
px = [p[1] for p in P]
py = [p[2] for p in P]

n_frames = 40
t_anim   = range(0.0, 1.0, length=n_frames)

anim = @animate for (frame_idx, t) in enumerate(t_anim)
    # de Casteljau levels
    L0 = deepcopy(P)
    L1 = [(1 - t) .* L0[i] .+ t .* L0[i + 1] for i in 1:3]
    L2 = [(1 - t) .* L1[i] .+ t .* L1[i + 1] for i in 1:2]
    L3 = [(1 - t) .* L2[i] .+ t .* L2[i + 1] for i in 1:1]

    plot(size=(700, 550),
         xlims=(-0.3, 4.3), ylims=(-1.3, 2.3),
         xlabel="x", ylabel="y",
         title="Bézier Curve (Example 3) — de Casteljau  (t = $(round(t, digits=2)))",
         legend=:outerright, grid=true, framestyle=:box,
         background_color=:white)

    # Curve traced so far: B(s) for s in [0, t], ending exactly at the red point
    tt = range(0.0, t, length=max(2, round(Int, 1 + t * (n_curve - 1))))
    trace = [decasteljau_point(P, s) for s in tt]
    plot!([p[1] for p in trace], [p[2] for p in trace];
          color=:steelblue, lw=3, label="Bézier curve")

    # Control polygon (dashed)
    plot!(px, py; color=:gray, lw=1, linestyle=:dash, label="control polygon")
    scatter!(px, py; color=:black, ms=7, label="control points P₀–P₃")

    # Level-1 segments and points
    l1x = [p[1] for p in L1]; l1y = [p[2] for p in L1]
    plot!([L1[1][1], L1[2][1], L1[3][1]],
          [L1[1][2], L1[2][2], L1[3][2]]; color=:orange, lw=1.5, label="")
    scatter!(l1x, l1y; color=:orange, ms=5, label="level 1")

    # Level-2 segments and points
    l2x = [p[1] for p in L2]; l2y = [p[2] for p in L2]
    plot!([L2[1][1], L2[2][1]], [L2[1][2], L2[2][2]]; color=:green, lw=1.5, label="")
    scatter!(l2x, l2y; color=:green, ms=5, label="level 2")

    # Curve point
    scatter!([L3[1][1]], [L3[1][2]]; color=:red, ms=8, label="point on curve")
end

gif(anim, joinpath(@__DIR__, "bezieraa.gif"); fps=8)
println("Saved: bezieraa.gif")
