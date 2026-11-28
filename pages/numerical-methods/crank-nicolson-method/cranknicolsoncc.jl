# cranknicolsoncc.jl
# Crank-Nicolson Method page, Case 3: Mathews' Examples 3 and 4, the
# Crank-Nicolson method for u_t = u_xx on [0, 1], u(0, t) = u(1, t) = 0,
# u(x, 0) = sin(pi x) + sin(3 pi x), with n = m = 11 (h = 0.1, ten time steps):
# Example 3 on [0, 0.1] (k = 0.01, r = 1) and Example 4 on [0, 0.2]
# (k = 0.02, r = 2). Each step solves Mathews' divided form of the
# Crank-Nicolson equations,
#   -u[i-1,j+1] + (2 + 2/r) u[i,j+1] - u[i+1,j+1] = u[i-1,j] + (2/r - 2) u[i,j] + u[i+1,j],
# a tridiagonal system, by forward elimination and back substitution.
# Top: one time step of each example per frame (red), the previous row
# (dashed) and the exact solution u = sin(pi x) e^(-pi^2 t) + sin(3 pi x) e^(-9 pi^2 t)
# (black). Bottom (log scale): the largest error |u_ij - u(x_i, t_j)| in each
# row against t, for both examples.
# Produces: cranknicolsoncc.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))

# --- Problem ---
f(x) = sin(π * x) + sin(3π * x)
uexact(x, t) = sin(π * x) * exp(-π^2 * t) + sin(3π * x) * exp(-9π^2 * t)
a, c = 1.0, 1.0
n, m = 11, 11

# Tridiagonal solve: sub-diagonal l, diagonal d, super-diagonal u, right side rhs
function tridiag(l, d, u, rhs)
    N = length(d)
    dd, rr = copy(d), copy(rhs)
    for i in 2:N                                   # forward elimination
        w = l[i-1] / dd[i-1]
        dd[i] -= w * u[i-1]
        rr[i] -= w * rr[i-1]
    end
    x = similar(rr)
    x[N] = rr[N] / dd[N]
    for i in N-1:-1:1                              # back substitution
        x[i] = (rr[i] - u[i] * x[i+1]) / dd[i]
    end
    return x
end

# Crank-Nicolson, Mathews' divided form; row j of U is t_j
function crank_nicolson(b)
    h = a / (n - 1); k = b / (m - 1); r = c^2 * k / h^2
    x = [(i - 1) * h for i in 1:n]
    U = zeros(m, n)
    U[1, :] = f.(x)
    U[1, 1] = U[1, n] = 0.0                        # boundary values c1 = c2 = 0
    N = n - 2
    l = fill(-1.0, N - 1); u = fill(-1.0, N - 1); d = fill(2 + 2 / r, N)
    for j in 1:m-1
        rhs = [U[j, i-1] + (2 / r - 2) * U[j, i] + U[j, i+1] for i in 2:n-1]
        U[j+1, 2:n-1] = tridiag(l, d, u, rhs)
    end
    t = [(j - 1) * k for j in 1:m]
    return x, t, U, r, k
end

runs = [crank_nicolson(0.1), crank_nicolson(0.2)]
names = ["Example 3", "Example 4"]
errs = [[maximum(abs.(U[j, :] .- uexact.(x, t[j]))) for j in 1:m] for (x, t, U) in runs]
for (q, (x, t, U, r, k)) in enumerate(runs)
    @printf("%s: k = %g, r = %.15g\n", names[q], k, r)
    for j in 1:m
        @printf("  t = %.2f  u(x=0.1..0.5) = %s  max|err| = %.6g\n", t[j],
                join([@sprintf("%.6f", U[j, i]) for i in 2:6], " "), errs[q][j])
    end
end

# --- Drawing ---
title_str = "Crank-Nicolson (Mathews' Examples 3 and 4):  u_t = u_xx,  " *
            "u(x, 0) = sin πx + sin 3πx,  h = 0.1,  ten steps"
xs = range(0, 1, length=301)
cols = [:red, :purple]

function draw_frame(j)
    pans = Any[]
    for q in 1:2
        x, t, U, r, k = runs[q]
        p = plot(xlims=(0, 1), ylims=(0, 1.75), framestyle=:box, grid=true,
                 xlabel="x", ylabel="u", legend=:topright, legendfontsize=8,
                 titlefontsize=10)
        if j > 1
            plot!(p, x, U[j-1, :]; color=cols[q], alpha=0.5, lw=1.2, ls=:dash,
                  label="previous row, t = $(fmt(t[j-1]))")
        end
        plot!(p, xs, uexact.(xs, t[j]); color=:black, lw=2, label="exact u(x, $(fmt(t[j])))")
        plot!(p, x, U[j, :]; color=cols[q], lw=2, marker=:circle, ms=4.5,
              markerstrokewidth=0, label="Crank-Nicolson, step $(j - 1)")
        etxt = j == 1 ? "initial row" : "max |error| = $(fmt(errs[q][j]))"
        title!(p, "$(names[q]): k = $(fmt(k)), r = $(round(Int, r)),  t = $(fmt(t[j])),  $etxt")
        push!(pans, p)
    end

    pe = plot(xlims=(0, 0.205), ylims=(1e-3, 0.1), yscale=:log10, framestyle=:box,
              grid=true, xlabel="t", ylabel="max |error| in the row",
              legend=:topright, legendfontsize=8, titlefontsize=10,
              yticks=([1e-3, 2e-3, 5e-3, 1e-2, 2e-2, 5e-2, 1e-1],
                      ["0.001", "0.002", "0.005", "0.01", "0.02", "0.05", "0.1"]))
    for q in 1:2
        x, t, U, r, k = runs[q]
        if j > 1
            plot!(pe, t[2:j], errs[q][2:j]; color=cols[q], lw=1.8, marker=:circle,
                  ms=4, markerstrokewidth=0,
                  label="$(names[q]), r = $(round(Int, r)): $(fmt(errs[q][j])) at t = $(fmt(t[j]))")
        else
            plot!(pe, [NaN], [NaN]; color=cols[q], lw=1.8, marker=:circle, ms=4,
                  markerstrokewidth=0, label="$(names[q]), r = $(round(Int, r))")
        end
    end
    title!(pe, "largest error in each time row (the initial rows are exact)")

    l = @layout [grid(1, 2){0.62h}; a]
    plot(pans[1], pans[2], pe; layout=l, size=(1150, 760), plot_title=title_str,
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
gif(anim, joinpath(@__DIR__, "cranknicolsoncc.gif"); fps=2)
println("Saved: cranknicolsoncc.gif")
