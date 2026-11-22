# bsplineaa.jl
# B-Splines animation: cubic B-spline curve from 7 control points
# Reveals the curve segment by segment (left to right) then shows
# control polygon comparison
# Produces: bsplineaa.gif

using Plots
gr()

# Cox–de Boor recursion (1-indexed knot vector t_knots, order k)
function bspline_basis(x, t_knots, i, k)
    if k == 1
        lo, hi = t_knots[i], t_knots[i + 1]
        return (lo <= x < hi) ? 1.0 : 0.0
    end
    denom1 = t_knots[i + k - 1] - t_knots[i]
    denom2 = t_knots[i + k]     - t_knots[i + 1]
    w1 = denom1 > 0 ? (x - t_knots[i])          / denom1 * bspline_basis(x, t_knots, i,     k - 1) : 0.0
    w2 = denom2 > 0 ? (t_knots[i + k] - x)      / denom2 * bspline_basis(x, t_knots, i + 1, k - 1) : 0.0
    return w1 + w2
end

# Evaluate B-spline curve at parameter t (returns [x, y])
function bspline_curve_point(t, ctrl_pts, t_knots, k)
    n = length(ctrl_pts)
    pt = [0.0, 0.0]
    for i in 1:n
        b = bspline_basis(t, t_knots, i, k)
        pt .+= b .* ctrl_pts[i]
    end
    return pt
end

# --- Parameters ---
k = 4                         # order = degree + 1 = cubic + 1
ctrl_pts = [
    [0.0, 0.0],
    [1.0, 2.0],
    [2.0, -1.0],
    [3.0, 2.0],
    [4.0, -0.5],
    [5.0, 1.5],
    [6.0, 0.0],
]
n_ctrl = length(ctrl_pts)     # 7 control points

# Clamped uniform knot vector: k zeros, interior knots, k zeros
# For n=7 control points, order k=4: need n+k = 11 knots
n_int = n_ctrl - k            # 3 interior knots
t_knots = vcat(zeros(k),
               range(1.0, n_int, length=n_int),
               fill(Float64(n_int + 1), k))
t_min, t_max = t_knots[k], t_knots[n_ctrl + 1]   # parameter range

# Pre-compute full curve
n_pts = 400
t_vals = range(t_min + 1e-9, t_max - 1e-9, length=n_pts)
curve  = [bspline_curve_point(t, ctrl_pts, t_knots, k) for t in t_vals]
cx = [p[1] for p in curve]
cy = [p[2] for p in curve]

# Control polygon
px = [p[1] for p in ctrl_pts]
py = [p[2] for p in ctrl_pts]
println("knots = ", collect(t_knots))
println("t_min,t_max = ", t_min, " ", t_max)
open("aa_curve.csv","w") do io
  for (t,x,y) in zip(t_vals,cx,cy); println(io, t, ",", x, ",", y); end
end
# frame marker positions
for frame in 0:30
  idx_end = max(1, round(Int, frame/30*n_pts))
  println("frame ", frame+1, " idx ", idx_end, " t=", t_vals[idx_end], " pt=(", cx[idx_end], ",", cy[idx_end], ")")
end
