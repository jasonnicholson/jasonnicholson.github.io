# gaussseidelaa.jl
# Jacobi and Gauss-Seidel Iteration animation: both methods on a 2 x 2 system,
#   5x - 4y = 6,  3x + 5y = 11   (solution (2, 1)),  starting point (0, 0),
# one sweep per frame, k = 0, ..., 12, drawn in the plane of the two lines.
# New animation: Mathews' module has no animation, and its examples are 4 x 4.
# Equation 1 is solved for x and equation 2 for y, so each sweep moves to line 1
# along a horizontal and to line 2 along a vertical.
#   Jacobi:       x_new from line 1 at the old y, y_new from line 2 at the old x;
#                 the new point is the corner of the two moves (dashed).
#   Gauss-Seidel: x_new from line 1 at the old y, then y_new from line 2 at the
#                 new x: a staircase that ends on line 2 after every sweep.
# Each plane panel is centred on the solution and zooms with every frame so that
# the latest move fills it. The right panel shows the errors ||x_k - x*||_2 on a
# log scale with the slopes rho(B_J)^k = (12/25)^(k/2) and rho(B_GS)^k = (12/25)^k.
# The iteration runs in exact rational arithmetic (Rational{BigInt}).
# Produces: gaussseidelaa.gif

using Plots
using Printf
using LinearAlgebra
gr()

const SUPS = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹']
sup(n) = (n < 0 ? "⁻" : "") * join(SUPS[d+1] for d in reverse(digits(abs(n))))
um(s) = replace(s, "-" => "−")
function tenpow(s)
    occursin('e', s) || return um(s)
    m, e = split(s, 'e')
    return um(m) * " × 10" * sup(parse(Int, e))
end
# Significant-figure label (exact arithmetic, so a zero is an exact zero)
fmt(x) = x == 0 ? "0 (exact)" : tenpow(@sprintf("%.4g", Float64(x)))
const SUBS = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉']
sub(n) = join(SUBS[d+1] for d in reverse(digits(n)))

# --- Parameters ---
A = Rational{BigInt}[5 -4; 3 5]
b = Rational{BigInt}[6, 11]
xstar = Rational{BigInt}[2, 1]
x0 = Rational{BigInt}[0, 0]
n_iter = 12
gif_name = "gaussseidelaa.gif"
A * xstar == b || error("x* does not solve the system")

# --- The runs (exact) ---
upd_x(y) = (b[1] - A[1, 2] * y) / A[1, 1]      # line 1 solved for x
upd_y(x) = (b[2] - A[2, 1] * x) / A[2, 2]      # line 2 solved for y
J = [x0]; G = [x0]
for k in 1:n_iter
    x, y = J[end]
    push!(J, [upd_x(y), upd_y(x)])
    x, y = G[end]
    xn = upd_x(y)
    push!(G, [xn, upd_y(xn)])
