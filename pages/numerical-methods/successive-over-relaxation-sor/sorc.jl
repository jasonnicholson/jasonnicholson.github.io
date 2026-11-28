# sorc.jl
# SOR animation: Mathews' Example 2, the 9 x 9 five-point system for Laplace's
# equation u_xx + u_yy = 0 on the unit square with u(x, 0) = 180, u(x, 1) = 20,
# u(0, y) = 80, u(1, y) = 0, at the nine interior points of a 5 x 5 grid (h = 1/4):
#   -4 p_i + (sum of the neighbouring values) = 0,  written as A p = B,
#   B = (-100, -20, -20, -80, 0, 0, -260, -180, -180),  p0 = (1, ..., 1).
# p1, p2, p3 lie on the row y = 3/4, p4, p5, p6 on y = 1/2, p7, p8, p9 on y = 1/4,
# each row ordered from x = 1/4 to x = 3/4 (this placement reproduces B).
# SOR with omega = 5/4, as in Mathews' command SORmethod[A, B, P, 1.25, 10],
# one sweep per frame, k = 0, ..., 10, against Jacobi and Gauss-Seidel.
# New animation: Mathews' SOR module has no animation.
# Left panel: the temperatures on the 5 x 5 grid, the nine interior values being
# the SOR iterate p_k; the corners, which no equation uses, take the average of
# the two adjacent edges, as in Mathews' remark.
# Right panel: ||p_k - p*||_inf for the three methods on a log scale.
# The iterations run in exact rational arithmetic (Rational{BigInt}).
# Produces: sorc.gif

using Plots
using Printf
using LinearAlgebra
gr()

const SUPS = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹']
sup(n) = (n < 0 ? "⁻" : "") * join(SUPS[d+1] for d in reverse(digits(abs(n))))
um(s) = replace(s, "-" => "−")
function tenpow(s)                      # "1.234e-07" -> "1.234 × 10⁻⁷"
    occursin('e', s) || return um(s)
    m, e = split(s, 'e')
    return um(m) * " × 10" * sup(parse(Int, e))
end
# Significant-figure label (exact arithmetic, so a zero is an exact zero)
fmt(x) = x == 0 ? "0 (exact)" : tenpow(@sprintf("%.4g", Float64(x)))

# --- Parameters (Mathews' Example 2) ---
const R = Rational{BigInt}
n = 9
A = R[-4  1  0  1  0  0  0  0  0;
       1 -4  1  0  1  0  0  0  0;
       0  1 -4  0  0  1  0  0  0;
       1  0  0 -4  1  0  1  0  0;
       0  1  0  1 -4  1  0  1  0;
       0  0  1  0  1 -4  0  0  1;
       0  0  0  1  0  0 -4  1  0;
       0  0  0  0  1  0  1 -4  1;
       0  0  0  0  0  1  0  1 -4]
B = R[-100, -20, -20, -80, 0, 0, -260, -180, -180]
p0 = fill(R(1), n)
omega = R(5, 4)
kmax = 10
gif_name = "sorc.gif"

# boundary values and grid placement of p1..p9: node (i, j) is (x, y) = (i/4, j/4)
ubot, utop, uleft, uright = 180, 20, 80, 0
pos = [(1, 3), (2, 3), (3, 3), (1, 2), (2, 2), (3, 2), (1, 1), (2, 1), (3, 1)]
# rebuild B from the boundary values and the placement (checks the placement)
function bdry(i, j)
    j == 0 && return ubot
    j == 4 && return utop
    i == 0 && return uleft
    i == 4 && return uright
    return nothing
end
Bcheck = R[-sum(v for v in (bdry(i - 1, j), bdry(i + 1, j), bdry(i, j - 1), bdry(i, j + 1))
               if v !== nothing; init=0) for (i, j) in pos]
Bcheck == B || error("grid placement does not reproduce Mathews' B")

pstar = A \ B                            # exact rational solution
A * pstar == B || error("p* does not solve A p = B")

function jacobi(x)
    [(B[i] - sum(A[i, j] * x[j] for j in 1:n if j != i)) / A[i, i] for i in 1:n]
end
function sor(x, w)                       # w = 1 is Gauss-Seidel
    y = copy(x)
    for i in 1:n
        gs = (B[i] - sum(A[i, j] * y[j] for j in 1:n if j != i)) / A[i, i]
        y[i] = (1 - w) * y[i] + w * gs
    end
    return y
end
PJ = [p0]; PG = [p0]; PS = [p0]
for k in 1:kmax
    push!(PJ, jacobi(PJ[end]))
    push!(PG, sor(PG[end], R(1)))
    push!(PS, sor(PS[end], omega))
end
errinf(x) = maximum(abs.(x .- pstar))
EJ = [Float64(errinf(x)) for x in PJ]
EG = [Float64(errinf(x)) for x in PG]
ES = [Float64(errinf(x)) for x in PS]
all(e -> e > 0, vcat(EJ, EG, ES)) || error("an exact zero error cannot go on a log axis")

