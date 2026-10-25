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

        err = abs(y5 - y4)

        if err <= tol || h <= hmin
            t += h
            y = mode == :rkf45 ? y4 : y5
            push!(ts, t)
            push!(ys, y)
        end

        s = err == 0.0 ? 2.0 : 0.84 * (tol / err)^(1 / 4)
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

xlims = (0.0, 1.1)
ylims = (0.0, 20.0)

n_frames = max(length(ts45), length(ts54))

anim = @animate for frame in 1:n_frames
    n45 = min(frame, length(ts45))
    n54 = min(frame, length(ts54))

    plot(
        size=(640, 480),
        xlims=xlims,
        ylims=ylims,
        xlabel="t",
        ylabel="y",
        title="RKF45/RKF54: y' = 1 + y^2, y(0)=0.5, tol=1e-6",
        legend=:topleft,
        grid=true,
        framestyle=:box,
        background_color=:white,
    )

    plot!(x_ref, y_ref; color=:black, ls=:dash, lw=2.0, label="Exact y(t)")
    plot!(ts45[1:n45], ys45[1:n45]; color=:magenta, lw=2.2, label="RKF45")
    plot!(ts54[1:n54], ys54[1:n54]; color=:royalblue, lw=2.2, label="RKF54")

    scatter!([ts45[n45]], [ys45[n45]]; color=:magenta, ms=4, label="")
    scatter!([ts54[n54]], [ys54[n54]]; color=:royalblue, ms=4, label="")
end

gif(anim, joinpath(@__DIR__, "rungekuttafehlbergaa.gif"); fps=2)
println("Saved: rungekuttafehlbergaa.gif")
println("Accepted points: RKF45=$(length(ts45)), RKF54=$(length(ts54))")
