# shootingaa.jl
# Shooting Methods animation: linear shooting for Mathews' boundary value
# problem (Examples 2-6)
#     x'' + x'/t + (1 - 1/(4t^2)) x = sqrt(t) cos t on [1, 6], x(1) = 1, x(6) = -0.5.
# One shot per frame: the solution x(t; s) = u(t) + s v(t) of the initial value
# problem x(1) = 1, x'(1) = s, for s = 0 (the function u of Example 2), s = 1,
# s = -1, s = 2 and finally s = C = (beta - u(6))/v(6) (Example 5), which lands on
# the target x(6) = -0.5. The left panel is Mathews' graph of the shots on
# [1, 6], with his colours (u green, v blue, the solution magenta) and the exact
# solution of Example 6 dashed. The right panel is new: the landing point
# x(6; s) = u(6) + s v(6) against the slope s. Every landing point lies on one
# straight line, and that line crosses the target -0.5 at s = C.
# u and v are computed as Mathews does, with his Runge2D (classical fourth-order
# Runge-Kutta) and m = 100 steps of h = 0.05; the shots are the combinations
# u_j + s v_j at the nodes.
# Produces: shootingaa.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))      # exact values
fmt6(x) = x == 0 ? "0" : um(@sprintf("%.6g", Float64(x)))     # Mathews prints 6 s.f.
fmt10(x) = um(@sprintf("%.10f", Float64(x)))                  # slope C, 10 decimals

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

# --- The boundary value problem (Mathews' Examples 1-6) ---
a, b     = 1.0, 6.0
alpha    = 1.0
beta     = -0.5
m        = 100                                       # Mathews' n = 100
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
Fu(t, z) = [z[2], p(t) * z[2] + q(t) * z[1] + r(t)]   # u' = y, y' = p y + q u + r
Fv(t, z) = [z[2], p(t) * z[2] + q(t) * z[1]]          # v' = z, z' = p z + q v

T, U = runge2d(Fu, a, b, [alpha, 0.0], m)            # Example 2
_, V = runge2d(Fv, a, b, [0.0, 1.0], m)              # Example 3
u, v = U[:, 1], V[:, 1]
C = (beta - u[end]) / v[end]                         # Example 5

# --- Exact solutions (Example 6), in 256-bit arithmetic ---
setprecision(BigFloat, 256)
const c1b, s1b = cos(big(1)), sin(big(1))
xpart(t) = (sqrt(t) * cos(t) + t * sqrt(t) * sin(t)) / 4      # w_p / sqrt(t)
phi(t)   = (cos(t - 1) + sin(t - 1) / 2) / sqrt(t)            # phi(1) = 1, phi'(1) = 0
vex(t)   = sin(t - 1) / sqrt(t)                               # v(1) = 0, v'(1) = 1
uex(t)   = xpart(t) + (1 - (c1b + s1b) / 4) * phi(t) - (3c1b + s1b) / 8 * vex(t)
Cex      = (beta - uex(big(6))) / vex(big(6))                # exact slope x'(1)
xex(t)   = uex(t) + Cex * vex(t)
@assert abs(uex(big(1)) - 1) < 1e-70 && abs(vex(big(1))) < 1e-70
@assert abs(xex(big(6)) - beta) < 1e-70

# Shots s = 0, 1, -1, 2, then the slope C that hits the target
shots = [0.0, 1.0, -1.0, 2.0, C]
land(s) = u[end] + s * v[end]                        # landing point x(6; s)
for s in shots
    @printf("s = %.10f  lands at x(6; s) = %.10f\n", s, land(s))
end
@printf("u_100(6) = %.10f  v_100(6) = %.10f  C = %.10f  exact C = %.10f\n",
        u[end], v[end], C, Float64(Cex))