Af = Float64.(A); D = Diagonal(diag(Af)); L = -tril(Af, -1); U = -triu(Af, 1)
rho(T) = maximum(abs.(eigvals(T)))
rhoJ = rho(D \ (L + U))
rhoG = rho((D - L) \ U)
rhoS = rho((D - Float64(omega) * L) \ ((1 - Float64(omega)) * D + Float64(omega) * U))

# --- the 5 x 5 grid of values for an interior vector p ---
function grid(p)
    G = zeros(5, 5)                      # G[j+1, i+1] = u(i/4, j/4)
    for j in 0:4, i in 0:4
        v = bdry(i, j)
        v === nothing || (G[j+1, i+1] = v)
    end
    G[1, 1] = (ubot + uleft) / 2; G[1, 5] = (ubot + uright) / 2
    G[5, 1] = (utop + uleft) / 2; G[5, 5] = (utop + uright) / 2
    for (m, (i, j)) in enumerate(pos)
        G[j+1, i+1] = Float64(p[m])
    end
    return G
end
cells = 0:0.25:1
const SUBS = ["₁", "₂", "₃", "₄", "₅", "₆", "₇", "₈", "₉"]
lab(v) = isinteger(v) ? string(Int(v)) : @sprintf("%.4g", v)

ylR = (10.0^floor(log10(minimum(vcat(EJ, EG, ES)))), 10.0^ceil(log10(maximum(vcat(EJ, EG, ES)))))

# --- Frames ---
function frame(k)
    p = PS[k+1]
    G = grid(p)
    pL = heatmap(cells, cells, G; c=:viridis, clims=(0, 180), aspect_ratio=:equal,
                 xlims=(-0.125, 1.125), ylims=(-0.125, 1.125), framestyle=:box,
                 xlabel="x", ylabel="y", colorbar_title="u", titlefontsize=10,
                 xticks=0:0.25:1, yticks=0:0.25:1)
    for j in 0:4, i in 0:4
        v = G[j+1, i+1]
        interior = 1 <= i <= 3 && 1 <= j <= 3
        s = interior ? @sprintf("%.6g", v) : lab(v)   # 6 significant figures, as Mathews prints
        col = v < 100 ? :white : :black
        annotate!(pL, i / 4, j / 4, text(s, interior ? 9 : 8, col))
    end
    for (m, (i, j)) in enumerate(pos)
        annotate!(pL, i / 4 - 0.09, j / 4 + 0.09, text("p" * SUBS[m], 7,
                                                   G[j+1, i+1] < 100 ? :white : :black))
    end
    title!(pL, k == 0 ? "SOR (ω = 1.25) iterate p⁽⁰⁾ = (1, …, 1) on the grid" :
                        "SOR (ω = 1.25) iterate after k = $k sweep" * (k == 1 ? "" : "s"))

    pR = plot(xlims=(-0.5, kmax + 0.5), ylims=ylR, yscale=:log10, framestyle=:box,
              xlabel="iteration k", ylabel="‖p⁽ᵏ⁾ − p*‖∞", legend=:bottomleft,
              legendfontsize=8, titlefontsize=10, xticks=0:kmax, minorgrid=false)
    plot!(pR, 0:k, EJ[1:k+1]; color=:darkorange, lw=1.5, marker=:circle, ms=4,
          markerstrokewidth=0, label="Jacobi, ρ = " * fmt(rhoJ))
    plot!(pR, 0:k, EG[1:k+1]; color=:seagreen, lw=1.5, marker=:diamond, ms=4,
          markerstrokewidth=0, label="Gauss-Seidel, ρ = " * fmt(rhoG))
    plot!(pR, 0:k, ES[1:k+1]; color=:royalblue, lw=2, marker=:square, ms=3.5,
          markerstrokewidth=0, label="SOR ω = 1.25, ρ = " * fmt(rhoS))
    title!(pR, "k = $k:  Jacobi " * fmt(EJ[k+1]) * ",  Gauss-Seidel " * fmt(EG[k+1]) *
               ",  SOR " * fmt(ES[k+1]))

    plot(pL, pR; layout=(1, 2), size=(1150, 540),
         plot_title="Mathews' Example 2: Laplace's equation on a 5 × 5 grid (u = 180 bottom, 20 top, 80 left, 0 right), 9 unknowns",
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white)
end

frames = vcat(collect(0:kmax), fill(kmax, 3))       # hold the last frame
anim = @animate for k in frames
    frame(k)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=2)
println("Saved: $gif_name  (", length(frames), " frames)")
println("p* = ", pstar)
@printf("rho: J %.6f  GS %.6f  SOR %.6f\n", rhoJ, rhoG, rhoS)
println("errors J  ", [@sprintf("%.4g", e) for e in EJ])
println("errors GS ", [@sprintf("%.4g", e) for e in EG])
println("errors SOR ", [@sprintf("%.4g", e) for e in ES])
println("SOR p10 = ", [@sprintf("%.6g", Float64(v)) for v in PS[end]])
