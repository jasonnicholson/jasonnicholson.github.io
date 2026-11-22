# bezieraa.jl
# Bézier Curve animation: de Casteljau construction for a cubic Bézier
# Control points: P0=(0,0), P1=(1,2), P2=(3,2), P3=(4,0)
# Animates parameter t ∈ [0,1], showing intermediate points and the curve being traced
# Produces: bezieraa.gif

using Plots
gr()

# Control points as 2-vectors
P = [[0.0, 0.0], [1.0, 2.0], [3.0, 2.0], [4.0, 0.0]]

# Pre-compute full Bézier curve for backdrop
n_curve = 300
t_curve = range(0.0, 1.0, length=n_curve)

function decasteljau_point(pts, t)
    pts_cur = deepcopy(pts)
    while length(pts_cur) > 1
        pts_cur = [(1 - t) .* pts_cur[i] .+ t .* pts_cur[i + 1]
                   for i in 1:length(pts_cur) - 1]
    end
    return pts_cur[1]
end

curve_pts = [decasteljau_point(P, t) for t in t_curve]
curve_x   = [p[1] for p in curve_pts]
curve_y   = [p[2] for p in curve_pts]

# Control polygon
px = [p[1] for p in P]
py = [p[2] for p in P]

n_frames = 40
t_anim   = range(0.0, 1.0, length=n_frames)

using Printf
open(joinpath(@__DIR__, "dump_"*basename(@__FILE__)[6:7]*".txt"), "w") do io
for (frame_idx, t) in enumerate(t_anim)
    L0 = deepcopy(P)
    L1 = [(1 - t) .* L0[i] .+ t .* L0[i + 1] for i in 1:3]
    L2 = [(1 - t) .* L1[i] .+ t .* L1[i + 1] for i in 1:2]
    L3 = [(1 - t) .* L2[i] .+ t .* L2[i + 1] for i in 1:1]
    idx_end = min(frame_idx * div(n_curve, n_frames), n_curve)
    @printf(io, "%d %.17g %d %.17g %.17g %.17g %.17g %.17g %.17g %.17g %.17g %.17g %.17g %.17g %.17g %.17g %.17g %.17g\n",
      frame_idx, t, idx_end, t_curve[idx_end], curve_x[idx_end], curve_y[idx_end],
      L1[1]..., L1[2]..., L1[3]..., L2[1]..., L2[2]..., L3[1]...)
end
end
open(joinpath(@__DIR__, "curve_"*basename(@__FILE__)[6:7]*".txt"), "w") do io
  for k in 1:n_curve; @printf(io, "%.17g %.17g %.17g\n", t_curve[k], curve_x[k], curve_y[k]); end
end
