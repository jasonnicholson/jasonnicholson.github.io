# boolesaa.jl
# Boole's Rule animation: each panel covers 4 subintervals (5 nodes)
# Produces: boolesaa.gif

using Plots
gr()

# --- Parameters ---
f(x) = exp(-x) * sin(8 * x^(2/3)) + 1
a, b = 0.0, 2.0
n = 8   # number of subintervals (must be multiple of 4 for Boole's rule)

xlims = (0.0, 2.0)
ylims = (-0.1, 2.3)

title_str = "Boole's Rule: y = e^{-x}sin(8x^{2/3})+1"

# --- Subinterval data ---
dx = (b - a) / n
xs = [a + i*dx for i in 0:n]
n_panels = n ÷ 4   # number of Boole panels (each spans 4 subintervals)

# --- Backdrop ---
xplot = range(a, b, length=400)

# --- 4th-order polynomial for a Boole panel [x0..x4] ---
function quartic_pts(x0, x1, x2, x3, x4)
    # Use Lagrange interpolation for plotting the polynomial approximation
    nodes = [x0, x1, x2, x3, x4]
    ys    = f.(nodes)
    px = range(x0, x4, length=80)
    py = map(px) do x
        sum(ys[i] * prod((x - nodes[j])/(nodes[i]-nodes[j]) for j in 1:5 if j!=i) for i in 1:5)
    end
    return collect(px), collect(py)
end

# Boole's rule coefficients: (2h/45)(7f0 + 32f1 + 12f2 + 32f3 + 7f4)
function boole_sum(x0, x1, x2, x3, x4)
    h = (x4 - x0) / 4
    return (2h/45) * (7f(x0) + 32f(x1) + 12f(x2) + 32f(x3) + 7f(x4))
end

# --- Animation (add one Boole panel per frame) ---
anim = @animate for frame in 0:n_panels
    plot(size=(640, 480), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y", title=title_str,
         legend=false, grid=true, framestyle=:box,
         background_color=:white)

    # Draw filled quartic panels
    for p in 1:frame
        i = 4*(p-1)
        x0, x1, x2, x3, x4 = xs[i+1], xs[i+2], xs[i+3], xs[i+4], xs[i+5]
        px, py = quartic_pts(x0, x1, x2, x3, x4)
        plot!(vcat(px, reverse(px)), vcat(py, zeros(length(py)));
              seriestype=:shape, fillcolor=:mediumpurple, fillalpha=0.4,
              linecolor=:mediumpurple, lw=1, label="")
    end

    # Draw function curve on top
    plot!(collect(xplot), f.(collect(xplot)); color=:magenta, lw=2, label="")

    # Annotation
    if frame > 0
        sum_val = sum(boole_sum(xs[4*(p-1)+1], xs[4*(p-1)+2], xs[4*(p-1)+3], xs[4*(p-1)+4], xs[4*(p-1)+5]) for p in 1:frame)
        annotate!(1.0, 2.1, text("panels=$frame  Sum≈$(round(sum_val; digits=4))", :black, 10))
    end
end

gif(anim, joinpath(@__DIR__, "boolesaa.gif"); fps=2)
println("Saved: boolesaa.gif")
