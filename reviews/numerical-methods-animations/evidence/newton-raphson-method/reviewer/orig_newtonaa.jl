# newtonaa.jl
# Newton-Raphson Method animation: Fast Convergence
# f(x) = 3*exp(x) - 4*cos(x), x0 = 1.0
# Produces: newtonaa.gif

using Plots
gr()

# --- Functions ---
f(x)  = 3*exp(x) - 4*cos(x)
fp(x) = 3*exp(x) + 4*sin(x)

# --- Parameters ---
x0      = 1.0
n_iters = 5

xlims = (0.0, 1.5)
ylims = (-2.0, 10.0)

title_str = "Newton-Raphson: f(x) = 3eˣ − 4cos(x)"

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

    # Backdrop
    hline!([0.0]; color=:black, lw=1, label="")
    plot!(xplot, f.(xplot); color=:magenta, lw=2, label="y = f(x)")

    # Draw all Newton steps up to current frame
    for k in 1:frame
        xn  = xs[k]
        xn1 = xs[k+1]
        fn  = f(xn)
        # Tangent line segment from (xn, f(xn)) to (xn1, 0)
        plot!([xn, xn1], [fn, 0.0]; color=:steelblue, lw=1.5, label="")
        # Vertical drop from (xn1, 0) to (xn1, f(xn1))
        fn1 = f(xn1)
        plot!([xn1, xn1], [0.0, fn1]; color=:steelblue, lw=1.5, label="")
    end

    # Current point on curve
    x_cur = xs[frame + 1]
    scatter!([x_cur], [f(x_cur)]; color=:red, ms=6,
             label="x₍$(frame)₎ = $(round(x_cur; digits=5))")
end

gif(anim, joinpath(@__DIR__, "newtonaa.gif"); fps=2)
println("Saved: newtonaa.gif")
