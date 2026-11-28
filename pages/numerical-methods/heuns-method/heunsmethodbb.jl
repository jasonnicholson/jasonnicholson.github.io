# heunsmethodbb.jl
# Heun's Method animation: error against step size h on log-log axes for Euler's method,
# Mathews' modified Euler method (the explicit midpoint method) and Heun's method,
# on y' = 1 - t*y^(1/3), y(0)=1 on [0,5]. New animation; Mathews made none.
#   Euler:     y_{k+1} = y_k + h*f(t_k, y_k)
#   midpoint:  y_{k+1} = y_k + h*f(t_k + h/2, y_k + (h/2)*f(t_k, y_k))
#   Heun:      p_{k+1} = y_k + h*f(t_k, y_k),  y_{k+1} = y_k + (h/2)*(f(t_k, y_k) + f(t_{k+1}, p_{k+1}))
# Each frame adds one step count m = 125, 250, ..., 16000 (h = 5/m halves from frame to frame) to two
# panels: the error at t = 5 and the largest error at any grid point. Every run has h < 0.0485, so
# h*|∂f/∂y| along the reference solution stays below the stability limit 2 of all three methods.
# Produces: heunsmethodbb.gif

using Plots
using Printf
gr()

# --- ODE and parameters ---
f(t, y) = 1.0 - t * cbrt(y)              # cbrt is the real cube root, as in heunsmethodaa.jl
t0, y0 = 0.0, 1.0
T  = 5.0
ms = [125 * 2^k for k in 0:7]            # 125 ... 16000, h = 0.04 ... 3.125e-4

# --- One step of each method ---
euler_step(t, y, h) = y + h * f(t, y)
mid_step(t, y, h)   = y + h * f(t + h/2, y + (h/2) * f(t, y))
function heun_step(t, y, h)
    k1 = f(t, y)
    p  = y + h * k1                       # Euler predictor
    return y + (h/2) * (k1 + f(t + h, p)) # trapezoidal corrector
end
function rk4_step(t, y, h)
    k1 = h * f(t,       y)
    k2 = h * f(t + h/2, y + k1/2)
    k3 = h * f(t + h/2, y + k2/2)
    k4 = h * f(t + h,   y + k3)
    return y + (k1 + 2k2 + 2k3 + k4)/6
end

# A run of m steps on [t0, T]; returns y at every node
function solve(step, m)
    h  = (T - t0) / m
    ys = Vector{Float64}(undef, m+1)
    ys[1] = y0
    for i in 1:m
        ys[i+1] = step(t0 + (i-1)*h, ys[i], h)
    end
    return ys
end

# Reference values at the nodes of an m-step run: RK4 with 400000 steps (400000/m substeps per node)
const NREF = 400_000
const YREF = solve(rk4_step, NREF)
function refnodes(m)
    k = div(NREF, m)
    @assert m * k == NREF
    return YREF[1:k:end]
end

# --- Errors (computed minus reference) for every m ---
methods = [("Euler",                    euler_step, :royalblue,  :circle),
           ("modified Euler (midpoint)", mid_step,   :darkorange, :square),
           ("Heun",                     heun_step,  :magenta,    :diamond)]
hs  = [(T - t0) / m for m in ms]
yrefs = Dict(m => refnodes(m) for m in ms)
err5 = [solve(st, m)[end] - yrefs[m][end] for (_, st, _, _) in methods, m in ms]                 # error at t = 5
emax = [maximum(abs.(solve(st, m) .- yrefs[m])) for (_, st, _, _) in methods, m in ms]          # largest |error| on the grid
for (j, m) in enumerate(ms), i in 1:3
    err5[i, j] != 0 || error("zero error at t = 5 cannot be drawn on log axes")
end

xl = (2.0e-4, 6.0e-2)
yl = (1.0e-11, 1.0e1)
hline = [xl[1], xl[2]]

# Slope of log|error| against log h over the last halving of h
slope(e, j) = j == 1 ? NaN : log(abs(e[j-1]) / abs(e[j])) / log(hs[j-1] / hs[j])
stxt(s) = isnan(s) ? "–" : @sprintf("%.2f", s)

function panel(E, ttl, n; showlegend)
    p = plot(xscale=:log10, yscale=:log10, xlims=xl, ylims=yl,
             xlabel="step size h", ylabel="|error|", title=ttl, titlefontsize=10,
             legend=showlegend ? :bottomright : false, legendfontsize=8,
             grid=true, framestyle=:box, minorgrid=false,
             yticks=10.0 .^ (-11:2:1), xticks=([1e-3, 1e-2], ["10⁻³", "10⁻²"]))
    # guide lines through the finest-h point of Euler (slope 1) and Heun (slope 2)
    plot!(p, hline, abs(E[1, end]) .* (hline ./ hs[end]);   color=:gray55, ls=:dot, lw=1.5, label="slope 1 (∝ h)")
    plot!(p, hline, abs(E[3, end]) .* (hline ./ hs[end]).^2; color=:gray55, ls=:dash, lw=1.5, label="slope 2 (∝ h²)")
    for (i, (name, _, col, mk)) in enumerate(methods)
        plot!(p, hs[1:n], abs.(E[i, 1:n]); color=col, lw=2, marker=mk, ms=4, msw=0, label=name)
    end
    annotate!(p, 2.6e-4, 3.0, text("slope over the last halving of h", :black, 8, :left))
    for (i, (name, _, col, _)) in enumerate(methods)
        nm = i == 2 ? "midpoint" : name
        annotate!(p, 2.6e-4, 3.0 * 0.2^i, text(nm, col, 8, :left))
        annotate!(p, 1.1e-3, 3.0 * 0.2^i, text(stxt(slope(E[i, :], n)), col, 8, :left))
    end
    return p
end

anim = @animate for n in vcat(1:length(ms), fill(length(ms), 2))    # last frame shown three times
    m = ms[n]
    p1 = panel(err5, "|error at t = 5|", n; showlegend=false)
    p2 = panel(emax, "largest |error| at any grid point", n; showlegend=true)
    plot(p1, p2; layout=(1, 2), size=(1000, 480), left_margin=4Plots.mm, bottom_margin=4Plots.mm,
         background_color=:white,
         plot_title="Euler, midpoint and Heun for y' = 1 - t·y^(1/3), y(0) = 1:  " *
                    (n == 1 ? "m = 125, h = 0.04" :
                              @sprintf("m = 125 to %d (doubling), newest h = %.4g", m, hs[n])),
         plot_titlefontsize=11)
end

gif(anim, joinpath(@__DIR__, "heunsmethodbb.gif"); fps=1)
println("Saved: heunsmethodbb.gif")
