# ellipticbb.jl
# Elliptic PDE's page, Case 2: Mathews' Example 3, the insulated bottom edge. Laplace's
# equation on a 9 x 9 grid with the edges held at 180 (top), 80 (left) and 0 (right)
# and du/dN = 0 on the bottom edge, solved by Mathews' Neumann program: each sweep
# relaxes the 49 interior points (column by column from the left, down each column)
# and then the 7 bottom-edge points from left to right with formula (12),
#   u[n,j] += omega (2 u[n-1,j] + u[n,j-1] + u[n,j+1] - 4 u[n,j]) / 4.
# Starting values: interior 70, bottom edge interpolated linearly from 80 to 0, top
# corners 130 and 90. Two runs with the same start and stopping rule (largest change
# below 0.001): omega = 1.446463 from formula (11), as Mathews has it, and
# omega = 1.5325, near the optimum for this mixed problem. One sweep per frame.
# Left: filled contours of Mathews' run at his levels 0, 15, ..., 180, with the
# insulated edge dashed. Middle: the values on the insulated edge (unknowns of the
# problem) in both runs against the exact solution of the 56 difference equations.
# Right (log scale): the largest change E of each sweep and the largest difference
# from the exact solution of the difference equations, for both runs.
# Produces: ellipticbb.gif

using Plots
using Printf
using LinearAlgebra
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))

# --- Mathews' set-up: table M laid out like the plate, row 1 at the top ---
n = m = 9
function setup()
    M = fill(70.0, n, m)
    M[1, 2:m-1] .= 180.0                           # top
    M[2:n-1, 1] .= 80.0                            # left
    M[2:n-1, m] .= 0.0                             # right
    M[1, 1] = (M[1, 2] + M[2, 1]) / 2              # 130
    M[1, m] = (M[1, m-1] + M[2, m]) / 2            # 90
    M[n, 1] = 80.0; M[n, m] = 0.0                  # bottom corners from the side edges
    for j in 1:m                                   # bottom edge: 80, 70, ..., 10, 0
        M[n, j] = M[n, 1] + (j - 1) / (m - 1) * (M[n, m] - M[n, 1])
    end
    return M
end
ωf = 4 / (2 + sqrt(4 - (cos(π / (n - 1)) + cos(π / (m - 1)))^2))   # 1.446463
ωb = 1.5325

function sweep!(M, ω)
    E = 0.0
    for j in 2:m-1, i in 2:n-1                     # interior, Dirichlet program order
        R = ω * (M[i, j+1] + M[i, j-1] + M[i+1, j] + M[i-1, j] - 4M[i, j]) / 4
        M[i, j] += R
        E = max(E, abs(R))
    end
    for j in 2:m-1                                 # insulated bottom edge, formula (12)
        R = ω * (2M[n-1, j] + M[n, j-1] + M[n, j+1] - 4M[n, j]) / 4
        M[n, j] += R
        E = max(E, abs(R))
    end
    return E
end

# --- Exact solution of the 56 difference equations (dense Gaussian elimination) ---
function direct(M0)
    id = zeros(Int, n, m); N = 0
    for j in 2:m-1, i in 2:n
        N += 1; id[i, j] = N
    end
    A = zeros(N, N); B = zeros(N)
    for j in 2:m-1, i in 2:n
        p = id[i, j]; A[p, p] = -4
        nb = i == n ? ((i - 1, j, 2), (i, j - 1, 1), (i, j + 1, 1)) :
                      ((i - 1, j, 1), (i + 1, j, 1), (i, j - 1, 1), (i, j + 1, 1))
        for (a, b, c) in nb
            if id[a, b] > 0
                A[p, id[a, b]] += c
            else
                B[p] -= c * M0[a, b]
            end
        end
    end
    x = A \ B
    S = copy(M0)
    for j in 2:m-1, i in 2:n
        S[i, j] = x[id[i, j]]
    end
    return S
end

S = direct(setup())
unk(A) = A[2:n, 2:m-1]                             # the 56 unknowns
function run(ω)
    M = setup()
    grids = [copy(M)]; E = Float64[]; err = [maximum(abs.(unk(M - S)))]
    while true
        e = sweep!(M, ω)
        push!(E, e); push!(grids, copy(M)); push!(err, maximum(abs.(unk(M - S))))
        (e <= 0.001 || length(E) >= 71) && break
    end
    return grids, E, err
end
gF, EF, errF = run(ωf)
gB, EB, errB = run(ωb)
KF, KB = length(EF), length(EB)
@printf("omega = %.6f: %d sweeps;  omega = %.4f: %d sweeps\n", ωf, KF, ωb, KB)
for k in 1:KF
    @printf("sweep %2d  E = %-12.6g err = %-12.6g", k, EF[k], errF[k+1])
    k <= KB && @printf("| E = %-12.6g err = %.6g", EB[k], errB[k+1])
    println()
