# riemannbb.jl
# Riemann Sums animation: Right Riemann Sum
# Produces: riemannbb.gif

using Plots
gr()

# --- Parameters ---
f(x) = exp(-x) * sin(8 * x^(2/3)) + 1
a, b = 0.0, 2.0
n = 10   # number of subintervals

xlims = (0.0, 2.0)
ylims = (-0.1, 2.3)

title_str = "Right Riemann Sum: y = e^{-x}sin(8x^{2/3})+1"

# --- Subinterval data ---
dx = (b - a) / n
xs_right = [a + i*dx for i in 1:n]   # right endpoints

# --- Backdrop ---
xplot = range(a, b, length=400)

# --- Animation (add one rectangle per frame) ---
anim = @animate for frame in 0:n
    plot(size=(640, 480), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y", title=title_str,
         legend=false, grid=true, framestyle=:box,
         background_color=:white)

    # Draw rectangles added so far
    for i in 1:frame
        xr = xs_right[i]
        xl = xr - dx
        h  = f(xr)
        plot!([xl, xr, xr, xl, xl], [0.0, 0.0, h, h, 0.0];
              seriestype=:shape, fillcolor=:darkorange, fillalpha=0.4,
              linecolor=:darkorange, lw=1, label="")
    end

    # Draw function curve on top
    plot!(collect(xplot), f.(collect(xplot)); color=:magenta, lw=2, label="")

    # Annotation
    if frame > 0
        sum_val = dx * sum(f(xs_right[i]) for i in 1:frame)
        annotate!(1.0, 2.1, text("n=$frame  Sum≈$(round(sum_val; digits=4))", :black, 10))
    end
end

gif(anim, joinpath(@__DIR__, "riemannbb.gif"); fps=2)
println("Saved: riemannbb.gif")
