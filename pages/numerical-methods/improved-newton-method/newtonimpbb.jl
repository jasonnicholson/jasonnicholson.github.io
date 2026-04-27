# newtonimpbb.jl
# Improved Newton Method animation: Method A (accelerated, m=2) at a double root
# f(x) = x^3 - 3x + 2 = (x-1)^2*(x+2), double root at x=1, x0=1.3
# Shows QUADRATIC (fast) convergence — accelerated Newton restores quadratic rate.
# Formula: x_{n+1} = x_n - m * f(x_n)/f'(x_n), m=2
# Produces: newtonimpbb.gif

using Plots
gr()

# --- Functions ---
f(x)  = x^3 - 3x + 2
fp(x) = 3x^2 - 3

# --- Parameters ---
x0      = 1.3
n_iters = 5
m       = 2   # multiplicity of the root

xlims = (0.6, 1.8)
ylims = (-0.1, 1.3)

title_str = "Method A (m=2): f(x) = x³−3x+2 (double root at x=1)"

# --- Pre-compute iterates using Method A ---
xs = Vector{Float64}(undef, n_iters + 1)
xs[1] = x0
for i in 1:n_iters
    xs[i+1] = xs[i] - m * f(xs[i]) / fp(xs[i])
end

# --- Animation ---
xplot = range(xlims[1], xlims[2], length=400)

anim = @animate for frame in 0:n_iters
    plot(size=(640, 600), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y", title=title_str,
         legend=:topleft, grid=true, framestyle=:box,
         background_color=:white)

    hline!([0.0]; color=:black, lw=1, label="")
    plot!(xplot, f.(xplot); color=:magenta, lw=2, label="y = f(x)")

    for k in 1:frame
        xn  = xs[k]
        xn1 = xs[k+1]
        fn  = f(xn)
        fpn = fp(xn)
        # Effective slope for Method A is f'(x)/m — draw effective tangent
        # from (xn, f(xn)) with slope fpn/m to its zero crossing at xn1
        plot!([xn, xn1], [fn, 0.0]; color=:darkorange, lw=1.5, label="")
        # Vertical drop from xn1 on x-axis to curve
        fn1 = f(xn1)
        plot!([xn1, xn1], [0.0, fn1]; color=:darkorange, lw=1.5, label="")
    end

    x_cur = xs[frame + 1]
    scatter!([x_cur], [f(x_cur)]; color=:red, ms=6,
             label="x₍$(frame)₎ = $(round(x_cur; digits=6))")
end

gif(anim, joinpath(@__DIR__, "newtonimpbb.gif"); fps=2)
println("Saved: newtonimpbb.gif")
