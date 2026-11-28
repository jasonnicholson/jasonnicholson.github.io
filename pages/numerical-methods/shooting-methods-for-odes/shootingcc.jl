# shootingcc.jl
# Shooting Methods animation: moving the right end b of Mathews' boundary value
# problem toward 1 + pi, where v(b) = sin(b - 1)/sqrt(b) = 0 (Example 3):
#     x'' + x'/t + (1 - 1/(4t^2)) x = sqrt(t) cos t on [1, b], x(1) = 1, x(b) = -0.5.
# The shots x(t; s) = u(t) + s v(t) do not depend on b; only the target (b, -0.5)
# moves. Because v(1 + pi) = 0, every shot passes through the same point
# (1 + pi, u(1 + pi)), and as b approaches 1 + pi the landing points
# x(b; s) = u(b) + s v(b) crowd together. The slope C = (-0.5 - u(b))/v(b) that
# hits the target grows without bound, and at b = 1 + pi no shot hits it.
# One frame per right end b = 6, 5, 4.6, 4.4, 4.25, 4.2, 4.16, 4.15, 4.145, 1 + pi.
# Left panel: the fan of shots s = -3, ..., 3 (gray, exact u and v of Example 6),
# u (green) and v (blue) in Mathews' colours, the target, and the shooting
# solution on [1, b] (magenta) computed as Mathews does, with Runge2D (classical
# fourth-order Runge-Kutta) and m = 100 steps on [1, b]. Right panel (new): the
# landing point against the slope s, from the same Runge-Kutta values, with the
# target beta; the line meets beta at s = C.
# Produces: shootingcc.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))      # exact values
fmt6(x) = x == 0 ? "0" : um(@sprintf("%.6g", Float64(x)))
fmtv(x) = um(@sprintf("%.1e", Float64(x)))                     # error sizes: 2 s.f.

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

# --- The equation (Mathews' Examples 1-6) with right end b ---
a, alpha, beta = 1.0, 1.0, -0.5
m = 100                                              # Mathews' n = 100 on [1, b]
p(t) = -1 / t
q(t) = -(1 - 1 / (4t^2))
r(t) = sqrt(t) * cos(t)

# --- Mathews' Runge2D: classical RK4 for Z' = F(t, Z), Z = (x, y) ---
function runge2d(F, a, b, z0, m)
    h = (b - a) / m
    T = [a + j * h for j in 0:m]
    Z = zeros(m + 1, 2)
    Z[1, :] = z0
    for j in 1:m
        t, z = T[j], Z[j, :]
        k1 = h * F(t, z)
        k2 = h * F(t + h / 2, z + k1 / 2)
        k3 = h * F(t + h / 2, z + k2 / 2)
        k4 = h * F(t + h, z + k3)
        Z[j+1, :] = z + (k1 + 2k2 + 2k3 + k4) / 6
    end
    return T, Z
end
Fu(t, z) = [z[2], p(t) * z[2] + q(t) * z[1] + r(t)]
Fv(t, z) = [z[2], p(t) * z[2] + q(t) * z[1]]

# --- Exact u and v (Example 6), in 256-bit arithmetic ---
setprecision(BigFloat, 256)
const c1b, s1b = cos(big(1)), sin(big(1))
xpart(t) = (sqrt(t) * cos(t) + t * sqrt(t) * sin(t)) / 4
phi(t)   = (cos(t - 1) + sin(t - 1) / 2) / sqrt(t)
vex(t)   = sin(t - 1) / sqrt(t)
uex(t)   = xpart(t) + (1 - (c1b + s1b) / 4) * phi(t) - (3c1b + s1b) / 8 * vex(t)
@assert abs(uex(big(1)) - 1) < 1e-70 && abs(vex(big(1))) < 1e-70
bpi = 1 + big(pi)
@assert abs(vex(bpi)) < 1e-70                        # v(1 + pi) = 0 exactly
upi = uex(bpi)                                       # common point of every shot

# --- Right ends: Float64 b; the last is the double nearest 1 + pi ---
bs = [6.0, 5.0, 4.6, 4.4, 4.25, 4.2, 4.16, 4.15, 4.145, Float64(bpi)]
nb = length(bs)
cases = map(bs) do b
    T, U = runge2d(Fu, a, b, [alpha, 0.0], m)
    _, V = runge2d(Fv, a, b, [0.0, 1.0], m)
    um_, vm_ = U[end, 1], V[end, 1]
    Cm = (beta - um_) / vm_
    bb = big(b)
    vb = vex(bb)
    Cx = (beta - uex(bb)) / vb                       # exact slope for this b
    (b=b, T=T, X=U[:, 1] .+ Cm .* V[:, 1], ub=um_, vb=vm_, Cm=Cm,
     vbex=vb, ubex=uex(bb), Cex=Cx)
