# heunsmethodaa.jl
# Heun's Method animation: step-refinement sweep for y' = 1 - t*y^(1/3), y(0)=1 on [0,5]
# Heun's method: Euler predictor, trapezoidal corrector
#   p_{k+1} = y_k + h*f(t_k, y_k)
#   y_{k+1} = y_k + (h/2)*(f(t_k, y_k) + f(t_{k+1}, p_{k+1}))
# Each frame is a complete run with m subintervals (h = 5/m), using the m sequence of
# Mathews' animation Heunaa.gif. Same reference curve, labels and stability band as the
# Euler page's cases (eulersmethodaa.jl, eulersmethodbb.jl).
# Produces: heunsmethodaa.gif

using Plots
using Printf
gr()

# --- ODE and parameters ---
f(t, y)  = 1.0 - t * cbrt(y)              # cbrt is the real cube root (Mathews: Sign[y] Abs[y]^(1/3));
                                          # for 3 <= m <= 68 some predictions p_{k+1} are negative (at m = 2, y_1 is)
fy(t, y) = -t / (3 * cbrt(y)^2)          # ∂f/∂y
t0, y0 = 0.0, 1.0
T  = 5.0
ms = [12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 70, 80, 90, 100, 120, 150]

xlims = (-0.1, 5.1)
ylims = (-0.55, 1.9)    # same window as the Euler page; every computed value lies inside (min 0.0081 at m = 150, max 1.4497)

# --- Heun's method with m subintervals on [t0, T] ---
function heun(m)
    h  = (T - t0) / m
    ts = [t0 + i*h for i in 0:m]
    ys = Vector{Float64}(undef, m+1)
    ys[1] = y0
    for i in 1:m
        k1 = f(ts[i], ys[i])
        p  = ys[i] + h * k1                   # Euler predictor
        ys[i+1] = ys[i] + (h/2) * (k1 + f(ts[i+1], p))   # trapezoidal corrector
    end
    return ts, ys
end

# --- Reference solution (RK4 with 50000 steps; error far below plotting resolution) ---
function rk4(m)
    h  = (T - t0) / m
    ts = [t0 + i*h for i in 0:m]
    ys = Vector{Float64}(undef, m+1)
    ys[1] = y0
    for i in 1:m
        t = ts[i];  y = ys[i]
        k1 = h * f(t,       y)
        k2 = h * f(t + h/2, y + k1/2)
        k3 = h * f(t + h/2, y + k2/2)
        k4 = h * f(t + h,   y + k3)
        ys[i+1] = y + (k1 + 2k2 + 2k3 + k4)/6
    end
    return ts, ys
end
tref, yref = rk4(50_000)
yex5 = yref[end]

# Reference values at the nodes of an m-step run: RK4 with k = cld(50000, m) substeps per node (at least 50000 steps)
function refnodes(m)
    k = cld(50_000, m)
    _, yr = rk4(m * k)
    return yr[1:k:end]
end

# --- Heun stability limit on the negative real axis: R(z) = 1 + z + z^2/2 satisfies |R(z)| <= 1
#     exactly for -2 <= z <= 0 (R >= 1/2 for all real z, R(-2) = R(0) = 1), the same limit as Euler ---
zlim = 2.0

# Onset time: first t where h*|∂f/∂y| along the reference solution exceeds the limit (nothing if never)
function onset(h)
    for i in eachindex(tref)
        h * abs(fy(tref[i], yref[i])) > zlim && return tref[i]
    end
    return nothing
end

# --- Animation: one complete Heun run per frame ---
anim = @animate for m in ms
    ts, ys = heun(m)
    all(ylims[1] .< ys .< ylims[2]) || error("m = $m leaves the plot window")
    h   = (T - t0) / m
    ton = onset(h)
    err  = ys .- refnodes(m)                 # error at every node of the run
    imax = argmax(abs.(err))

    plot(size=(640, 480), xlims=xlims, ylims=ylims,
         xlabel="t", ylabel="y",
         title="Heun's method for y' = 1 - t·y^(1/3), y(0) = 1\nm = $m subintervals, h = 5/$m",
         titlefontsize=11, legend=:bottomleft, grid=true, framestyle=:box,
         background_color=:white)

    if ton !== nothing
        vspan!([ton, T]; color=:red, alpha=0.10, lw=0, label="h·|∂f/∂y| > 2")
    end
    plot!(tref, yref; color=:gray70, lw=4, label="reference solution")
    plot!(ts, ys; color=:magenta, lw=2, marker=:circle, ms=2.5, msw=0, label="Heun, m = $m")
    scatter!([ts[end]], [ys[end]]; color=:red, ms=5, msw=0, label="")

    stab_txt = ton === nothing ? "h·|∂f/∂y| < 2 up to t = 5" :
                                 @sprintf("h·|∂f/∂y| > 2 from t ≈ %.2f", ton)
    annotate!(0.05, 0.73, text(@sprintf("y(5) = %.7f", ys[end]), :black, 10, :left))
    annotate!(0.05, 0.61, text(@sprintf("error at t = 5: %+.1e", err[end]), :black, 10, :left))
    annotate!(0.05, 0.49, text(@sprintf("max |error| = %.1e at t = %.2f", abs(err[imax]), ts[imax]), :black, 10, :left))
    annotate!(0.05, 0.38, text(@sprintf("reference y(5) = %.7f", yex5), :gray40, 9, :left))
    annotate!(0.05, 0.27, text(stab_txt, :gray40, 9, :left))
end

gif(anim, joinpath(@__DIR__, "heunsmethodaa.gif"); fps=1)
println("Saved: heunsmethodaa.gif")
