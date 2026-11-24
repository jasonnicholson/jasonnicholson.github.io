# adamsbashforthmoultonaa.jl
# Adams-Bashforth-Moulton animation: step-refinement sweep for y' = 1 - t*y^(1/3), y(0)=1 on [0,5]
# Each frame is a complete ABM4 predictor-corrector run with m subintervals (h = 5/m),
# using the sequence of m from Mathews' animation.
# Produces: adamsbashforthmoultonaa.gif

using Plots
using Printf
using LinearAlgebra
gr()

f(t, y)  = 1 - t * cbrt(y)                # cbrt is the real cube root, so negative y stays real
fy(t, y) = -t / (3 * cbrt(y)^2)           # ∂f/∂y

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
ms = [12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 70, 80, 90, 100, 120, 150]
h_ref = 1e-4

ts_ref, ys_ref = rk4_reference(f, t0, tf, y0, h_ref)
yex5 = ys_ref[end]

# --- Linear (frozen-coefficient) stability limit of this ABM4 PECE scheme on the negative real axis ---
# For y' = λy and z = hλ the recurrence has characteristic polynomial
#   ζ^4 - ζ^3 - (z/24)(9P(ζ) + 19ζ^3 - 5ζ^2 + ζ),  P(ζ) = ζ^3 + (z/24)(55ζ^3 - 59ζ^2 + 37ζ - 9).
# The limit is the z where its largest root first reaches modulus 1.
function spectral_radius(z)
    a = z / 24
    c = [-1 - a * (9 * (1 + 55a) + 19), -a * (-9 * 59a - 5), -a * (9 * 37a + 1), -a * (-81a)]  # ζ^3..ζ^0
    C = zeros(4, 4)
    C[1, :] = -c
    C[2, 1] = C[3, 2] = C[4, 3] = 1.0
    return maximum(abs.(eigvals(C)))
end
function stab_limit()
    a, b = -1.5, -1.0                    # radius > 1 at -1.5, < 1 at -1.0
    for _ in 1:60
        c = (a + b) / 2
        spectral_radius(c) > 1 ? (a = c) : (b = c)
    end
    return -(a + b) / 2
end
zlim = stab_limit()                      # 1.2848: a linear bound, not an accuracy threshold

# Onset time: first t where h*|∂f/∂y| along the reference solution exceeds the limit (nothing if never)
function onset(h)
    for i in eachindex(ts_ref)
        h * abs(fy(ts_ref[i], ys_ref[i])) > zlim && return ts_ref[i]
    end
    return nothing
end

xlims = (-0.1, 5.1)
ylims = (-0.5, 1.8)    # every computed value of every run lies inside (min -0.453 at m = 14, max 1.4498)

# --- Animation: one complete ABM4 run per frame ---
anim = @animate for m in ms
    ts, ys = abm4(f, t0, tf, y0, m)
    h   = (tf - t0) / m
    ton = onset(h)

    plot(size=(640, 480), xlims=xlims, ylims=ylims,
         xlabel="t", ylabel="y",
         title="ABM4 for y' = 1 - t·y^(1/3), y(0) = 1\nm = $m subintervals, h = 5/$m",
         titlefontsize=11, legend=:topright, grid=true, framestyle=:box,
         background_color=:white)

    if ton !== nothing
        vspan!([ton, tf]; color=:red, alpha=0.10, lw=0, label="h·|∂f/∂y| > $(round(zlim; digits=3))")
    end
    plot!(ts_ref, ys_ref; color=:gray70, lw=4, label="reference solution")
    plot!(ts, ys; color=:magenta, lw=2, marker=:circle, ms=2.5, msw=0, label="ABM4, m = $m")
    scatter!([ts[end]], [ys[end]]; color=:red, ms=5, msw=0, label="")

    stab_txt = ton === nothing ? "h·|∂f/∂y| < $(round(zlim; digits=3)) up to t = 5" :
                                 @sprintf("h·|∂f/∂y| > %.3f from t ≈ %.2f", zlim, ton)
    annotate!(2.35, 1.28, text(@sprintf("y(5) = %.7f", ys[end]), :black, 10, :left))
    annotate!(2.35, 1.14, text(@sprintf("error = %+.1e", ys[end] - yex5), :black, 10, :left))
    annotate!(2.35, 1.00, text(@sprintf("reference y(5) = %.7f", yex5), :gray40, 9, :left))
    annotate!(2.35, 0.87, text(stab_txt, :gray40, 9, :left))
end

gif(anim, joinpath(@__DIR__, "adamsbashforthmoultonaa.gif"); fps=1)
println("Saved: adamsbashforthmoultonaa.gif")
