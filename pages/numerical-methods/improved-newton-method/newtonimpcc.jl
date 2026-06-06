# newtonimpcc.jl
# Improved Newton Method animation: Standard Newton-Raphson at a triple root
# f(x) = x^4 - x^3 - 3x^2 + 5x - 2 = (x-1)^3*(x+2), triple root at x=1, x0=1.3
# Shows even SLOWER linear convergence than the double-root case.
# Produces: newtonimpcc.gif

using Plots
gr()

# --- Functions ---
f(x)  = x^4 - x^3 - 3x^2 + 5x - 2
fp(x) = 4x^3 - 3x^2 - 6x + 5

# --- Parameters ---
x0      = 1.3
n_iters = 12

xlims = (0.5, 1.6)
ylims = (-0.05, 0.5)

title_str = "Standard Newton: f(x) = x⁴−x³−3x²+5x−2 (triple root at x=1)"

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
        plot!([xn, xn1], [fn, 0.0]; color=:steelblue, lw=1.5, label="")
        fn1 = f(xn1)
        plot!([xn1, xn1], [0.0, fn1]; color=:steelblue, lw=1.5, label="")
    end

    x_cur = xs[frame + 1]
    scatter!([x_cur], [f(x_cur)]; color=:red, ms=6,
             label="x₍$(frame)₎ = $(round(x_cur; digits=6))")
end

gif(anim, joinpath(@__DIR__, "newtonimpcc.gif"); fps=2)
println("Saved: newtonimpcc.gif")
