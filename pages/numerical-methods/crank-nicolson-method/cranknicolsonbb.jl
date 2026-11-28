# cranknicolsonbb.jl
# Crank-Nicolson Method page, Case 2: Mathews' Example 2, the forward-difference
# (explicit) method with a step that is too large. u_t = u_xx, u(0, t) = u(1, t) = 0,
# u(x, 0) = 4x - 4x^2, n = 6 columns, h = 0.2, k = 0.035, r = c^2 k / h^2 = 0.875.
# Mathews' run has m = 11 rows (t up to 0.35); this animation continues the same
# run to row 21 (t = 0.70). The method runs in exact rational arithmetic.
# Left: one time row per frame (red), the previous row (dashed), and the exact
# solution (black), the Fourier series summed over odd p up to 1999. The axis is
# fixed; rows that outgrow it leave the frame (drawn positions are limited to one
# axis span beyond the frame), and the title gives their true largest value.
# Right (log scale): the coefficients A_1 and A_3 of the discrete sine modes
# sin(pi x_i) and sin(3 pi x_i) in each computed row, found by a discrete sine
# transform of the row, against the decay e^(-p^2 pi^2 t) that the heat equation
# gives each mode. A_3 is drawn by its size, with filled markers where A_3 > 0
# and open markers where A_3 < 0.
# Produces: cranknicolsonbb.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

# --- Problem and grid (Mathews' Example 2) ---
f(x) = 4x - 4x^2
a, b, c = 1, 7 // 20, 1                            # b = 0.35
n, mM = 6, 11                                      # Mathews' grid
m = 21                                             # continued to t = 0.70
h = a // (n - 1)                                   # 1/5
k = b // (mM - 1)                                  # 7/200 = 0.035
r = c^2 * k / h^2                                  # 7/8
xg = [(i - 1) * h for i in 1:n]
tg = [(j - 1) * k for j in 1:m]

# --- Forward-difference method (3), exact rationals; row j of U is t_j ---
U = zeros(Rational{BigInt}, m, n)
U[1, :] = f.(big.(xg))
for j in 1:m-1, i in 2:n-1
    U[j+1, i] = (1 - 2r) * U[j, i] + r * (U[j, i-1] + U[j, i+1])
end
Uf = Float64.(U)
tf, xf = Float64.(tg), Float64.(xg)

# --- Exact solution: Fourier sine series, odd p up to 1999 (f itself at t = 0) ---
function uexact(x, t)
    t == 0 && return f(x)
    s = 0.0
    for p in 1:2:1999
        s += 32 / (p^3 * π^3) * sin(p * π * x) * exp(-p^2 * π^2 * t)
    end
    return s
end
xs = range(0, 1, length=301)

# --- Discrete sine coefficients of each row: u_i = sum_p A_p sin(p pi x_i) ---
A(j, p) = 2 / (n - 1) * sum(Uf[j, i] * sin(p * π * xf[i]) for i in 2:n-1)
A1 = [A(j, 1) for j in 1:m]
A3 = [A(j, 3) for j in 1:m]
G1 = 1 - 4 * Float64(r) * sin(π * Float64(h) / 2)^2
G3 = 1 - 4 * Float64(r) * sin(3π * Float64(h) / 2)^2

maxu = [maximum(abs.(Uf[j, :])) for j in 1:m]
for j in 1:m
    @printf("row %2d t = %.3f  u(0.2) = %-12.6f u(0.4) = %-12.6f exact %.6f  max|u| = %.6g  A1 = %.6g  A3 = %.6g\n",
            j, tf[j], Uf[j, 2], Uf[j, 3], uexact(0.2, tf[j]), maxu[j], A1[j], A3[j])
end
@printf("G1 = %.6f  G3 = %.6f\n", G1, G3)

# --- Drawing ---
title_str = "Forward differences with too large a step (Mathews' Example 2):  u_t = u_xx,  " *
            "u(x, 0) = 4x − 4x²,  h = 0.2,  k = 0.035,  r = 0.875"
ylU = (-1.25, 1.25)

function draw_frame(j)
    pU = plot(xlims=(0, 1), ylims=ylU, framestyle=:box, grid=true,
              xlabel="x", ylabel="u", legend=:outertop, legend_columns=3, legendfontsize=8,
              titlefontsize=10)
    hline!(pU, [0.0]; color=:gray50, lw=1, label="")
    if j > 1
        plot!(pU, xf, ydraw.(Uf[j-1, :], Ref(ylU)); color=:salmon, lw=1.5,
              ls=:dash, label="previous row, $(j - 1)")
    end
    plot!(pU, xs, uexact.(xs, tf[j]); color=:black, lw=2,
          label="exact u(x, $(fmt(tf[j])))")
    plot!(pU, xf, ydraw.(Uf[j, :], Ref(ylU)); color=:red, lw=2, marker=:circle, ms=5,
          markerstrokewidth=0, label="forward difference, row $j")
    off = maxu[j] > ylU[2] ? " (off scale)" : ""
    note = j == mM ? "  (Mathews' last row)" : j > mM ? "  (run continued)" : ""
    title!(pU, "row $j, t = $(fmt(tf[j]))$note:  max |u| = $(fmt(maxu[j]))$off")

    pA = plot(xlims=(0, 0.72), ylims=(1e-7, 30), yscale=:log10, framestyle=:box,
              grid=true, xlabel="t", ylabel="size of the mode coefficient",
              legend=:bottomright, legendfontsize=8, titlefontsize=10,
              yticks=10.0 .^ (-7:1))
    vline!(pA, [tf[mM]]; color=:gray60, ls=:dot, lw=1, label="t = 0.35, Mathews' last row")
    tt = range(0, 0.72, length=200)
    plot!(pA, tt, A1[1] .* exp.(-π^2 .* tt); color=:steelblue, ls=:dash, lw=1.5,
          label="A₁(0) e^(−π²t), true decay")
    plot!(pA, tt, A3[1] .* exp.(-9π^2 .* tt); color=:darkorange, ls=:dash, lw=1.5,
          label="A₃(0) e^(−9π²t), true decay")
    plot!(pA, tf[1:j], A1[1:j]; color=:steelblue, lw=1.5, marker=:circle, ms=4,
          markerstrokewidth=0, label="A₁, computed (factor $(fmt(G1)) per step)")
    plot!(pA, tf[1:j], abs.(A3[1:j]); color=:darkorange, lw=1.5, label="")
    pos = [jj for jj in 1:j if A3[jj] > 0]
    neg = [jj for jj in 1:j if A3[jj] < 0]
    scatter!(pA, tf[pos], A3[pos]; color=:darkorange, ms=4.5, markerstrokewidth=0,
             label="|A₃|, computed (factor $(fmt(G3)) per step): A₃ > 0")
    scatter!(pA, tf[neg], abs.(A3[neg]); color=:white, ms=4.5,
             markerstrokecolor=:darkorange, markerstrokewidth=1.5, label="A₃ < 0")
    title!(pA, "A₁ = $(fmt(A1[j])),   A₃ = $(fmt(A3[j]))")

    plot(pU, pA; layout=(1, 2), size=(1150, 500), plot_title=title_str,
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white)
end

anim = Animation()
for j in 1:m
    draw_frame(j)
    frame(anim)
    if j == mM                                     # pause 1 s on Mathews' last row
        frame(anim); frame(anim)
    end
end
for _ in 1:5                                       # hold the last row 3 s in all
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "cranknicolsonbb.gif"); fps=2)
println("Saved: cranknicolsonbb.gif")
