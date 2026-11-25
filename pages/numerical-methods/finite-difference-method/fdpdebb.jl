# fdpdebb.jl
# Finite Difference Method page, Case 2: Mathews' Example 2, the plucked string.
# Explicit finite differences for u_tt = 4 u_xx on [0, 1], u(0, t) = u(1, t) = 0,
# u_t(x, 0) = 0, u(x, 0) = f(x) = x on [0, 3/5] and 3/2 - 3x/2 on [3/5, 1],
# with Mathews' grid n = 11, m = 21 (h = 0.1, k = 0.05, r = ck/h = 1).
# Row 1 is f, row 2 comes from formula (8) (exact here, since g = 0 and r = 1),
# rows 3..m from formula (6).
# Left: one time row per frame (red), the previous row (dashed) and d'Alembert's
# solution u = (F(x + 2t) + F(x - 2t))/2, F the odd period-2 extension of f
# (black), with the two corners of the exact string marked.
# Right: the (x, t) plane. The grid points of the rows computed so far are
# coloured by u_ij (Mathews' surface seen from above), and the paths of the two
# corners, x = fold(0.6 + 2t) and x = fold(0.6 - 2t), run along the grid diagonals.
# Produces: fdpdebb.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))

# --- Problem (Mathews' Example 2) ---
f(x) = x <= 0.6 ? x : 1.5 - 1.5x
function F(z)                                      # odd extension of f, period 2
    z = mod(z + 1, 2) - 1                          # into [-1, 1)
    return z >= 0 ? f(z) : -f(-z)
end
uexact(x, t) = (F(x + 2t) + F(x - 2t)) / 2         # d'Alembert, c = 2
function fold(z)                                   # position on [0, 1] after reflections
    z = mod(z, 2)
    return z <= 1 ? z : 2 - z
end
a, b, c = 1.0, 1.0, 2.0
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
# (left-moving, right-moving); rounded to 12 digits so that a corner at an end
# is labelled 0 or 1, not a rounding residue of 1e-16
corners(tt) = (round(fold(0.6 - 2tt), digits=12), round(fold(0.6 + 2tt), digits=12))
@printf("h = %g, k = %g, r = %.15g, max error over the grid = %.4g\n", h, k, r, maximum(err))
for j in 1:m
    cl, cr = corners(t[j])
    @printf("j = %2d  t = %.2f  corners at %.2f, %.2f   min u = %.4f   max|err| = %.3g\n",
            j, t[j], cl, cr, minimum(U[:, j]), err[j])
end

# --- Drawing ---
title_str = "Finite differences for the wave equation, Mathews' Example 2 (plucked string)\n" *
            "u_tt = 4u_xx,  u(x, 0) = f(x) peaked at x = 0.6,  u_t(x, 0) = 0,  " *
            "h = 0.1,  k = 0.05,  r = 1"
xs = range(0, 1, length=401)
ts = range(0, 1, length=401)
X = repeat(x, 1, m); T = repeat(t', n, 1)

function draw_frame(j)
    pu = plot(xlims=(0, 1), ylims=(-0.8, 0.8), framestyle=:box, grid=true,
              xlabel="x", ylabel="u", legend=:outerbottom, legend_columns=2,
              legendfontsize=8, titlefontsize=10)
    cl, cr = corners(t[j])
    vline!(pu, [cl, cr]; color=:gray, ls=:dot, lw=1.2, label="corners of the exact string")
    if j > 1
        plot!(pu, x, U[:, j-1]; color=:salmon, lw=1.2, ls=:dash,
              label="previous row, t = $(fmt(t[j-1]))")
    end
    plot!(pu, xs, uexact.(xs, t[j]); color=:black, lw=2.5,
          label="d'Alembert u(x, $(fmt(t[j])))")
    plot!(pu, x, U[:, j]; color=:red, lw=1, marker=:circle, ms=5, markerstrokewidth=0,
          label="finite differences, row $j")
    etxt = j == 1 ? "initial row f" : "max |error| in the row = $(fmt(err[j]))"
    ctxt = cl == cr ? "one corner, at x = $(fmt(cl))" : "corners at x = $(fmt(cl)) and $(fmt(cr))"
    title!(pu, "t = $(fmt(t[j])),  $ctxt,  $etxt")

    pxt = plot(xlims=(-0.03, 1.03), ylims=(-0.03, 1.03), framestyle=:box, grid=false,
               xlabel="x", ylabel="t", legend=:outerbottom, legendfontsize=8,
               legend_columns=2, titlefontsize=10, aspect_ratio=:none)
    scatter!(pxt, vec(X), vec(T); color=:lightgray, ms=2.5, markerstrokewidth=0, label="")
    plot!(pxt, fold.(0.6 .+ 2 .* ts), ts; color=:gray, lw=1, ls=:dot, label="")
    plot!(pxt, fold.(0.6 .- 2 .* ts), ts; color=:gray, lw=1, ls=:dot, label="")
    scatter!(pxt, vec(X[:, 1:j]), vec(T[:, 1:j]); marker_z=vec(U[:, 1:j]),
             color=:balance, clims=(-0.6, 0.6), ms=5, markerstrokewidth=0, label="",
             colorbar=true, colorbar_title="u_ij")
    tt = ts[ts .<= t[j]]
    plot!(pxt, fold.(0.6 .- 2 .* tt), tt; color=:darkorange, lw=2.5,
          label="corner moving left at first")
    plot!(pxt, fold.(0.6 .+ 2 .* tt), tt; color=:purple, lw=2.5,
          label="corner moving right at first")
    hline!(pxt, [t[j]]; color=:red, lw=1, label="current row")
    title!(pxt, "grid points coloured by u_ij, rows 1 to $j")

    ph = plot(framestyle=:none, grid=false, xlims=(0, 1), ylims=(0, 1))
    annotate!(ph, 0.5, 0.5, text(title_str, 11, :center))
    l = @layout [t{0.06h}; a{0.55w} b]
    plot(ph, pu, pxt; layout=l, size=(1200, 660), left_margin=5Plots.mm,
         bottom_margin=6Plots.mm, right_margin=3Plots.mm, background_color=:white)
end

anim = Animation()
for j in 1:m
    draw_frame(j)
    frame(anim)
end
for _ in 1:5                                       # hold the last row 3 s in all
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "fdpdebb.gif"); fps=2)
println("Saved: fdpdebb.gif")