end
@printf("start err = %.6g; exact bottom edge: %s\n", errF[1], join([@sprintf("%.4f", S[n, j]) for j in 1:m], ", "))

# --- Drawing ---
xs = range(0, 1, length=n)
plate(M) = reverse(M, dims=1)                      # Z[iy, ix], y = 0 first
XX = [x for y in xs, x in xs]; YY = [y for y in xs, x in xs]
title_str = "SOR on Mathews' Example 3:  9 × 9 grid,  top 180,  left 80,  right 0,  " *
            "bottom edge insulated (∂u/∂N = 0),  interior starts at 70"
K = KF

function draw_frame(k)                             # k = sweeps done
    kF = min(k, KF); kB = min(k, KB)
    Z = plate(gF[kF+1])
    head = k == 0 ? "ω = $(@sprintf("%.6f", ωf)):  starting grid (sweep 0)" :
           "ω = $(@sprintf("%.6f", ωf)):  sweep $kF,  E = $(fmt(EF[kF]))" *
           (kF == KF ? "  (stop)" : "")
    pC = contour(xs, xs, Z; levels=0:15:180, fill=true, clims=(0, 180), c=:thermal,
                 aspect_ratio=1, xlims=(0, 1), ylims=(0, 1), framestyle=:box,
                 xlabel="x", ylabel="y", titlefontsize=10, title=head)
    contour!(pC, xs, xs, Z; levels=0:15:180, color=:black, lw=0.6)
    scatter!(pC, vec(XX), vec(YY); color=:white, ms=2.5, markerstrokecolor=:black,
             markerstrokewidth=0.5, label="")
    plot!(pC, [0, 1], [0, 0]; color=:limegreen, lw=4, ls=:dash, label="")
    annotate!(pC, 0.5, 0.045, text("insulated", 8, :limegreen, :bottom))

    pE = plot(xlims=(0, 1), ylims=(0, 90), framestyle=:box, grid=true, xlabel="x",
              ylabel="u(x, 0)", legend=:topright, legendfontsize=8, titlefontsize=10,
              title="values on the insulated edge y = 0")
    plot!(pE, xs, gF[1][n, :]; color=:gray60, lw=1, ls=:dot, label="start: 80, 70, …, 0")
    plot!(pE, xs, S[n, :]; color=:black, lw=2, label="exact solution of the difference equations")
    plot!(pE, xs, gF[kF+1][n, :]; color=:red, lw=1.5, marker=:circle, ms=4,
          markerstrokewidth=0, label="ω = $(@sprintf("%.6f", ωf)), sweep $kF")
    plot!(pE, xs, gB[kB+1][n, :]; color=:steelblue, lw=1.5, ls=:dash, marker=:diamond,
          ms=4, markerstrokewidth=0, label="ω = $(ωb), sweep $kB" * (kB == KB ? " (stop)" : ""))

    pL = plot(xlims=(0, K + 0.5), ylims=(1e-4, 300), yscale=:log10, framestyle=:box,
              grid=true, xlabel="sweep", ylabel="largest size (log scale)",
              legend=:topright, legendfontsize=8, titlefontsize=10,
              yticks=10.0 .^ (-4:2), xticks=0:5:K,
              title="max |u − u*| = $(fmt(errF[kF+1])) (red),  $(fmt(errB[kB+1])) (blue)")
    hline!(pL, [0.001]; color=:gray40, ls=:dash, lw=1, label="tolerance 0.001")
    if k >= 1
        plot!(pL, 1:kF, EF[1:kF]; color=:red, lw=1.5, marker=:circle, ms=4,
              markerstrokewidth=0, label="E,  ω = $(@sprintf("%.6f", ωf))")
        plot!(pL, 1:kB, EB[1:kB]; color=:steelblue, lw=1.5, marker=:circle, ms=4,
              markerstrokewidth=0, label="E,  ω = $ωb")
    end
    plot!(pL, 0:kF, errF[1:kF+1]; color=:darkred, lw=1, ls=:dot, marker=:diamond, ms=3.5,
          markerstrokewidth=0, label="max |u − u*|,  ω = $(@sprintf("%.6f", ωf))")
    plot!(pL, 0:kB, errB[1:kB+1]; color=:navy, lw=1, ls=:dot, marker=:diamond, ms=3.5,
          markerstrokewidth=0, label="max |u − u*|,  ω = $ωb")
    plot(pC, pE, pL; layout=grid(1, 3, widths=[0.31, 0.33, 0.36]), size=(1500, 520),
         plot_title=title_str, plot_titlefontsize=11, left_margin=7Plots.mm,
         bottom_margin=6Plots.mm, background_color=:white)
end

anim = Animation()
for k in 0:K
    draw_frame(k)
    frame(anim)
    (k == 0 || k == KB) && frame(anim)             # hold the start and the ω = 1.5325 stop
end
for _ in 1:5                                       # hold the last sweep 3 s in all
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "ellipticbb.gif"); fps=2)
println("Saved: ellipticbb.gif")
