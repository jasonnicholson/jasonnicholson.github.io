# lorenzaa.jl
# Lorenz Attractor animation: Example 1, the Runge-Kutta solution against the
# true solution.
# x' = σ(y − x), y' = r x − y − x z, z' = x y − b z with σ = 10, r = 28, b = 8/3,
# from Z₀ = (10, −10, 20), solved on [0, 20] with the classical fourth-order
# Runge-Kutta method in vector form (Mathews' Runge3D), m = 1000 steps of
# h = 0.02. The "true solution" drawn beside it is a reference computed here by
# a Taylor series method of order 30 with step 0.01 in 200-bit (about 60-digit)
# BigFloat arithmetic. Five Runge-Kutta steps (0.1 time units) per frame.
# Left: both curves in 3-D, with the equilibria C₊, C₋ and the origin.
# Top right: x(t) of both. Bottom right: the distance between them at every
# Runge-Kutta point t_j = 0.02 j, on a log scale, with the levels 0.01 and 1
# and the first times the distance exceeds them.
# Produces: lorenzaa.gif

using Plots
using Printf
gr()

um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))      # significant figures
fmt3(x) = um(@sprintf("%#.3g", x))
fmtt(t) = um(@sprintf("%.2f", t))                     # times on the grid 0.02 j
sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))

# --- Problem (Example 1) ---
σ, r, b = 10.0, 28.0, 8 / 3
z0 = [10.0, -10.0, 20.0]
a, tend, m = 0.0, 20.0, 1000
F(t, u) = [σ * (u[2] - u[1]), r * u[1] - u[2] - u[1] * u[3], u[1] * u[2] - b * u[3]]

# Classical Runge-Kutta method in vector form, formula (5): returns Z_0, ..., Z_m
function rk4(F, a, bb, z0, m)
    h = (bb - a) / m
    Z = zeros(m + 1, 3); Z[1, :] = z0
    z = copy(z0)
    for j in 0:m-1
        t = a + j * h
        K1 = h * F(t, z)
        K2 = h * F(t + h / 2, z + K1 / 2)
        K3 = h * F(t + h / 2, z + K2 / 2)
        K4 = h * F(t + h, z + K3)
        z = z + (K1 + 2K2 + 2K3 + K4) / 6
        Z[j+2, :] = z
    end
    return Z
end

# --- Reference: Taylor series of order N, step hT, in BigFloat ---
setprecision(BigFloat, 200)
function taylor_lorenz(σ, r, b, u0, hT, nsteps; N=30)
    T = BigFloat
    X = zeros(T, N + 1); Y = zeros(T, N + 1); Zc = zeros(T, N + 1)
    u = T.(u0)
    out = zeros(nsteps + 1, 3); out[1, :] = Float64.(u)
    for n in 1:nsteps
        X[1], Y[1], Zc[1] = u
        for k in 0:N-1                    # Taylor coefficients from the equations
            xz = zero(T); xy = zero(T)
            for i in 0:k
                xz += X[i+1] * Zc[k-i+1]; xy += X[i+1] * Y[k-i+1]
            end
            X[k+2] = σ * (Y[k+1] - X[k+1]) / (k + 1)
            Y[k+2] = (r * X[k+1] - Y[k+1] - xz) / (k + 1)
            Zc[k+2] = (xy - b * Zc[k+1]) / (k + 1)
        end
        u = [evalpoly(hT, X), evalpoly(hT, Y), evalpoly(hT, Zc)]
        out[n+1, :] = Float64.(u)
    end
    return out
end

Zrk = rk4(F, a, tend, z0, m)
t = [a + j * (tend - a) / m for j in 0:m]
R = taylor_lorenz(BigFloat(10), BigFloat(28), BigFloat(8) / 3, z0, BigFloat(1) / 100, 2000)
Zref = R[1:2:end, :]                                  # reference at t_j = 0.02 j
d = [sqrt(sum(abs2, Zrk[j, :] - Zref[j, :])) for j in 1:m+1]

j1 = findfirst(>(0.01), d); t1 = t[j1]
j2 = findfirst(>(1.0), d); t2 = t[j2]
signchanges(x) = count(i -> sign(x[i]) != sign(x[i+1]) && x[i] != 0, 1:length(x)-1)
@printf("RK4 end Z_m = (%.6f, %.6f, %.6f)\n", Zrk[end, :]...)
@printf("ref at t = 20: (%.6f, %.6f, %.6f)\n", Zref[end, :]...)
for tt in (0.5, 1, 2, 5, 7, 10, 20)
    j = round(Int, tt / 0.02) + 1
    @printf("t = %4.1f  distance = %.4g\n", tt, d[j])
end
@printf("first t with distance > 0.01: %.2f; > 1: %.2f\n", t1, t2)
@printf("min distance on (0, 20]: %.3g at t = %.2f; max %.3g at t = %.2f\n",
        minimum(d[2:end]), t[argmin(d[2:end])+1], maximum(d), t[argmax(d)])
