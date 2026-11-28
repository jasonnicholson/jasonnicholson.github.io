# rungekuttafehlbergaa.jl
# Runge-Kutta-Fehlberg method animation: adaptive RKF45 vs RKF54 on Example 1 IVP
# Produces: rungekuttafehlbergaa.gif

using Plots
gr()

f(t, y) = 1 + y^2
y_exact(t) = tan(t + atan(0.5))

function rkf_integrate(f, t0, tf, y0; h0=0.1, tol=1e-6, mode=:rkf45, hmin=1e-6, hmax=0.25)
    t = t0
    y = y0
    h = h0

    ts = Float64[t]
    ys = Float64[y]

    while t < tf
        if t + h > tf
            h = tf - t
        end

        k1 = h * f(t, y)
        k2 = h * f(t + h / 4, y + k1 / 4)
        k3 = h * f(t + 3h / 8, y + 3k1 / 32 + 9k2 / 32)
        k4 = h * f(t + 12h / 13, y + 1932k1 / 2197 - 7200k2 / 2197 + 7296k3 / 2197)
        k5 = h * f(t + h, y + 439k1 / 216 - 8k2 + 3680k3 / 513 - 845k4 / 4104)
        k6 = h * f(t + h / 2, y - 8k1 / 27 + 2k2 - 3544k3 / 2565 + 1859k4 / 4104 - 11k5 / 40)

        y4 = y + 25k1 / 216 + 1408k3 / 2565 + 2197k4 / 4104 - k5 / 5
        y5 = y + 16k1 / 135 + 6656k3 / 12825 + 28561k4 / 56430 - 9k5 / 50 + 2k6 / 55

        err = abs(y5 - y4)   # local error estimate for y4; scales like h^5

        # RKF rule: tolerance per unit step, accept if err/h <= tol, s = 0.84*(tol*h/err)^(1/4)
        if err <= tol * h || h <= hmin
            t += h
            y = mode == :rkf45 ? y4 : y5
            push!(ts, t)
            push!(ys, y)
        end

        s = err == 0.0 ? 2.0 : 0.84 * (tol * h / err)^(1 / 4)
        h = clamp(s * h, hmin, hmax)
    end

    return ts, ys
end

t0 = 0.0
tf = 1.1
y0 = 0.5
tol = 1e-6

ts45, ys45 = rkf_integrate(f, t0, tf, y0; h0=0.1, tol=tol, mode=:rkf45)
ts54, ys54 = rkf_integrate(f, t0, tf, y0; h0=0.1, tol=tol, mode=:rkf54)

x_ref = range(t0, tf, length=800)
y_ref = y_exact.(x_ref)

xlims = (-0.02, 1.12)  # small margins so the start and end markers are not clipped
# Log y-axis: y(1.1) = 139.9 (pole of tan at t = 1.1071), so a linear window would clip the end of the run
ylims = (0.4, 200.0)
yticks = ([0.5, 1, 2, 5, 10, 20, 50, 100], ["0.5", "1", "2", "5", "10", "20", "50", "100"])

n_points = max(length(ts45), length(ts54))
stride = 4  # each frame adds up to `stride` accepted steps (the steps crowd together near t = 1.1)
frames = unique(vcat(collect(1:stride:n_points), n_points))

anim = @animate for frame in frames
    n45 = min(frame, length(ts45))
    n54 = min(frame, length(ts54))

    plot(
        size=(640, 480),
        xlims=xlims,
        ylims=ylims,
        yscale=:log10,
        yticks=yticks,
        xlabel="t",
        ylabel="y (log scale)",
        title="RKF45/RKF54: y' = 1 + y^2, y(0)=0.5, tol=1e-6",
        legend=:topleft,
        grid=true,
        framestyle=:box,
        background_color=:white,
    )

    plot!(x_ref, y_ref; color=:black, ls=:dash, lw=2.0, label="Exact y(t)")
    # RKF45 drawn wide underneath so it stays visible where RKF54 lies on top of it
    plot!(ts45[1:n45], ys45[1:n45]; color=:magenta, lw=5, label="RKF45")
    plot!(ts54[1:n54], ys54[1:n54]; color=:royalblue, lw=2, label="RKF54")

    scatter!([ts45[n45]], [ys45[n45]]; color=:magenta, ms=7, label="")
    scatter!([ts54[n54]], [ys54[n54]]; color=:royalblue, ms=4, label="")
end

gif(anim, joinpath(@__DIR__, "rungekuttafehlbergaa.gif"); fps=2)
println("Saved: rungekuttafehlbergaa.gif")
println("Accepted points: RKF45=$(length(ts45)), RKF54=$(length(ts54))")
