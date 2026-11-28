# cranknicolsondd.jl
# Crank-Nicolson Method page, Case 4: what unconditional stability buys.
# The grid and data of Mathews' Example 4 (u_t = u_xx, u(0, t) = u(1, t) = 0,
# u(x, 0) = sin(pi x) + sin(3 pi x), h = 0.1, k = 0.02, r = 2, ten steps to
# t = 0.2), with a sawtooth of size 0.001 added to the nine interior initial
# values: -0.001 at x = 0.1, +0.001 at x = 0.2, ..., -0.001 at x = 0.9.
# Both methods run twice, with and without the sawtooth, and
# delta = (perturbed run) - (unperturbed run) is the part of the solution that
# the sawtooth causes.
# Left column: the forward-difference (explicit) method (3) at r = 2, four times
# its stability limit. Middle column: the Crank-Nicolson method (6) at r = 2.
# Top row: the perturbed run (fixed axis; values that outgrow it leave the
# frame, with drawn positions limited to one axis span beyond it), the same
# method's run without the sawtooth (dashed) and the exact solution of the
# unperturbed problem (black). Bottom row: delta at the grid
# points, on an axis rescaled every step to fit it. Right: the largest |delta|
# in each row against t, log scale.
# Produces: cranknicolsondd.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

# --- Problem and grid (Mathews' Example 4) ---
f(x) = sin(π * x) + sin(3π * x)
uexact(x, t) = sin(π * x) * exp(-π^2 * t) + sin(3π * x) * exp(-9π^2 * t)
a, b, c = 1.0, 0.2, 1.0
n, m = 11, 11
h = a / (n - 1); k = b / (m - 1); r = c^2 * k / h^2
x = [(i - 1) * h for i in 1:n]
t = [(j - 1) * k for j in 1:m]
ε = 1e-3
saw = [i in 2:n-1 ? ε * (-1)^(i - 1) : 0.0 for i in 1:n]   # -ε at x = 0.1, +ε at x = 0.2, ...

function initial_row(pert)
    u0 = f.(x)
    u0[1] = u0[n] = 0.0                            # boundary values c1 = c2 = 0
    return pert ? u0 .+ saw : u0
end

# Forward-difference method (3)
function forward_difference(u0)
    U = zeros(m, n); U[1, :] = u0
    for j in 1:m-1, i in 2:n-1
        U[j+1, i] = (1 - 2r) * U[j, i] + r * (U[j, i-1] + U[j, i+1])
    end
    return U
end

# Tridiagonal solve: sub-diagonal l, diagonal d, super-diagonal u, right side rhs
function tridiag(l, d, u, rhs)
    N = length(d)
    dd, rr = copy(d), copy(rhs)
    for i in 2:N
        w = l[i-1] / dd[i-1]
        dd[i] -= w * u[i-1]
        rr[i] -= w * rr[i-1]
    end
    y = similar(rr)
    y[N] = rr[N] / dd[N]
    for i in N-1:-1:1
        y[i] = (rr[i] - u[i] * y[i+1]) / dd[i]
    end
    return y
end

# Crank-Nicolson method (6), Mathews' divided form
function crank_nicolson(u0)
    U = zeros(m, n); U[1, :] = u0
    N = n - 2
    l = fill(-1.0, N - 1); u = fill(-1.0, N - 1); d = fill(2 + 2 / r, N)
    for j in 1:m-1
        rhs = [U[j, i-1] + (2 / r - 2) * U[j, i] + U[j, i+1] for i in 2:n-1]
        U[j+1, 2:n-1] = tridiag(l, d, u, rhs)
    end
    return U
end

