# newtondd.jl
# Newton-Raphson Method animation: NON Convergence — Cycling
# f(x) = x^3 - x + 3, x0 = 0.0
# Newton iterates cycle between ~0 and ~3 indefinitely
# Produces: newtondd.gif

using Plots
gr()

# --- Functions ---
f(x)  = x^3 - x + 3
fp(x) = 3*x^2 - 1

# --- Parameters ---
x0      = 0.0
n_iters = 10

xlims = (-0.5, 3.5)
ylims = (-3.0, 30.0)

title_str = "Newton-Raphson: f(x) = x³ − x + 3"

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
        # Clamp tangent line y-values for display
        fn_clamped = clamp(fn, ylims[1], ylims[2])
        if xlims[1] <= xn <= xlims[2] && xlims[1] <= xn1 <= xlims[2]
            plot!([xn, xn1], [fn_clamped, 0.0]; color=:steelblue, lw=1.5, label="")
            fn1_clamped = clamp(f(xn1), ylims[1], ylims[2])
            plot!([xn1, xn1], [0.0, fn1_clamped]; color=:steelblue, lw=1.5, label="")
        end
    end

    x_cur = xs[frame + 1]
    if xlims[1] <= x_cur <= xlims[2]
        fn_cur = clamp(f(x_cur), ylims[1], ylims[2])
        scatter!([x_cur], [fn_cur]; color=:red, ms=6,
                 label="x₍$(frame)₎ = $(round(x_cur; digits=4))")
    else
        scatter!(Float64[], Float64[]; color=:red, ms=6,
                 label="x₍$(frame)₎ = $(round(x_cur; digits=4))")
    end
end

gif(anim, joinpath(@__DIR__, "newtondd.gif"); fps=2)
println("Saved: newtondd.gif")
