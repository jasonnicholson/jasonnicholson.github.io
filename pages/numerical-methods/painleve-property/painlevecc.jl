# painlevecc.jl
# Painleve Property animation: Mathews' pole-vaulting Runge-Kutta method on his
# Example 11, y' = x + y^2, y(0) = 1, on [0, 3.5] with m = 400 steps
# (h = 0.00875), B = 3. Exact solution y = -u'/u with u'' + x u = 0, u(0) = 1,
# u'(0) = -1, so u(x) = a Ai(-x) + b Bi(-x), a = pi (Bi'(0) - Bi(0)),
# b = pi (Ai(0) - Ai'(0)); its poles in [0, 3.5] are the zeros 0.9306 and
# 3.1235 of u. Companion equation Y' = g(x, Y) = -Y^2 (x + 1/Y^2) = -1 - x Y^2.
# Each step is a fourth-order Runge-Kutta step on y' = f(x, y) when |y_j| <= 3
# (magenta) and on Y' = g(x, Y) when |y_j| > 3 (orange), as in Mathews'
# subroutine PoleVaultRungeKutta. Top: the points (x_j, y_j) joined, on Mathews'
# window [0, 3.5] x [-15, 15], with the exact solution and plain RK4 (same h).
# Bottom: Y_j = 1/y_j with the exact Y = -u/u' and the band |Y| < 1/3.
# The joining line is broken where Y_j changes sign (the poles of y) and, in the
# bottom panel, where y_j changes sign (the pole of Y at the zero of u'),
# unlike Mathews' joined ListPlot, which draws a vertical line at each pole.
# Produces: painlevecc.gif

using Plots
using Printf
using SpecialFunctions
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0.
# Computed values keep 4 significant figures with trailing zeros. Exponents are
# written as x10 with superscripts; infinity as the symbol.
const SUP = Dict('0'=>'⁰','1'=>'¹','2'=>'²','3'=>'³','4'=>'⁴','5'=>'⁵','6'=>'⁶',
                 '7'=>'⁷','8'=>'⁸','9'=>'⁹','-'=>'⁻')
um(s) = replace(s, "-" => "−")
function fmt(x)
    isinf(x) && return x > 0 ? "∞" : "−∞"
    x == 0 && return "0"                   # only the initial value (asserted below)
    s = @sprintf("%#.4g", x)               # computed values: 4 s.f., zeros kept
    s = replace(s, r"\.(?=e|$)" => "")    # no bare trailing point ("2050." -> "2050")
    if occursin('e', s)
        m, e = split(s, 'e')
        e = string(parse(Int, e))
        s = m * "×10" * join(SUP[c] for c in e)
    end
    return um(s)
end
fx(x) = um(@sprintf("%.6g", x))          # grid points x_j = a + j h (exact to 6 s.f.)

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = isnan(y) ? NaN : clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

# --- Parameters (Mathews' Example 11) ---
gif_name = "painlevecc.gif"
f(x, y)  = x + y^2              # y' = f(x, y)
g(x, Y)  = -1 - x * Y^2         # companion Y' = g(x, Y) = -Y^2 f(x, 1/Y), simplified
# Exact solution y = -u'/u, u'' + x u = 0, u(0) = 1, u'(0) = -1 (Airy functions)
const ca = π * (airybiprime(0.0) - airybi(0.0))
const cb = π * (airyai(0.0) - airyaiprime(0.0))
u(x)  = ca * airyai(-x) + cb * airybi(-x)
up(x) = -ca * airyaiprime(-x) - cb * airybiprime(-x)
@assert abs(u(0.0) - 1) < 1e-14 && abs(up(0.0) + 1) < 1e-14
yexact(x) = -up(x) / u(x)
function bisect(F, lo, hi)      # simple root of F in [lo, hi]
    for _ in 1:200
        mid = (lo + hi) / 2
        sign(F(mid)) == sign(F(lo)) ? (lo = mid) : (hi = mid)
    end
    return (lo + hi) / 2
