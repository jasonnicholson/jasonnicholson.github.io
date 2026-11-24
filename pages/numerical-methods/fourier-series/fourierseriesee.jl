# fourierseriesee.jl
# Fourier series animation: partial sums S_m of f(x) = x - |x - pi| (period 2pi),
# m = 1, ..., 25. Rebuilds Mathews' FourierSeriesee.gif, which shows f alone and
# then S_1, S_2, ..., S_25. Picture elements follow Mathews: f in blue on one
# period [0, 2pi], S_m in magenta. The periodic extension of f jumps by 2pi at
# x = 0 and 2pi (the edges of the window); f is continuous inside.
# Coefficients (page, Example 2): a_0 = pi, a_j = -2(1 - (-1)^j)/(pi j^2),
# b_j = -2/j.
# The second title line gives max S_m over a period, to compare with sup f = pi.
# Produces: fourierseriesee.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
fmt(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%.4g", x)

# Unicode subscript for frame labels: 17 -> "₁₇"
sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))

# --- Parameters ---
f(x) = x - abs(x - π)               # on [0, 2π]; one period
f_str = "f(x) = x − |x − π|"
a0 = π
a(j) = -2 * (1 - (-1)^j) / (π * j^2)
b(j) = -2 / j
ms = collect(1:25)                  # Mathews' sequence: S_1, ..., S_25
f_segments = [(0.0, 2π)]            # f is continuous on each segment (no interior jump)
legend_pos = :bottomright
yticks_vals = (-π:π/2:π, ["−π", "−π/2", "0", "π/2", "π"])
label_kind = :max                   # :max -> max S_m ; :err -> max |f - S_m|
sup_f_str = "π"
gif_name = "fourierseriesee.gif"

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
