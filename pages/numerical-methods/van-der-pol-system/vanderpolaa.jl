# vanderpolaa.jl
# van der Pol System animation: Mathews' Example 1, mu = 0 (the harmonic
# oscillator x'' + x = 0), x(0) = 0, x'(0) = 3, over Mathews' interval
# 0 <= t <= 6.283185 with n = 400 steps, solved as the system x' = y, y' = -x
# with the fourth-order Runge-Kutta method in vector form (Mathews' Runge2D).
# Four steps per frame.
# Left: the path in the xy-plane, in Mathews' style (joined points, magenta,
# axes marked -3..3, aspect ratio 1), over the exact circle of radius 3.
# Right: x(t) and y(t) against t over the exact 3 sin t and 3 cos t, and the
# error of each computed point (distance from the exact point) and the shrink
# of its distance from the origin, on a logarithmic scale.
# Produces: vanderpolaa.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))
fmtn(x, n) = x == 0 ? "0" : um(@sprintf("%.*g", n, x))

# --- Example 1 ---
mu = 0.0
F(t, z) = [z[2], -z[1] + mu * (1 - z[1]^2) * z[2]]
a, b, n = 0.0, 6.283185, 400
z0 = [0.0, 3.0]
h = (b - a) / n
ts = [a + j * h for j in 0:n]

# Runge-Kutta method of order 4 in vector form, formula (5): returns Z_0, ..., Z_n
function rk4(F, a, b, z0, n)
    h = (b - a) / n
    Z = [copy(z0)]
    z = copy(z0)
    for j in 0:n-1
        t = a + j * h
        K1 = h * F(t, z)
        K2 = h * F(t + h / 2, z + K1 / 2)
        K3 = h * F(t + h / 2, z + K2 / 2)
        K4 = h * F(t + h, z + K3)
        z = z + (K1 + 2K2 + 2K3 + K4) / 6
        push!(Z, z)
    end
    return Z
end

Z  = rk4(F, a, b, z0, n)
xs = first.(Z)
ys = last.(Z)

# --- Exact solution x = 3 sin t, y = 3 cos t and the errors ---
err  = [hypot(xs[j] - 3sin(ts[j]), ys[j] - 3cos(ts[j])) for j in 1:n+1]
drad = [3 - hypot(xs[j], ys[j]) for j in 1:n+1]      # shrink of the distance from the origin
emax = maximum(err)
@printf("h = %.10f\n", h)
@printf("end point Z_%d = (%.10e, %.15f)\n", n, xs[end], ys[end])
@printf("largest error over the %d points = %.6e\n", n + 1, emax)
@printf("3 - radius: min %.4e, max %.4e, at end %.6e\n", minimum(drad[2:end]), maximum(drad), drad[end])
@printf("error nondecreasing in j: %s\n", all(diff(err) .>= 0))
@printf("3 - radius nondecreasing in j: %s\n", all(diff(drad) .>= 0))

# --- Drawing ---
cP = :magenta                       # Mathews' PlotStyle -> Magenta
cX, cY = :royalblue, :orangered
lim = (-3.4, 3.4)
th = range(0, 2π, length=721)
title_str = "van der Pol (Mathews' Example 1):  μ = 0,  x′′ + x = 0,  " *
            "(x(0), x′(0)) = (0, 3),  Runge-Kutta, 0 ≤ t ≤ 6.283185, n = $n, h = $(fmtn(h, 9))"
steps_per_frame = 4
log_ticks = ([1e-14, 1e-12, 1e-10, 1e-8], ["10⁻¹⁴", "10⁻¹²", "10⁻¹⁰", "10⁻⁸"])

function draw_frame(j)
    t = ts[j+1]
    pP = plot(xlims=lim, ylims=lim, aspect_ratio=:equal, framestyle=:box,
              xticks=-3:3, yticks=-3:3, xlabel="x", ylabel="y = x′", grid=true,
              legend=:outerbottom, legend_columns=3, legendfontsize=7, titlefontsize=9)
    hline!(pP, [0]; color=:black, lw=0.8, label="")
    vline!(pP, [0]; color=:black, lw=0.8, label="")
    plot!(pP, 3cos.(th), 3sin.(th); color=:gray55, ls=:dash, lw=1,
          label="exact path: circle of radius 3")
    plot!(pP, xs[1:j+1], ys[1:j+1]; color=cP, lw=2, label="Runge-Kutta points, joined")
    scatter!(pP, [z0[1]], [z0[2]]; color=:white, markerstrokecolor=:black, ms=4,
             label="start (0, 3)")
    scatter!(pP, [xs[j+1]], [ys[j+1]]; color=cP, ms=6, label="")
    if j < n
        title!(pP, j == 0 ? "step j = 0:  t = 0:  (x, y) = (0, 3)" :
                   "step j = $j:  t = $(fmt(t)):  (x, y) = ($(fmt(xs[j+1])), $(fmt(ys[j+1])))")
    else
        title!(pP, "end point, j = $n, t = 6.283185:\n(x, y) = ($(fmtn(xs[end], 7)), " *
                   "$(fmtn(ys[end], 12)))")
    end

    pT = plot(xlims=(0, 2π), ylims=(-3.4, 4.9), framestyle=:box, ylabel="x(t), y(t)",
              grid=true, legend=:top, legend_columns=4, yticks=-3:3, legendfontsize=7,
              titlefontsize=9, xticks=0:1:6)
    plot!(pT, collect(range(0, b, length=400)), 3sin.(range(0, b, length=400));
          color=:gray55, ls=:dash, lw=1, label="3 sin t (exact)")
    plot!(pT, collect(range(0, b, length=400)), 3cos.(range(0, b, length=400));
          color=:gray30, ls=:dot, lw=1, label="3 cos t (exact)")
    plot!(pT, ts[1:j+1], xs[1:j+1]; color=cX, lw=2, label="x(t)")
    plot!(pT, ts[1:j+1], ys[1:j+1]; color=cY, lw=2, label="y(t) = x′(t)")
    scatter!(pT, [t, t], [xs[j+1], ys[j+1]]; color=[cX, cY], ms=4, markerstrokewidth=0, label="")
    title!(pT, "the computed points (x_j, y_j) against t_j")

    pE = plot(xlims=(0, 2π), ylims=(1e-14, 1e-7), yscale=:log10, framestyle=:box,
              xlabel="t", ylabel="size (log scale)", grid=true, legend=:bottomright,
              legendfontsize=7, titlefontsize=9, xticks=0:1:6, yticks=log_ticks)
    if j >= 1
        plot!(pE, ts[2:j+1], err[2:j+1]; color=:purple, lw=2,
              label="error: distance from (3 sin t, 3 cos t)")
        plot!(pE, ts[2:j+1], drad[2:j+1]; color=:darkgreen, lw=2,
              label="3 − distance from the origin")
        title!(pE, "error at step j = $j:  $(fmt(err[j+1])),  radius shrink $(fmt(drad[j+1]))")
    else
        title!(pE, "error at step j = 0:  0 (the starting point is exact)")
    end

    l = @layout [a{0.5w} [b; c]]
    plot(pP, pT, pE; layout=l, size=(1200, 600), plot_title=title_str,
         plot_titlefontsize=10, left_margin=5Plots.mm, right_margin=3Plots.mm, bottom_margin=4Plots.mm,
         background_color=:white)
end

anim = Animation()
for j in 0:steps_per_frame:n
    draw_frame(j)
    frame(anim)
end
for _ in 1:29                                          # hold the last frame 3 s
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "vanderpolaa.gif"); fps=10)
println("Saved: vanderpolaa.gif")
