# eigenaa.jl
# Eigenvalues and Eigenvectors animation: eigenvectors as the invariant
# directions of the matrix of Mathews' Example 2, A = [1 2; 1 1].
# A unit vector X = (cos t, sin t) turns once around the unit circle; each frame
# draws X and its image AX. The tip of AX runs around the ellipse A(unit circle).
# X and AX lie on one line through the origin exactly when X points along an
# eigenvector: along V2 = (sqrt2, 1), AX = (1 + sqrt2) X (same direction), and
# along V1 = (sqrt2, -1), AX = (1 - sqrt2) X (reversed and shortened).
# Right panel: det[X, AX] = cos(t)^2 - 2 sin(t)^2, which is |X||AX| times the
# sine of the angle from X to AX; it vanishes exactly at the eigen-directions.
# The four eigen-directions are added to the 7.5-degree grid of angles and
# held for several frames.
# New animation: Mathews' Eigenvalues module has no animation.
# Produces: eigenaa.gif

using Plots
using Printf
using LinearAlgebra
gr()

const SUPS = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹']
sup(n) = (n < 0 ? "⁻" : "") * join(SUPS[d+1] for d in reverse(digits(abs(n))))
um(s) = replace(s, "-" => "−")
function tenpow(s)                              # "1.234e-07" -> "1.234 × 10⁻⁷"
    occursin('e', s) || return um(s)
    m, e = split(s, 'e')
    return um(m) * " × 10" * sup(parse(Int, e))
end
# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0.
# A component printed as 0 is exactly 0: cosd/sind are exact at multiples of 90
# degrees, and AX has a zero component on the grid only at t = 135 and 315
# degrees, where cos t = -sin t (checked below).
fmt(x) = x == 0 ? "0" : tenpow(@sprintf("%.4g", x))

# --- Parameters (Mathews' Example 2) ---
A = [1.0 2.0; 1.0 1.0]
lam1, lam2 = 1 - sqrt(2), 1 + sqrt(2)
V1 = [sqrt(2), -1.0]                            # eigenvector for lam1
V2 = [sqrt(2), 1.0]                             # eigenvector for lam2
t2 = atand(1 / sqrt(2))                         # direction of V2, 35.26 degrees
eig_angles = [t2, 180 - t2, 180 + t2, 360 - t2] # V2, -V1, -V2, V1
eig_lams = [lam2, lam1, lam2, lam1]
hold = 4                                        # frames held at an eigen-direction
gif_name = "eigenaa.gif"

# checks of the eigen-directions (A X = lambda X to rounding)
for (t, l) in zip(eig_angles, eig_lams)
    X = [cosd(t), sind(t)]
    norm(A * X - l * X) < 1e-14 || error("not an eigen-direction: $t")
end

grid_t = collect(0.0:7.5:352.5)
for t in grid_t                                  # where a printed 0 may occur
    X = [cosd(t), sind(t)]; AX = A * X
    zx = any(==(0), X); zax = any(==(0), AX)
    zx == (mod(t, 90) == 0) || error("unexpected zero in X at $t")
    zax == (t in (135.0, 315.0)) || error("unexpected zero in AX at $t")
end
angles = sort(vcat(grid_t, eig_angles))
frames = Int[]                                  # indices into angles
for (i, t) in enumerate(angles)
    n = any(isequal(t), eig_angles) ? hold : 1
    append!(frames, fill(i, n))
end