end
a, b, α, m = 0.0, 3.5, 1.0, 400
B        = 3.0
poles    = [bisect(u, 0.5, 1.5), bisect(u, 2.5, 3.4)]   # zeros of u: poles of y
yzeros   = [bisect(up, poles[1] + 0.01, poles[2] - 0.01)] # zero of u': pole of Y
@assert abs(poles[1] - 0.930564508526) < 1e-11 && abs(poles[2] - 3.123493003957) < 1e-11
pole_lbl = "poles x = $(@sprintf("%.4f", poles[1])), $(@sprintf("%.4f", poles[2]))"
xlims    = (a, b)
ylims    = (-15.0, 15.0)        # Mathews' PlotRange
Ylims    = (-2.0, 2.0)
xticks   = 0:0.5:3.5
fstr, gstr = "y′ = x + y²", "Y′ = −1 − xY²"
title_str = "Pole vaulting (Mathews' Example 11):  y′ = x + y²,  y(0) = 1,  RK4 with h = 0.00875,  B = 3"
exact_lbl = "exact y = −u′/u  (Airy functions)"
Yexact_lbl = "exact Y = −u/u′"
stride   = 8                    # frame every `stride` steps, every step near events
legpos_top, legpos_bot = :outerbottom, :bottomleft
fps_out  = 5

# --- The method ---
function rk4(F, x, u, h)
    k1 = h * F(x, u)
    k2 = h * F(x + h / 2, u + k1 / 2)
    k3 = h * F(x + h / 2, u + k2 / 2)
    k4 = h * F(x + h, u + k3)
    return u + (k1 + 2k2 + 2k3 + k4) / 6
end
h  = (b - a) / m
xs = [a + j * h for j in 0:m]
ys = zeros(m + 1); Ys = zeros(m + 1)
useY = falses(m)                # useY[j+1]: the step from x_j to x_{j+1} is on Y' = g
ys[1] = α; Ys[1] = 1 / α
for j in 1:m
    if abs(ys[j]) <= B
        ys[j+1] = rk4(f, xs[j], ys[j], h); Ys[j+1] = 1 / ys[j+1]
    else
        useY[j] = true
        Ys[j+1] = rk4(g, xs[j], Ys[j], h); ys[j+1] = 1 / Ys[j+1]
    end
end
# plain RK4 with the same step, for comparison
yp = zeros(m + 1); yp[1] = α
for j in 1:m
    yp[j+1] = rk4(f, xs[j], yp[j], h)
end
@assert all(!iszero, ys[2:end]) && all(!iszero, Ys[2:end])   # no computed value is 0.0
jover = findfirst(!isfinite, yp)            # first non-finite plain RK4 value (1-based)

# --- Events: switches, sign changes of Y in the Y phases, overflow ---
switches = [j for j in 2:m if useY[j] != useY[j-1]]          # 1-based index of x_L
signch   = [j for j in 1:m if useY[j] && Ys[j] * Ys[j+1] < 0]  # Y_j, Y_{j+1} differ in sign
interp   = [xs[j] - Ys[j] * (xs[j+1] - xs[j]) / (Ys[j+1] - Ys[j]) for j in signch]
ysign    = [j for j in 1:m if ys[j] * ys[j+1] < 0 && !useY[j]]  # y through 0 on a y step
for j in switches
    @printf("switch to %s at x = %s, y = %.10g\n", useY[j] ? "Y" : "y", fx(xs[j]), ys[j])
end
for (j, z) in zip(signch, interp)
    @printf("Y changes sign on [%s, %s]: interpolated zero %.10f\n", fx(xs[j]), fx(xs[j+1]), z)
end
jover === nothing || @printf("plain RK4 first non-finite at x = %s\n", fx(xs[jover]))
@printf("y(b) = %.12g, exact %.12g\n", ys[end], yexact(b))

