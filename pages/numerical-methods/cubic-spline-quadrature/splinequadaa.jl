# splinequadaa.jl
# Cubic Spline Quadrature animation: natural cubic spline panels build up one at a time
# Produces: splinequadaa.gif

using Plots
gr()

# --- Parameters ---
f(x) = exp(-x) * sin(8 * x^(2/3)) + 1
a, b = 0.0, 2.0
n = 10   # number of subintervals

xlims = (0.0, 2.0)
ylims = (-0.1, 2.3)

title_str = "Cubic Spline Quadrature: y = e^{-x}sin(8x^{2/3})+1"

# --- Nodes and function values ---
dx = (b - a) / n
xs = [a + i*dx for i in 0:n]
ys = f.(xs)

# --- Natural cubic spline construction ---
# Using standard tridiagonal system for natural spline (M = second derivatives at nodes)
N = n + 1  # number of nodes
h = dx     # uniform spacing

# Set up the tridiagonal system for M values (second derivatives)
rhs = Vector{Float64}(undef, N-2)
for i in 2:N-1
    rhs[i-1] = 6/h^2 * (ys[i+1] - 2*ys[i] + ys[i-1])
end

# Build tridiagonal matrix (natural spline: M[1]=M[N]=0)
dl = fill(1.0, N-3)
d  = fill(4.0, N-2)
du = fill(1.0, N-3)

# Thomas algorithm
for i in 2:N-2
    m = dl[i-1] / d[i-1]
    d[i] -= m * du[i-1]
    rhs[i] -= m * rhs[i-1]
end
M_inner = Vector{Float64}(undef, N-2)
M_inner[end] = rhs[end] / d[end]
for i in N-3:-1:1
    M_inner[i] = (rhs[i] - du[i]*M_inner[i+1]) / d[i]
end
M = vcat(0.0, M_inner, 0.0)

# Evaluate spline at fine points within interval i (1-indexed: interval i covers [xs[i], xs[i+1]])
function spline_eval(xi, i)
    xl = xs[i]; xr = xs[i+1]
    t = xi - xl
    s = h - t
    return (M[i]*s^3 + M[i+1]*t^3)/(6h) + (ys[i]/h - M[i]*h/6)*s + (ys[i+1]/h - M[i+1]*h/6)*t
end

# Spline integral over interval i: (h/6)*(ys[i] + 4*spline_eval(midpoint) + ys[i+1])
# Using Simpson on spline between xs[i] and xs[i+1] (exact for cubic)
function spline_panel_integral(i)
    xm = (xs[i] + xs[i+1]) / 2
    return (h/6) * (ys[i] + 4*spline_eval(xm, i) + ys[i+1])
end

# --- Backdrop ---
xplot = range(a, b, length=400)
# Full spline curve
function full_spline(xi)
    # find which interval
    idx = min(floor(Int, (xi - a)/dx) + 1, n)
    return spline_eval(xi, idx)
end

# --- Animation (add one spline panel per frame) ---
anim = @animate for frame in 0:n
    plot(size=(640, 480), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y", title=title_str,
         legend=false, grid=true, framestyle=:box,
         background_color=:white)

    # Draw filled spline panels
    for i in 1:frame
        px = range(xs[i], xs[i+1], length=40)
        py = [spline_eval(xi, i) for xi in px]
        plot!(vcat(collect(px), reverse(collect(px))),
              vcat(py, zeros(length(py)));
              seriestype=:shape, fillcolor=:teal, fillalpha=0.4,
              linecolor=:teal, lw=1, label="")
    end

    # Draw the natural cubic spline overlay (so far)
    if frame > 0
        sx = range(xs[1], xs[frame+1], length=200)
        sy = [full_spline(xi) for xi in sx]
        plot!(collect(sx), sy; color=:steelblue, lw=1.5, linestyle=:dash, label="")
    end

    # Draw original function curve
    plot!(collect(xplot), f.(collect(xplot)); color=:magenta, lw=2, label="")

    # Annotation
    if frame > 0
        sum_val = sum(spline_panel_integral(i) for i in 1:frame)
        annotate!(1.0, 2.1, text("n=$frame  Sum≈$(round(sum_val; digits=4))", :black, 10))
    end
end

gif(anim, joinpath(@__DIR__, "splinequadaa.gif"); fps=2)
println("Saved: splinequadaa.gif")
