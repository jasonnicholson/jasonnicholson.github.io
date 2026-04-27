# simpsonsaa.jl
# Simpson's Rule animation: parabolic panels build up one pair at a time
# Produces: simpsonsaa.gif
# Simpson's rule requires even number of subintervals; each panel covers 2 intervals

using Plots
gr()

# --- Parameters ---
f(x) = exp(-x) * sin(8 * x^(2/3)) + 1
a, b = 0.0, 2.0
n = 10   # number of subintervals (must be even)

xlims = (0.0, 2.0)
ylims = (-0.1, 2.3)

title_str = "Simpson's Rule: y = e^{-x}sin(8x^{2/3})+1"

# --- Subinterval data ---
dx = (b - a) / n
xs = [a + i*dx for i in 0:n]
n_panels = n ÷ 2   # number of parabolic panels

# --- Backdrop ---
xplot = range(a, b, length=400)

# --- Parabola for a single panel [x0,x1,x2] ---
function parabola_pts(x0, x1, x2)
    # fit y = Ax^2 + Bx + C through (x0,f(x0)), (x1,f(x1)), (x2,f(x2))
    y0, y1, y2 = f(x0), f(x1), f(x2)
    # Vandermonde solve (numerically stable enough for plotting)
    A = (y0/(x0-x1)/(x0-x2) + y1/(x1-x0)/(x1-x2) + y2/(x2-x0)/(x2-x1))
    B = (-y0*(x1+x2)/((x0-x1)*(x0-x2))
         -y1*(x0+x2)/((x1-x0)*(x1-x2))
         -y2*(x0+x1)/((x2-x0)*(x2-x1)))
    C = (y0*x1*x2/((x0-x1)*(x0-x2))
         +y1*x0*x2/((x1-x0)*(x1-x2))
         +y2*x0*x1/((x2-x0)*(x2-x1)))
    px = range(x0, x2, length=60)
    py = @. A*px^2 + B*px + C
    return collect(px), collect(py)
end

# --- Animation (add one parabolic panel per frame) ---
anim = @animate for frame in 0:n_panels
    plot(size=(640, 480), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y", title=title_str,
         legend=false, grid=true, framestyle=:box,
         background_color=:white)

    # Draw filled parabolic panels
    for p in 1:frame
        i = 2*(p-1)
        x0, x1, x2 = xs[i+1], xs[i+2], xs[i+3]
        px, py = parabola_pts(x0, x1, x2)
        # Fill region between parabola and x-axis
        plot!(vcat(px, reverse(px)), vcat(py, zeros(length(py)));
              seriestype=:shape, fillcolor=:steelblue, fillalpha=0.4,
              linecolor=:steelblue, lw=1, label="")
    end

    # Draw function curve on top
    plot!(collect(xplot), f.(collect(xplot)); color=:magenta, lw=2, label="")

    # Annotation: running sum
    if frame > 0
        sum_val = 0.0
        for p in 1:frame
            i = 2*(p-1)
            sum_val += (dx/3) * (f(xs[i+1]) + 4*f(xs[i+2]) + f(xs[i+3]))
        end
        annotate!(1.0, 2.1, text("panels=$frame  Sum≈$(round(sum_val; digits=4))", :black, 10))
    end
end

gif(anim, joinpath(@__DIR__, "simpsonsaa.gif"); fps=2)
println("Saved: simpsonsaa.gif")