end
for c in cases
    @printf("min x_j = %.6g  max x_j = %.6g  ", minimum(c.X), maximum(c.X))
    @printf("b = %-18.15g h = %.6f  u_m(b) = %.10f  v_m(b) = %.6e  C_m = %.10g  exact v(b) = %.6e  exact C = %.10g  |C_m - C| = %.3e  max|x_j| = %.6g\n",
            c.b, (c.b - 1) / m, c.ub, c.vb, c.Cm, Float64(c.vbex), Float64(c.Cex),
            Float64(abs(c.Cm - c.Cex)), maximum(abs.(c.X)))
end
@printf("u(1 + pi) = %.10f\n", Float64(upi))

# --- Windows and backdrop ---
tlims = (1.0, 6.0)
xlims_L = (-6.0, 7.0)
slims = (-40.0, 5.0)
xlims_R = (-4.0, 3.0)
fan = -3:3
tf = collect(range(1.0, 6.0, length=1001))
uf = Float64.(uex.(big.(tf)))
vf = Float64.(vex.(big.(tf)))
title_str = "Linear shooting as the right end b approaches 1 + π:  x″ + x′/t + (1 − 1/(4t²))x = √t cos t,  " *
            "x(1) = 1,  x(b) = −0.5"

function draw_frame(n)
    c = cases[n]
    last = n == nb
    bstr = last ? "1 + π" : fmt(c.b)
    pL = plot(xlims=tlims, ylims=xlims_L, framestyle=:box, xlabel="t", ylabel="x",
              legend=:topright, legendfontsize=8, titlefontsize=10, grid=true)
    hline!(pL, [0.0]; color=:black, lw=0.5, label="")
    for s in fan
        s == 0 && continue
        plot!(pL, tf, ydraw.(uf .+ s .* vf, Ref(xlims_L)); color=:gray70, lw=1,
              label=s == fan[1] ? "shots s = −3, …, 3" : "")
    end
    plot!(pL, tf, uf; color=:green, lw=1.5, label="s = 0: u(t)")
    plot!(pL, tf, vf; color=:blue, lw=1.5, ls=:dot, label="v(t) = sin(t − 1)/√t")
    vline!(pL, [c.b]; color=:red, ls=:dot, lw=1, label="")
    scatter!(pL, fill(c.b, length(fan)), Float64.(c.ubex .+ fan .* c.vbex);
             color=:gray40, ms=3, markerstrokewidth=0, label="")
    plot!(pL, c.T, ydraw.(c.X, Ref(xlims_L)); color=:magenta, lw=2.5,
          label=last ? "RK4 \"solution\", C = $(fmt(c.Cm)), largest xⱼ = $(fmt(maximum(c.X)))" :
                       "shooting solution on [1, b], lowest xⱼ = $(fmt(minimum(c.X)))")
    scatter!(pL, [Float64(bpi)], [Float64(upi)]; color=:black, marker=:diamond, ms=5,
             label="(1 + π, u(1 + π)) = (4.142, $(fmt(upi)))")
    scatter!(pL, [c.b], [beta]; color=:red, marker=:star5, ms=9, label="target x(b) = −0.5")
    title!(pL, last ?
           "b = 1 + π: v(b) = 0, every shot lands at u(b) = $(fmt(upi)), none at −0.5" :
           "b = $bstr:  v(b) = $(fmt(c.vbex)),  C = $(fmt(c.Cex)),  RK4 error in C $(fmtv(abs(c.Cm - c.Cex)))")

    pR = plot(xlims=slims, ylims=xlims_R, framestyle=:box, xlabel="slope s = x′(1)",
              ylabel="landing point x(b; s)", legend=:bottomleft, legendfontsize=8,
              titlefontsize=10, grid=true)
    hline!(pR, [beta]; color=:red, ls=:dash, lw=1.5, label="target β = −0.5")
    sl = collect(slims)
    plot!(pR, sl, c.ub .+ sl .* c.vb; color=:black, lw=1.5,
          label="x(b; s) = u(b) + s v(b) (RK4)")
    scatter!(pR, collect(fan), c.ub .+ fan .* c.vb; color=:gray40, ms=3,
             markerstrokewidth=0, label="")
    if slims[1] <= c.Cm <= slims[2]
        scatter!(pR, [c.Cm], [beta]; color=:magenta, marker=:star5, ms=9, label="s = C")
        title!(pR, "Line of slope v(b) meets β at s = C = $(fmt(c.Cm))")
    elseif last
        title!(pR, "RK4 gives v(b) = $(fmt(c.vb)) instead of 0, so C = $(fmt(c.Cm))")
    else
        title!(pR, "The line meets β at s = C = $(fmt(c.Cm)), off the panel to the left")
    end

    plot(pL, pR; layout=(1, 2), size=(1150, 560), plot_title=title_str,
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white)
end

anim = Animation()
for n in 1:nb
    draw_frame(n)
    frame(anim)
end
for _ in 1:2                                         # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "shootingcc.gif"); fps=0.5)
println("Saved: shootingcc.gif")