# --- Exact curves on a fine grid, broken (NaN) at poles of y and of Y = 1/y ---
function broken_grid(breaks)
    xg = collect(range(a, b, length=3001))
    for c in breaks
        filter!(x -> abs(x - c) > 1e-9, xg)
        push!(xg, c)
    end
    sort!(xg)
    return xg, [any(abs(x - c) <= 1e-9 for c in breaks) for x in xg]
end
xg1, br1 = broken_grid(poles)
yg = [br ? NaN : ydraw(yexact(x), ylims) for (x, br) in zip(xg1, br1)]
xg2, br2 = broken_grid(yzeros)
Yg = [br ? NaN : ydraw(1 / yexact(x), Ylims) for (x, br) in zip(xg2, br2)]

# --- Joined computed points, one series per equation, broken at sign changes ---
# Step k (from x_k to x_{k+1}, 1-based) is drawn in the colour of its equation.
# The y panel leaves a gap where Y changes sign (through the pole), the Y panel
# where y changes sign (through a pole of Y).
function segments(vals, upto, which, gap, yl)
    px = Float64[]; py = Float64[]
    for k in 1:upto
        useY[k] == which || continue
        k in gap && continue
        y0, y1 = vals[k], vals[k+1]
        (isfinite(y0) && isfinite(y1)) || continue
        append!(px, [xs[k], xs[k+1], NaN]); append!(py, [ydraw(y0, yl), ydraw(y1, yl), NaN])
    end
    return px, py
end
function plain_segment(upto)
    last = jover === nothing ? upto + 1 : min(upto + 1, jover - 1)
    return xs[1:last], ydraw.(yp[1:last], Ref(ylims))
end

# --- Frames: every `stride` steps, and every step within 3 of an event ---
events = sort(unique(vcat(switches, signch .+ 1, jover === nothing ? Int[] : [jover])))
fr = Set(1:stride:m+1); push!(fr, m + 1)
for e in events, j in e-3:e+3
    1 <= j <= m + 1 && push!(fr, j)
end
frames_j = sort(collect(fr))
pause_at = Set(events)

const MAG, ORA, BLU = :magenta, :darkorange, :royalblue
band = RGBA(1.0, 0.55, 0.0, 0.12)

