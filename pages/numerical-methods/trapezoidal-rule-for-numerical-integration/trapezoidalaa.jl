# trapezoidalaa.jl
# Trapezoidal Rule animation: single case
# Produces: trapezoidalaa.gif

using Plots
gr()

# --- Parameters ---
f(x) = exp(-x) * sin(8 * x^(2/3)) + 1
a, b = 0.0, 2.0
n = 10   # number of subintervals

xlims = (0.0, 2.0)
ylims = (-0.1, 2.3)

title_str = "Trapezoidal Rule: y = e^{-x}sin(8x^{2/3})+1"

# --- Subinterval data ---
dx = (b - a) / n
xs = [a + i*dx for i in 0:n]

# --- Backdrop ---
xplot = range(a, b, length=400)

# --- Animation (add one trapezoid per frame) ---
anim = @animate for frame in 0:n
    plot(size=(640, 480), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y", title=title_str,
         legend=false, grid=true, framestyle=:box,
         background_color=:white)

    # Draw trapezoids added so far
    for i in 1:frame
        xl = xs[i]
        xr = xs[i+1]
        fl = f(xl)
        fr = f(xr)
        # Trapezoid as a filled polygon
        plot!([xl, xr, xr, xl, xl], [0.0, 0.0, fr, fl, 0.0];
              seriestype=:shape, fillcolor=:steelblue, fillalpha=0.4,
              linecolor=:steelblue, lw=1, label="")
        # Draw the top slanted line
        plot!([xl, xr], [fl, fr]; color=:steelblue, lw=1.5, label="")
    end

    # Draw function curve on top
    plot!(collect(xplot), f.(collect(xplot)); color=:magenta, lw=2, label="")

    # Annotation
    if frame > 0
        interior = frame > 1 ? 2*sum(f(xs[i]) for i in 2:frame) : 0.0
        sum_val = dx/2 * (f(xs[1]) + interior + f(xs[frame+1]))
        annotate!(1.0, 2.1, text("n=$frame  Sum≈$(round(sum_val; digits=4))", :black, 10))
    end
end

gif(anim, joinpath(@__DIR__, "trapezoidalaa.gif"); fps=2)
println("Saved: trapezoidalaa.gif")
