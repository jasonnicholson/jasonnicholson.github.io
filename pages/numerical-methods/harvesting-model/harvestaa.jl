# harvestaa.jl
# Harvesting Model animation, case (i) a^2 = 4bk: Mathews' Example 8,
# x' = 2x - x^2 - 1 (a = 2, b = 1, k = 1), one stationary solution x = 1.
# Mathews' modified Euler method in midpoint form,
#     y_{k+1} = y_k + h f(t_k + h/2, y_k + (h/2) f(t_k, y_k)),
# with m = 110 steps on each of his intervals: x0 = 6, 5, 4, 3, 2, 1, 4/5 on
# [0, 4], x0 = 3/5 on [0, 1.5], 2/5 on [0, 1] and 1/5 on [0, 0.5]. The family
# grows in time, all runs on one clock, in Mathews' window [0, 4] x [0, 6]
# (extended below to x = -1, shaded, so that the runs that continue past
# extinction are shown, and marked as no longer a population) and with his
# colours. Crosses mark the exact extinction times t0, dashed lines the
# asymptotes t1 inside the window. The right panel is new: the error
# |y_k - x(t_k)| against the exact solution, on a log scale.
# The method runs in double precision, as Mathews' did; the exact solution is
# evaluated in 256-bit arithmetic.
# Produces: harvestaa.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))
fmte(x) = um(@sprintf("%.3e", Float64(x)))

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

setprecision(BigFloat, 256)
const Q = Rational{BigInt}

# --- Parameters (Mathews' Example 8) ---
gif_name = "harvestaa.gif"
a, b, k  = 2, 1, 1
f(t, y)  = 2y - y^2 - 1                      # right-hand side, as Mathews codes it
m        = 110
# (x0, end of interval, Mathews' colour), in Mathews' order
# Mathews' colours (Mathematica's Graphics`Colors`), with his Green (0, 1, 0)
# darkened for legibility on white
mcol = Dict(:Blue => RGB(0, 0, 1), :Green => RGB(0, 0.75, 0), :Orange => RGB(1, 0.5, 0),
            :Red => RGB(1, 0, 0), :Brown => RGB(0.647, 0.165, 0.165), :Magenta => RGB(1, 0, 1))
runs = [(Q(6), Q(4), :Blue), (Q(5), Q(4), :Green), (Q(4), Q(4), :Orange),
        (Q(3), Q(4), :Red), (Q(2), Q(4), :Brown), (Q(1), Q(4), :Magenta),
        (Q(4, 5), Q(4), :Brown),
        (Q(3, 5), Q(3, 2), :Red), (Q(2, 5), Q(1), :Green), (Q(1, 5), Q(1, 2), :Blue)]
x0str(x0) = denominator(x0) == 1 ? string(numerator(x0)) :
            string(numerator(x0), "/", denominator(x0))
t1str(t1) = x0str(t1)                                # asymptotes are rational here

# Exact solution x(t) = 1 + (x0 - 1)/(1 + (x0 - 1) t), formula (5) with a = 2, b = 1,
# through the double-precision starting value the method uses (so the error is 0 at t = 0)
xexact(x0, t) = (x = BigFloat(Float64(x0)); 1 + (x - 1) / (1 + (x - 1) * t))
t0exact(x0) = x0 < 1 ? x0 / (1 - x0) : nothing     # extinction, x(t0) = 0
t1exact(x0) = x0 < 1 ? 1 / (1 - x0) : nothing      # vertical asymptote

tlims  = (0.0, 4.0)                                  # Mathews' window [0, 4] x [0, 6]
ylims  = (-1.0, 6.0)                                 # extended below 0 (shaded)
tticks = 0:1:4
yticks = -1:1:6
elims  = (1e-8, 1e-1)
# Drawn view: the window plus a small margin, so that the starting points on its
# edges show in full
tview  = (tlims[1] - 0.015 * (tlims[2] - tlims[1]), tlims[2])
yview  = (ylims[1], ylims[2] + 0.03 * (ylims[2] - ylims[1]))
statpts = [1.0]                                      # stationary solution a/(2b)
stat_lbl = "stationary solution x = 1"
n_frames = 40                                        # frame j shows t <= j * tmax/40
tmax   = Q(4)
title_str = "Harvesting, case (i) a² = 4bk (Mathews' Example 8):  x′ = 2x − x² − 1,  " *
            "modified Euler (midpoint form), m = 110"

