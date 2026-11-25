# earthquakedd.jl
# Earthquake Model animation: the six natural modes of Mathews' Example 1, the
# building with six floors and k/m = 8, vibrating freely (no earthquake).
# Mode j is the free vibration X(t) = u_j cos(w_j t), where u_j is the
# eigenvector of a for the eigenvalue -w_j^2, from the closed form
# u_i = sin(i (2j - 1) pi / 13), w_j = 4 sqrt(2) sin((2j - 1) pi / 26),
# scaled so that its largest entry is 1 and floor 1 moves to the right at t = 0.
# The amplitude of a free vibration is arbitrary, so the horizontal axis is in
# units of the largest floor amplitude. All six modes run on one clock for one
# fundamental period P_1 = 9.215 s, one frame per P_1/96; a gray bar shows the
# range of each floor.
# Produces: earthquakedd.gif

using Plots
using Printf
using LinearAlgebra
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))
sub(j) = Char(0x2080 + j)

# --- Parameters (Mathews' Example 1) ---
gif_name = "earthquakedd.gif"
n, c   = 6, 8.0
A      = Matrix(SymTridiagonal([fill(-2c, n - 1); -c], fill(c, n - 1)))
wj     = [2sqrt(c) * sin((2j - 1) * pi / (2(2n + 1))) for j in 1:n]
Pj     = 2pi ./ wj
U      = [sin(i * (2j - 1) * pi / (2n + 1)) for i in 1:n, j in 1:n]
Uh     = U ./ maximum(abs.(U), dims=1)               # largest entry 1, floor 1 positive
nfr    = 96
ts     = [Pj[1] * f / nfr for f in 0:nfr]            # one fundamental period
mcol   = [RGB(0, 0, 1), RGB(1, 0, 0), RGB(0.647, 0.165, 0.165), RGB(1, 0, 1),
          RGB(0, 0.75, 0), RGB(1, 0.5, 0)]           # Mathews' floor colours of Example 2
title_str(t) = "Earthquake model, Example 1:  the six natural modes X(t) = uⱼ cos(ωⱼt) of the " *
               "six-floor building,  t = $(fmt(t)) s"

# Check: a u_j = -w_j^2 u_j for the closed form
println("max residual a u_j + w_j^2 u_j = ",
        maximum(abs.(A * U .+ U .* (wj' .^ 2))))
println("w_j = ", wj); println("P_j = ", Pj)
for j in 1:n
    println("mode $j scaled: ", Uh[:, j], "  sign changes: ",
            count(i -> Uh[i, j] * Uh[i+1, j] < 0, 1:n-1))
end

panel_title(j) = "mode $j:  ω$(sub(j)) = $(fmt(wj[j])),  P$(sub(j)) = $(fmt(Pj[j])) s"

function draw_frame(t)
    ps = map(1:n) do j
        x = Uh[:, j] .* cos(wj[j] * t)
        p = plot(xlims=(-1.25, 1.25), ylims=(-0.4, 6.6), framestyle=:box, grid=true,
                 xticks=([-1, 0, 1], ["−1", "0", "1"]),
                 yticks=(0:6, ["ground"; ["floor $i" for i in 1:n]]),
                 legend=false, titlefontsize=9, tickfontsize=7,
                 xlabel="displacement (largest = 1)", title=panel_title(j))
        vline!(p, [0.0]; color=:gray40, ls=:dot, lw=1)
        for i in 1:n
            plot!(p, [-abs(Uh[i, j]), abs(Uh[i, j])], [i, i]; color=:gray85, lw=5)
        end
        plot!(p, [0; x], 0:n; color=:gray30, lw=1.5)
        scatter!(p, [0.0], [0]; color=:black, marker=:rect, ms=6)
        for i in 1:n
            scatter!(p, [x[i]], [i]; color=mcol[i], marker=:rect, ms=6, msw=0)
        end
        p
    end
    plot(ps...; layout=(2, 3), size=(1100, 720), plot_title=title_str(t),
         plot_titlefontsize=11, left_margin=3Plots.mm, bottom_margin=3Plots.mm,
         background_color=:white)
end

for j in 1:n
    println("PANEL ", j, " | ", panel_title(j))
end
for (f, t) in enumerate(ts)
    println("FRAME ", f - 1, " | ", title_str(t))
end

anim = Animation()
for t in ts
    draw_frame(t)
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=10)
println("Saved: ", gif_name)