end
nrm(v) = sqrt(Float64(v[1]^2 + v[2]^2))
eJ = [nrm(p - xstar) for p in J]
eG = [nrm(p - xstar) for p in G]
rhoJ = sqrt(12 / 25)
rhoG = 12 / 25
# exact checks of the rates quoted on the page
all((J[k+2] - xstar) == -(12 // 25) * (J[k] - xstar) for k in 1:n_iter-1) ||
    error("Jacobi two-step factor is not -12/25")
all((G[k+1] - xstar) == -(12 // 25) * (G[k] - xstar) for k in 2:n_iter) ||
    error("Gauss-Seidel factor is not -12/25 from k = 2")

# --- Plane panel ---
lineY1(x) = (b[1] - A[1, 1] * x) / A[1, 2]     # line 1 as y(x)
lineY2(x) = (b[2] - A[2, 1] * x) / A[2, 2]     # line 2 as y(x)

function plane(P, k, name, jacobi)
    pts = [Float64.(p - xstar) for p in P]
    prev = pts[max(k, 1)]
    h = 1.3 * max(maximum(abs.(pts[k+1])), maximum(abs.(prev)))
    xl = (-h, h); yl = (-h, h)
    p = plot(xlims=xl, ylims=yl, aspect_ratio=:equal, framestyle=:box,
             xlabel="x − 2", ylabel="y − 1", legend=false, titlefontsize=10, grid=true, gridalpha=0.25)
    xx = [-h, h]
    # lines through the solution, in offsets: y - 1 = slope (x - 2)
    s1 = -Float64(A[1, 1] / A[1, 2]); s2 = -Float64(A[2, 1] / A[2, 2])
    plot!(p, xx, s1 .* xx; color=:magenta, lw=2, label="")
    plot!(p, xx, s2 .* xx; color=:green, lw=2, label="")
    if k >= 1
        if jacobi
            # earlier iterates
            if k >= 2
                scatter!(p, [q[1] for q in pts[1:k-1]], [q[2] for q in pts[1:k-1]];
                         color=:gray70, ms=3.5, markerstrokewidth=0, label="")
            end
            o = pts[k]; n = pts[k+1]
            plot!(p, [o[1], n[1]], [o[2], o[2]]; color=:magenta, ls=:dash, lw=1.5, label="")
            plot!(p, [o[1], o[1]], [o[2], n[2]]; color=:green, ls=:dash, lw=1.5, label="")
            plot!(p, [n[1], n[1], o[1]], [o[2], n[2], n[2]]; color=:steelblue, ls=:dot,
                  lw=1.5, label="")
            scatter!(p, [n[1], o[1]], [o[2], n[2]]; color=:white, markerstrokecolor=:steelblue,
                     ms=4, label="")
        else
            # staircase X_0 -> (x_1, y_0) -> X_1 -> (x_2, y_1) -> X_2 ...
            sx = [pts[1][1]]; sy = [pts[1][2]]
            for j in 1:k
                push!(sx, pts[j+1][1], pts[j+1][1])
                push!(sy, pts[j][2], pts[j+1][2])
            end
            plot!(p, sx, sy; color=:steelblue, lw=1.5, label="")
            if k >= 2
                scatter!(p, [q[1] for q in pts[1:k-1]], [q[2] for q in pts[1:k-1]];
                         color=:gray70, ms=3.5, markerstrokewidth=0, label="")
            end
        end
        scatter!(p, [pts[k][1]], [pts[k][2]]; color=:orange, ms=5, markerstrokewidth=0,
                 label="")
    end
    scatter!(p, [pts[k+1][1]], [pts[k+1][2]]; color=:red, ms=6, markerstrokewidth=0,
             label="")
    scatter!(p, [0.0], [0.0]; color=:black, marker=:star5, ms=7, label="")
    ek = P[k+1] - xstar
    title!(p, name * ": x" * sub(k) * " − x* = (" * fmt(ek[1]) * ", " * fmt(ek[2]) * ")" *
              "\nwindow ±" * fmt(h) * " around x*")
    return p
end

function errpanel(k)
    p = plot(xlims=(-0.5, n_iter + 0.5), ylims=(1e-4, 10.0), yscale=:log10,
             framestyle=:box, xlabel="sweep k", ylabel="‖xₖ − x*‖₂",
             legend=:bottomleft, legendfontsize=7, titlefontsize=10,
             yticks=10.0 .^ (-4:0), minorgrid=false)
    ks = 0:n_iter
    plot!(p, ks, eJ[1] .* rhoJ .^ ks; color=:steelblue, ls=:dash, lw=1, alpha=0.6,
          label="slope ρ(B_J)ᵏ = (12/25)^(k/2)")
    plot!(p, 1:n_iter, eG[2] .* rhoG .^ ((1:n_iter) .- 1); color=:red, ls=:dash, lw=1,
          alpha=0.6, label="slope ρ(B_GS)ᵏ = (12/25)ᵏ")
    plot!(p, 0:k, eJ[1:k+1]; color=:steelblue, lw=1.5, marker=:circle, ms=4,
          markerstrokewidth=0, label="Jacobi")
    plot!(p, 0:k, eG[1:k+1]; color=:red, lw=1.5, marker=:square, ms=4,
          markerstrokewidth=0, label="Gauss–Seidel")
    if k == 0
        title!(p, "k = 0: both errors " * fmt(eJ[1]) * "\n ")
    else
        title!(p, "k = $k: Jacobi " * fmt(eJ[k+1]) * " (ratio " *
                  @sprintf("%.4f", eJ[k+1] / eJ[k]) * ")\nGauss–Seidel " * fmt(eG[k+1]) *
                  " (ratio " * @sprintf("%.4f", eG[k+1] / eG[k]) * ")")
    end
    return p
end

# Shared legend strip for the two plane panels
function legendstrip()
    p = plot(; framestyle=:none, grid=false, xlims=(0, 1), ylims=(0, 1),
             legend=:top, legend_columns=4, legendfontsize=8,
             foreground_color_legend=nothing, background_color_legend=nothing)
    plot!(p, [NaN], [NaN]; color=:magenta, lw=2, label="line 1: 5x − 4y = 6 (gives x)")
    plot!(p, [NaN], [NaN]; color=:green, lw=2, label="line 2: 3x + 5y = 11 (gives y)")
    scatter!(p, [NaN], [NaN]; color=:gray70, ms=3.5, markerstrokewidth=0, label="earlier iterates")
    scatter!(p, [NaN], [NaN]; color=:orange, ms=5, markerstrokewidth=0, label="previous iterate xₖ₋₁")
    scatter!(p, [NaN], [NaN]; color=:red, ms=6, markerstrokewidth=0, label="new iterate xₖ")
    scatter!(p, [NaN], [NaN]; color=:white, markerstrokecolor=:steelblue, ms=4,
             label="Jacobi: points reached on the lines")
    scatter!(p, [NaN], [NaN]; color=:black, marker=:star5, ms=7, label="solution x* = (2, 1)")
    return p
end
const LEG = legendstrip()

function frame(k)
    lay = @layout [grid(1, 3); a{0.09h}]
    plot(plane(J, k, "Jacobi", true), plane(G, k, "Gauss–Seidel", false), errpanel(k), LEG;
         layout=lay, size=(1500, 640),
         plot_title="Jacobi vs Gauss–Seidel on 5x − 4y = 6, 3x + 5y = 11 from x₀ = (0, 0), sweep $k of $n_iter",
         plot_titlefontsize=12, left_margin=5Plots.mm, bottom_margin=4Plots.mm, top_margin=3Plots.mm,
         background_color=:white)
end

frames = vcat(collect(0:n_iter), fill(n_iter, 3))     # hold the last frame
anim = @animate for k in frames
    frame(k)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: $gif_name  (", length(frames), " frames)")
for k in 0:n_iter
    println(k, "  J ", Float64.(J[k+1]), "  eJ ", eJ[k+1], "   G ", Float64.(G[k+1]), "  eG ", eG[k+1])
end
