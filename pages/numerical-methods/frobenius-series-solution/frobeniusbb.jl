# frobeniusbb.jl
# Frobenius Series Solution animation: Mathews' Examples 8 and 9, the rim
# condition of the vibrating drum. A drum of radius 1 vibrating radially as
# R(r) cos(lambda t) has R(r) = J0(lambda r) (Example 7), and the rim r = 1 stays
# at rest only if J0(lambda) = 0. One frame per value of lambda, swept from 0 to
# the fifth zero lambda_5 of J0, with the five zeros themselves included and held.
# Left: J0(x) in Mathews' Example 8 window [0, 5 pi] x [-0.5, 1] (top raised to
# 1.05, here and on the right, so that the value 1 at x = 0 is not drawn on the
# frame edge), ticks at multiples of pi; the stretch 0 <= x <= lambda (blue) is the part of J0 that the
# drum's radius 0 <= r <= 1 uses, and the red dot is the rim value J0(lambda).
# Right: the cross-section through the centre, u = J0(lambda |x|) on
# -1 <= x <= 1, in the window of Mathews' Example 10 cross-sections
# [-1, 1] x [-0.45, 1], positive part pink and negative part cyan as in his
# graphs; black dots mark the interior nodes r = lambda_k / lambda, red dots
# the rim. The zeros lambda_k are found as Mathews finds them, by a root finder
# (Newton's method) started at k pi, here in 256-bit arithmetic.
# Produces: frobeniusbb.gif

using Plots
using Printf
using SpecialFunctions
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))      # exact values
fmtv(x) = um(@sprintf("%#.4g", Float64(x)))                    # computed: 4 s.f.
sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))   # 3 -> "₃"

setprecision(BigFloat, 256)

# --- Parameters ---
gif_name = "frobeniusbb.gif"
nzeros   = 5
dlam     = 0.2                      # sweep step in lambda
hold     = 6                        # extra frames at each zero
xlimsL   = (0.0, 5π)                # Mathews' Example 8 window
ylimsL   = (-0.5, 1.05)               # top raised from 1 so J0(0) = 1 is off the edge
xlimsR   = (-1.0, 1.0)              # Mathews' Example 10 cross-section window
ylimsR   = (-0.45, 1.05)              # (top raised from 1, as on the left)
pink, cyan = RGB(1.0, 0.41, 0.71), RGB(0.0, 0.75, 0.80)
title_str = "Vibrating drum (Mathews' Examples 8 and 9):  u = J₀(λr) cos(λt),  " *
            "the rim r = 1 is at rest only when J₀(λ) = 0"

# --- Zeros of J0: Newton's method from k*pi (J0' = -J1) ---
function j0zero(k)
    x = BigFloat(k) * BigFloat(π)
    for _ in 1:60
        dx = besselj0(x) / besselj1(x)          # x - J0/J0' = x + J0/J1
        x += dx
        abs(dx) < big"1e-70" && break
    end
    return x
end
lamb = [j0zero(k) for k in 1:nzeros]
@assert issorted(lamb) && all(abs(besselj0(l)) < big"1e-60" for l in lamb)
@assert all((k - 1) * π < lamb[k] < k * π for k in 1:nzeros)   # the k-th zero
lam = Float64.(lamb)
for k in 1:nzeros
    @printf("lambda_%d = %.10f   J0 = %.1e\n", k, Float64(lamb[k]), Float64(besselj0(lamb[k])))
end

# --- Frame list: the sweep 0, dlam, 2 dlam, ... with the zeros inserted ---
sweep = collect(0:dlam:lam[end])
frames = Tuple{Float64,Int}[]                    # (lambda, k) with k > 0 at a zero
for x in sweep
    for k in 1:nzeros                            # insert zeros in order
        if lam[k] <= x && !any(f -> f[2] == k, frames)
            push!(frames, (lam[k], k))
        end
    end
    any(isapprox(x, l; atol=1e-12) for l in lam) || push!(frames, (x, 0))
end
for k in 1:nzeros
    any(f -> f[2] == k, frames) || push!(frames, (lam[k], k))
end
@assert issorted(first.(frames))

xL = range(xlimsL..., length=1200)
xR = range(xlimsR..., length=1001)
piticks = (0:π:5π, ["0", "π", "2π", "3π", "4π", "5π"])

# Cross-section coloured by sign: each part is drawn only where it has that sign
pos(v) = v >= 0 ? v : NaN
neg(v) = v <= 0 ? v : NaN

