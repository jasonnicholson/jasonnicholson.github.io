# ellipticdd.jl
# Elliptic PDE's page, Case 4: Mathews' Example 6, continuous boundary values.
# Laplace's equation on the unit square with u(x, 0) = sin(pi x), u(x, 1) = 1,
# u(0, y) = u(1, y) = y^2, on the page's 21 x 21 grid (h = 0.05), every interior value
# starting at 0, solved by Mathews' Dirichlet program with the table stored by
# coordinates as in his Example 5 (entry (i, j) = u(x_i, y_j); a sweep runs along the
# rows of the plate from the bottom up, left to right along each row), SOR with
# omega = 1.729454 from formula (11). The program stops at sweep 40 (largest change
# below 0.001); this animation continues the same iteration to sweep 60 to show what
# further sweeps can and cannot remove. One sweep per frame.
# Left: filled contours of the grid at levels 0, 0.1, ..., 1 (the corners drawn with
# their true values 0 and 1 instead of the program's averages, which the five-point
# formula never uses). Middle: the error u - u_exact at the grid points against the
# exact solution of Laplace's equation (the Fourier series on the page, odd k up to
# 399), colour scale rescaled every frame. Right (log scale): the largest change E of
# each sweep, the largest difference from the exact solution u* of the 361 difference
# equations (Gaussian elimination), and the largest error against Laplace's equation,
# with the discretisation error max |u* - u_exact| marked.
# Produces: ellipticdd.gif

using Plots
using Printf
using LinearAlgebra
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))

# --- Problem and Mathews' set-up (Example 5 storage: U[i, j] = u(x_i, y_j)) ---
f1(x) = sinpi(x); f2(x) = 1.0; f3(y) = y^2; f4(y) = y^2
n = m = 21
h = 1 / (n - 1)
xs = [(i - 1) * h for i in 1:n]
function setup()
    U = zeros(n, m)                                # interior starts at 0
    for i in 2:n-1
        U[i, 1] = f1(xs[i]); U[i, m] = f2(xs[i])
    end
    for j in 2:m-1
        U[1, j] = f3(xs[j]); U[n, j] = f4(xs[j])
    end
    U[1, 1] = (U[1, 2] + U[2, 1]) / 2; U[1, m] = (U[1, m-1] + U[2, m]) / 2
    U[n, 1] = (U[n-1, 1] + U[n, 2]) / 2; U[n, m] = (U[n-1, m] + U[n, m-1]) / 2
    return U
end
ω = 4 / (2 + sqrt(4 - (cos(π / (n - 1)) + cos(π / (m - 1)))^2))

function sweep!(U, ω)                              # j (y) outer, i (x) inner
    E = 0.0
    for j in 2:m-1, i in 2:n-1
        R = ω * (U[i, j+1] + U[i, j-1] + U[i+1, j] + U[i-1, j] - 4U[i, j]) / 4
        U[i, j] += R
        E = max(E, abs(R))
    end
    return E
end

function direct(U0)                                # exact solution of the 361 equations
    id = zeros(Int, n, m); N = 0
    for j in 2:m-1, i in 2:n-1
        N += 1; id[i, j] = N
    end
    A = zeros(N, N); B = zeros(N)
    for j in 2:m-1, i in 2:n-1
        p = id[i, j]; A[p, p] = -4
        for (a, b) in ((i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1))
            if id[a, b] > 0
                A[p, id[a, b]] = 1
            else
                B[p] -= U0[a, b]
            end
        end
    end
    x = A \ B
    S = copy(U0)
    for j in 2:m-1, i in 2:n-1
        S[i, j] = x[id[i, j]]
    end
    return S
end

# --- Exact solution of Laplace's equation (series on the page, odd k up to 399) ---
# sinh(k pi t) / sinh(k pi) written with exponentials that cannot overflow
sr(k, t) = exp(k * π * (t - 1)) * (1 - exp(-2k * π * t)) / (1 - exp(-2k * π))
function uexact(x, y)
    s = y^2 - x^2 + x
    for k in 1:2:399
        c = 8 / (k * π)^3
        Ak = (k == 1 ? 1.0 : 0.0) - c
        Bk = -c
        s += sinpi(k * x) * (Ak * sr(k, 1 - y) + Bk * sr(k, y))
    end
    return s
end
Ue = [uexact(xs[i], xs[j]) for i in 1:n, j in 1:m]

S = direct(setup())
interior(A) = A[2:end-1, 2:end-1]
K = 60                                             # sweeps drawn
U = setup()
grids = [copy(U)]; E = Float64[]
for k in 1:K
    push!(E, sweep!(U, ω)); push!(grids, copy(U))
