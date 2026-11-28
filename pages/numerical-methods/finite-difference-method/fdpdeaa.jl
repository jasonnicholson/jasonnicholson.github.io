# fdpdeaa.jl
# Finite Difference Method page, Case 1: Mathews' Example 1, the explicit
# finite difference method for the wave equation u_tt = 4 u_xx on [0, 1],
# u(0, t) = u(1, t) = 0, u(x, 0) = sin(pi x) + sin(2 pi x), u_t(x, 0) = 0,
# with Mathews' grid n = 11, m = 21 (h = 0.1, k = 0.05, r = ck/h = 1).
# Row 1 is f; row 2 is either Mathews' second-row formula (8), which for
# g = 0 and r = 1 is exact, or the first-order formula (7), u[i,2] = f[i];
# rows 3..m come from formula (6),
#   u[i,j+1] = (2 - 2r^2) u[i,j] + r^2 (u[i+1,j] + u[i-1,j]) - u[i,j-1].
# Top: one time row per frame for both runs, against the exact solution
# u = sin(pi x) cos(2 pi t) + sin(2 pi x) cos(4 pi t) (black).
# Bottom (log scale): the largest error |u_ij - u(x_i, t_j)| in each row
# against t, for both runs (the initial row is f in both).
# Produces: fdpdeaa.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))

# --- Problem (Mathews' Example 1) ---
f(x) = sin(π * x) + sin(2π * x)
uexact(x, t) = sin(π * x) * cos(2π * t) + sin(2π * x) * cos(4π * t)
a, b, c = 1.0, 1.0, 2.0
n, m = 11, 21

# Mathews' program: U[i, j] approximates u(x_i, t_j), x_i = (i-1)h, t_j = (j-1)k
function wave_fd(row2)
    h = a / (n - 1); k = b / (m - 1); r = c * k / h
    x = [(i - 1) * h for i in 1:n]
    t = [(j - 1) * k for j in 1:m]
    U = zeros(n, m)
    U[:, 1] = f.(x)
    for i in 2:n-1
        U[i, 2] = row2 == :eq8 ? (1 - r^2) * U[i, 1] + r^2 / 2 * (U[i+1, 1] + U[i-1, 1]) :
                                 U[i, 1]                                  # formula (7), g = 0
    end
    for j in 3:m, i in 2:n-1
        U[i, j] = (2 - 2r^2) * U[i, j-1] + r^2 * (U[i+1, j-1] + U[i-1, j-1]) - U[i, j-2]
    end
    return x, t, U, r, k
end

x, t, U8, r, k = wave_fd(:eq8)
_, _, U7, _, _ = wave_fd(:eq7)
err8 = [maximum(abs.(U8[:, j] .- uexact.(x, t[j]))) for j in 1:m]
err7 = [maximum(abs.(U7[:, j] .- uexact.(x, t[j]))) for j in 1:m]
@printf("h = %g, k = %g, r = %.15g\n", x[2], k, r)
for j in 1:m
    @printf("j = %2d  t = %.2f  max|err| (8) = %.4g   (7) = %.4g\n", j, t[j], err8[j], err7[j])
end
@printf("over the grid: (8) %.4g, (7) %.4g at t = %.2f\n", maximum(err8), maximum(err7),
        t[argmax(err7)])

# --- Drawing ---
title_str = "Finite differences for the wave equation, Mathews' Example 1\n" *
            "u_tt = 4u_xx,  u(x, 0) = sin πx + sin 2πx,  u_t(x, 0) = 0,  h = 0.1,  k = 0.05,  r = 1"
xs = range(0, 1, length=301)

function draw_frame(j)
    pu = plot(xlims=(0, 1), ylims=(-2.2, 2.2), framestyle=:box, grid=true,
              xlabel="x", ylabel="u", legend=:bottomleft, legendfontsize=8,
              titlefontsize=10)
    plot!(pu, xs, uexact.(xs, t[j]); color=:black, lw=2.5, label="exact u(x, $(fmt(t[j])))")
    plot!(pu, x, U7[:, j]; color=:steelblue, lw=1.5, ls=:dash, marker=:diamond, ms=5,
          markerstrokewidth=0, label="second row by (7), u_i,2 = f_i")
    plot!(pu, x, U8[:, j]; color=:red, lw=1, marker=:circle, ms=5, markerstrokewidth=0,
          label="second row by (8): Mathews' method")
    stxt = j == 1 ? "initial row f" :
           "max |error|:  (8) $(fmt(err8[j])),  (7) $(fmt(err7[j]))"
    title!(pu, "row j = $j,  t = $(fmt(t[j])),  $stxt")

    pe = plot(xlims=(0, 1.02), ylims=(1e-17, 3), yscale=:log10, framestyle=:box,
              grid=true, xlabel="t", ylabel="max |error| in the row",
              legend=:right, legendfontsize=8, titlefontsize=10,
              yticks=10.0 .^ (-16:2:0))
    if j > 1
        plot!(pe, t[2:j], err7[2:j]; color=:steelblue, lw=1.5, marker=:diamond, ms=4,
              markerstrokewidth=0, label="second row by (7)")
        plot!(pe, t[2:j], err8[2:j]; color=:red, lw=1.5, marker=:circle, ms=4,
              markerstrokewidth=0, label="second row by (8)")
    else
        plot!(pe, [NaN], [NaN]; color=:steelblue, lw=1.5, marker=:diamond, ms=4,
              markerstrokewidth=0, label="second row by (7)")
        plot!(pe, [NaN], [NaN]; color=:red, lw=1.5, marker=:circle, ms=4,
              markerstrokewidth=0, label="second row by (8)")
    end
    title!(pe, "largest error in each time row (row 1 is f in both runs)")

    ph = plot(framestyle=:none, grid=false, xlims=(0, 1), ylims=(0, 1))
    annotate!(ph, 0.5, 0.5, text(title_str, 11, :center))
    l = @layout [t{0.06h}; a{0.57h}; b]
    plot(ph, pu, pe; layout=l, size=(1000, 820), left_margin=5Plots.mm,
         bottom_margin=4Plots.mm, background_color=:white)
end

anim = Animation()
for j in 1:m
    draw_frame(j)
    frame(anim)
end
for _ in 1:5                                       # hold the last row 3 s in all
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "fdpdeaa.gif"); fps=2)
println("Saved: fdpdeaa.gif")
