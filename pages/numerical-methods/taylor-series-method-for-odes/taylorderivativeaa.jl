# taylorderivativeaa.jl
# Taylor Series Method (Order 3) animation: step-refinement sweep for y' = 1 - t*y^(1/3), y(0)=1 on [0,5]
# Each frame is a complete order-3 Taylor run with m subintervals (h = 5/m), using Mathews' sequence of m.
# Produces: taylorderivativeaa.gif
# Note: prefix "taylor" used for this topic's scripts

using Plots
using Printf
gr()

# --- ODE and parameters ---
# y' = f = 1 - t*y^(1/3); Taylor order 3 needs y'' and y''' as total derivatives along y' = f:
# y'  = 1 - t * y^(1/3)
# y'' = -y^(1/3) - t * (1/3) * y^(-2/3) * y'
# y''' = -(1/3)*y^(-2/3)*y' - (1/3)*y^(-2/3)*y' - t*( (1/3)*(-2/3)*y^(-5/3)*(y')^2 + (1/3)*y^(-2/3)*y'' )
# y^(1/3) is the real cube root cbrt(y) throughout, so coarse runs that go negative stay real.
function taylor3_step(t, y, h)
    c   = cbrt(y)
    yd1 = 1.0 - t * c
    yd2 = -c - t * (1.0/3) * c^(-2) * yd1
    yd3 = -(2.0/3) * c^(-2) * yd1 - t * ((-2.0/9) * c^(-5) * yd1^2 + (1.0/3) * c^(-2) * yd2)
    return y + h*yd1 + (h^2/2)*yd2 + (h^3/6)*yd3
end
fy(t, y) = -t / (3 * cbrt(y)^2)          # ∂f/∂y

t0, y0 = 0.0, 1.0
T  = 5.0
ms = [12, 14, 16, 18, 20, 24, 28, 32, 36, 40, 44, 48, 52, 56, 60, 70, 80, 90, 100, 120, 150]

xlims = (-0.1, 5.1)
ylims = (-0.3, 1.8)     # fixed for all frames; nodes below -0.3 are marked on the bottom border

# --- Order-3 Taylor method with m subintervals on [t0, T] ---
function taylor3(m)
    h  = (T - t0) / m
    ts = [t0 + i*h for i in 0:m]
    ys = Vector{Float64}(undef, m+1)
    ys[1] = y0
    for i in 1:m
        ys[i+1] = taylor3_step(ts[i], ys[i], h)
    end
    return ts, ys
end

# --- Reference solution (order-3 Taylor with 50000 steps; error far below plotting resolution) ---
tref, yref = taylor3(50_000)
yex5 = yref[end]

# --- Order-3 Taylor stability limit on the negative real axis: |R(z)| = 1, R(z) = 1 + z + z^2/2 + z^3/6 ---
R(z) = 1 + z + z^2/2 + z^3/6
function stab_limit()
    a, b = -3.0, -2.0                    # |R(-3)| > 1, |R(-2)| < 1
    for _ in 1:200
        c = (a + b)/2
        abs(R(c)) > 1 ? (a = c) : (b = c)
    end
    return -(a + b)/2
end
zlim = stab_limit()                      # 2.5127

# Onset time: first t where h*|∂f/∂y| along the reference solution exceeds the limit (nothing if never)
function onset(h)
    for i in eachindex(tref)
        h * abs(fy(tref[i], yref[i])) > zlim && return tref[i]
    end
    return nothing
end

# --- Animation: one complete order-3 Taylor run per frame ---
anim = @animate for m in ms
    ts, ys = taylor3(m)
    h   = (T - t0) / m
    ton = onset(h)
    low = findall(<(ylims[1]), ys)       # nodes below the window (true values kept in ys)

    plot(size=(640, 480), xlims=xlims, ylims=ylims,
         xlabel="t", ylabel="y",
         title="Taylor order 3 for y' = 1 - t·y^(1/3), y(0) = 1\nm = $m subintervals, h = 5/$m",
         titlefontsize=11, legend=:bottomleft, grid=true, framestyle=:box,
         background_color=:white)

    if ton !== nothing
        vspan!([ton, T]; color=:red, alpha=0.10, lw=0, label="h·|∂f/∂y| > $(round(zlim; digits=3))")
    end
    plot!(tref, yref; color=:gray70, lw=4, label="reference solution")
    plot!(ts, ys; color=:darkorange, lw=2, marker=:circle, ms=2.5, msw=0, label="Taylor 3, m = $m")
    if !isempty(low)
        scatter!(ts[low], fill(ylims[1], length(low)); marker=:dtriangle, ms=6, color=:darkorange,
                 msc=:black, msw=0.5, label="node below $(ylims[1]) (off scale)")
    end
    ys[end] >= ylims[1] && scatter!([ts[end]], [ys[end]]; color=:red, ms=5, msw=0, label="")

    stab_txt = ton === nothing ? "h·|∂f/∂y| < $(round(zlim; digits=3)) up to t = 5" :
                                 @sprintf("h·|∂f/∂y| > %.3f from t ≈ %.2f", zlim, ton)
    annotate!(2.35, 1.72, text(@sprintf("y(5) = %.7f", ys[end]), :black, 10, :left))
    annotate!(2.35, 1.61, text(@sprintf("error = %+.1e", ys[end] - yex5), :black, 10, :left))
    annotate!(2.35, 1.50, text(@sprintf("reference y(5) = %.7f", yex5), :gray40, 9, :left))
    annotate!(2.35, 1.40, text(stab_txt, :gray40, 9, :left))
    if !isempty(low)
        k = argmin(ys)
        annotate!(2.35, 1.30, text(@sprintf("min y = %.4g at t ≈ %.2f (off scale)", ys[k], ts[k]), :gray40, 9, :left))
    end
end

gif(anim, joinpath(@__DIR__, "taylorderivativeaa.gif"); fps=1)
println("Saved: taylorderivativeaa.gif")