d(t) = cosd(t)^2 - 2 * sind(t)^2                # det[X, AX]
tt = range(0, 360, length=721)
circ = [cosd.(tt) sind.(tt)]
ell = (A * circ')'                              # A(unit circle)
L = 3.0                                         # window half-width
sig = svdvals(A)                                # semi-axes of the ellipse
maximum(sig) < L || error("ellipse leaves the window")

c_x, c_ax = :royalblue, :crimson
c_v1, c_v2 = :purple, :darkgreen

function draw(i)
    t = angles[i]
    X = [cosd(t), sind(t)]
    AX = A * X
    ie = findfirst(isequal(t), eig_angles)
    p1 = plot(xlims=(-L, L), ylims=(-L, L), aspect_ratio=:equal, framestyle=:box,
              legend=:outerbottom, legendcolumns=2, legendfontsize=7, grid=true,
              xlabel="x₁", ylabel="x₂")
    hline!(p1, [0]; color=:black, lw=0.8, label="")
    vline!(p1, [0]; color=:black, lw=0.8, label="")
    plot!(p1, [-L, L], [-L, L] .* (V2[2] / V2[1]); color=c_v2, ls=:dash, lw=1.5,
          label="eigenvector line of V₂ = (√2, 1), λ₂ = 1 + √2")
    plot!(p1, [-L, L], [-L, L] .* (V1[2] / V1[1]); color=c_v1, ls=:dash, lw=1.5,
          label="eigenvector line of V₁ = (√2, −1), λ₁ = 1 − √2")
    plot!(p1, circ[:, 1], circ[:, 2]; color=:gray60, lw=1, label="unit circle (tip of X)")
    plot!(p1, ell[:, 1], ell[:, 2]; color=:pink, lw=1, label="ellipse A(unit circle) (tip of AX)")
    # traces of the tips up to the current angle
    m = tt .<= t
    plot!(p1, circ[m, 1], circ[m, 2]; color=c_x, lw=2, alpha=0.5, label="")
    plot!(p1, ell[m, 1], ell[m, 2]; color=c_ax, lw=2, alpha=0.5, label="")
    plot!(p1, [0, AX[1]], [0, AX[2]]; color=c_ax, lw=3, arrow=true, label="AX")
    plot!(p1, [0, X[1]], [0, X[2]]; color=c_x, lw=3, arrow=true, label="X")
    if ie !== nothing
        scatter!(p1, [X[1], AX[1]], [X[2], AX[2]]; color=:gold, ms=5,
                 markerstrokecolor=:black, label="")
    end

    p2 = plot(xlims=(0, 360), ylims=(-2.3, 1.5), framestyle=:box, legend=:outerbottom,
              legendfontsize=7, xlabel="angle t of X (degrees)", ylabel="det[X, AX]",
              xticks=0:45:360)
    hline!(p2, [0]; color=:black, lw=0.8, label="")
    vline!(p2, eig_angles; color=:gray, ls=:dot, lw=1,
           label="eigen-directions " * join((@sprintf("%.2f°", a) for a in eig_angles), ", "))
    plot!(p2, tt, d.(tt); color=:black, lw=1.5, label="det[X, AX] = cos²t − 2 sin²t")
    scatter!(p2, [t], [d(t)]; color=(ie === nothing ? c_ax : :gold), ms=6,
             markerstrokecolor=:black, label="")

    head = @sprintf("t = %.2f°", t)
    if ie === nothing
        line = head * ":  X = (" * fmt(X[1]) * ", " * fmt(X[2]) * "),  AX = (" *
               fmt(AX[1]) * ", " * fmt(AX[2]) * "),  det[X, AX] = " * fmt(d(t))
    else
        which = eig_lams[ie] == lam2 ? "λ₂ = 1 + √2" : "λ₁ = 1 − √2"
        sgn = ie <= 2 ? (ie == 1 ? "V₂" : "−V₁") : (ie == 3 ? "−V₂" : "V₁")
        line = head * ":  X points along " * sgn * ",  AX = " * fmt(eig_lams[ie]) *
               " X  (" * which * "),  det[X, AX] = 0"
    end
    plot(p1, p2; layout=grid(1, 2, widths=[0.5, 0.5]), size=(1100, 640),
         plot_title="A = [1 2; 1 1] (Mathews' Example 2): X on the unit circle and its image AX\n" * line,
         plot_titlefontsize=10, left_margin=3Plots.mm, bottom_margin=4Plots.mm,
         background_color=:white)
end

anim = @animate for i in frames
    draw(i)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=6)
println("Saved: $gif_name  (", length(frames), " frames)")
println("eigen angles: ", eig_angles, "  semi-axes: ", sig)
