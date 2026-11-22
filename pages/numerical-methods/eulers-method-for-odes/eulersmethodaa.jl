# eulersmethodaa.jl
# Euler's Method for ODE's animation: step-refinement sweep for y' = 1 - t*y^(1/3), y(0)=1 on [0,5]
# Each frame is a complete forward Euler run with m subintervals (h = 5/m), using the m sequence of
# Mathews' animation Euleraa.gif.
# Produces: eulersmethodaa.gif

using Plots
using Printf
gr()

# --- ODE and parameters ---
f(t, y)  = 1.0 - t * cbrt(y)              # cbrt is the real cube root (Mathews: Sign[y] Abs[y]^(1/3))
fy(t, y) = -t / (3 * cbrt(y)^2)          # ∂f/∂y
t0, y0 = 0.0, 1.0
T  = 5.0
ms = [10, 15, 20, 25, 30, 35, 40, 45, 50, 55, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150]

xlims = (-0.1, 5.1)
ylims = (-0.55, 1.9)    # every computed value of every run lies inside (min -0.4624 at m = 10, max 1.7775 at m = 10)

# --- Forward Euler with m subintervals on [t0, T] ---
function euler(m)
    h  = (T - t0) / m
    ts = [t0 + i*h for i in 0:m]
    ys = Vector{Float64}(undef, m+1)
    ys[1] = y0
    for i in 1:m
        ys[i+1] = ys[i] + h * f(ts[i], ys[i])
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

# --- Euler stability limit on the negative real axis: |1 + z| <= 1 exactly for -2 <= z <= 0 ---
zlim = 2.0

# Onset time: first t where h*|∂f/∂y| along the reference solution exceeds the limit (nothing if never)
function onset(h)
    for i in eachindex(tref)
        h * abs(fy(tref[i], yref[i])) > zlim && return tref[i]
    end
    return nothing
end

# --- Animation: one complete Euler run per frame ---
anim = @animate for m in ms
    ts, ys = euler(m)
    all(ylims[1] .< ys .< ylims[2]) || error("m = $m leaves the plot window")
    h   = (T - t0) / m
    ton = onset(h)

    plot(size=(640, 480), xlims=xlims, ylims=ylims,
         xlabel="t", ylabel="y",
         title="Euler's method for y' = 1 - t·y^(1/3), y(0) = 1\nm = $m subintervals, h = 5/$m",
         titlefontsize=11, legend=:bottomleft, grid=true, framestyle=:box,
         background_color=:white)

    if ton !== nothing
        vspan!([ton, T]; color=:red, alpha=0.10, lw=0, label="h·|∂f/∂y| > 2")
    end
    plot!(tref, yref; color=:gray70, lw=4, label="reference solution")
    plot!(ts, ys; color=:magenta, lw=2, marker=:circle, ms=2.5, msw=0, label="Euler, m = $m")
    scatter!([ts[end]], [ys[end]]; color=:red, ms=5, msw=0, label="")

    stab_txt = ton === nothing ? "h·|∂f/∂y| < 2 up to t = 5" :
                                 @sprintf("h·|∂f/∂y| > 2 from t ≈ %.2f", ton)
    annotate!(0.05, 0.62, text(@sprintf("y(5) = %.7f", ys[end]), :black, 10, :left))
    annotate!(0.05, 0.50, text(@sprintf("error = %+.1e", ys[end] - yex5), :black, 10, :left))
    annotate!(0.05, 0.38, text(@sprintf("reference y(5) = %.7f", yex5), :gray40, 9, :left))
    annotate!(0.05, 0.27, text(stab_txt, :gray40, 9, :left))
end

gif(anim, joinpath(@__DIR__, "eulersmethodaa.gif"); fps=1)
println("Saved: eulersmethodaa.gif")
