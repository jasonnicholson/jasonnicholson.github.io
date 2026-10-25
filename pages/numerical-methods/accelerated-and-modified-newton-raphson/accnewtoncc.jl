# accnewtoncc.jl
# Accelerated & Modified Newton-Raphson animation: Modified Newton (Method B)
# f(x) = x^3 - 3x + 2 = (x-1)^2*(x+2), double root at x=1, x0=1.2
# Method B: define h(x) = f(x)/f'(x); h has a SIMPLE root where f has a double root.
# Newton on h(x) gives: x_{n+1} = x_n - f(x_n)*f'(x_n) / (f'(x_n)^2 - f(x_n)*f''(x_n))
# Shows QUADRATIC (fast) convergence without needing to know the multiplicity m.
# The animation plots h(x) and shows Newton tangent lines converging in ~2 steps.
# Produces: accnewtoncc.gif

using Plots
gr()

# --- Functions ---
f(x)   = x^3 - 3x + 2
fp(x)  = 3x^2 - 3
fpp(x) = 6x

# h(x) = f(x)/f'(x) = (x-1)*(x+2)/(3*(x+1))  [simplified form, valid for x ≠ ±1]
h_plot(x) = (x - 1) * (x + 2) / (3 * (x + 1))

# Modified Newton step (= Newton's step applied to h(x))
function modified_newton_step(x)
    fx   = f(x)
    fpx  = fp(x)
    fppx = fpp(x)
    denom = fpx^2 - fx * fppx
    x - fx * fpx / denom
end

# --- Parameters ---
x0      = 1.2
n_iters = 4

xlims = (0.5, 2.0)
ylims = (-0.4, 0.6)

title_str = "Modified Newton (Method B): h(x) = f(x)/f'(x)"

# --- Pre-compute iterates ---
xs = Vector{Float64}(undef, n_iters + 1)
xs[1] = x0
for i in 1:n_iters
    xs[i+1] = modified_newton_step(xs[i])
end

# --- Animation ---
xplot = range(xlims[1], xlims[2], length=400)

anim = @animate for frame in 0:n_iters
    plot(size=(640, 600), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y", title=title_str,
         legend=:topleft, grid=true, framestyle=:box,
         background_color=:white)

    hline!([0.0]; color=:black, lw=1, label="")
    plot!(xplot, h_plot.(xplot); color=:green, lw=2, label="y = h(x) = f(x)/f'(x)")

    for k in 1:frame
        xn  = xs[k]
        xn1 = xs[k+1]
        hn  = h_plot(xn)
        # Tangent line from (xn, h(xn)) to (xn1, 0)
        plot!([xn, xn1], [hn, 0.0]; color=:steelblue, lw=1.5, label="")
        hn1 = h_plot(xn1)
        plot!([xn1, xn1], [0.0, hn1]; color=:steelblue, lw=1.5, label="")
    end

    x_cur = xs[frame + 1]
    scatter!([x_cur], [h_plot(x_cur)]; color=:red, ms=6,
             label="x₍$(frame)₎ = $(round(x_cur; digits=6))")
end

gif(anim, joinpath(@__DIR__, "accnewtoncc.gif"); fps=2)
println("Saved: accnewtoncc.gif")