function draw_frame(J)                     # J: 1-based index of the latest point
    j = J - 1                              # step number
    upto = J - 1                           # steps drawn
    # top: y
    pT = plot(xlims=xlims, ylims=ylims, framestyle=:box, xlabel="x", ylabel="y",
              legend=legpos_top, legend_columns=2, legendfontsize=8, titlefontsize=10, grid=true,
              xticks=xticks, yticks=-15:5:15)
    plot!(pT, Shape([a, b, b, a], [B, B, ylims[2], ylims[2]]); color=band, linealpha=0,
          label="|y| > 3: next step on $gstr")
    plot!(pT, Shape([a, b, b, a], [ylims[1], ylims[1], -B, -B]); color=band, linealpha=0, label="")
    hline!(pT, [0.0]; color=:black, lw=0.5, label="")
    vline!(pT, poles; color=:gray40, ls=:dash, lw=1, label=pole_lbl)
    plot!(pT, xg1, yg; color=BLU, lw=4, alpha=0.35, label=exact_lbl)
    sx, sy = segments(ys, upto, false, signch, ylims)
    plot!(pT, sx, sy; color=MAG, lw=2, label="step on $fstr")
    sx, sy = segments(ys, upto, true, signch, ylims)
    plot!(pT, sx, sy; color=ORA, lw=2, label="step on $gstr,  y = 1/Y")
    px, py = plain_segment(upto)
    plain_lbl = jover !== nothing && J >= jover ?
        "plain RK4: overflow (Inf) at x = $(fx(xs[jover]))" :
        "plain RK4, same h: y = $(fmt(yp[J]))"
    plot!(pT, px, py; color=:black, lw=1.2, ls=:dot, label=plain_lbl)
    col = j == 0 ? :black : (useY[j] ? ORA : MAG)
    # legend entry always present, so that the legend (below the axes) keeps its size
    scatter!(pT, [NaN], [NaN]; color=:gray60, ms=7, marker=:utriangle,
             label="current point off the scale (drawn at the edge)")
    if abs(ys[J]) <= ylims[2]
        scatter!(pT, [xs[J]], [ys[J]]; color=col, ms=6, label="")
    else                                   # off the scale: arrowhead on the frame edge
        scatter!(pT, [xs[J]], [sign(ys[J]) * ylims[2] * 0.97]; color=col, ms=7,
                 marker=ys[J] > 0 ? :utriangle : :dtriangle, label="")
    end
    how = j == 0 ? "initial value" : (useY[j] ? "from a step on Y′" : "from a step on y′")
    title!(pT, "j = $j,  x = $(fx(xs[J])):  y = $(fmt(ys[J]))  ($how)")

    # bottom: Y = 1/y
    pB = plot(xlims=xlims, ylims=Ylims, framestyle=:box, xlabel="x", ylabel="Y = 1/y",
              legend=legpos_bot, legendfontsize=8, titlefontsize=10, grid=true,
              xticks=xticks)
    plot!(pB, Shape([a, b, b, a], [-1/B, -1/B, 1/B, 1/B]); color=band, linealpha=0,
          label="|Y| < 1/3")
    hline!(pB, [0.0]; color=:black, lw=0.5, label="")
    vline!(pB, poles; color=:gray40, ls=:dash, lw=1, label="")
    plot!(pB, xg2, Yg; color=BLU, lw=4, alpha=0.35, label=Yexact_lbl)
    sx, sy = segments(Ys, upto, false, ysign, Ylims)
    plot!(pB, sx, sy; color=MAG, lw=2, label="")
    sx, sy = segments(Ys, upto, true, ysign, Ylims)
    plot!(pB, sx, sy; color=ORA, lw=2, label="")
    if isfinite(Ys[J]) && abs(Ys[J]) <= Ylims[2]
        scatter!(pB, [xs[J]], [Ys[J]]; color=col, ms=6, label="")
    end
    done = [k for (k, jj) in enumerate(signch) if jj + 1 <= J]
    if !isempty(done)
        scatter!(pB, interp[done], zeros(length(done)); color=:black, marker=:x, ms=8,
                 label="zero of Y, linear interpolation")
        # its value, where Y has the other sign: above right, or below left near the edge
        for k in done
            zs = @sprintf("%.10f", interp[k])
            if interp[k] < xlims[1] + 0.8 * (xlims[2] - xlims[1])
                annotate!(pB, interp[k] + 0.012 * (xlims[2] - xlims[1]), 0.45, text(zs, 8, :left))
            else
                annotate!(pB, interp[k] - 0.012 * (xlims[2] - xlims[1]), -0.45, text(zs, 8, :right))
            end
        end
    end
    nxt = J == m + 1 ? "end of the run" :
          (abs(ys[J]) <= B ? "next step on $fstr  (|y| ≤ 3)" : "next step on $gstr  (|y| > 3)")
    title!(pB, "Y = 1/y = $(fmt(Ys[J])):  $nxt")
    println("TITLE: ", "j = $j,  x = $(fx(xs[J])):  y = $(fmt(ys[J]))  ($how)", " | ",
            "Y = 1/y = $(fmt(Ys[J])):  $nxt", " | ", plain_lbl)
    plot(pT, pB; layout=grid(2, 1, heights=[0.64, 0.36]), size=(900, 900),
         plot_title=title_str, plot_titlefontsize=11, left_margin=4Plots.mm,
         background_color=:white)
end

anim = Animation()
for J in frames_j
    draw_frame(J)
    frame(anim)
    if J in pause_at || J == m + 1         # hold switches, sign changes, overflow, end
        for _ in 1:4
            frame(anim)
        end
    end
end
gif(anim, joinpath(@__DIR__, gif_name); fps=fps_out)
println("Saved: ", gif_name, " (", length(frames_j), " distinct frames)")
