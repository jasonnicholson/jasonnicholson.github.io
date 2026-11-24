# fourierseriescc.jl
# Fourier series animation: partial sums S_m of Mathews' "unit step function",
# f(x) = -1 on (0, pi), +1 on (pi, 2pi) (period 2pi), m = 1, 3, 5, ..., 25.
# Mathews' FourierSeriescc.gif is lost (its HTML page and the formula image
# "f[x] = unit step function" survive); the -1/+1 values are those of his
# surviving FourierFFTcc.gif. This rebuild takes the picture (f in blue, S_m in
# magenta, a first frame with f alone) and the range m <= 25 from his surviving
# FourierSeriesee.gif. Only odd m are shown: b_j = 0 for even j, so
# S_m = S_(m-1) for even m. f jumps by 2 at x = pi and (periodically) at 0, 2pi;
# f is drawn with a break at pi and no value there.
# Coefficients (page, Example 2): a_0 = 0, a_j = 0, b_j = -2(1 - (-1)^j)/(pi j).
# The second title line gives max S_m over a period, to compare with sup f = 1.
# Produces: fourierseriescc.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
fmt(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%.4g", x)

# Unicode subscript for frame labels: 17 -> "₁₇"
sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))

# --- Parameters ---
f(x) = x < π ? -1.0 : 1.0           # on (0, π) and (π, 2π); no value is drawn at π
f_str = "f(x) = −1 on (0, π), 1 on (π, 2π)"
a0 = 0.0
a(j) = 0.0
b(j) = -2 * (1 - (-1)^j) / (π * j)
ms = collect(1:2:25)                # odd m only: even-j coefficients are zero
f_segments = [(0.0, π), (π, 2π)]    # f is continuous on each segment; break at the jump x = π
legend_pos = :bottomright
yticks_vals = (-1:0.5:1, ["−1", "−1/2", "0", "1/2", "1"])
label_kind = :max                   # :max -> max S_m ; :err -> max |f - S_m|
sup_f_str = "1"
gif_name = "fourierseriescc.gif"

S(x, m) = a0 / 2 + sum(a(j) * cos(j * x) + b(j) * sin(j * x) for j in 1:m)

# Maximum of a smooth function g on [lo, hi]: grid, then golden-section refinement
function gridmax(g, lo, hi; N = 20001)
    xs = range(lo, hi, length = N)
    vals = g.(xs)
    i = argmax(vals)
    l, r = xs[max(i - 1, 1)], xs[min(i + 1, N)]
    φ = (sqrt(5) - 1) / 2
    c, d = r - φ * (r - l), l + φ * (r - l)
    for _ in 1:80
        if g(c) > g(d)
            r = d
        else
            l = c
        end
        c, d = r - φ * (r - l), l + φ * (r - l)
    end
    return max(vals[i], g((l + r) / 2))
end

# Per-frame number: max S_m (discontinuous f) or max |f - S_m| (continuous f)
frame_value(m) = label_kind == :max ? gridmax(x -> S(x, m), 0.0, 2π) :
                                      gridmax(x -> abs(f(x) - S(x, m)), 0.0, 2π)
vals = Dict(m => frame_value(m) for m in ms)
value_str(m) = label_kind == :max ?
    "max S$(sub(m)) = $(fmt(vals[m]))  (sup f = $(sup_f_str))" :
    "max |f − S$(sub(m))| = $(fmt(vals[m]))"

# --- Curves ---
xplot = range(0, 2π, length = 1201)
fx = Float64[]; fy = Float64[]
for (lo, hi) in f_segments           # NaN between segments breaks f at its jumps
    isempty(fx) || (push!(fx, NaN); push!(fy, NaN))
    seg = range(lo, hi, length = 600)
    # endpoints of a segment are approached from inside (one-sided limits)
    append!(fx, seg); append!(fy, f.(clamp.(seg, lo + 1e-12, hi - 1e-12)))
end
Sm = Dict(m => S.(xplot, m) for m in ms)

# y-range holds f and every S_m drawn (nothing is clamped)
ymin = min(minimum(filter(!isnan, fy)), minimum(minimum(v) for v in values(Sm)))
ymax = max(maximum(filter(!isnan, fy)), maximum(maximum(v) for v in values(Sm)))
pad = 0.06 * (ymax - ymin)
ylims = (ymin - pad, ymax + pad)
xticks_vals = (0:π/2:2π, ["0", "π/2", "π", "3π/2", "2π"])

# frames: 0 = f alone (held), then each m, last frame held
frames = vcat([0, 0], ms, fill(ms[end], 3))

function make_frame(i)
    m = frames[i]
    t2 = m == 0 ? "f alone; then the partial sums Sₘ, m = $(ms[1]), $(ms[2]), …, $(ms[end])" :
                  "S$(sub(m))(x):  " * value_str(m)
    p = plot(size = (640, 480), xlims = (-0.15, 2π + 0.15), ylims = ylims,
             xticks = xticks_vals, yticks = yticks_vals,
             title = "Fourier series of $(f_str), period 2π\n" * t2,
             titlefontsize = 11, legend = legend_pos, legendfontsize = 9,
             framestyle = :zerolines, grid = true, background_color = :white,
             xlabel = "x", ylabel = "y")
    plot!(p, fx, fy; color = :blue, lw = 2, label = "f(x)")
    if m > 0
        plot!(p, xplot, Sm[m]; color = :magenta, lw = 2, label = "S$(sub(m))(x)")
    end
    return p
end

anim = @animate for i in eachindex(frames)
    make_frame(i)
end
gif(anim, joinpath(@__DIR__, gif_name); fps = 2)
println("Saved: ", gif_name)
