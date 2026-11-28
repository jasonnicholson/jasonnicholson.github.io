# shootingbb.jl
# Shooting Methods animation: refining the step of linear shooting for Mathews'
# boundary value problem (Examples 5 and 6)
#     x'' + x'/t + (1 - 1/(4t^2)) x = sqrt(t) cos t on [1, 6], x(1) = 1, x(6) = -0.5.
# One frame per number of steps m = 25, 50, 100, 200, 400 (h = 0.2 down to
# 0.0125; Mathews uses m = 100). Each frame runs Mathews' Runge2D (classical
# fourth-order Runge-Kutta) for u and v with m steps, forms
# x_j = u_j + C v_j with C = (beta - u_m)/v_m, and compares x_j with the exact
# solution of Example 6. The left panel is Mathews' graph of the solution
# (magenta) with the nodes (t_j, x_j); the right panel is new: the error
# |x_j - x(t_j)| at the nodes on a log scale, with earlier m in gray.
# The exact solution is evaluated in 256-bit arithmetic.
# Produces: shootingbb.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))      # exact values
fmtv(x) = um(@sprintf("%.2e", Float64(x)))                     # computed: 3 s.f.
fmt10(x) = um(@sprintf("%.10f", Float64(x)))

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

# --- The boundary value problem (Mathews' Examples 1-6) ---
a, b     = 1.0, 6.0
alpha    = 1.0
beta     = -0.5
ms       = [25, 50, 100, 200, 400]                   # the table of Example 5
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

# --- Exact solution (Example 6), in 256-bit arithmetic ---
setprecision(BigFloat, 256)
const c1b, s1b = cos(big(1)), sin(big(1))
xpart(t) = (sqrt(t) * cos(t) + t * sqrt(t) * sin(t)) / 4
phi(t)   = (cos(t - 1) + sin(t - 1) / 2) / sqrt(t)
vex(t)   = sin(t - 1) / sqrt(t)
uex(t)   = xpart(t) + (1 - (c1b + s1b) / 4) * phi(t) - (3c1b + s1b) / 8 * vex(t)
Cex      = (beta - uex(big(6))) / vex(big(6))
xex(t)   = uex(t) + Cex * vex(t)
@assert abs(uex(big(1)) - 1) < 1e-70 && abs(xex(big(6)) - beta) < 1e-70

# --- Shooting with each m ---
runs = map(ms) do m
    T, U = runge2d(Fu, a, b, [alpha, 0.0], m)
    _, V = runge2d(Fv, a, b, [0.0, 1.0], m)
    C = (beta - U[end, 1]) / V[end, 1]
    X = U[:, 1] .+ C .* V[:, 1]
    E = Float64.(abs.(big.(X) .- xex.(big.(T))))   # |x_j - x(t_j)|; T is the Float64 node
    (m=m, h=(b - a) / m, T=T, X=X, C=C, E=E, emax=maximum(E), tmax=T[argmax(E)])
end
for (k, R) in enumerate(runs)
    @printf("m = %4d  h = %-7g  C = %.10f  max err = %.4e at t = %g  ratio = %s  |x_0-1| = %.3g  |x_m+0.5| = %.3g\n",
            R.m, R.h, R.C, R.emax, R.tmax,
            k == 1 ? "-" : @sprintf("%.4f", runs[k-1].emax / R.emax), R.E[1], R.E[end])
end

# --- Windows ---
tlims = (1.0, 6.0)
xlims_L = (-3.5, 1.5)
elims = (1e-11, 1e-3)
tf = range(a, b, length=1001)
xexact = Float64.(xex.(big.(collect(tf))))
# Log panel, drawn position only: an error below the panel (the end values are
# exact up to rounding) is drawn one decade below the bottom edge, so the curve
# visibly leaves the panel there instead of stopping short of it.
logdraw(e) = max(e, elims[1] / 10)
title_str = "Linear shooting with m steps (Mathews' Example 5):  x″ + x′/t + (1 − 1/(4t²))x = √t cos t,  " *
            "x(1) = 1,  x(6) = −0.5"

function draw_frame(n)
    R = runs[n]
    pL = plot(xlims=tlims, ylims=xlims_L, framestyle=:box, xlabel="t", ylabel="x",
              legend=:bottomleft, legendfontsize=8, titlefontsize=10, grid=true)
    hline!(pL, [0.0]; color=:black, lw=0.5, label="")
    plot!(pL, R.T, ydraw.(R.X, Ref(xlims_L)); color=:magenta, lw=3,
          markershape=:circle, ms=R.m <= 50 ? 5 : R.m <= 100 ? 4 : 3,
          markerstrokewidth=0, label="xⱼ = uⱼ + C vⱼ, m = $(R.m)")
    plot!(pL, tf, xexact; color=:black, lw=1.2, ls=:dash, label="exact solution (Example 6)")
    scatter!(pL, [a, b], [alpha, beta]; color=:red, ms=5, label="boundary values")
    title!(pL, "m = $(R.m), h = $(fmt(R.h)):  C = $(fmt10(R.C))  (exact $(fmt10(Cex)))")

    pR = plot(xlims=tlims, ylims=elims, yscale=:log10, framestyle=:box, xlabel="t",
              ylabel="|xⱼ − x(tⱼ)|", legend=:bottomleft, legendfontsize=8,
              titlefontsize=10, grid=true, yticks=10.0 .^ (-11:-3))
    for k in 1:n-1
        plot!(pR, runs[k].T, logdraw.(runs[k].E); color=:gray65, lw=1,
              label=k == 1 ? "earlier m" : "")
    end
    plot!(pR, R.T, logdraw.(R.E); color=:magenta, lw=2, label="m = $(R.m)")
    ratio = n == 1 ? "" : ",  m = $(runs[n-1].m) error / this = $(@sprintf("%.1f", runs[n-1].emax / R.emax))"
    title!(pR, "max error $(fmtv(R.emax)) at t = $(fmt(R.tmax))" * ratio)

    plot(pL, pR; layout=(1, 2), size=(1150, 520), plot_title=title_str,
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white)
end

anim = Animation()
for n in eachindex(runs)
    draw_frame(n)
    frame(anim)
end
for _ in 1:2                                         # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "shootingbb.gif"); fps=0.5)
println("Saved: shootingbb.gif")