function draw_frame(lmb, kz)
    nodes = [l / lmb for l in lam if l < lmb - 1e-12]          # interior nodes r = lambda_k / lambda
    rim   = kz > 0 ? 0.0 : besselj0(lmb)
    rimstr = kz > 0 ? "J₀(λ$(sub(kz))) = 0" : "J₀(λ) = $(fmtv(rim))"
    lamstr = kz > 0 ? "λ = λ$(sub(kz)) = $(fmtv(lmb))" : "λ = $(fmt(lmb))"

    pL = plot(xlims=xlimsL, ylims=ylimsL, framestyle=:box, xlabel="x", ylabel="J₀(x)",
              xticks=piticks, yticks=-0.5:0.25:1, legend=:topright, legendfontsize=8, titlefontsize=10, grid=true)
    hline!(pL, [0.0]; color=:black, lw=0.5, label="")
    plot!(pL, xL, besselj0.(xL); color=:magenta, lw=1.5, label="J₀(x)")
    if lmb > 0
        xs = range(0, lmb, length=max(2, round(Int, 80 * lmb)))
        plot!(pL, xs, besselj0.(xs); color=:royalblue, lw=3.5,
              label="0 ≤ x ≤ λ (drum radius 0 ≤ r ≤ 1)")
    end
    scatter!(pL, lam, zeros(nzeros); color=:white, markerstrokecolor=:black, ms=4,
             label="zeros λ₁, …, λ₅")
    scatter!(pL, [lmb], [besselj0(lmb)]; color=:red, ms=6, label="rim value J₀(λ) (both panels)")
    # The right panel has no room for a legend in every frame; its entries are here
    plot!(pL, [NaN], [NaN]; color=pink, lw=3, label="right: u > 0")
    plot!(pL, [NaN], [NaN]; color=cyan, lw=3, label="right: u < 0")
    scatter!(pL, [NaN], [NaN]; color=:black, ms=4, label="right: nodes r = λₖ/λ")
    title!(pL, "$lamstr:  $rimstr")

    pR = plot(xlims=xlimsR, ylims=ylimsR, framestyle=:box, xlabel="x  (cross-section through the centre)",
              ylabel="u = J₀(λ|x|)", legend=false, titlefontsize=10, grid=true,
              xticks=-1:0.5:1, yticks=-0.25:0.25:1)
    u = besselj0.(lmb .* abs.(xR))
    hline!(pR, [0.0]; color=:black, lw=0.5, label="")
    plot!(pR, xR, max.(u, 0); fillrange=0, fillalpha=0.25, fillcolor=pink, linealpha=0,
          label="")
    plot!(pR, xR, min.(u, 0); fillrange=0, fillalpha=0.25, fillcolor=cyan, linealpha=0,
          label="")
    plot!(pR, xR, pos.(u); color=pink, lw=3, label="u > 0")
    plot!(pR, xR, neg.(u); color=cyan, lw=3, label=any(<(0), u) ? "u < 0" : "")
    if !isempty(nodes)
        scatter!(pR, vcat(-nodes, nodes), zeros(2 * length(nodes)); color=:black, ms=4,
                 label="nodes r = λₖ/λ")
    end
    scatter!(pR, [-1.0, 1.0], [rim, rim]; color=:red, ms=6, label="rim u(±1) = J₀(λ)")
    if kz > 0
        nstr = isempty(nodes) ? "no nodal circle inside the rim" :
               (length(nodes) == 1 ? "nodal circle r = " : "nodal circles r = ") *
               join(fmtv.(nodes), ", ")
        title!(pR, "mode $kz:  $nstr")
    else
        title!(pR, "rim moves:  u(±1) = J₀(λ) = $(fmtv(rim))")
    end

    plot(pL, pR; layout=(1, 2), size=(1150, 500), plot_title=title_str,
         plot_titlefontsize=12, left_margin=5Plots.mm, bottom_margin=6Plots.mm,
         top_margin=2Plots.mm,
         background_color=:white)
end

anim = Animation()
for (lmb, kz) in frames
    draw_frame(lmb, kz)
    for _ in 1:(kz > 0 ? 1 + hold : 1)
        frame(anim)
    end
end
gif(anim, joinpath(@__DIR__, gif_name); fps=6)
println("Saved: ", gif_name, "  (", length(frames), " distinct frames)")
