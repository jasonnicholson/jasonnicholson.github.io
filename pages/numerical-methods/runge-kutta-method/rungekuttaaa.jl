# rungekuttaaa.jl
# Runge-Kutta Method (RK4) animation: approximate y' = 1 - t*y^(1/3), y(0)=1
# Produces: rungekuttaaa.gif

using Plots
gr()

# --- ODE and parameters ---
f(t, y) = 1.0 - t * cbrt(y)
t0, y0 = 0.0, 1.0
T  = 5.0
n  = 80     # steps: h = 0.0625 keeps h*|df/dy| below RK4's limit 2.785 up to t = 5
h  = (T - t0) / n
stride = 4  # each frame adds `stride` RK4 steps (0.25 in t)

xlims = (-0.1, 5.1)   # small margins so the end point (5, 0.0081) is not clipped
ylims = (-0.05, 1.8)

title_str = "RK4, h = 0.0625: y' = 1 - t·y^(1/3),  y(0) = 1"

# --- Compute RK4 solution ---
ts = Vector{Float64}(undef, n+1)
ys = Vector{Float64}(undef, n+1)
ts[1] = t0;  ys[1] = y0
for i in 1:n
    t = ts[i];  y = ys[i]
    k1 = h * f(t,       y)
    k2 = h * f(t + h/2, y + k1/2)
    k3 = h * f(t + h/2, y + k2/2)
    k4 = h * f(t + h,   y + k3)
    ts[i+1] = t + h
    ys[i+1] = y + (k1 + 2k2 + 2k3 + k4)/6
end

# --- Animation: reveal the solution `stride` steps per frame ---
anim = @animate for frame in 1:stride:n+1
    plot(size=(640, 480), xlims=xlims, ylims=ylims,
         xlabel="t", ylabel="y", title=title_str,
         legend=false, grid=true, framestyle=:box,
         background_color=:white)

    # Connecting line segments so far
    if frame > 1
        plot!(ts[1:frame], ys[1:frame]; color=:steelblue, lw=2, label="")
    end

    # Current point
    scatter!([ts[frame]], [ys[frame]]; color=:red, ms=5, label="")

    # Annotation
    annotate!(2.5, 1.7, text("t=$(round(ts[frame]; digits=2))  y≈$(round(ys[frame]; digits=4))", :black, 10))
end

gif(anim, joinpath(@__DIR__, "rungekuttaaa.gif"); fps=3)
println("Saved: rungekuttaaa.gif")
