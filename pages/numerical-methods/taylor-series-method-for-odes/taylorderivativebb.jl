# taylorderivativebb.jl
# Taylor Series Method (Order 4) for ODE animation: y' = 1 - t*y^(1/3), y(0)=1
# Produces: taylorderivativebb.gif

using Plots
gr()

# --- ODE and parameters ---
# Taylor Order 4 — same ODE, one more derivative term
# Use cbrt() to handle all real inputs safely
function yd1_f(t, y); 1.0 - t * cbrt(y); end
function yd2_f(t, y); -cbrt(y) - t * (1/3) * cbrt(y)^(-2) * yd1_f(t, y); end
function yd3_f(t, y)
    d1 = yd1_f(t, y); d2 = yd2_f(t, y)
    -(2/3) * cbrt(y)^(-2) * d1 +
        -t * ((-2/9) * cbrt(y)^(-5) * d1^2 + (1/3) * cbrt(y)^(-2) * d2)
end

function taylor4_step(t, y, h)
    d1 = yd1_f(t, y)
    d2 = yd2_f(t, y)
    d3 = yd3_f(t, y)
    eps_h = h * 1e-5
    d4 = (yd3_f(t + eps_h, y + eps_h * d1) - d3) / eps_h
    return y + h*d1 + (h^2/2)*d2 + (h^3/6)*d3 + (h^4/24)*d4
end

t0, y0 = 0.0, 1.0
T  = 5.0
n  = 20
h  = (T - t0) / n

xlims = (0.0, 5.0)
ylims = (0.0, 1.8)

title_str = "Taylor Method (n=4): y' = 1 - t·y^{1/3},  y(0) = 1"

# --- Compute solution ---
ts = Vector{Float64}(undef, n+1)
ys = Vector{Float64}(undef, n+1)
ts[1] = t0;  ys[1] = y0
for i in 1:n
    ts[i+1] = ts[i] + h
    ys[i+1] = taylor4_step(ts[i], ys[i], h)
end

# --- Animation ---
anim = @animate for frame in 1:n+1
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
