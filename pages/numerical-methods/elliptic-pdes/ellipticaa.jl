# ellipticaa.jl
# Elliptic PDE's page, Case 1: Mathews' Example 1. Laplace's equation on a 9 x 9 grid
# with the edges held at 180 (top), 80 (left), 20 (bottom) and 0 (right), solved by
# Mathews' Dirichlet program: SOR with omega = 1.446463 from formula (11), every
# interior value starting at 70, the corners set to the averages of their two edge
# neighbours, sweeps column by column from the left and down each column from the
# top, stopping once the largest correction |omega r| of a sweep is below 0.001.
# One sweep per frame, from the starting grid (sweep 0) to sweep 20, where it stops.
# Left: the grid values as a surface (wire mesh through the grid points). Middle: filled contours at Mathews' 13 levels
# 0, 15, ..., 180, with the grid points marked. The plate is drawn on the unit square
# (h = 1/8, as in Example 4); the grid values do not depend on the side length.
# Right (log scale): the largest change E of each sweep (what the program prints and
# tests) and the largest difference from the exact solution of the 49 difference
# equations, found by Gaussian elimination.
# Produces: ellipticaa.gif

using Plots
using Printf
using LinearAlgebra
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))

# --- Mathews' set-up: table M laid out like the plate, row 1 at the top ---
n = m = 9
function setup(n, m)
    M = fill(70.0, n, m)
    M[1, 2:m-1] .= 180.0                           # top
    M[n, 2:m-1] .= 20.0                            # bottom
    M[2:n-1, 1] .= 80.0                            # left
    M[2:n-1, m] .= 0.0                             # right
    M[1, 1] = (M[1, 2] + M[2, 1]) / 2
    M[1, m] = (M[1, m-1] + M[2, m]) / 2
    M[n, 1] = (M[n-1, 1] + M[n, 2]) / 2
    M[n, m] = (M[n-1, m] + M[n, m-1]) / 2
    return M
end
ω = 4 / (2 + sqrt(4 - (cos(π / (n - 1)) + cos(π / (m - 1)))^2))

# One sweep of Mathews' program: column j outer (left to right), row i inner (top down)
function sweep!(M, ω)
    E = 0.0
    nr, nc = size(M)
    for j in 2:nc-1, i in 2:nr-1
        R = ω * (M[i, j+1] + M[i, j-1] + M[i+1, j] + M[i-1, j] - 4M[i, j]) / 4
        M[i, j] += R
        E = max(E, abs(R))
    end
    return E
end

# --- Exact solution of the difference equations (dense Gaussian elimination) ---
function direct(M0)
    nr, nc = size(M0)
    id = zeros(Int, nr, nc); N = 0
    for j in 2:nc-1, i in 2:nr-1
        N += 1; id[i, j] = N
    end
    A = zeros(N, N); B = zeros(N)
    for j in 2:nc-1, i in 2:nr-1
        p = id[i, j]; A[p, p] = -4
        for (a, b) in ((i - 1, j), (i + 1, j), (i, j - 1), (i, j + 1))
            if id[a, b] > 0
                A[p, id[a, b]] = 1
            else
                B[p] -= M0[a, b]
            end
        end
    end
    x = A \ B
    S = copy(M0)
    for j in 2:nc-1, i in 2:nr-1
        S[i, j] = x[id[i, j]]
    end
    return S
end

M = setup(n, m)
S = direct(M)
interior(A) = A[2:end-1, 2:end-1]
grids = [copy(M)]
E = Float64[]
err = [maximum(abs.(interior(M - S)))]
while true
    e = sweep!(M, ω)
    push!(E, e); push!(grids, copy(M))
    push!(err, maximum(abs.(interior(M - S))))
    (e <= 0.001 || length(E) >= 71) && break
end
K = length(E)
@printf("omega = %.6f  sweeps = %d\n", ω, K)
for k in 1:K
    @printf("sweep %2d  E = %-12.6g max|u - u*| = %.6g\n", k, E[k], err[k+1])
end
@printf("start: max|u - u*| = %.6g   centre after %d sweeps = %.6f\n", err[1], K, M[5, 5])

# --- Drawing ---
xs = range(0, 1, length=n)                         # x_i = (i - 1)/8
plate(M) = reverse(M, dims=1)                      # Z[iy, ix], y = 0 first
title_str = "SOR on Mathews' Example 1:  9 × 9 grid,  top 180,  left 80,  bottom 20,  right 0,  " *
            "ω = $(@sprintf("%.6f", ω)),  interior starts at 70"
XX = [x for y in xs, x in xs]; YY = [y for y in xs, x in xs]

function draw_frame(k)                             # k = sweeps done
    Z = plate(grids[k+1])
    head = k == 0 ? "starting grid (sweep 0)" :
           "sweep $k:  largest change E = $(fmt(E[k]))" * (k == K ? "  (below 0.001: stop)" : "")
    pS = wireframe(xs, xs, Z; camera=(30, 30), zlims=(0, 180), xlabel="x", ylabel="y",
                   zlabel="u", titlefontsize=10, zticks=0:50:150, title=head)
    pC = contour(xs, xs, Z; levels=0:15:180, fill=true, clims=(0, 180), c=:thermal,
                 aspect_ratio=1, xlims=(0, 1), ylims=(0, 1), framestyle=:box,
                 xlabel="x", ylabel="y", titlefontsize=10, colorbar_ticks=0:30:180,
                 title="contours of u at 0, 15, …, 180;  centre $(@sprintf("%.6g", Z[5, 5]))")
    contour!(pC, xs, xs, Z; levels=0:15:180, color=:black, lw=0.6)
    scatter!(pC, vec(XX), vec(YY); color=:white, ms=2.5, markerstrokecolor=:black,
             markerstrokewidth=0.5, label="")
    pL = plot(xlims=(0, K + 0.5), ylims=(1e-4, 300), yscale=:log10, framestyle=:box,
              grid=true, xlabel="sweep", ylabel="largest size (log scale)", legend=:topright,
              legendfontsize=8, titlefontsize=10, yticks=10.0 .^ (-4:2), xticks=0:5:K,
              title="max |u − u*| = $(fmt(err[k+1]))  (u* solves the 49 equations)")
    hline!(pL, [0.001]; color=:gray40, ls=:dash, lw=1, label="tolerance 0.001")
    plot!(pL, 0:k, err[1:k+1]; color=:black, lw=1.5, marker=:diamond, ms=4,
          markerstrokewidth=0, label="max |u − u*|, error after the sweep")
    if k >= 1
        plot!(pL, 1:k, E[1:k]; color=:red, lw=1.5, marker=:circle, ms=4,
              markerstrokewidth=0, label="E, largest change in the sweep")
    end
    plot(pS, pC, pL; layout=grid(1, 3, widths=[0.33, 0.33, 0.34]), size=(1500, 520),
         plot_title=title_str, plot_titlefontsize=11, left_margin=4Plots.mm,
         bottom_margin=6Plots.mm, background_color=:white)
end

anim = Animation()
for k in 0:K
    draw_frame(k)
    frame(anim)
    k == 0 && frame(anim)                          # hold the starting grid 1 s
end
for _ in 1:5                                       # hold the last sweep 3 s in all
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "ellipticaa.gif"); fps=2)
println("Saved: ellipticaa.gif")
