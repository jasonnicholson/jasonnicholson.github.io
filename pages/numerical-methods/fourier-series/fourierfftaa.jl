# fourierfftaa.jl
# Discrete Fourier series (FFT) animation: the trigonometric polynomial P_m of
# degree m = 1, 3, 5, ..., 17 through n = 36 equally spaced samples of
# f(x) = |x - pi| (period 2pi). Stands in for Mathews' lost FourierFFTaa.gif:
# its frames and its formula image are lost, and the function is identified
# from the layout of his FFT index page. The picture, n = 36 and the range
# m <= 17 follow his surviving FourierFFTcc/dd/ee.gif. Only odd m are shown:
# the samples satisfy y_(36-k) = y_k and y_(k+18) = pi - y_k, so every b_j and
# every a_j with even j >= 2 is zero for these 36 samples, and P_m = P_(m-1)
# for even m.
# Picture elements follow Mathews: the 36 samples x_k = k pi/18, k = 0..35, as
# red dots, the periodic copy (2pi, y_0) as a pale pink dot, P_m in magenta.
# Added: f itself as a thin grey line. f is continuous and periodic, so no
# sample sits on a jump.
# The coefficients are the discrete Fourier sums (6)-(7) of the page, evaluated
# directly (O(n^2) operations, no FFT package); an FFT gives the same numbers up
# to rounding.
# The second title line gives max |f - P_m| over a period.
# Produces: fourierfftaa.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
fmt(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%.4g", x)

# Unicode subscript for frame labels: 17 -> "₁₇"
sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))

# --- Parameters ---
f(x) = abs(x - π)                   # on [0, 2π]; one period
f_str = "f(x) = |x − π|"
n = 36
xk = [2π * k / n for k in 0:n-1]
yk = [f(xk[k+1]) for k in 0:n-1]
ms = collect(1:2:17)                # odd m only: even-j terms are zero (2m + 1 <= n)
f_segments = [(0.0, 2π)]            # f is continuous on each segment (no interior jump)
legend_pos = :top
yticks_vals = (0:π/2:π, ["0", "π/2", "π"])
label_kind = :err                   # :max -> max P_m ; :err -> max |f - P_m|
sup_f_str = "π"
gif_name = "fourierfftaa.gif"

# --- Discrete Fourier coefficients, equations (6)-(7) ---
A = [2 / n * sum(yk[k+1] * cos(2π * j * k / n) for k in 0:n-1) for j in 0:ms[end]]
B = [2 / n * sum(yk[k+1] * sin(2π * j * k / n) for k in 0:n-1) for j in 0:ms[end]]
P(x, m) = A[1] / 2 + sum(A[j+1] * cos(j * x) + B[j+1] * sin(j * x) for j in 1:m)

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

# Per-frame number: max P_m (discontinuous f) or max |f - P_m| (continuous f)
frame_value(m) = label_kind == :max ? gridmax(x -> P(x, m), 0.0, 2π) :
                                      gridmax(x -> abs(f(x) - P(x, m)), 0.0, 2π)
vals = Dict(m => frame_value(m) for m in ms)
value_str(m) = label_kind == :max ?
    "max P$(sub(m)) = $(fmt(vals[m]))  (sup f = $(sup_f_str))" :
    "max |f − P$(sub(m))| = $(fmt(vals[m]))"

# --- Curves ---
xplot = range(0, 2π, length = 1201)
fx = Float64[]; fy = Float64[]
for (lo, hi) in f_segments           # NaN between segments breaks f at its jumps
    isempty(fx) || (push!(fx, NaN); push!(fy, NaN))
    seg = range(lo, hi, length = 600)
    # endpoints of a segment are approached from inside (one-sided limits)
    append!(fx, seg); append!(fy, f.(clamp.(seg, lo + 1e-12, hi - 1e-12)))
end
Pm = Dict(m => P.(xplot, m) for m in ms)

# y-range holds f, the samples and every P_m drawn (nothing is clamped)
ymin = min(minimum(filter(!isnan, fy)), minimum(yk), minimum(minimum(v) for v in values(Pm)))
ymax = max(maximum(filter(!isnan, fy)), maximum(yk), maximum(maximum(v) for v in values(Pm)))
pad = 0.06 * (ymax - ymin)
ylims = (ymin - pad, ymax + pad)
xticks_vals = (0:π/2:2π, ["0", "π/2", "π", "3π/2", "2π"])

# frames: 0 = samples alone (held), then each degree m, last frame held
frames = vcat([0, 0], ms, fill(ms[end], 3))

function make_frame(i)
    m = frames[i]
    t2 = m == 0 ? "n = $n samples yₖ = f(xₖ), xₖ = kπ/$(n ÷ 2); then Pₘ, m = $(ms[1]), $(ms[2]), …, $(ms[end])" :
                  "P$(sub(m))(x):  " * value_str(m)
    p = plot(size = (640, 480), xlims = (-0.15, 2π + 0.15), ylims = ylims,
             xticks = xticks_vals, yticks = yticks_vals,
             title = "Discrete Fourier series of $(f_str), period 2π\n" * t2,
             titlefontsize = 11, legend = legend_pos, legendfontsize = 9,
             framestyle = :zerolines, grid = true, background_color = :white,
             xlabel = "x", ylabel = "y")
    plot!(p, fx, fy; color = :gray60, lw = 1, label = "f(x)")
    if m > 0
        plot!(p, xplot, Pm[m]; color = :magenta, lw = 2, label = "P$(sub(m))(x), degree $m")
    end
    scatter!(p, xk, yk; color = :red, markerstrokecolor = :red, ms = 4,
             label = "samples (xₖ, yₖ)")
    scatter!(p, [2π], [yk[1]]; color = :pink, markerstrokecolor = :pink, ms = 4,
             label = "(2π, y₀): periodic copy")
    return p
end

anim = @animate for i in eachindex(frames)
    make_frame(i)
end
gif(anim, joinpath(@__DIR__, gif_name); fps = 2)
println("Saved: ", gif_name)
