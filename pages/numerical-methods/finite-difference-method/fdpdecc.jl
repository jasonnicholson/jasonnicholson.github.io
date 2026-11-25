# fdpdecc.jl
# Finite Difference Method page, Case 3: Mathews' Example 3, the plucked string
# of Example 2 over the slightly longer rectangle 0 <= t <= 1.02. Explicit
# finite differences for u_tt = 4 u_xx on [0, 1], u(0, t) = u(1, t) = 0,
# u_t(x, 0) = 0, u(x, 0) = f(x) = x on [0, 3/5] and 3/2 - 3x/2 on [3/5, 1],
# keeping Example 2's grid n = 11, m = 21 (the page's reconstruction of
# Mathews' lost setup): h = 0.1, k = 1.02/20 = 0.051, r = ck/h = 1.02 > 1.
# Row 1 is f, row 2 comes from formula (8), rows 3..m from formula (6).
# Top: one time row per frame (red), the previous row (dashed) and d'Alembert's
# solution (black).
# Bottom left: the sawtooth part of the row, c9_j sin(9 pi x_i), where
# c9_j = (2/10) sum_i u_ij sin(9 pi x_i) is the coefficient of the unstable mode
# p = 9 in the discrete sine expansion of row j; the axis is rescaled every
# frame and the true size is in the title; the dashed envelope is ±|c9_j| sin(pi x).
# Bottom right (log scale): |c9_j| (filled marker c9 > 0, open marker c9 < 0)
# and the largest error |u_ij - u(x_i, t_j)| in each row, against t, with a
# reference line of slope |lambda| = 1.2762 per step, the size of the unstable
# root of lambda^2 - (2 - 4 r^2 s_9) lambda + 1 = 0, s_9 = sin^2(9 pi h / 2).
# Produces: fdpdecc.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))

# --- Problem (Mathews' Example 3) ---
f(x) = x <= 0.6 ? x : 1.5 - 1.5x
function F(z)                                      # odd extension of f, period 2
    z = mod(z + 1, 2) - 1                          # into [-1, 1)
    return z >= 0 ? f(z) : -f(-z)
end
uexact(x, t) = (F(x + 2t) + F(x - 2t)) / 2         # d'Alembert, c = 2
a, b, c = 1.0, 1.02, 2.0
n, m = 11, 21

h = a / (n - 1); k = b / (m - 1); r = c * k / h
x = [(i - 1) * h for i in 1:n]
t = [(j - 1) * k for j in 1:m]
U = zeros(n, m)
U[:, 1] = f.(x)
for i in 2:n-1                                     # formula (8), g = 0
    U[i, 2] = (1 - r^2) * U[i, 1] + r^2 / 2 * (U[i+1, 1] + U[i-1, 1])
end
for j in 3:m, i in 2:n-1                           # formula (6)
    U[i, j] = (2 - 2r^2) * U[i, j-1] + r^2 * (U[i+1, j-1] + U[i-1, j-1]) - U[i, j-2]
end
err = [maximum(abs.(U[:, j] .- uexact.(x, t[j]))) for j in 1:m]
s9 = sin(9π * h / 2)^2
B = 2 - 4r^2 * s9
lam = (B - sqrt(B^2 - 4)) / 2                      # the root of modulus > 1 (B < -2)
saw = sin.(9π .* x)                                # mode p = 9 at the grid points
c9 = [2 / (n - 1) * sum(U[:, j] .* saw) for j in 1:m]
umax = [maximum(abs.(U[:, j])) for j in 1:m]
@printf("h = %g, k = %.15g, r = %.15g, r^2 s9 = %.6f, lambda = %.6f\n", h, k, r, r^2 * s9, lam)
for j in 1:m
    @printf("j = %2d  t = %.3f  max|u| = %.4f  max|err| = %.4g  c9 = %+.4g  ratio = %s\n",
            j, t[j], umax[j], err[j], c9[j], j > 1 ? @sprintf("%.4f", c9[j] / c9[j-1]) : "-")
end

# --- Drawing ---
title_str = "Finite differences for the wave equation, Mathews' Example 3 (Example 2 with r > 1)\n" *
            "u_tt = 4u_xx,  same plucked string,  h = 0.1,  k = 1.02/20 = 0.051,  " *
            "r = 1.02:  unstable"