# --- Modified Euler runs (double precision, Mathews' program) ---
function meuler(x0, bend)
    h = Float64(bend) / m
    T = [h * j for j in 0:m]
    Y = zeros(m + 1)
    Y[1] = Float64(x0)
    for j in 1:m
        Y[j+1] = Y[j] + h * f(T[j] + h / 2, Y[j] + h / 2 * f(T[j], Y[j]))
    end
    return T, Y
end
R = map(runs) do (x0, bend, col)
    T, Y = meuler(x0, bend)
    X = [xexact(x0, t) for t in T]                   # exact, 256-bit, at the grid
    X[1] = BigFloat(Y[1])                            # x(0) = starting value, exactly
    E = abs.(BigFloat.(Y) .- X)
    (x0=x0, bend=bend, col=mcol[col], T=T, Y=Y, X=X, E=E,
     t0=t0exact(x0), t1=t1exact(x0))
end
for r in R
    @printf("x0 = %-4s [0, %s]: y_110 = %.6f, exact x(b) = %.6f, max error = %s, max error while x >= 0 = %s\n",
            x0str(r.x0), x0str(r.bend), r.Y[end], Float64(r.X[end]), fmte(maximum(r.E)),
            fmte(maximum(r.E[r.X .>= 0])))
    r.t0 === nothing || @printf("    exact t0 = %.10g, t1 = %.10g\n", Float64(r.t0), Float64(r.t1))
end

# Frame j shows the grid points with t_k <= tau_j = j * tmax / n_frames (exact test)
visible(r, j) = [i for i in 0:m if i * r.bend * n_frames <= j * tmax * m] .+ 1

# Running largest error over the points shown while the exact x >= 0
function runmax(j)
    best = (BigFloat(0), Q(0), 0.0)
    for r in R, i in visible(r, j)
        if r.X[i] >= 0 && r.E[i] > best[1]
            best = (r.E[i], r.x0, r.T[i])
        end
    end
    return best
end

# Polyline of a run split where the computed curve crosses x = 0
function split_at_zero(T, Y)
    i = findfirst(<(0), Y)
    i === nothing && return (T, Y), (Float64[], Float64[])
    tz = T[i-1] + (T[i] - T[i-1]) * Y[i-1] / (Y[i-1] - Y[i])   # drawing only
    return (vcat(T[1:i-1], tz), vcat(Y[1:i-1], 0.0)), (vcat(tz, T[i:end]), vcat(0.0, Y[i:end]))
end

logdraw(e) = max(Float64(e), elims[1] / 10)

asym = sort([Float64(r.t1) for r in R if r.t1 !== nothing && r.t1 < tlims[2]])
asym_lbl = "asymptotes t₁ = " * join([t1str(r.t1) for r in sort(R, by=r -> r.x0)
                                      if r.t1 !== nothing && r.t1 < tlims[2]], ", ")

