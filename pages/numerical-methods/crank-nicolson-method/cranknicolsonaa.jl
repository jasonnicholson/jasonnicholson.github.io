# cranknicolsonaa.jl
# Crank-Nicolson Method page, Case 1: Mathews' Example 1, the forward-difference
# (explicit) method for u_t = u_xx on [0, 1] x [0, 0.2], u(0, t) = u(1, t) = 0,
# u(x, 0) = 4x - 4x^2, with n = 6 columns and m = 11 rows: h = 0.2, k = 0.02,
# r = c^2 k / h^2 = 0.5. The method runs in exact rational arithmetic.
# Left: one time row per frame (red, joined by straight lines as in Mathews'
# surface), the earlier rows faint, and the exact solution at the same time
# (black), the Fourier series summed over odd p up to 1999.
# Right: the error u_ij - u(x_i, t_j) at the grid points of the row.
# Produces: cranknicolsonaa.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))

# --- Problem and grid (Mathews' Example 1) ---
f(x) = 4x - 4x^2
a, b, c = 1, 1 // 5, 1
n, m = 6, 11
h = a // (n - 1)                                   # 1/5
k = b // (m - 1)                                   # 1/50
r = c^2 * k / h^2                                  # 1/2
xg = [(i - 1) * h for i in 1:n]
tg = [(j - 1) * k for j in 1:m]

# --- Forward-difference method (3), exact rationals; row j of U is t_j ---
U = zeros(Rational{BigInt}, m, n)
U[1, :] = f.(big.(xg))
for j in 1:m-1, i in 2:n-1
    U[j+1, i] = (1 - 2r) * U[j, i] + r * (U[j, i-1] + U[j, i+1])
end
Uf = Float64.(U)

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
tf, xf = Float64.(tg), Float64.(xg)
E = [Uf[j, i] - uexact(xf[i], tf[j]) for j in 1:m, i in 1:n]   # errors at grid points
E[1, :] .= 0.0                                     # the initial row is f(x_i) exactly

for j in 1:m
    @printf("t = %.2f  u(0.2) = %-10s u(0.4) = %-10s exact %.6f %.6f  max|err| = %.6g\n",
            tf[j], string(U[j, 2]), string(U[j, 3]), uexact(0.2, tf[j]),
            uexact(0.4, tf[j]), maximum(abs.(E[j, :])))
end
jmax = argmax([maximum(abs.(E[j, :])) for j in 1:m])
@printf("largest error %.6g at t = %.2f\n", maximum(abs.(E)), tf[jmax])

# --- Drawing ---
title_str = "Forward differences (Mathews' Example 1):  u_t = u_xx,  u(x, 0) = 4x − 4x²,  " *
            "h = 0.2,  k = 0.02,  r = c²k/h² = 0.5"

where(e) = join(fmt.(xf[findall(abs.(e) .>= maximum(abs.(e)) * (1 - 1e-12))]), " and ")

function draw_frame(j)
    pU = plot(xlims=(0, 1), ylims=(0, 1.3), framestyle=:box, grid=true,
              xlabel="x", ylabel="u", legend=:top, legendfontsize=8,
              titlefontsize=10)
    for jj in 1:j-1
        plot!(pU, xf, Uf[jj, :]; color=:salmon, alpha=0.45, lw=1,
              label=jj == 1 ? "earlier rows" : "")
    end
    plot!(pU, xs, uexact.(xs, tf[j]); color=:black, lw=2,
          label="exact u(x, $(fmt(tf[j])))")
    plot!(pU, xf, Uf[j, :]; color=:red, lw=2, marker=:circle, ms=5,
          markerstrokewidth=0, label="forward difference, row $j")
    title!(pU, j == 1 ? "row 1, t = 0:  u_i1 = f(x_i)" :
               "row $j, t = $(fmt(tf[j])):  u(0.2) = $(fmt(Uf[j, 2])),  u(0.4) = $(fmt(Uf[j, 3]))")

    pE = plot(xlims=(0, 1), ylims=(-0.03, 0.005), framestyle=:box, grid=true,
              xlabel="x", ylabel="u_ij − u(x_i, t_j)", legend=:bottomright,
              legendfontsize=8, titlefontsize=10)
    hline!(pE, [0.0]; color=:gray50, lw=1, label="")
    for jj in 2:j-1
        plot!(pE, xf, E[jj, :]; color=:salmon, alpha=0.45, lw=1,
              label=jj == 2 ? "earlier rows" : "")
    end
    plot!(pE, xf, E[j, :]; color=:red, lw=2, marker=:circle, ms=5,
          markerstrokewidth=0, label="error, row $j")
    emax = maximum(abs.(E[j, :]))
    title!(pE, j == 1 ? "error 0: the first row is the initial data" :
               "max |error| = $(fmt(emax)) at x = $(where(E[j, :]))")

    plot(pU, pE; layout=(1, 2), size=(1100, 470), plot_title=title_str,
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white)
end

anim = Animation()
for j in 1:m
    draw_frame(j)
    frame(anim)
end
for _ in 1:5                                       # hold the last row 3 s in all
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "cranknicolsonaa.gif"); fps=2)
println("Saved: cranknicolsonaa.gif")