xs = range(0, 1, length=401)
xf = range(0, 1, length=401)
lamtxt = @sprintf("%.5g", abs(lam))                # 1.2762, as on the page
ref = abs(c9[m]) .* abs(lam) .^ ((1:m) .- m)       # slope |lambda| per step, through the last point

function draw_frame(j)
    pu = plot(xlims=(0, 1), ylims=(-1.45, 1.45), framestyle=:box, grid=true,
              xlabel="x", ylabel="u", legend=:outerright, legendfontsize=8,
              titlefontsize=10)
    if j > 1
        plot!(pu, x, U[:, j-1]; color=:salmon, lw=1.2, ls=:dash,
              label="previous row, t = $(fmt(t[j-1]))")
    end
    plot!(pu, xs, uexact.(xs, t[j]); color=:black, lw=2.5,
          label="d'Alembert u(x, $(fmt(t[j])))")
    plot!(pu, x, U[:, j]; color=:red, lw=1.5, marker=:circle, ms=5, markerstrokewidth=0,
          label="finite differences, row $j")
    etxt = j == 1 ? "initial row f" :
           "max |u| = $(fmt(umax[j])),  max |error| = $(fmt(err[j]))"
    title!(pu, "row j = $j,  t = $(fmt(t[j])),  $etxt")

    A = abs(c9[j])
    ps = plot(xlims=(0, 1), ylims=(-1.25A, 1.25A), framestyle=:box, grid=true,
              xlabel="x", ylabel="sawtooth part", legend=false, titlefontsize=10,
              yticks=([-A, 0, A], [fmt(-A), "0", fmt(A)]))
    # on this grid sin(9 pi x_i) = (-1)^i sin(pi x_i): a sawtooth inside the envelope ±sin(pi x)
    plot!(ps, xf, A .* sin.(π .* xf); color=:gray, lw=1, ls=:dash)
    plot!(ps, xf, -A .* sin.(π .* xf); color=:gray, lw=1, ls=:dash)
    plot!(ps, x, c9[j] .* saw; color=:darkorange, lw=1.5, marker=:circle, ms=4.5,
          markerstrokewidth=0)
    title!(ps, "c₉ sin 9πxᵢ in row $j: c₉ = $(fmt(c9[j])) (axis rescaled)")

    pl = plot(xlims=(-0.02, 1.04), ylims=(1e-3, 3), yscale=:log10, framestyle=:box,
              grid=true, xlabel="t", legend=:topleft, legendfontsize=8, titlefontsize=10,
              yticks=([1e-3, 1e-2, 1e-1, 1], ["0.001", "0.01", "0.1", "1"]))
    plot!(pl, t, ref; color=:gray, ls=:dash, lw=1,
          label="growth by |λ| = $lamtxt per step")
    js = 1:j
    pos = [q for q in js if c9[q] > 0]
    neg = [q for q in js if c9[q] < 0]
    plot!(pl, t[js], abs.(c9[js]); color=:darkorange, lw=1.2, label="")
    scatter!(pl, t[pos], abs.(c9[pos]); color=:darkorange, ms=4.5, markerstrokewidth=0,
             label="|c₉|, c₉ > 0")
    scatter!(pl, t[neg], abs.(c9[neg]); color=:white, markerstrokecolor=:darkorange,
             markerstrokewidth=1.5, ms=4.5, label="|c₉|, c₉ < 0")
    if j > 1
        plot!(pl, t[2:j], err[2:j]; color=:red, lw=1.5, marker=:square, ms=3.5,
              markerstrokewidth=0, label="max |error| in the row")
    else
        plot!(pl, [NaN], [NaN]; color=:red, lw=1.5, marker=:square, ms=3.5,
              markerstrokewidth=0, label="max |error| in the row")
    end
    title!(pl, "size of the sawtooth mode and of the error, rows 1 to $j")

    ph = plot(framestyle=:none, grid=false, xlims=(0, 1), ylims=(0, 1))
    annotate!(ph, 0.5, 0.5, text(title_str, 11, :center))
    l = @layout [t{0.06h}; a{0.5h}; b c]
    plot(ph, pu, ps, pl; layout=l, size=(1150, 820), left_margin=5Plots.mm,
         bottom_margin=5Plots.mm, right_margin=3Plots.mm, background_color=:white)
end

anim = Animation()
for j in 1:m
    draw_frame(j)
    frame(anim)
end
for _ in 1:5                                       # hold the last row 3 s in all
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "fdpdecc.gif"); fps=2)
println("Saved: fdpdecc.gif")
