# milnesimpsonsaa.jl
# Milne-Simpson method animation: predictor-corrector trajectory vs exact reference
# Produces: milnesimpsonsaa.gif

using Plots
gr()

f(t, y) = t^2 + y^2

# Use robust RK4 reference for stability near the rapid-growth region.
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

function milne_simpson(f, t0, tf, y0, n_steps)
    h = (tf - t0) / n_steps
    ts = collect(range(t0, tf, length=n_steps + 1))
    ys = zeros(n_steps + 1)
    ys[1] = y0

    # Startup: 3 points via RK4
    for i in 1:3
        t = ts[i]
        y = ys[i]
        k1 = f(t, y)
        k2 = f(t + 0.5 * h, y + 0.5 * h * k1)
        k3 = f(t + 0.5 * h, y + 0.5 * h * k2)
        k4 = f(t + h, y + h * k3)
        ys[i + 1] = y + (h / 6.0) * (k1 + 2.0 * k2 + 2.0 * k3 + k4)
    end

    fs = f.(ts[1:4], ys[1:4])

    for n in 4:n_steps
        # Milne predictor
        y_pred = ys[n - 3] + (4.0 * h / 3.0) * (2.0 * fs[n - 2] - fs[n - 1] + 2.0 * fs[n])
        f_pred = f(ts[n + 1], y_pred)

        # Simpson corrector
        ys[n + 1] = ys[n - 1] + (h / 3.0) * (fs[n - 1] + 4.0 * fs[n] + f_pred)

        fs = f.(ts[1:n + 1], ys[1:n + 1])
    end

    return ts, ys
end

t0 = 0.0
tf = 0.90
y0 = 1.0
n_steps = 100
h_ref = 1e-4

ts, ys = milne_simpson(f, t0, tf, y0, n_steps)
ts_ref, ys_ref = rk4_reference(f, t0, tf, y0, h_ref)

xlims = (0.0, 0.90)
ylims = (0.0, 4.0)

anim = @animate for frame in 1:length(ts)
    plot(
        size=(700, 500),
        xlims=xlims,
        ylims=ylims,
        xlabel="t",
        ylabel="y",
        title="Milne-Simpson: y' = t^2 + y^2, y(0)=1",
        legend=:topleft,
        grid=true,
        framestyle=:box,
        background_color=:white,
    )

    plot!(ts_ref, ys_ref; color=:black, ls=:dash, lw=2.0, label="Reference (RK4 h=1e-4)")
    plot!(ts[1:frame], ys[1:frame]; color=:magenta, lw=2.2, label="Milne-Simpson")
    scatter!([ts[frame]], [ys[frame]]; color=:red, ms=4, label="")
end

gif(anim, joinpath(@__DIR__, "milnesimpsonsaa.gif"); fps=2)
println("Saved: milnesimpsonsaa.gif")
println("Final y($(tf)) = $(ys[end])")
println("Reference y($(tf)) (RK4 h=1e-4) = $(ys_ref[end])")
