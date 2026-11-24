# quadraticaa.jl
# Quadratic Interpolative Search animation: rebuild of Mathews' animation
# (Quadratic and Cubic Search module, Example 3), f(x) = 1/2 + x^5 - 4x/5 on
# [0, 1], QuadraticSearch[0, 1, 10^-6, 10^-6]. His GIF is lost, so the look
# follows the graphs of his Example 3 solution: f in magenta, the span of the
# current points as a red arc with pink fill, red dots on the current triple,
# a blue dot on the newest point, window [0, 1] x [0, 0.7]. One frame per
# event of his subroutine: each new triple, each halving or doubling of h, and
# each vertex, where the interpolating parabola Q is drawn. A lower panel
# zooms on the triple and plots f(x) - f(p), so the late, narrow triples stay
# visible.
# Produces: quadraticaa.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
fmt(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%.4g", x)

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

# x label with enough significant figures to tell apart points that are at
# least w/2 apart: ceil(-log10(w)) + 1 significant figures, between 4 and 10,
# trailing zeros kept; the exact starting point 0 is printed as 0
fmtx(x, w) = x == 0 ? "0" : @sprintf("%#.*g", clamp(ceil(Int, -log10(w)) + 1, 4, 10), x)

const SUB = Dict(zip("0123456789", "₀₁₂₃₄₅₆₇₈₉"))
sub(n) = map(c -> SUB[c], string(n))

# --- Parameters ---
# Double-precision f as in the page's tables (Mathematica evaluates 4x/5 for a
# machine number x as 0.8x); f' is used only for its sign, as in Mathews
f(x) = 0.5 + x^5 - 0.8x
fp(x) = 5x^4 - 0.8
f_str = "f(x) = 1/2 + x⁵ − 4x/5"
a0, b0 = 0.0, 1.0
delta, epsilon = 1e-6, 1e-6
Jmax, Kmax = 50, 50
p_big = sqrt(big(10)) / 5            # exact minimiser: 5p⁴ = 4/5
p_true = Float64(p_big)
fexact(x) = big(1) / 2 + x^5 - 4x / 5
fp_big = fexact(p_big)
gz(x) = Float64(fexact(big(x)) - fp_big)   # f(x) − f(p) in high precision
xlims_full = (-0.05, 1.05)           # Mathews' graphs: f on [0, 1], y from 0 to 0.7
ylims_full = (0.0, 0.72)
gif_name = "quadraticaa.gif"

# --- Mathews' QuadraticSearch subroutine, line by line, recording events ---
events = NamedTuple[]
nfev = 0
fc(x) = (global nfev += 1; f(x))
p0 = a0; Err = 1.0; h = (b0 - a0) / 2; k = 0
while k < Kmax && Err > epsilon
    fp0 = fp(p0)
    fp0 > 0 && (global h = -abs(h))
    global p1 = p0 + h; global p2 = p0 + 2h
    global Y0 = fc(p0); global Y1 = fc(p1); global Y2 = fc(p2)
    push!(events, (kind=:triple, k=k, j=-1, h=h, p=(p0, p1, p2), y=(Y0, Y1, Y2), new=NaN, fp0=fp0))
    j = 0
    while j < Jmax && abs(h) > delta
        if Y0 <= Y1                       # case (iii): halve
            global p2, Y2 = p1, Y1
            global h = h / 2
            global p1 = p0 + h; global Y1 = fc(p1)
            push!(events, (kind=:halve, k=k, j=j, h=h, p=(p0, p1, p2), y=(Y0, Y1, Y2), new=p1, fp0=NaN))
        elseif Y2 < Y1                    # case (ii): double
            global p1, Y1 = p2, Y2
            global h = 2h
            global p2 = p0 + 2h; global Y2 = fc(p2)
            push!(events, (kind=:double, k=k, j=j, h=h, p=(p0, p1, p2), y=(Y0, Y1, Y2), new=p2, fp0=NaN))
        end
        j += 1
    end
    @assert Y0 > Y1 && Y2 >= Y1          # every loop ends bracketed (case i)
    Hmin = h * (4Y1 - 3Y0 - Y2) / (2 * (2Y1 - Y0 - Y2))
    pmin = p0 + Hmin
    Ymin = fc(pmin)
    hb = h
    global h = abs(h)
    H0 = abs(Hmin); H1 = abs(Hmin - h); H2 = abs(Hmin - 2h)
    H0 < h && (global h = H0)
    H1 < h && (global h = H1)
    H2 < h && (global h = H2)
    h == 0 && (global h = Hmin)
    for e in (abs(Y0 - Ymin), abs(Y1 - Ymin), abs(Y2 - Ymin))
        (e != 0 && e < Err) && (global Err = e)
    end
    (Y0 == Ymin && Y1 == Ymin && Y2 == Ymin) && (global Err = 0.0)
    push!(events, (kind=:vertex, k=k, j=-1, h=hb, p=(p0, p1, p2), y=(Y0, Y1, Y2), new=pmin,
                   fp0=NaN, ymin=Ymin, hmin=Hmin, newh=h, Err=Err))
    global p0 = pmin
    global k += 1
end
K = k

# Interpolating parabola (3) through a triple
Qpoly(p, y) = x -> y[1] * (x - p[2]) * (x - p[3]) / ((p[1] - p[2]) * (p[1] - p[3])) +
                   y[2] * (x - p[1]) * (x - p[3]) / ((p[2] - p[1]) * (p[2] - p[3])) +
                   y[3] * (x - p[1]) * (x - p[2]) / ((p[3] - p[1]) * (p[3] - p[2]))

# Test on a triple, as in the bracketing loop
function test_str(y)
    if y[1] <= y[2]
        "f(p₁) − f(p₀) = $(fmt(y[2] - y[1])) ≥ 0: case (iii), halve h"
    elseif y[3] < y[2]
        "f(p₀) > f(p₁) > f(p₂): case (ii), double h"
    else
        "f(p₀) > f(p₁) ≤ f(p₂): bracketed, case (i)"
    end
end

# Print every event (checked against the page's tables)
for (i, e) in enumerate(events)
    @printf("%2d k=%d %-6s h=%.17g p=(%.17g, %.17g, %.17g) y=(%.12f, %.12f, %.12f)",
            i, e.k, e.kind, e.h, e.p..., e.y...)
    if e.kind == :vertex
        @printf(" pmin=%.17g f=%.12f hmin=%.4e |pmin-p|=%.3e newh=%.10f Err=%.3e Q''>0=%s\n",
                e.new, e.ymin, e.hmin, abs(Float64(big(e.new) - p_big)), e.newh, e.Err,
                e.y[1] - 2e.y[2] + e.y[3] > 0)
    elseif e.kind == :triple
        @printf(" f'(p0)=%+.4g\n", e.fp0)
    else
        @printf(" new=%.17g f=%.12f\n", e.new, f(e.new))
    end
    # every Float64 comparison in the test has the sign of the high-precision difference
    @assert (e.y[1] <= e.y[2]) == (fexact(big(e.p[1])) <= fexact(big(e.p[2])))
    @assert (e.y[3] < e.y[2]) == (fexact(big(e.p[3])) < fexact(big(e.p[2])))
end
@printf("K = %d vertex steps, %d calls of f, last vertex %.10f, |p - pmin| = %.3e\n",
        K, nfev, events[end].new, abs(Float64(big(events[end].new) - p_big)))

# --- Drawing ---
const PINK = RGB(1.0, 0.8, 0.85)
xplot = range(a0, b0, length=600)        # Mathews plots f over [a0, b0]

function span_fill!(plt, lo, hi, g, ybase; label="")
    xs = range(lo, hi, length=200)
    plot!(plt, xs, g.(xs); fillrange=ybase, fillcolor=PINK, fillalpha=1.0,
          color=:red, lw=2, label=label)
end

function draw_frame(i)
    e = events[i]
    p, y, k = e.p, e.y, e.k
    w = abs(p[3] - p[1])
    lo, hi = minmax(p[1], p[3])
    isvert = e.kind == :vertex
    Q = Qpoly(p, y)
    vname = "p" * sub(3k + 3)

    # ---------------- Top panel: Mathews' view ----------------
    trip = "{p₀, p₁, p₂} = {" * join(fmtx.(collect(p), w), ", ") * "}, h = $(fmt(e.h))"
    p1 = plot(xlims=xlims_full, ylims=ylims_full, xlabel="x", ylabel="y",
              title="Quadratic search, outer step k = $(k): $(f_str)\n$(trip)",
              titlefontsize=10, legend=:top, legendfontsize=7, grid=true, framestyle=:box,
              background_color=:white, xticks=0:0.1:1, yticks=0:0.1:0.7)
    plot!(p1, xplot, f.(xplot); color=:magenta, lw=2, label="y = f(x)")
    span_fill!(p1, lo, hi, f, ylims_full[1]; label="span of the triple")
    vline!(p1, [p_true]; color=:green, ls=:dash, lw=1, label="minimiser p = √10/5 ≈ $(fmt(p_true))")
    if isvert
        xq = range(xlims_full..., length=400)
        plot!(p1, xq, ydraw.(Q.(xq), Ref(ylims_full)); color=:black, ls=:dash, lw=1.5,
              label="parabola Q through the triple")
    end
    scatter!(p1, collect(p), collect(y); color=:red, ms=6, msw=0, label="triple p₀, p₁, p₂")
    if isvert
        scatter!(p1, [e.new], [Q(e.new)]; color=:white, msc=:black, msw=1.5, ms=6,
                 label="vertex of Q")
        scatter!(p1, [e.new], [e.ymin]; color=:blue, ms=6, msw=0, label="new point $(vname) on f")
    elseif e.kind != :triple
        scatter!(p1, [e.new], [f(e.new)]; color=:blue, ms=6, msw=0, label="new point")
    end

    # ---------------- Bottom panel: zoom on the triple ----------------
    zx = (lo - 0.08w, hi + 0.08w)
    xz = range(zx[1], zx[2], length=400)
    gxz = gz.(xz)
    ylo, yhi = 0.0, maximum(gxz)
    if isvert
        qz = Float64.(Q.(big.(xz)) .- fp_big)
        ylo = min(ylo, minimum(qz))
    end
    pad = 0.08 * (yhi - ylo)
    zy = (ylo - pad, yhi + 1.5pad)
    if e.kind == :triple
        dir = e.fp0 < 0 ? "f′(p₀) = $(fmt(e.fp0)) < 0, so h > 0" : "f′(p₀) = $(fmt(e.fp0)) > 0, so h < 0"
        ztitle = "k = $(k): new triple from p₀, $(dir)\n" * test_str(y)
    elseif e.kind == :halve || e.kind == :double
        qn = "q" * sub(3k + 2) * "," * sub(e.j)
        ztitle = (e.kind == :halve ? "halved" : "doubled") *
                 ": h = $(fmt(e.h)), new point $(qn) = $(fmtx(e.new, w))\n" * test_str(y)
    else
        err = abs(Float64(big(e.new) - p_big))
        nd = clamp(ceil(Int, -log10(err)) + 1, 4, 10)
        ztitle = "vertex of Q: $(vname) = $(@sprintf("%#.*g", nd, e.new)), |$(vname) − p| = $(fmt(err))\n" *
                 (e.Err <= epsilon ? "Err = $(fmt(e.Err)) ≤ 10⁻⁶: stop after $(nfev) calls of f" :
                                     "Err = $(fmt(e.Err)) > 10⁻⁶: restart, h = $(fmt(e.newh))")
    end
    xt = collect(p)
    p2 = plot(xlims=zx, ylims=zy, xlabel="x", ylabel="f(x) − f(p)",
              title=ztitle, titlefontsize=10, legend=false, grid=true,
              framestyle=:box, background_color=:white,
              xticks=(xt, fmtx.(xt, w)), yformatter=v -> @sprintf("%+.2e", v))
    plot!(p2, xz, gxz; color=:magenta, lw=2)
    span_fill!(p2, lo, hi, gz, zy[1])
    zx[1] < p_true < zx[2] && vline!(p2, [p_true]; color=:green, ls=:dash, lw=1)
    isvert && plot!(p2, xz, ydraw.(qz, Ref(zy)); color=:black, ls=:dash, lw=1.5)
    scatter!(p2, collect(p), gz.(collect(p)); color=:red, ms=6, msw=0)
    if isvert
        scatter!(p2, [e.new], [Float64(Q(big(e.new)) - fp_big)]; color=:white, msc=:black, msw=1.5, ms=6)
        scatter!(p2, [e.new], [gz(e.new)]; color=:blue, ms=6, msw=0)
    elseif e.kind != :triple
        scatter!(p2, [e.new], [gz(e.new)]; color=:blue, ms=6, msw=0)
    end

    plot(p1, p2; layout=grid(2, 1, heights=[0.55, 0.45]), size=(640, 900),
         left_margin=8Plots.mm, right_margin=4Plots.mm)
end

n = length(events)
frames = [collect(1:n); fill(n, 2)]      # hold the last frame
anim = @animate for i in frames
    draw_frame(i)
end

gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: ", gif_name)
