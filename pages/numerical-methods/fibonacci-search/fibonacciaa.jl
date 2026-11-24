# fibonacciaa.jl
# Fibonacci Search animation: f(x) = 1/2 + x^5 - 4x/5 on [0, 1] with tolerance
# 7e-3, so n = 12 and the search has n - 2 = 10 steps (Mathews, Fibonacci Search
# module, Example 2, whose solution shows these ten steps as static graphs).
# Picture elements follow Mathews' animation: magenta curve, the bracket [a, b]
# as a red arc with pink fill, red dots at a and b, blue dots at c and d, and
# the list {a, c, d, b}. A lower panel zooms on the current bracket and plots
# f(x) - f(p), so each comparison stays visible once the bracket is narrow.
# Produces: fibonacciaa.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
fmt(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%.4g", x)

# x label with enough significant figures to tell apart points that are at least
# w/5 apart: ceil(-log10(w)) + 1 significant figures, between 4 and 10, trailing
# zeros kept (the only zero is the exact given endpoint a₀ = 0)
fmtx(x, w) = x == 0 ? "0" : @sprintf("%#.*g", clamp(ceil(Int, -log10(w)) + 1, 4, 10), x)

# --- Parameters ---
f(x) = 1/2 + x^5 - 4x/5
f_str = "f(x) = 1/2 + x⁵ − 4x/5"
# f(c) − f(d) for the labels, evaluated in BigFloat at the Float64 points: near
# the minimum the Float64 difference loses its fourth significant figure
fdiff(x, y) = Float64(f(big(x)) - f(big(y)))
a0, b0 = 0.0, 1.0
tol = 7e-3                   # Mathews' tolerance for Example 2
split_e = nothing            # no final split: Mathews stops at the midpoint
p_true = sqrt(10) / 5        # exact minimiser: f'(x) = 5x⁴ − 4/5 = 0
p_label = "minimiser p = √10/5 ≈ $(fmt(p_true))"
xlims_full = (-0.05, 1.05)   # Mathews' plot window
ylims_full = (0.0, 0.75)
legend_pos = :top
gif_name = "fibonacciaa.gif"
n_expected = 12

# --- Fibonacci numbers and n: the smallest n with F_n > (b0 - a0)/tol ---
F = [0, 1]                   # F[i + 1] = F_i
fib(i) = F[i + 1]
n = 1
while fib(n) <= (b0 - a0) / tol
    global n += 1
    length(F) < n + 1 && push!(F, F[end] + F[end - 1])
end
@assert n == n_expected
r(k) = fib(n - 1 - k) / fib(n - k)

# --- Fibonacci search, steps k = 0, ..., n - 3 ---
A = Float64[]; B = Float64[]; C = Float64[]; D = Float64[]
FC = Float64[]; FD = Float64[]; keep_left = Bool[]
a, b = a0, b0
c = a + (1 - r(0)) * (b - a)
d = a + r(0) * (b - a)
fc, fd = f(c), f(d)
for k in 0:(n - 3)
    push!(A, a); push!(B, b); push!(C, c); push!(D, d); push!(FC, fc); push!(FD, fd)
    k == n - 3 && break
    if fc <= fd                          # squeeze from the right: keep [a, d]
        push!(keep_left, true)
        global b = d; global d = c; global fd = fc
        global c = a + (1 - r(k + 1)) * (b - a)
        if k + 1 == n - 3                # last step: c is the midpoint, which is d
            @assert abs(c - d) <= 1e-12
            global c = d; global fc = fd
        else
            global fc = f(c)
        end
    else                                 # squeeze from the left: keep [c, b]
        push!(keep_left, false)
        global a = c; global c = d; global fc = fd
        global d = a + r(k + 1) * (b - a)
        if k + 1 == n - 3
            @assert abs(d - c) <= 1e-12
            global d = c; global fd = fc
        else
            global fd = f(d)
        end
    end
end
nsteps = n - 2
p_hat = C[end]                           # midpoint estimate c_{n-3} = d_{n-3}

# Optional split of the last interval with the distinguishability constant e
if split_e !== nothing
    a_s, b_s, d_s = A[end], B[end], D[end]
    c_s = a_s + (0.5 - split_e) * (b_s - a_s)
    fc_s = f(c_s)
    split_left = fc_s <= FD[end]
    a_fin, b_fin = split_left ? (a_s, d_s) : (c_s, b_s)
end

# --- Drawing helpers ---
xplot = range(xlims_full[1], xlims_full[2], length=600)
const PINK = RGB(1.0, 0.8, 0.85)

function bracket_fill!(p, a, b, g, ybase)
    xs = range(a, b, length=200)
    plot!(p, xs, g.(xs); fillrange=ybase, fillcolor=PINK, fillalpha=1.0,
          color=:red, lw=2, label="bracket [a, b]")
end

# One frame. step = -1 is the starting frame, 0..n-3 the steps, n-2 the split.
function draw_frame(step)
    if step < 0
        a, b, pts = a0, b0, Float64[]
    elseif step <= n - 3
        i = step + 1
        a, b, pts = A[i], B[i], [C[i], D[i]]
    else
        a, b, pts = A[end], B[end], [c_s, D[end]]
    end
    w = b - a
    # label digits: the split point c′ is only e(b − a) from d
    wl = step == n - 2 ? 5 * (D[end] - c_s) : w

    # ---------------- Top panel: Mathews' full view ----------------
    lst = step < 0 ? "{a, b} = {$(fmtx(a, wl)), $(fmtx(b, wl))}" :
          (step <= n - 3 ? "{a, c, d, b} = {" : "{a, c′, d, b} = {") *
          join(fmtx.([a; pts; b], wl), ", ") * "}"
    p1 = plot(xlims=xlims_full, ylims=ylims_full, xlabel="x", ylabel="y",
              title="Fibonacci search, n = $(n): $(f_str)\n$(lst)", titlefontsize=10,
              legend=legend_pos, legendfontsize=8, grid=true, framestyle=:box,
              background_color=:white)
    plot!(p1, xplot, f.(xplot); color=:magenta, lw=2, label="y = f(x)")
    if step >= 0
        bracket_fill!(p1, a, b, f, ylims_full[1])
        scatter!(p1, pts, f.(pts); color=:blue, ms=6, msw=0,
                 label=step <= n - 3 ? "interior points c, d" : "split point c′ and d")
    end
    scatter!(p1, [a, b], f.([a, b]); color=:red, ms=6, msw=0,
             label=step < 0 ? "a₀, b₀" : "a, b")
    vline!(p1, [p_true]; color=:green, ls=:dash, lw=1,
           label=p_label)

    # ---------------- Bottom panel: zoom on the bracket ----------------
    zx = (a - 0.08w, b + 0.08w)
    xz = range(zx[1], zx[2], length=400)
    g(x) = f(x) - f(p_true)
    ymax = maximum(g.(xz))
    zy = (-0.08ymax, 1.12ymax)
    if step < 0
        ztitle = "n = $(n): smallest n with F_n > (b₀ − a₀)/ε = $(@sprintf("%.7g", (b0 - a0) / tol)), " *
                 "so $(nsteps) steps"
    elseif step < n - 3
        diff = fdiff(C[step + 1], D[step + 1])
        ztitle = "Step k = $(step) of 0…$(n - 3), r_k = $(fib(n - 1 - step))/$(fib(n - step)):\n" *
                 (keep_left[step + 1] ?
                  "f(c) − f(d) = $(fmt(diff)) ≤ 0, keep [a, d]" :
                  "f(c) − f(d) = $(fmt(diff)) > 0, keep [c, b]")
    elseif step == n - 3
        ztitle = "Step k = $(step): r_k = 1/2, c = d = midpoint p̂ = $(fmtx(p_hat, wl))\n" *
                 "|p̂ − p| = $(fmt(abs(p_hat - p_true))) ≤ (b₀ − a₀)/F_n = $(fmt((b0 - a0) / fib(n)))"
    else
        diff = fdiff(c_s, D[end])
        ztitle = "Split with e = $(split_e): f(c′) − f(d) = $(fmt(diff)), " *
                 (split_left ? "keep [a, d]" : "keep [c′, b]") *
                 "\nfinal bracket width $(fmt(b_fin - a_fin)) contains p"
    end
    p2 = plot(xlims=zx, ylims=zy, xlabel="x", ylabel="f(x) − f(p)",
              title=ztitle, titlefontsize=10, legend=false, grid=true,
              framestyle=:box, background_color=:white,
              xticks=([a, (a + b) / 2, b], [fmtx(a, wl), fmtx((a + b) / 2, wl), fmtx(b, wl)]),
              yformatter=y -> @sprintf("%+.2e", y))
    plot!(p2, xz, g.(xz); color=:magenta, lw=2)
    if step >= 0
        bracket_fill!(p2, a, b, g, zy[1])
        # the part that survives this step, as a green bar along the bottom
        if step < n - 3
            kl = keep_left[step + 1]
            ka, kb = kl ? (a, pts[2]) : (pts[1], b)
            plot!(p2, [ka, kb], fill(zy[1] + 0.03 * (zy[2] - zy[1]), 2); color=:green, lw=6)
        elseif step == n - 2
            plot!(p2, [a_fin, b_fin], fill(zy[1] + 0.03 * (zy[2] - zy[1]), 2); color=:green, lw=6)
        end
        scatter!(p2, pts, g.(pts); color=:blue, ms=6, msw=0)
    end
    scatter!(p2, [a, b], g.([a, b]); color=:red, ms=6, msw=0)
    vline!(p2, [p_true]; color=:green, ls=:dash, lw=1)

    plot(p1, p2; layout=grid(2, 1, heights=[0.55, 0.45]), size=(640, 900),
         left_margin=8Plots.mm, right_margin=4Plots.mm)
end

last_step = split_e === nothing ? n - 3 : n - 2
frames = [-1; collect(0:last_step); fill(last_step, 2)]   # hold the last frame
anim = @animate for s in frames
    draw_frame(s)
end

gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: ", gif_name)
