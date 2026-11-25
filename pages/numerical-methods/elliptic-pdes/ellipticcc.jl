# ellipticcc.jl
# Elliptic PDE's page, Case 3: Mathews' Example 2, the plate of Example 1 on a 21 x 21
# grid (361 unknowns), with the set-up of Example 1: edges 180 (top), 80 (left),
# 20 (bottom), 0 (right), corners averaged, every interior value starting at 70.
# Two runs of Mathews' Dirichlet program with the same start and stopping rule
# (largest change |omega r| of a sweep below 0.001): SOR with omega = 1.729454 from
# formula (11), and Gauss-Seidel (omega = 1). Sweeps go column by column from the
# left and down each column from the top.
# Frames: one sweep per frame up to sweep 47, where SOR stops; then Gauss-Seidel
# goes on 10 sweeps per frame (sweeps 50, 60, ..., 220) to its stop at sweep 227.
# Left and middle: the error u - u* of each run at the grid points of the unit square
# (h = 1/20), where u* is the exact solution of the 361 difference equations (Gaussian
# elimination); each panel's colour scale is rescaled every frame to its own largest
# |u - u*|, given in its title. Right (log scale): the largest change E of each sweep
# and the largest difference |u - u*|, for both runs.
# Produces: ellipticcc.gif

using Plots
using Printf
using LinearAlgebra
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))

# --- Mathews' set-up: table M laid out like the plate, row 1 at the top ---
n = m = 21
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

function sweep!(M, ω)                              # column j outer, row i inner
    E = 0.0
    nr, nc = size(M)
    for j in 2:nc-1, i in 2:nr-1
        R = ω * (M[i, j+1] + M[i, j-1] + M[i+1, j] + M[i-1, j] - 4M[i, j]) / 4
        M[i, j] += R
        E = max(E, abs(R))
    end
    return E
end

function direct(M0)                                # exact solution of the 361 equations
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

S = direct(setup(n, m))
interior(A) = A[2:end-1, 2:end-1]
function run(ω)
    M = setup(n, m)
    grids = [copy(M)]; E = Float64[]; err = [maximum(abs.(interior(M - S)))]
    while true
        e = sweep!(M, ω)
        push!(E, e); push!(grids, copy(M)); push!(err, maximum(abs.(interior(M - S))))
        (e <= 0.001 || length(E) >= 1000) && break # Gauss-Seidel needs more than 71
    end
    return grids, E, err
end
gS, ES, errS = run(ω)
gG, EG, errG = run(1.0)
KS, KG = length(ES), length(EG)
@printf("omega = %.6f: %d sweeps (last E %.6g, err %.6g, centre %.6f)\n", ω, KS, ES[end], errS[end], gS[end][11, 11])
@printf("Gauss-Seidel: %d sweeps (last E %.6g, err %.6g)\n", KG, EG[end], errG[end])
@printf("start err %.6g\n", errS[1])
for k in [1, 10, 20, 30, 38, 39, 40, 47]
    @printf("sweep %3d  SOR E = %-12.6g err = %-12.6g  GS E = %-12.6g err = %.6g\n", k, ES[k], errS[k+1], EG[k], errG[k+1])
end
for k in [50, 100, 150, 200, 227]
    @printf("sweep %3d  GS E = %-12.6g err = %.6g\n", k, EG[k], errG[k+1])
end
println("SOR E rises at sweeps ", [k for k in 2:KS if ES[k] > ES[k-1]])
println("GS E rises at sweeps ", [k for k in 2:KG if EG[k] > EG[k-1]])

# --- Frame schedule: one sweep per frame to KS, then Gauss-Seidel 10 per frame ---
sched = vcat(collect(0:KS), collect(50:10:KG), KG) |> unique

# --- Drawing ---
xs = range(0, 1, length=n)
plate(M) = reverse(M, dims=1)                      # Z[iy, ix], y = 0 first
title_str = "SOR against Gauss-Seidel on Mathews' Example 2:  21 × 21 grid,  top 180,  left 80,  " *
            "bottom 20,  right 0,  interior starts at 70"

function eplot(D, head)                            # D = u − u* on the plate
    c = maximum(abs.(D))
    p = heatmap(xs, xs, D; clims=(-c, c), c=:balance, aspect_ratio=1, xlims=(0, 1),
                ylims=(0, 1), framestyle=:box, xlabel="x", ylabel="y", titlefontsize=9,
                title=head * "\ncolour scale ±$(fmt(c)), rescaled every frame")
    return p
end

function draw_frame(k)                             # k = sweeps done
    kS = min(k, KS); kG = min(k, KG)
    hS = "u − u*, SOR (ω = $(@sprintf("%.6f", ω))), " *
         (kS == 0 ? "start" : "sweep $kS" * (kS == KS ? " (stop)" : ""))
    hG = "u − u*, Gauss-Seidel (ω = 1), " *
         (kG == 0 ? "start" : "sweep $kG" * (kG == KG ? " (stop)" : ""))
    pS = eplot(plate(gS[kS+1] - S), hS)
    pG = eplot(plate(gG[kG+1] - S), hG)
    step = k <= KS ? "one sweep per frame" : "10 sweeps per frame"
    pL = plot(xlims=(0, 232), ylims=(1e-4, 300), yscale=:log10, framestyle=:box,
              grid=true, xlabel="sweep  ($step)", ylabel="largest size (log scale)",
              legend=:topright, legendfontsize=8, titlefontsize=10,
              yticks=10.0 .^ (-4:2), xticks=0:25:225,
              title="E and max |u − u*|  (u* solves the 361 difference equations)")
    hline!(pL, [0.001]; color=:gray40, ls=:dash, lw=1, label="tolerance 0.001")
    if k >= 1
        plot!(pL, 1:kS, ES[1:kS]; color=:red, lw=1.2, marker=:circle, ms=2.5,
              markerstrokewidth=0, label="E, SOR")
        plot!(pL, 1:kG, EG[1:kG]; color=:steelblue, lw=1.2, marker=:circle, ms=2,
              markerstrokewidth=0, label="E, Gauss-Seidel")
    end
    plot!(pL, 0:kS, errS[1:kS+1]; color=:darkred, lw=1.5, ls=:dot,
          label="max |u − u*|, SOR: $(fmt(errS[kS+1]))")
    plot!(pL, 0:kG, errG[1:kG+1]; color=:navy, lw=1.5, ls=:dot,
          label="max |u − u*|, Gauss-Seidel: $(fmt(errG[kG+1]))")
    scatter!(pL, [kS], [errS[kS+1]]; color=:darkred, ms=4, markerstrokewidth=0, label="")
    scatter!(pL, [kG], [errG[kG+1]]; color=:navy, ms=4, markerstrokewidth=0, label="")
    plot(pS, pG, pL; layout=grid(1, 3, widths=[0.31, 0.31, 0.38]), size=(1500, 520),
         plot_title=title_str, plot_titlefontsize=11, left_margin=7Plots.mm,
         bottom_margin=6Plots.mm, background_color=:white)
end

anim = Animation()
for k in sched
    draw_frame(k)
    frame(anim)
    (k == 0 || k == KS) && (frame(anim); frame(anim); frame(anim))  # hold 1 s
end
for _ in 1:11                                      # hold the last frame 3 s in all
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "ellipticcc.gif"); fps=4)
println("Saved: ellipticcc.gif")
