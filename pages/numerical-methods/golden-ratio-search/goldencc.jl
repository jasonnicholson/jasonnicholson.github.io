# goldencc.jl
# Golden Ratio Search animation: f(x) = e^x - sin(2x) on all of [-1, 1], where
# f is not unimodal (a local maximum near -0.6539 and a local minimum near
# 0.3770), with Mathews' stopping rule delta = epsilon = 1e-6 (Golden Ratio
# Search module, Example 2, which searches a smaller interval; this run and its
# animation are new). The first comparison discards [-1, c0], which holds the
# local maximum, and the rest of the run is a search on an interval where f is
# unimodal. Picture elements are those of Mathews' plotting program for
# Example 6; a lower panel zooms on the current bracket and plots f(x) - f(p).
# Produces: goldencc.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
fmt(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%.4g", x)

# x label with enough significant figures to tell apart points that are at least
# w/5 apart: ceil(-log10(w)) + 1 significant figures, between 4 and 10, trailing
# zeros kept; a zero is printed as 0 (it occurs only as an exact value: the
# endpoint a₀ = 0, or the midpoint 0 of [−1, 1])
fmtx(x, w) = x == 0 ? "0" : @sprintf("%#.*g", clamp(ceil(Int, -log10(w)) + 1, 4, 10), x)

# --- Parameters ---
f(x) = exp(x) - sin(2x)
f_str = "f(x) = eˣ − sin 2x"
a0, b0 = -1.0, 1.0
K_fixed = nothing            # stop by Mathews' rule instead
stop_tol = (1e-6, 1e-6)      # (δ, ε): stop once b − a ≤ δ and |f(b) − f(a)| ≤ ε
# minimiser: root of f'(x) = eˣ − 2cos 2x near 0.377, by Newton's method in BigFloat
newton(x) = (for _ in 1:12; x -= (exp(x) - 2cos(2x)) / (exp(x) + 4sin(2x)); end; x)
p_big = newton(big(0.38))
p_true = Float64(p_big)
p_label = "minimiser p ≈ $(@sprintf("%.4f", p_true))"
x_max = Float64(newton(big(-0.65)))  # the local maximum of f in [-1, 1]
xlims_full = (a0 - 0.05, b0 + 0.05)
ylims_full = (0.0, 2.0)
top_ticks = nothing
legend_pos = :top
extra_vline = (x_max, "local maximum ≈ $(fmt(x_max))")
step_note = Dict(0 => "this drops [a, c], which holds the local maximum")
gif_name = "goldencc.gif"

# f(x) − f(p) and f(c) − f(d) for the plot and labels, evaluated in BigFloat at
# the Float64 points: near the minimum Float64 differences lose digits
fp_big = f(p_big)
gz(x) = Float64(f(big(x)) - fp_big)
fdiff(x, y) = Float64(f(big(x)) - f(big(y)))

# --- Golden ratio search (Mathews' update: r1 = (√5 − 1)/2, r2 = r1²) ---
r1 = (sqrt(5) - 1) / 2
r2 = r1^2
A = Float64[]; B = Float64[]; C = Float64[]; D = Float64[]
FA = Float64[]; FB = Float64[]; FC = Float64[]; FD = Float64[]; keep_left = Bool[]
a, b = a0, b0
fa, fb = f(a), f(b)
c, d = a + r2 * (b - a), a + r1 * (b - a)
fc, fd = f(c), f(d)
k = 0
while true
    push!(A, a); push!(B, b); push!(C, c); push!(D, d)
    push!(FA, fa); push!(FB, fb); push!(FC, fc); push!(FD, fd)
    if stop_tol === nothing
        k == K_fixed && break
    else                     # Mathews: continue while |f(b) − f(a)| > ε or b − a > δ
        (abs(fb - fa) > stop_tol[2] || b - a > stop_tol[1]) || break
    end
    @assert fc != fd                         # no ties: both tie rules agree
    @assert (fc <= fd) == (fdiff(c, d) <= 0) # Float64 decision = exact sign
    if fc <= fd                              # squeeze from the right: keep [a, d]
        push!(keep_left, true)
        global b, fb = d, fd
        global d, fd = c, fc
        global c = a + r2 * (b - a); global fc = f(c)
    else                                     # squeeze from the left: keep [c, b]
        push!(keep_left, false)
        global a, fa = c, fc
        global c, fc = d, fd
        global d = a + r1 * (b - a); global fd = f(d)
    end
    global k += 1
end
K = k
@assert all(A .< p_true .< B)                # every bracket contains p
# Mathews returns the endpoint with the smaller value (a unless f(b) < f(a))
ret_is_b = FB[end] < FA[end]
p_ret = ret_is_b ? B[end] : A[end]
p_mid = (A[end] + B[end]) / 2

for i in 1:K + 1
    @printf("%3d %.17g %.17g %.17g %.17g diff=%.4g keep=%s\n", i - 1, A[i], C[i], D[i], B[i],
            fdiff(C[i], D[i]), i <= K ? (keep_left[i] ? "L" : "R") : "-")
end
@printf("K = %d, final width %.6g, returned %s = %.10g, |ret - p| = %.4g, midpoint %.10g, |mid - p| = %.4g\n",
        K, B[end] - A[end], ret_is_b ? "b" : "a", p_ret, abs(p_ret - p_true), p_mid, abs(p_mid - p_true))

# --- Drawing helpers ---
xplot = range(a0, b0, length=600)        # Mathews plots f over [a0, b0]
const PINK = RGB(1.0, 0.8, 0.85)

function bracket_fill!(p, a, b, g, ybase)
    xs = range(a, b, length=200)
    plot!(p, xs, g.(xs); fillrange=ybase, fillcolor=PINK, fillalpha=1.0,
          color=:red, lw=2, label="bracket [a, b]")
end

function draw_frame(k)
    i = k + 1
    a, b, c, d = A[i], B[i], C[i], D[i]
    w = b - a

    # ---------------- Top panel: Mathews' full view ----------------
    lst = "{a, c, d, b} = {" * join(fmtx.([a, c, d, b], w), ", ") * "}"
    p1 = plot(xlims=xlims_full, ylims=ylims_full, xlabel="x", ylabel="y",
              title="Golden ratio search, k = $(k): $(f_str)\n$(lst)", titlefontsize=10,
              legend=legend_pos, legendfontsize=8, grid=true, framestyle=:box,
              background_color=:white)
    top_ticks === nothing || plot!(p1; xticks=top_ticks[1], yticks=top_ticks[2])
    plot!(p1, xplot, f.(xplot); color=:magenta, lw=2, label="y = f(x)")
    bracket_fill!(p1, a, b, f, ylims_full[1])
    scatter!(p1, [c, d], f.([c, d]); color=:blue, ms=6, msw=0, label="interior points c, d")
    scatter!(p1, [a, b], f.([a, b]); color=:red, ms=6, msw=0, label="a, b")
    vline!(p1, [p_true]; color=:green, ls=:dash, lw=1, label=p_label)
    extra_vline === nothing ||
        vline!(p1, [extra_vline[1]]; color=:darkorange, ls=:dot, lw=2, label=extra_vline[2])

    # ---------------- Bottom panel: zoom on the bracket ----------------
    zx = (a - 0.08w, b + 0.08w)
    xz = range(zx[1], zx[2], length=400)
    gxz = gz.(xz)
    ymax = maximum(gxz)
    zy = (-0.08ymax, 1.12ymax)
    if k < K
        df = fdiff(c, d)
        ztitle = "Step k = $(k) of 0…$(K), b − a = $(fmt(w)):\n" *
                 (keep_left[i] ? "f(c) − f(d) = $(fmt(df)) < 0, keep [a, d]" :
                                 "f(c) − f(d) = $(fmt(df)) > 0, keep [c, b]")
        haskey(step_note, k) && (ztitle *= "\n" * step_note[k])
    else
        ztitle = "k = $(K), last: b − a = $(fmt(w)), contains p\n" *
                 "Mathews returns $(ret_is_b ? "b" : "a") = $(fmtx(p_ret, w)) " *
                 (ret_is_b ? "(f(b) < f(a))" : FA[end] < FB[end] ? "(f(a) < f(b))" : "(f(a) = f(b))") *
                 ", midpoint $(fmtx(p_mid, w))"
    end
    p2 = plot(xlims=zx, ylims=zy, xlabel="x", ylabel="f(x) − f(p)",
              title=ztitle, titlefontsize=10, legend=false, grid=true,
              framestyle=:box, background_color=:white,
              xticks=([a, (a + b) / 2, b], [fmtx(a, w), fmtx((a + b) / 2, w), fmtx(b, w)]),
              yformatter=y -> @sprintf("%+.2e", y))
    plot!(p2, xz, gxz; color=:magenta, lw=2)
    bracket_fill!(p2, a, b, gz, zy[1])
    if k < K                 # the part that survives this step, as a green bar
        ka, kb = keep_left[i] ? (a, d) : (c, b)
        plot!(p2, [ka, kb], fill(zy[1] + 0.03 * (zy[2] - zy[1]), 2); color=:green, lw=6)
    end
    scatter!(p2, [c, d], gz.([c, d]); color=:blue, ms=6, msw=0)
    scatter!(p2, [a, b], gz.([a, b]); color=:red, ms=6, msw=0)
    vline!(p2, [p_true]; color=:green, ls=:dash, lw=1)

    plot(p1, p2; layout=grid(2, 1, heights=[0.55, 0.45]), size=(640, 900),
         left_margin=8Plots.mm, right_margin=4Plots.mm)
end

frames = [collect(0:K); fill(K, 2)]      # hold the last frame
anim = @animate for k in frames
    draw_frame(k)
end

gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: ", gif_name)