end
Kstop = findfirst(<=(0.001), E)
errD = [maximum(abs.(interior(G - S))) for G in grids]      # iteration error
errL = [maximum(abs.(interior(G - Ue))) for G in grids]     # error against Laplace
disc = maximum(abs.(interior(S - Ue)))                      # discretisation error
@printf("omega = %.6f  program stops at sweep %d (E = %.6g)\n", ω, Kstop, E[Kstop])
@printf("discretisation error max|u* - u_exact| = %.6g\n", disc)
for k in [0, 1, 10, 20, 30, 38, 39, 40, 45, 50, 55, 60]
    @printf("sweep %2d  E = %-12.6g |u-u*| = %-12.6g |u-u_exact| = %.6g\n",
            k, k == 0 ? NaN : E[k], errD[k+1], errL[k+1])
end
println("E rises at sweeps ", [k for k in 2:K if E[k] > E[k-1]])
G = grids[Kstop+1]
@printf("after %d sweeps: u(0.25,0.25) = %.6f  u(0.5,0.5) = %.6f  interior min %.6f max %.6f\n",
        Kstop, G[6, 6], G[11, 11], minimum(interior(G)), maximum(interior(G)))

# --- Drawing ---
Ztrue(G) = (Z = permutedims(G); Z[1, 1] = 0.0; Z[1, n] = 0.0; Z[m, 1] = 1.0; Z[m, n] = 1.0; Z)
title_str = "SOR on Mathews' Example 6:  u(x, 0) = sin πx,  u(x, 1) = 1,  u(0, y) = u(1, y) = y²,  " *
            "21 × 21 grid,  ω = $(@sprintf("%.6f", ω)),  interior starts at 0"

function draw_frame(k)
    G = grids[k+1]
    tag = k == 0 ? "starting grid" : k < Kstop ? "sweep $k" :
          k == Kstop ? "sweep $k (program stops)" : "sweep $k (continued)"
    pC = contour(xs, xs, Ztrue(G); levels=0:0.1:1, fill=true, clims=(0, 1), c=:viridis,
                 aspect_ratio=1, xlims=(0, 1), ylims=(0, 1), framestyle=:box,
                 xlabel="x", ylabel="y", titlefontsize=9,
                 title="u, $tag\ncontours at 0, 0.1, …, 1")
    contour!(pC, xs, xs, Ztrue(G); levels=0:0.1:1, color=:black, lw=0.6)
    D = permutedims(G - Ue); D[1, 1] = D[1, n] = D[m, 1] = D[m, n] = 0.0
    c = errL[k+1]
    pE = heatmap(xs, xs, D; clims=(-c, c), c=:balance, aspect_ratio=1, xlims=(0, 1),
                 ylims=(0, 1), framestyle=:box, xlabel="x", ylabel="y", titlefontsize=9,
                 title="u − u_exact (Laplace's equation), $tag\ncolour scale ±$(fmt(c)), rescaled every frame")
    pL = plot(xlims=(0, K + 0.5), ylims=(1e-7, 3), yscale=:log10, framestyle=:box,
              grid=true, xlabel="sweep", ylabel="largest size (log scale)",
              legend=:bottomleft, legendfontsize=8, titlefontsize=10,
              yticks=10.0 .^ (-7:0), xticks=0:10:K,
              title="max |u − u_exact| = $(fmt(errL[k+1])),  max |u − u*| = $(fmt(errD[k+1]))")
    hline!(pL, [0.001]; color=:gray40, ls=:dash, lw=1, label="tolerance 0.001")
    hline!(pL, [disc]; color=:darkgreen, ls=:dashdot, lw=1.5,
           label="discretisation error max |u* − u_exact| = $(fmt(disc))")
    vline!(pL, [Kstop]; color=:gray60, ls=:dot, lw=1, label="sweep $Kstop: program stops")
    if k >= 1
        plot!(pL, 1:k, E[1:k]; color=:red, lw=1.2, marker=:circle, ms=3,
              markerstrokewidth=0, label="E, largest change in the sweep")
    end
    plot!(pL, 0:k, errD[1:k+1]; color=:black, lw=1.5, ls=:dot,
          label="max |u − u*|, iteration error")
    plot!(pL, 0:k, errL[1:k+1]; color=:darkorange, lw=2,
          label="max |u − u_exact|, error against Laplace")
    scatter!(pL, [k], [errD[k+1]]; color=:black, ms=4, markerstrokewidth=0, label="")
    scatter!(pL, [k], [errL[k+1]]; color=:darkorange, ms=4, markerstrokewidth=0, label="")
    plot(pC, pE, pL; layout=grid(1, 3, widths=[0.31, 0.31, 0.38]), size=(1500, 520),
         plot_title=title_str, plot_titlefontsize=11, left_margin=7Plots.mm,
         bottom_margin=6Plots.mm, background_color=:white)
end

anim = Animation()
for k in 0:K
    draw_frame(k)
    frame(anim)
    (k == 0 || k == Kstop) && (frame(anim); frame(anim); frame(anim))   # hold 1 s
end
for _ in 1:11                                      # hold the last sweep 3 s in all
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "ellipticdd.gif"); fps=4)
println("Saved: ellipticdd.gif")
