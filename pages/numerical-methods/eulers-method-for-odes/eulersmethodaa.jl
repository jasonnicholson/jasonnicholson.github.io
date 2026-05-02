# eulersmethodaa.jl
# Euler's Method for ODE's animation: forward Euler trajectory build
# Produces: eulersmethodaa.gif

using Plots
gr()

f(t, y) = 1 - t * cbrt(y)

function rk4_reference(f, t0, tf, y0, h)
    n_steps = Int(round((tf - t0) / h))
    ts = collect(range(t0, tf, length=n_steps + 1))
    ys = zeros(n_steps + 1)
    ys[1] = y0

    for i in 1:n_steps
        t = ts[i]
        y = ys[i]
        k1 = f(t, y)
        k2 = f(t + 0.5 * h, y + 0.5 * h * k1)
        k3 = f(t + 0.5 * h, y + 0.5 * h * k2)
        k4 = f(t + h, y + h * k3)
        ys[i + 1] = y + (h / 6.0) * (k1 + 2.0 * k2 + 2.0 * k3 + k4)
    end

    return ts, ys
end

t0 = 0.0
tf = 5.0
n_pts = 41
n_steps = n_pts - 1
h = (tf - t0) / n_steps
h_ref = 1e-4

ts = collect(range(t0, tf, length=n_pts))
ys = zeros(n_pts)
ys[1] = 1.0
ts_ref, ys_ref = rk4_reference(f, t0, tf, ys[1], h_ref)

for i in 1:n_steps
    ys[i + 1] = ys[i] + h * f(ts[i], ys[i])
end

xlims = (t0, tf)
ylims = (-0.1, 1.55)
title_str = "Euler Method: y' = 1 - t*cbrt(y), y(0)=1, n=41"

anim = @animate for frame in 1:n_pts
    plot(
        size=(640, 480),
        xlims=xlims,
        ylims=ylims,
        xlabel="t",
        ylabel="y",
        title=title_str,
        legend=:topright,
        grid=true,
        framestyle=:box,
        background_color=:white,
    )

    plot!(ts_ref, ys_ref; color=:black, ls=:dash, lw=2.0, label="Reference (RK4 h=1e-4)")
    plot!(ts[1:frame], ys[1:frame]; color=:magenta, lw=2.2, label="Euler")
    scatter!([ts[frame]], [ys[frame]]; color=:red, ms=5, label="y_$(frame - 1)")
end

gif(anim, joinpath(@__DIR__, "eulersmethodaa.gif"); fps=2)
println("Saved: eulersmethodaa.gif")
println("Final y(5) = $(ys[end])")
println("Reference y(5) (RK4 h=1e-4) = $(ys_ref[end])")