function draw_frame(j)
    tau = j * tmax / n_frames
    pL = plot(xlims=tview, ylims=yview, framestyle=:box, xlabel="t", ylabel="x",
              xticks=tticks, yticks=yticks, legend=:topright, legendfontsize=8,
              titlefontsize=10, grid=true)
    plot!(pL, Shape([tview[1], tview[2], tview[2], tview[1]], [ylims[1], ylims[1], 0, 0]);
          color=:gray88, linealpha=0, label="x < 0: past extinction, not a population")
    isempty(statpts) || hline!(pL, statpts; color=:black, ls=:dot, lw=1, label=stat_lbl)
    isempty(asym) || vline!(pL, asym; color=:gray45, ls=:dash, lw=1, label=asym_lbl)
    first_x = true
    for r in R
        idx = visible(r, j)
        (Ta, Ya), (Tb, Yb) = split_at_zero(r.T[idx], r.Y[idx])
        plot!(pL, Ta, ydraw.(Ya, Ref(ylims)); color=r.col, lw=2, label="")
        if !isempty(Tb)
            plot!(pL, Tb, ydraw.(Yb, Ref(ylims)); color=r.col, lw=1.5, ls=:dash, label="")
        end
        scatter!(pL, [r.T[idx[end]]], [ydraw(r.Y[idx[end]], ylims)]; color=r.col,
                 ms=3.5, msw=0, label="")
        if r.t0 !== nothing && r.t0 <= tau
            scatter!(pL, [Float64(r.t0)], [0.0]; color=:black, marker=:xcross, ms=6,
                     label=first_x ? "exact extinction time t₀" : "")
            first_x = false
        end
    end
    # A run whose newest point is below the window: say where it is
    off = [r for r in R if r.Y[visible(r, j)[end]] < ylims[1]]
    for (n, r) in enumerate(off)
        i = visible(r, j)[end]
        annotate!(pL, tlims[1] + 0.02 * (tlims[2] - tlims[1]),
                  ylims[1] + (0.12 + 0.1 * (n - 1)) * (0 - ylims[1]),
                  text("↓ x₀ = $(x0str(r.x0)) is below the window: y = $(fmt(r.Y[i])) at t = $(fmt(r.T[i]))",
                       8, :left, r.col))
    end
    title!(pL, j == 0 ? "t = 0:  the $(length(R)) starting values (Mathews' colours)" :
           "t ≤ $(fmt(tau)):  each run's points up to t (Mathews' intervals and colours)")

    pR = plot(xlims=tview, ylims=elims, yscale=:log10, framestyle=:box, xlabel="t",
              ylabel="|yₖ − x(tₖ)|", xticks=tticks, yticks=10.0 .^ (-8:-1),
              legend=:bottomright, legendfontsize=8, titlefontsize=10, grid=true)
    for r in R
        all(iszero, r.E) && continue                 # stationary start: error exactly 0
        idx = filter(>(1), visible(r, j))            # error is 0 at t = 0
        isempty(idx) && continue
        pos = [i for i in idx if r.X[i] >= 0]
        neg = [i for i in idx if r.X[i] < 0]
        plot!(pR, r.T[pos], logdraw.(r.E[pos]); color=r.col, lw=1.8, label="")
        if !isempty(neg)
            ii = isempty(pos) ? neg : vcat(pos[end], neg)
            plot!(pR, r.T[ii], logdraw.(r.E[ii]); color=r.col, lw=1.2, ls=:dot, label="")
        end
    end
    plot!(pR, [NaN], [NaN]; color=:gray30, lw=1.8, label="while exact x ≥ 0")
    plot!(pR, [NaN], [NaN]; color=:gray30, lw=1.2, ls=:dot, label="past extinction")
    for r in R
        all(iszero, r.E) && plot!(pR, [NaN], [NaN]; color=r.col, lw=1.8,
                                  label="x₀ = $(x0str(r.x0)): error exactly 0 (not drawn)")
    end
    e, x0b, tb = runmax(j)
    title!(pR, j == 0 ? "error is 0 at t = 0" :
           "largest error so far while x ≥ 0: $(fmte(e)) (x₀ = $(x0str(x0b)), t = $(fmt(tb)))")

    plot(pL, pR; layout=(1, 2), size=(1200, 540), plot_title=title_str,
         plot_titlefontsize=12, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white)
end

for j in 0:n_frames
    e, x0b, tb = runmax(j)
    @printf("frame %2d: t <= %s, running max error (x >= 0) = %s at x0 = %s, t = %s\n",
            j, fmt(j * tmax / n_frames), fmte(e), x0str(x0b), fmt(tb))
    for r in R
        i = visible(r, j)[end]
        r.Y[i] < ylims[1] && println("    below the window: x0 = ", x0str(r.x0),
                                     ", y = ", fmt(r.Y[i]), " at t = ", fmt(r.T[i]))
    end
end

anim = Animation()
for j in 0:n_frames
    draw_frame(j)
    frame(anim)
    if j == 0                                        # hold the starting values
        frame(anim); frame(anim)
    end
end
for _ in 1:12                                        # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=6)
println("Saved: ", gif_name)