# --- Windows ---
tlims = (1.0, 6.0)
xlims_L = (-4.0, 2.5)
slims = (-1.5, 2.5)
xlims_R = (-1.5, 0.5)
tf = range(a, b, length=1001)
xexact = Float64.(xex.(big.(collect(tf))))
title_str = "Linear shooting (Mathews' Examples 2–6):  x″ + x′/t + (1 − 1/(4t²))x = √t cos t,  " *
            "x(1) = 1,  x(6) = −0.5,  RK4 with m = $m, h = 0.05"
shotcolor = [:green, :darkorange, :purple, :saddlebrown, :magenta]
shotname(k) = k == length(shots) ? "s = C = $(fmt10(C))" : "s = $(fmt(shots[k]))"

function draw_frame(n)
    # Left: the shots
    pL = plot(xlims=tlims, ylims=xlims_L, framestyle=:box, xlabel="t", ylabel="x",
              legend=:bottomleft, legendfontsize=8, titlefontsize=10, grid=true)
    hline!(pL, [0.0]; color=:black, lw=0.5, label="")
    if n >= 2
        plot!(pL, T, ydraw.(v, Ref(xlims_L)); color=:blue, lw=1.5, ls=:dot,
              label="v(t) (Example 3)")
    end
    # The shot s = 0 is u: it stays green (Mathews' colour for u) in every frame
    plot!(pL, T, ydraw.(u, Ref(xlims_L)); color=:green, lw=n == 1 ? 2.5 : 1.5,
          label="s = 0: u(t) (Example 2)")
    for k in 2:n
        cur = k == n
        plot!(pL, T, ydraw.(u .+ shots[k] .* v, Ref(xlims_L));
              color=cur ? shotcolor[k] : :gray65, lw=cur ? 2.5 : 1.2,
              label=cur ? shotname(k) : (k == 2 ? "earlier shots" : ""))
    end
    if n == length(shots)
        plot!(pL, tf, xexact; color=:black, lw=1.5, ls=:dash,
              label="exact solution (Example 6)")
    end
    scatter!(pL, [a], [alpha]; color=:red, ms=5, label="x(1) = 1")
    scatter!(pL, [b], [beta]; color=:red, marker=:star5, ms=9,
             label="target x(6) = −0.5")
    s = shots[n]
    title!(pL, n == length(shots) ?
           "Shot $n: s = C lands on the target, x(6; C) = $(fmt6(land(s)))" :
           "Shot $n: slope x′(1) = s = $(fmt(s)),  lands at x(6; s) = $(fmt6(land(s)))")

    # Right: landing point against slope
    pR = plot(xlims=slims, ylims=xlims_R, framestyle=:box, xlabel="slope s = x′(1)",
              ylabel="landing point x(6; s)", legend=:topright, legendfontsize=8,
              titlefontsize=10, grid=true)
    hline!(pR, [beta]; color=:red, ls=:dash, lw=1.5, label="target β = −0.5")
    if n >= 2
        sl = collect(slims)
        plot!(pR, sl, land.(sl); color=:black, lw=1.2,
              label="line through the first two landings")
    end
    for k in 1:n
        cur = k == n
        scatter!(pR, [shots[k]], [land(shots[k])];
                 color=cur ? shotcolor[k] : :gray55, ms=cur ? 7 : 5,
                 marker=k == length(shots) ? :star5 : :circle, label="")
    end
    title!(pR, n == 1 ? "Landing point of each shot" :
           n == length(shots) ? "The line meets β at s = C = $(fmt10(C)) (exact $(fmt10(Cex)))" :
           n == 2 ? "Line through two landings: x(6; s) = $(fmt6(u[end])) + s·($(fmt6(v[end])))" :
           "Every landing point lies on x(6; s) = $(fmt6(u[end])) + s·($(fmt6(v[end])))")

    plot(pL, pR; layout=(1, 2), size=(1150, 520), plot_title=title_str,
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white)
end

anim = Animation()
for n in 1:length(shots)
    draw_frame(n)
    frame(anim)
end
for _ in 1:2                                         # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "shootingaa.gif"); fps=0.5)
println("Saved: shootingaa.gif")