@printf("min distance on [t2, 20]: %.3g\n", minimum(d[j2:end]))
@printf("x sign changes on [0, 20]: reference (step 0.01) %d, RK4 %d\n",
        signchanges(R[:, 1]), signchanges(Zrk[:, 1]))
for (k, nm) in enumerate(("x", "y", "z"))
    @printf("%s range: reference [%.3f, %.3f], RK4 [%.3f, %.3f]\n", nm,
            extrema(R[:, k])..., extrema(Zrk[:, k])...)
end

# --- Drawing ---
cR, cT = :darkorange, :navy               # Runge-Kutta path, true solution
xl, yl, zl = (-20, 20), (-25, 25), (0, 50)
dl = (1e-4, 1e2)
q = 6 * sqrt(2)
title_str = "Lorenz system (Example 1):  σ = 10,  r = 28,  b = 8/3,  Z₀ = (10, −10, 20);  " *
            "Runge-Kutta m = $m, h = 0.02, against the true solution"
step = 5                                   # Runge-Kutta steps per frame

function draw_frame(j)                     # j = index of the last point drawn (t[j])
    tj = t[j]
    after = j >= j2
    p3 = plot(xlims=xl, ylims=yl, zlims=zl, camera=(35, 20), xlabel="x", ylabel="y",
              zlabel="z", legend=:topleft, legendfontsize=7, titlefontsize=10,
              grid=true)
    plot!(p3, Zrk[1:j, 1], Zrk[1:j, 2], Zrk[1:j, 3]; color=cR, lw=2.6,
          label="Runge-Kutta path, h = 0.02")
    plot!(p3, Zref[1:j, 1], Zref[1:j, 2], Zref[1:j, 3]; color=cT, lw=1,
          label="true solution (Taylor reference)")
    scatter!(p3, [q, -q, 0], [q, -q, 0], [27, 27, 0]; color=:black, ms=3,
             markerstrokewidth=0, label="equilibria C₊, C₋, origin")
    scatter!(p3, [Zrk[j, 1]], [Zrk[j, 2]], [Zrk[j, 3]]; color=cR, ms=5,
             markerstrokewidth=0, label="")
    scatter!(p3, [Zref[j, 1]], [Zref[j, 2]], [Zref[j, 3]]; color=cT, ms=4,
             markerstrokewidth=0, label="")
    title!(p3, j == 1 ? "t = 0:  Z₀ = (10, −10, 20)" :
               after ? "t = $(fmtt(tj)):  the Runge-Kutta path has left the true solution\n" *
                       "(distance first > 1 at t = $(fmtt(t2)))" :
                       "t = $(fmtt(tj)):  the Runge-Kutta path follows the true solution\n" *
                       "(distance < 1 so far)")

    px = plot(xlims=(0, 20), ylims=(-20, 20), framestyle=:box, xlabel="t",
              ylabel="x", grid=true, legend=false, titlefontsize=10,
              yticks=([-20, -q, 0, q, 20], ["−20", "C₋: −8.485", "0", "C₊: 8.485", "20"]))
    hline!(px, [q, -q]; color=:gray60, ls=:dot, lw=1)
    plot!(px, t[1:j], Zrk[1:j, 1]; color=cR, lw=2.6)
    plot!(px, t[1:j], Zref[1:j, 1]; color=cT, lw=1)
    title!(px, j == 1 ? "x(t):  Runge-Kutta and true solution" :
               "Z$(sub(j-1)):  x = $(fmt(Zrk[j,1]))   true x($(fmtt(tj))) = $(fmt(Zref[j,1]))")

    pd = plot(xlims=(0, 20), ylims=dl, yscale=:log10, framestyle=:box, xlabel="t",
              ylabel="distance", grid=true, legend=:bottomright, legendfontsize=7,
              titlefontsize=10, yticks=10.0 .^ (-4:2))
    hline!(pd, [0.01, 1]; color=:gray50, ls=:dash, lw=1, label="")
    if j >= 2
        plot!(pd, t[2:j], d[2:j]; color=:black, lw=1.4, label="")
    end
    if j >= j1
        scatter!(pd, [t1], [d[j1]]; color=:purple, ms=5, markerstrokewidth=0,
                 label="first > 0.01 at t = $(fmtt(t1))")
    end
    if j >= j2
        scatter!(pd, [t2], [d[j2]]; color=:red, ms=5, markerstrokewidth=0,
                 label="first > 1 at t = $(fmtt(t2))")
    end
    title!(pd, j == 1 ? "distance between the two (log scale)" :
               "distance at t = $(fmtt(tj)):  $(fmt3(d[j]))")

    l = @layout [a{0.5w} [b; c]]
    plot(p3, px, pd; layout=l, size=(1200, 640), plot_title=title_str,
         plot_titlefontsize=11, left_margin=4Plots.mm, bottom_margin=4Plots.mm,
         background_color=:white)
end

anim = Animation()
for k in 0:div(m, step)
    draw_frame(1 + step * k)
    frame(anim)
end
for _ in 1:30                              # hold the last frame 3 s
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "lorenzaa.gif"); fps=10)
println("Saved: lorenzaa.gif")
