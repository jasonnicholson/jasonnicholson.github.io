# eulersmethodbb.jl
# Euler's Method for ODE's animation: modified Euler (midpoint) step-refinement sweep for y' = 1 - t*y^(1/3), y(0)=1 on [0,5]
# Mathews' "Modified Euler" method is the explicit midpoint method (his MEuler subroutine):
#   y_{k+1} = y_k + h*f(t_k + h/2, y_k + (h/2)*f(t_k, y_k))
# Each frame is a complete run with m subintervals (h = 5/m), using the m sequence of
# Mathews' animation MEuleraa.gif.
# Produces: eulersmethodbb.gif

using Plots
using Printf
gr()

# --- ODE and parameters ---
f(t, y)  = 1.0 - t * cbrt(y)              # cbrt is the real cube root (Mathews: Sign[y] Abs[y]^(1/3))
fy(t, y) = -t / (3 * cbrt(y)^2)          # ∂f/∂y
t0, y0 = 0.0, 1.0
T  = 5.0
ms = [12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 70, 80, 90, 100, 120, 150]

xlims = (-0.1, 5.1)
ylims = (-0.55, 1.9)    # same window as Case 1; every computed value lies inside (min 0.0081 at m = 150, max 1.4497)

# --- Modified Euler (midpoint) with m subintervals on [t0, T] ---
function meuler(m)
    h  = (T - t0) / m
    ts = [t0 + i*h for i in 0:m]
    ys = Vector{Float64}(undef, m+1)
    ys[1] = y0
    for i in 1:m
        ys[i+1] = ys[i] + h * f(ts[i] + h/2, ys[i] + (h/2) * f(ts[i], ys[i]))
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

# --- Midpoint stability limit on the negative real axis: R(z) = 1 + z + z^2/2 satisfies |R(z)| <= 1
#     exactly for -2 <= z <= 0 (R >= 1/2 for all real z, R(-2) = R(0) = 1), the same limit as Euler ---
zlim = 2.0

# Onset time: first t where h*|∂f/∂y| along the reference solution exceeds the limit (nothing if never)
function onset(h)
    for i in eachindex(tref)
        h * abs(fy(tref[i], yref[i])) > zlim && return tref[i]
    end
    return nothing
end

# --- Animation: one complete modified Euler run per frame ---
anim = @animate for m in ms
    ts, ys = meuler(m)
    all(ylims[1] .< ys .< ylims[2]) || error("m = $m leaves the plot window")
    h   = (T - t0) / m
    ton = onset(h)

    plot(size=(640, 480), xlims=xlims, ylims=ylims,
         xlabel="t", ylabel="y",
         title="Modified Euler (midpoint) for y' = 1 - t·y^(1/3), y(0) = 1\nm = $m subintervals, h = 5/$m",
         titlefontsize=11, legend=:bottomleft, grid=true, framestyle=:box,
         background_color=:white)

    if ton !== nothing
        vspan!([ton, T]; color=:red, alpha=0.10, lw=0, label="h·|∂f/∂y| > 2")
    end
    plot!(tref, yref; color=:gray70, lw=4, label="reference solution")
    plot!(ts, ys; color=:magenta, lw=2, marker=:circle, ms=2.5, msw=0, label="modified Euler, m = $m")
    scatter!([ts[end]], [ys[end]]; color=:red, ms=5, msw=0, label="")

    stab_txt = ton === nothing ? "h·|∂f/∂y| < 2 up to t = 5" :
                                 @sprintf("h·|∂f/∂y| > 2 from t ≈ %.2f", ton)
    annotate!(0.05, 0.62, text(@sprintf("y(5) = %.7f", ys[end]), :black, 10, :left))
    annotate!(0.05, 0.50, text(@sprintf("error = %+.1e", ys[end] - yex5), :black, 10, :left))
    annotate!(0.05, 0.38, text(@sprintf("reference y(5) = %.7f", yex5), :gray40, 9, :left))
    annotate!(0.05, 0.27, text(stab_txt, :gray40, 9, :left))
end

gif(anim, joinpath(@__DIR__, "eulersmethodbb.gif"); fps=1)
println("Saved: eulersmethodbb.gif")
