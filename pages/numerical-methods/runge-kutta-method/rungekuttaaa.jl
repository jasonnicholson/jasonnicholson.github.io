# rungekuttaaa.jl
# Runge-Kutta Method (RK4) animation: step-refinement sweep for y' = 1 - t*y^(1/3), y(0)=1 on [0,5]
# Each frame is a complete RK4 run with m subintervals (h = 5/m), using Mathews' sequence of m.
# Produces: rungekuttaaa.gif

using Plots
using Printf
gr()

# --- ODE and parameters ---
f(t, y)  = 1.0 - t * cbrt(y)
fy(t, y) = -t / (3 * cbrt(y)^2)          # ∂f/∂y
t0, y0 = 0.0, 1.0
T  = 5.0
ms = [12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 70, 80, 90, 100, 120, 150]

xlims = (-0.1, 5.1)
ylims = (-0.05, 1.8)    # every computed value of every run lies inside (min 0.0081, max 1.4498)

# --- RK4 with m subintervals on [t0, T] ---
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

# --- Reference solution (RK4 with 50000 steps; error far below plotting resolution) ---
tref, yref = rk4(50_000)
yex5 = yref[end]

# --- RK4 stability limit on the negative real axis: |R(z)| = 1, R(z) = 1 + z + z^2/2 + z^3/6 + z^4/24 ---
R(z) = 1 + z + z^2/2 + z^3/6 + z^4/24
function stab_limit()
    a, b = -3.0, -2.0                    # |R(-3)| > 1, |R(-2)| < 1
    for _ in 1:200
        c = (a + b)/2
        abs(R(c)) > 1 ? (a = c) : (b = c)
    end
    return -(a + b)/2
end
zlim = stab_limit()                      # 2.7853

# Onset time: first t where h*|∂f/∂y| along the reference solution exceeds the limit (nothing if never)
function onset(h)
    for i in eachindex(tref)
        h * abs(fy(tref[i], yref[i])) > zlim && return tref[i]
    end
    return nothing
end

# --- Animation: one complete RK4 run per frame ---
anim = @animate for m in ms
    ts, ys = rk4(m)
    h   = (T - t0) / m
    ton = onset(h)

    plot(size=(640, 480), xlims=xlims, ylims=ylims,
         xlabel="t", ylabel="y",
         title="RK4 for y' = 1 - t·y^(1/3), y(0) = 1\nm = $m subintervals, h = 5/$m",
         titlefontsize=11, legend=:topright, grid=true, framestyle=:box,
         background_color=:white)

    if ton !== nothing
        vspan!([ton, T]; color=:red, alpha=0.10, lw=0, label="h·|∂f/∂y| > $(round(zlim; digits=3))")
    end
    plot!(tref, yref; color=:gray70, lw=4, label="reference solution")
    plot!(ts, ys; color=:magenta, lw=2, marker=:circle, ms=2.5, msw=0, label="RK4, m = $m")
    scatter!([ts[end]], [ys[end]]; color=:red, ms=5, msw=0, label="")

    stab_txt = ton === nothing ? "h·|∂f/∂y| < $(round(zlim; digits=3)) up to t = 5" :
                                 @sprintf("h·|∂f/∂y| > %.3f from t ≈ %.2f", zlim, ton)
    annotate!(2.35, 1.22, text(@sprintf("y(5) = %.7f", ys[end]), :black, 10, :left))
    annotate!(2.35, 1.10, text(@sprintf("error = %+.1e", ys[end] - yex5), :black, 10, :left))
    annotate!(2.35, 0.98, text(@sprintf("reference y(5) = %.7f", yex5), :gray40, 9, :left))
    annotate!(2.35, 0.87, text(stab_txt, :gray40, 9, :left))
end

gif(anim, joinpath(@__DIR__, "rungekuttaaa.gif"); fps=1)
println("Saved: rungekuttaaa.gif")