FDp, FD0 = forward_difference(initial_row(true)), forward_difference(initial_row(false))
CNp, CN0 = crank_nicolson(initial_row(true)), crank_nicolson(initial_row(false))
dFD, dCN = FDp .- FD0, CNp .- CN0
mFD = [maximum(abs.(dFD[j, :])) for j in 1:m]
mCN = [maximum(abs.(dCN[j, :])) for j in 1:m]
GFD9 = 1 - 4r * sin(9π * h / 2)^2
GCN9 = (1 - 2r * sin(9π * h / 2)^2) / (1 + 2r * sin(9π * h / 2)^2)
@printf("r = %.15g, FD factor for p = 9: %.6f, CN factor for p = 9: %.6f\n", r, GFD9, GCN9)
for j in 1:m
    @printf("t = %.2f  max|delta| FD = %-12.6g CN = %-12.6g  max|u| FD perturbed = %.6g\n",
            t[j], mFD[j], mCN[j], maximum(abs.(FDp[j, :])))
end

# --- Drawing ---
title_str = "A sawtooth of size 0.001 added to the initial data of Mathews' Example 4:  " *
            "h = 0.1,  k = 0.02,  r = 2"
xs = range(0, 1, length=301)
ylU = (-0.5, 2.5)

function profile_panel(Up, U0, j, col, name)
    p = plot(xlims=(0, 1), ylims=ylU, framestyle=:box, grid=true, xlabel="x",
             ylabel="u", legend=:top, legendfontsize=8, titlefontsize=10)
    hline!(p, [0.0]; color=:gray50, lw=1, label="")
    plot!(p, xs, uexact.(xs, t[j]); color=:black, lw=2,
          label="exact u(x, $(fmt(t[j]))), no sawtooth")
    plot!(p, x, U0[j, :]; color=col, alpha=0.6, lw=1.2, ls=:dash,
          label="$name without the sawtooth")
    plot!(p, x, ydraw.(Up[j, :], Ref(ylU)); color=col, lw=2, marker=:circle, ms=4.5,
          markerstrokewidth=0, label="$name with the sawtooth")
    mu = maximum(abs.(Up[j, :]))
    off = mu > ylU[2] ? " (off scale)" : ""
    title!(p, "$name, step $(j - 1), t = $(fmt(t[j])):  max |u| = $(fmt(mu))$off")
    return p
end

function delta_panel(d, j, col, name)
    s = maximum(abs.(d[j, :]))
    p = plot(xlims=(0, 1), ylims=(-1.2s, 1.2s), framestyle=:box, grid=true,
             xlabel="x", ylabel="δ", legend=false, titlefontsize=10,
             yformatter=v -> fmt(v))
    hline!(p, [0.0]; color=:gray50, lw=1)
    plot!(p, x, d[j, :]; color=col, lw=1.8, marker=:circle, ms=4.5, markerstrokewidth=0)
    title!(p, "δ, $name:  max |δ| = $(fmt(s))  (axis rescaled)")
    return p
end

function draw_frame(j)
    p1 = profile_panel(FDp, FD0, j, :red, "forward difference")
    p2 = profile_panel(CNp, CN0, j, :purple, "Crank-Nicolson")
    p3 = delta_panel(dFD, j, :red, "forward difference")
    p4 = delta_panel(dCN, j, :purple, "Crank-Nicolson")
    pm = plot(xlims=(0, 0.205), ylims=(1e-6, 1e6), yscale=:log10, framestyle=:box,
              grid=true, xlabel="t", legend=:topleft,
              legendfontsize=8, titlefontsize=10, yticks=10.0 .^ (-6:2:6))
    plot!(pm, t[1:j], mFD[1:j]; color=:red, lw=1.8, marker=:circle, ms=4,
          markerstrokewidth=0, label="forward difference: $(fmt(mFD[j]))")
    plot!(pm, t[1:j], mCN[1:j]; color=:purple, lw=1.8, marker=:circle, ms=4,
          markerstrokewidth=0, label="Crank-Nicolson: $(fmt(mCN[j]))")
    title!(pm, "largest |δ| in each row")
    l = @layout [grid(2, 2) a{0.27w}]
    plot(p1, p2, p3, p4, pm; layout=l, size=(1450, 720), plot_title=title_str,
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=4Plots.mm,
         background_color=:white)
end

anim = Animation()
for j in 1:m
    draw_frame(j)
    frame(anim)
end
for _ in 1:5                                       # hold the last step 3 s in all
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "cranknicolsondd.gif"); fps=2)
println("Saved: cranknicolsondd.gif")
