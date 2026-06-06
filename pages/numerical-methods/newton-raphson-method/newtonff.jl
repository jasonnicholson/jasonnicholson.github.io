# newtonff.jl
# Newton-Raphson Method animation: NON Convergence — Divergent Oscillation
# f(x) = arctan(x), x0 = 1.4
# Root at x = 0; x0 just above divergence threshold -> oscillates with growing amplitude
# Produces: newtonff.gif

using Plots
gr()

# --- Functions ---
f(x)  = atan(x)
fp(x) = 1.0 / (1.0 + x^2)

# --- Parameters ---
x0      = 1.4
n_iters = 6

xlims = (-4.0, 5.0)
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
        if xlims[1] <= xn <= xlims[2] && xlims[1] <= xn1 <= xlims[2]
            plot!([xn, xn1], [fn, 0.0]; color=:steelblue, lw=1.5, label="")
            fn1 = f(xn1)
            plot!([xn1, xn1], [0.0, fn1]; color=:steelblue, lw=1.5, label="")
        end
    end

    x_cur = xs[frame + 1]
    if xlims[1] <= x_cur <= xlims[2]
        scatter!([x_cur], [f(x_cur)]; color=:red, ms=6,
                 label="x₍$(frame)₎ = $(round(x_cur; digits=4))")
    else
        scatter!(Float64[], Float64[]; color=:red, ms=6,
                 label="x₍$(frame)₎ = $(round(x_cur; digits=2)) (out of range)")
    end
end

gif(anim, joinpath(@__DIR__, "newtonff.gif"); fps=2)
println("Saved: newtonff.gif")
