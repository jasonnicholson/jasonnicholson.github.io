# adamsbashforthmoultonaa.jl
# Adams-Bashforth-Moulton animation: ABM4 predictor-corrector trajectory build
# Produces: adamsbashforthmoultonaa.gif

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

function abm4(f, t0, tf, y0, n_steps)
    h = (tf - t0) / n_steps
    ts = collect(range(t0, tf, length=n_steps + 1))
    ys = zeros(n_steps + 1)
    ys[1] = y0

    # Self-start with RK4 for y1, y2, y3.
    for i in 1:3
        t = ts[i]
        y = ys[i]
        k1 = f(t, y)
        k2 = f(t + 0.5 * h, y + 0.5 * h * k1)
        k3 = f(t + 0.5 * h, y + 0.5 * h * k2)
        k4 = f(t + h, y + h * k3)
        ys[i + 1] = y + (h / 6.0) * (k1 + 2.0 * k2 + 2.0 * k3 + k4)
    end

    for n in 4:n_steps
        fn = f(ts[n], ys[n])
        fn1 = f(ts[n - 1], ys[n - 1])
        fn2 = f(ts[n - 2], ys[n - 2])
        fn3 = f(ts[n - 3], ys[n - 3])

        y_pred = ys[n] + (h / 24.0) * (55.0 * fn - 59.0 * fn1 + 37.0 * fn2 - 9.0 * fn3)
        f_pred = f(ts[n + 1], y_pred)

        ys[n + 1] = ys[n] + (h / 24.0) * (9.0 * f_pred + 19.0 * fn - 5.0 * fn1 + fn2)
    end

    return ts, ys
end

t0 = 0.0
tf = 5.0
y0 = 1.0
n_steps = 50
h_ref = 1e-4

ts, ys = abm4(f, t0, tf, y0, n_steps)
ts_ref, ys_ref = rk4_reference(f, t0, tf, y0, h_ref)

xlims = (0.0, 5.0)
ylims = (0.0, 1.55)

anim = @animate for frame in 1:length(ts)
    plot(
        size=(700, 500),
        xlims=xlims,
        ylims=ylims,
        xlabel="t",
        ylabel="y",
        title="ABM4: y' = 1 - t*cbrt(y), y(0)=1",
        legend=:topright,
        grid=true,
        framestyle=:box,
        background_color=:white,
    )

    plot!(ts_ref, ys_ref; color=:black, ls=:dash, lw=2.0, label="Reference (RK4 h=1e-4)")
    plot!(ts[1:frame], ys[1:frame]; color=:magenta, lw=2.2, label="ABM4")
    scatter!([ts[frame]], [ys[frame]]; color=:red, ms=5, label="y_$(frame - 1)")
end

gif(anim, joinpath(@__DIR__, "adamsbashforthmoultonaa.gif"); fps=2)
println("Saved: adamsbashforthmoultonaa.gif")
println("Final y(5) = $(ys[end])")
println("Reference y(5) (RK4 h=1e-4) = $(ys_ref[end])")
