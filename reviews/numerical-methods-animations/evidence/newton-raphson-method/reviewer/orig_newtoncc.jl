# newtoncc.jl
# Newton-Raphson Method animation: Convergence with Oscillation
# f(x) = arctan(x), x0 = 1.35
# Root at x = 0; x0 just below the divergence threshold -> oscillates but converges
# Produces: newtoncc.gif

using Plots
gr()

# --- Functions ---
f(x)  = atan(x)
fp(x) = 1.0 / (1.0 + x^2)

# --- Parameters ---
x0      = 1.35
n_iters = 8

xlims = (-3.0, 2.5)
ylims = (-1.8, 1.8)

title_str = "Newton-Raphson: f(x) = arctan(x)"

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
        # Only draw if both endpoints visible
        x_lo, x_hi = min(xn, xn1), max(xn, xn1)
        if x_lo >= xlims[1] && x_hi <= xlims[2]
            plot!([xn, xn1], [fn, 0.0]; color=:steelblue, lw=1.5, label="")
            fn1 = f(xn1)
            plot!([xn1, xn1], [0.0, fn1]; color=:steelblue, lw=1.5, label="")
        end
    end

    x_cur = xs[frame + 1]
    if xlims[1] <= x_cur <= xlims[2]
        scatter!([x_cur], [f(x_cur)]; color=:red, ms=6,
                 label="x₍$(frame)₎ = $(round(x_cur; digits=5))")
    else
        scatter!(Float64[], Float64[]; color=:red, ms=6,
                 label="x₍$(frame)₎ = $(round(x_cur; digits=5))")
    end
end

gif(anim, joinpath(@__DIR__, "newtoncc.gif"); fps=2)
println("Saved: newtoncc.gif")
