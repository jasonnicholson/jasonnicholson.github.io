# accnewtonaa.jl
# Accelerated & Modified Newton-Raphson animation: Standard Newton at double root
# f(x) = x^3 - 3x + 2 = (x-1)^2*(x+2), double root at x=1, x0=1.2
# Shows LINEAR (slow) convergence — standard Newton degrades at multiple roots.
# Produces: accnewtonaa.gif

using Plots
gr()

# --- Functions ---
f(x)  = x^3 - 3x + 2
fp(x) = 3x^2 - 3

# --- Parameters ---
x0      = 1.2
n_iters = 12

xlims = (0.7, 1.8)
ylims = (-0.05, 1.0)

title_str = "Standard Newton: f(x) = x³−3x+2 (double root at x=1)"

# --- Pre-compute iterates ---
xs = Vector{Float64}(undef, n_iters + 1)
xs[1] = x0
for i in 1:n_iters
    xs[i+1] = xs[i] - f(xs[i]) / fp(xs[i])
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
        # Tangent line from (xn, f(xn)) to (xn1, 0)
        plot!([xn, xn1], [fn, 0.0]; color=:steelblue, lw=1.5, label="")
        # Vertical drop from x_{n+1} on x-axis to curve
        fn1 = f(xn1)
        plot!([xn1, xn1], [0.0, fn1]; color=:steelblue, lw=1.5, label="")
    end

    x_cur = xs[frame + 1]
    scatter!([x_cur], [f(x_cur)]; color=:red, ms=6,
             label="x₍$(frame)₎ = $(round(x_cur; digits=6))")
end

gif(anim, joinpath(@__DIR__, "accnewtonaa.gif"); fps=2)
println("Saved: accnewtonaa.gif")
