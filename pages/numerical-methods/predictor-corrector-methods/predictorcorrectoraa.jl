# predictorcorrectoraa.jl
# Predictor-Corrector animation: AB2-AM2 PECE trajectory vs reference
# Produces: predictorcorrectoraa.gif

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

# AB2 predictor + AM2 corrector (PECE)
function ab2_am2(f, t0, tf, y0, n_steps)
    h = (tf - t0) / n_steps
    ts = collect(range(t0, tf, length=n_steps + 1))
    ys = zeros(n_steps + 1)
    ys[1] = y0

    # Startup with RK4 for y1
    k1 = f(ts[1], ys[1])
    k2 = f(ts[1] + 0.5 * h, ys[1] + 0.5 * h * k1)
    k3 = f(ts[1] + 0.5 * h, ys[1] + 0.5 * h * k2)
    k4 = f(ts[1] + h, ys[1] + h * k3)
    ys[2] = ys[1] + (h / 6.0) * (k1 + 2.0 * k2 + 2.0 * k3 + k4)

    fs = f.(ts[1:2], ys[1:2])

    for n in 2:n_steps
        y_pred = ys[n] + (h / 2.0) * (3.0 * fs[n] - fs[n - 1])
        f_pred = f(ts[n + 1], y_pred)

        ys[n + 1] = ys[n] + (h / 2.0) * (f_pred + fs[n])
        push!(fs, f(ts[n + 1], ys[n + 1]))
    end

    return ts, ys
end

t0 = 0.0
tf = 5.0
y0 = 1.0
n_steps = 50
h_ref = 1e-4

ts, ys = ab2_am2(f, t0, tf, y0, n_steps)
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
        title="Predictor-Corrector (AB2-AM2): y' = 1 - t*cbrt(y), y(0)=1",
        legend=:topright,
        grid=true,
        framestyle=:box,
        background_color=:white,
    )

    plot!(ts_ref, ys_ref; color=:black, ls=:dash, lw=2.0, label="Reference (RK4 h=1e-4)")
    plot!(ts[1:frame], ys[1:frame]; color=:magenta, lw=2.2, label="AB2-AM2")
    scatter!([ts[frame]], [ys[frame]]; color=:red, ms=4, label="")
end

gif(anim, joinpath(@__DIR__, "predictorcorrectoraa.gif"); fps=2)
println("Saved: predictorcorrectoraa.gif")
println("Final y(5) = $(ys[end])")
println("Reference y(5) (RK4 h=1e-4) = $(ys_ref[end])")
