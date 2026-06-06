# newtonbb.jl
# Newton-Raphson Method animation: Slow (Linear) Convergence
# f(x) = (1 - 5x)^2 = 1 - 10x + 25x^2, x0 = 1.0
# Double root at x = 0.2 causes linear convergence (rate 1/2 per step)
# Produces: newtonbb.gif

using Plots
gr()

# --- Functions ---
f(x)  = (1 - 5x)^2
fp(x) = -10*(1 - 5x)    # = -10 + 50x

# --- Parameters ---
x0      = 1.0
n_iters = 12

xlims = (0.0, 1.5)
ylims = (-0.5, 18.0)

title_str = "Newton-Raphson: f(x) = (1 − 5x)²"

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
         legend=:topright, grid=true, framestyle=:box,
         background_color=:white)

    hline!([0.0]; color=:black, lw=1, label="")
    plot!(xplot, f.(xplot); color=:magenta, lw=2, label="y = f(x)")

    for k in 1:frame
        xn  = xs[k]
        xn1 = xs[k+1]
        fn  = f(xn)
        plot!([xn, xn1], [fn, 0.0]; color=:steelblue, lw=1.5, label="")
        fn1 = f(xn1)
        plot!([xn1, xn1], [0.0, fn1]; color=:steelblue, lw=1.5, label="")
    end

    x_cur = xs[frame + 1]
    scatter!([x_cur], [f(x_cur)]; color=:red, ms=6,
             label="x₍$(frame)₎ = $(round(x_cur; digits=5))")
end

gif(anim, joinpath(@__DIR__, "newtonbb.gif"); fps=2)
println("Saved: newtonbb.gif")
