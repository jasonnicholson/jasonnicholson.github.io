# taylorderivativebb.jl
# Taylor Series Method (Order 4) for ODE animation: y' = 1 - t*y^(1/3), y(0)=1
# Produces: taylorderivativebb.gif

using Plots
gr()

# --- ODE and parameters ---
# Taylor Order 4 — same ODE, one more derivative term (y'''' also analytic)
# Use cbrt() to handle all real inputs safely
function yd1_f(t, y); 1.0 - t * cbrt(y); end
function yd2_f(t, y); -cbrt(y) - t * (1/3) * cbrt(y)^(-2) * yd1_f(t, y); end
function yd3_f(t, y)
    d1 = yd1_f(t, y); d2 = yd2_f(t, y)
    -(2/3) * cbrt(y)^(-2) * d1 +
        -t * ((-2/9) * cbrt(y)^(-5) * d1^2 + (1/3) * cbrt(y)^(-2) * d2)
end
# y'''' = total derivative of y''' along y' = f, simplified with c = y^(1/3)
function yd4_f(t, y)
    c = cbrt(y)
    (27c^7 + 18c^5*t^2 - 39c^4*t + 3c^3*t^4 + 18c^3 - 15c^2*t^3 + 22c*t^2 - 10t) / (27c^8)
end

function taylor4_step(t, y, h)
    d1 = yd1_f(t, y)
    d2 = yd2_f(t, y)
    d3 = yd3_f(t, y)
    d4 = yd4_f(t, y)
    return y + h*d1 + (h^2/2)*d2 + (h^3/6)*d3 + (h^4/24)*d4
end

t0, y0 = 0.0, 1.0
T  = 5.0
n  = 100    # steps: h = 0.05 keeps h*|df/dy| below order-4 Taylor's limit 2.785 up to t = 5
h  = (T - t0) / n
stride = 5  # each frame adds `stride` Taylor steps (0.25 in t)

xlims = (-0.1, 5.1)   # small margins so the end point (5, 0.0081) is not clipped
ylims = (-0.05, 1.8)

title_str = "Taylor order 4, h = 0.05: y' = 1 - t·y^(1/3),  y(0) = 1"

# --- Compute solution ---
ts = Vector{Float64}(undef, n+1)
ys = Vector{Float64}(undef, n+1)
ts[1] = t0;  ys[1] = y0
for i in 1:n
    ts[i+1] = ts[i] + h
    ys[i+1] = taylor4_step(ts[i], ys[i], h)
end

# --- Animation: reveal the solution `stride` steps per frame ---
anim = @animate for frame in 1:stride:n+1
    plot(size=(640, 480), xlims=xlims, ylims=ylims,
         xlabel="t", ylabel="y", title=title_str,
         legend=false, grid=true, framestyle=:box,
         background_color=:white)

    if frame > 1
        plot!(ts[1:frame], ys[1:frame]; color=:purple, lw=2, label="")
    end

    scatter!([ts[frame]], [ys[frame]]; color=:red, ms=5, label="")

    annotate!(2.5, 1.7, text("t=$(round(ts[frame]; digits=2))  y≈$(round(ys[frame]; digits=4))", :black, 10))
end

gif(anim, joinpath(@__DIR__, "taylorderivativebb.gif"); fps=3)
println("Saved: taylorderivativebb.gif")
