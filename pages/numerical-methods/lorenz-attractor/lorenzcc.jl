# lorenzcc.jl
# Lorenz Attractor animation: the Rössler attractors of Examples 5 and 6.
# x' = −(y + z), y' = x + a y, z' = b + x z − c z from Z₀ = (9, 0, 1) with
# (a, b, c) = (0.2, 0.2, 5.7) (Example 5, left) and (0.343, 1.82, 9.75)
# (Example 6, right), each solved on [0, 50] with the classical fourth-order
# Runge-Kutta method in vector form (Mathews' Runge3D), m = 1000 steps of
# h = 0.05. Each Runge-Kutta path is drawn over the true solution, a reference
# computed here by a Taylor series method of order 30 with step 0.01 in 200-bit
# (about 60-digit) BigFloat arithmetic, and each panel reports the largest
# distance between them so far. Five Runge-Kutta steps (0.25 time units) per frame.
# Top: the curves in 3-D. Bottom: x(t) and z(t) of the Runge-Kutta paths.
# The parameters are the Float64 numbers nearest 0.2, 0.343, ... in both
# computations, so the reference solves the same problem as the Runge-Kutta run.
# Produces: lorenzcc.gif

using Plots
using Printf
gr()

um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))      # significant figures
fmt2(x) = um(@sprintf("%#.2g", x))
fmtt(t) = um(@sprintf("%.2f", t))

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

# Reference: Taylor series of order N, step hT, in BigFloat
setprecision(BigFloat, 200)
function taylor_rossler(a, b, c, u0, hT, nsteps; N=30)
    T = BigFloat
    X = zeros(T, N + 1); Y = zeros(T, N + 1); Zc = zeros(T, N + 1)
    u = T.(u0)
    out = zeros(nsteps + 1, 3); out[1, :] = Float64.(u)
    for n in 1:nsteps
        X[1], Y[1], Zc[1] = u
        for k in 0:N-1                    # Taylor coefficients from the equations
            xz = zero(T)
            for i in 0:k
                xz += X[i+1] * Zc[k-i+1]
            end
            X[k+2] = -(Y[k+1] + Zc[k+1]) / (k + 1)
            Y[k+2] = (X[k+1] + a * Y[k+1]) / (k + 1)
            Zc[k+2] = ((k == 0 ? b : zero(T)) + xz - c * Zc[k+1]) / (k + 1)
        end
        u = [evalpoly(hT, X), evalpoly(hT, Y), evalpoly(hT, Zc)]
        out[n+1, :] = Float64.(u)
    end
    return out
end

z0 = [9.0, 0.0, 1.0]
tend, m = 50.0, 1000
t = [j * tend / m for j in 0:m]
cases = [
    (ex=5, a=0.2, b=0.2, c=5.7, xl=(-12, 12), yl=(-12, 10), zl=(0, 25), tl=(-12, 25)),
    (ex=6, a=0.343, b=1.82, c=9.75, xl=(-16, 20), yl=(-22, 14), zl=(0, 70), tl=(-20, 70)),
]
runs = map(cases) do C
    F(t, u) = [-(u[2] + u[3]), u[1] + C.a * u[2], C.b + u[1] * u[3] - C.c * u[3]]
    Z = rk4(F, 0.0, tend, z0, m)
    R = taylor_rossler(BigFloat(C.a), BigFloat(C.b), BigFloat(C.c), z0,
                       BigFloat(1) / 100, 5000)[1:5:end, :]          # at t_j = 0.05 j
    d = [sqrt(sum(abs2, Z[j, :] - R[j, :])) for j in 1:m+1]
    dmax = accumulate(max, d)                                      # largest so far
    @printf("Example %d: RK4 end (%.6f, %.6f, %.6f); ref end (%.6f, %.6f, %.6f)\n",
            C.ex, Z[end, :]..., R[end, :]...)
    @printf("  max distance on [0, 50]: %.4g at t = %.2f; first > 0.1 at t = %s\n",
            maximum(d), t[argmax(d)],
            something(findfirst(>(0.1), d), 0) == 0 ? "never" :
            @sprintf("%.2f", t[findfirst(>(0.1), d)]))
    for (k, nm) in enumerate(("x", "y", "z"))
        @printf("  %s range: RK4 [%.4f, %.4f], ref [%.4f, %.4f]\n", nm,
                extrema(Z[:, k])..., extrema(R[:, k])...)
    end
    for tt in 10:10:50
        @printf("  t = %d: distance %.4g\n", tt, d[20tt+1])
    end
    (C=C, Z=Z, R=R, d=d, dmax=dmax)
end

# --- Drawing ---
cR, cT = :darkorange, :navy
title_str = "Rössler system (Examples 5 and 6):  x′ = −(y + z),  y′ = x + a y,  " *
            "z′ = b + x z − c z,  Z₀ = (9, 0, 1),  Runge-Kutta m = 1000, h = 0.05"
step = 5

function panels(run, j)
    C, Z, R = run.C, run.Z, run.R
    p3 = plot(xlims=C.xl, ylims=C.yl, zlims=C.zl, camera=(35, 25), xlabel="x",
              ylabel="y", zlabel="z", legend=:topleft, legendfontsize=7,
              titlefontsize=10, grid=true)
    plot!(p3, Z[1:j, 1], Z[1:j, 2], Z[1:j, 3]; color=cR, lw=2.6,
          label="Runge-Kutta path, h = 0.05")
    plot!(p3, R[1:j, 1], R[1:j, 2], R[1:j, 3]; color=cT, lw=0.9,
          label="true solution (Taylor reference)")
    scatter!(p3, [Z[j, 1]], [Z[j, 2]], [Z[j, 3]]; color=cR, ms=5,
             markerstrokewidth=0, label="")
    title!(p3, "Example $(C.ex):  a = $(fmt(C.a)),  b = $(fmt(C.b)),  c = $(fmt(C.c))\n" *
               (j == 1 ? "t = 0" :
                "t = $(fmtt(t[j])):  largest distance so far $(fmt2(run.dmax[j]))"))

    pt = plot(xlims=(0, 50), ylims=C.tl, framestyle=:box, xlabel="t", grid=true,
              legend=:outerright, legendfontsize=7, titlefontsize=10)
    plot!(pt, t[1:j], Z[1:j, 1]; color=:teal, lw=1.4, label="x(t)")
    plot!(pt, t[1:j], Z[1:j, 3]; color=:crimson, lw=1.4, label="z(t)")
    title!(pt, "Z$(join(Char(0x2080 + q) for q in reverse(digits(j - 1)))) = " *
               "($(fmt(Z[j,1])), $(fmt(Z[j,2])), $(fmt(Z[j,3])))")
    return p3, pt
end

function draw_frame(j)
    a3, at = panels(runs[1], j)
    b3, bt = panels(runs[2], j)
    l = @layout [grid(1, 2){0.68h}; grid(1, 2)]
    plot(a3, b3, at, bt; layout=l, size=(1200, 760), plot_title=title_str,
         plot_titlefontsize=11, left_margin=4Plots.mm, bottom_margin=3Plots.mm,
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
gif(anim, joinpath(@__DIR__, "lorenzcc.gif"); fps=10)
println("Saved: lorenzcc.gif")
