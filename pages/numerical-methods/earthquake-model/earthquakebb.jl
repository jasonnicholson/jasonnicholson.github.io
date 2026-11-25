# earthquakebb.jl
# Earthquake Model animation: Mathews' Example 3, sweeping the frequency of the
# earthquake. For the building of Example 1 (six floors, k/m = 8) shaken by
# e cos(wt), e = 0.075 ft, one frame per w = 0, 0.025, ..., 6 rad/s.
# Left: Mathews' graph of the largest floor amplitude g(w) = max_i |v_i|, where
# (w^2 I + a) v = -e w^2 b, over his interval 0 <= w <= 6 (his Blue), traced
# up to the current w, with the six natural frequencies w_j (closed form) as
# dashed asymptotes. The curve is broken at every w_j. Where g is above the
# window the curve leaves the top edge and the current point is drawn as a
# triangle on the edge, with its true value in the title.
# Right (new): the response shape v/g (floor i at height i, the ground at 0),
# beside the mode shape of the natural frequency nearest to w (gray, scaled to
# largest entry 1 and signed to match v), with the largest difference between
# the two shapes.
# Produces: earthquakebb.gif

using Plots
using Printf
using LinearAlgebra
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))
wstr(k) = @sprintf("%.3f", k / 1000)                 # w = k/1000 exactly, as a decimal

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

# --- Parameters (Mathews' Examples 1 and 3) ---
gif_name = "earthquakebb.gif"
n, c   = 6, 8.0
e      = 0.075
A      = Matrix(SymTridiagonal([fill(-2c, n - 1); -c], fill(c, n - 1)))
b      = ones(n)
# Natural frequencies and mode shapes, closed form (Example 1's theorem)
wj     = [2sqrt(c) * sin((2j - 1) * pi / (2(2n + 1))) for j in 1:n]
U      = [sin(i * (2j - 1) * pi / (2n + 1)) for i in 1:n, j in 1:n]
ks     = 0:25:6000                                   # frame w = k/1000
wlims  = (0.0, 6.0)                                  # Mathews' interval
glims  = (0.0, 1.4)                                  # close to Mathews' automatic range
title_str = "Earthquake model, Example 3:  largest floor amplitude g(ω) = maxᵢ |vᵢ|,  " *
            "(ω²I + a) v = −eω² b,  e = 0.075 ft"

vsolve(w) = (w^2 * I + A) \ (-e * w^2 * b)
function gfloor(w)
    v = vsolve(w)
    i = argmax(abs.(v))
    return v, abs(v[i]), i
end

# Fine curve, broken at every natural frequency
wf = collect(range(wlims[1], wlims[2], length=12001))
gf = [gfloor(w)[2] for w in wf]
for wn in wj
    i = findfirst(>(wn), wf)
    insert!(wf, i, wn); insert!(gf, i, NaN)
end

# Frame data
function frame_data(k)
    w = k / 1000
    v, g, imax = gfloor(w)
    j = argmin(abs.(w .- wj))                        # nearest natural frequency
    uh = U[:, j] ./ maximum(abs.(U[:, j]))
    s = dot(v, uh) >= 0 ? 1.0 : -1.0
    shape = g == 0 ? fill(NaN, n) : v ./ g
    d = g == 0 ? NaN : maximum(abs.(shape .- s .* uh))
    return (w=w, v=v, g=g, imax=imax, j=j, uh=s .* uh, shape=shape, d=d)
end

left_title(F)  = F.g == 0 ? "ω = $(wstr(round(Int, 1000F.w))) rad/s:  g = 0 (no shaking, v = 0)" :
                 "ω = $(wstr(round(Int, 1000F.w))) rad/s:  g = $(fmt(F.g)) ft (floor $(F.imax))" *
                 (F.g > glims[2] ? ", above the window" : "")
right_title(F) = F.g == 0 ? "response shape v/g undefined at ω = 0" :
                 "shape v/g vs mode $(F.j) (ω$(Char(0x2080 + F.j)) = $(fmt(wj[F.j]))): " *
                 "largest difference $(fmt(F.d))"

function draw_frame(k)
    F = frame_data(k)
    # Drawn view: Mathews' interval plus a small margin on each side and below, so
    # that the current point at w = 0 (where g = 0) and at w = 6 shows in full
    pL = plot(xlims=(wlims[1] - 0.015 * (wlims[2] - wlims[1]), wlims[2] + 0.015 * (wlims[2] - wlims[1])),
              ylims=(glims[1] - 0.015 * (glims[2] - glims[1]), glims[2]), framestyle=:box, grid=true,
              xlabel="ω (rad/s)", ylabel="g(ω)  (ft)", xticks=0:1:6,
              legend=:outerbottom, legend_columns=2, legendfontsize=8, titlefontsize=10)
    vline!(pL, wj; color=:gray50, ls=:dash, lw=1, label="natural frequencies ω₁, …, ω₆")
    hline!(pL, [e]; color=:gray50, ls=:dot, lw=1, label="ground amplitude e = 0.075 ft")
    idx = [i for i in eachindex(wf) if wf[i] <= F.w]
    plot!(pL, wf[idx], ydraw.(gf[idx], Ref(glims)); color=RGB(0, 0, 1), lw=1.8, label="g(ω)")
    scatter!(pL, [NaN], [NaN]; color=:black, ms=5, label="current ω (▲: g above the window)")
    if F.g <= glims[2]
        scatter!(pL, [F.w], [F.g]; color=:black, ms=5, label="")
    else
        scatter!(pL, [F.w], [glims[2]]; color=:black, marker=:utriangle, ms=7, label="")
    end
    title!(pL, left_title(F))

    pR = plot(xlims=(-1.15, 1.15), ylims=(-0.4, 6.6), framestyle=:box, grid=true,
              xlabel="displacement / g  (relative to the ground)",
              yticks=(0:6, ["ground"; ["floor $i" for i in 1:n]]),
              legend=:outerbottom, legend_columns=2, legendfontsize=8, titlefontsize=10)
    vline!(pR, [0.0]; color=:gray40, ls=:dot, lw=1, label="")
    if F.g == 0                                      # same legend, nothing drawn
        annotate!(pR, 0.0, 3.2, text("ω = 0: no shaking, v = 0\n(every floor at rest relative to the ground)",
                                     10, :center))
        plot!(pR, [NaN], [NaN]; color=:gray60, lw=4, alpha=0.6, label="mode shape (largest entry 1)")
        plot!(pR, [NaN], [NaN]; color=RGB(0, 0, 1), lw=2, marker=:rect, ms=6, label="response shape v/g")
        scatter!(pR, [NaN], [NaN]; color=:red, marker=:rect, ms=8, label="floor moving most")
    else
        plot!(pR, [0; F.uh], 0:n; color=:gray60, lw=4, alpha=0.6,
              label="mode shape (largest entry 1)")
        plot!(pR, [0; F.shape], 0:n; color=RGB(0, 0, 1), lw=2, marker=:rect, ms=6,
              label="response shape v/g")
        scatter!(pR, [F.shape[F.imax]], [F.imax]; color=:red, marker=:rect, ms=8,
                 label="floor moving most")
    end
    title!(pR, right_title(F))

    plot(pL, pR; layout=(1, 2), size=(1150, 590), plot_title=title_str,
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white)
end

println("w_j = ", wj)
for (f, k) in enumerate(ks)
    F = frame_data(k)
    println("FRAME ", f - 1, " | ", left_title(F), " | ", right_title(F))
end

anim = Animation()
for k in ks
    draw_frame(k)
    frame(anim)
end
for _ in 1:15                                        # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=12)
println("Saved: ", gif_name)
