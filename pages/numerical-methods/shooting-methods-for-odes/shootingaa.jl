# shootingaa.jl
# Shooting Methods for ODE's animation: linear shooting combination for a two-point BVP
# Produces: shootingaa.gif

using Plots
gr()

# Boundary value problem:
# x'' + (1/t) x' + (1 - 1/(4 t^2)) x = sqrt(t) cos(t),  t in [1, 6]
# x(1) = 1,  x(6) = -0.5

p(t) = -1.0 / t
q(t) = -(1.0 - 1.0 / (4.0 * t^2))
r(t) = sqrt(t) * cos(t)

a = 1.0
b = 6.0
alpha = 1.0
beta = -0.5

# Solve a two-variable first-order system with classic RK4.
function rk4_system(f, tspan, y0, nsteps)
    t0, t1 = tspan
    h = (t1 - t0) / nsteps
    ts = collect(range(t0, t1; length=nsteps + 1))
    ys = Matrix{Float64}(undef, length(y0), nsteps + 1)
    ys[:, 1] = y0

    for i in 1:nsteps
        t = ts[i]
        y = ys[:, i]

        k1 = f(t, y)
        k2 = f(t + 0.5h, y + 0.5h .* k1)
        k3 = f(t + 0.5h, y + 0.5h .* k2)
        k4 = f(t + h, y + h .* k3)

        ys[:, i + 1] = y + (h / 6.0) .* (k1 + 2.0k2 + 2.0k3 + k4)
    end

    return ts, ys
end

# First auxiliary IVP (u): includes forcing r(t).
f_u(t, y) = [
    y[2],
    p(t) * y[2] + q(t) * y[1] + r(t),
]

# Second auxiliary IVP (v): homogeneous equation.
f_v(t, y) = [
    y[2],
    p(t) * y[2] + q(t) * y[1],
]

nsteps = 600
ts, yu = rk4_system(f_u, (a, b), [alpha, 0.0], nsteps)
_, yv = rk4_system(f_v, (a, b), [0.0, 1.0], nsteps)

u = yu[1, :]
v = yv[1, :]

c_star = (beta - u[end]) / v[end]
x_final = u .+ c_star .* v

xlims = (a, b)
ylims = (-3.2, 1.2)

n_frames = 16
c_path = range(0.0, c_star; length=n_frames)

anim = @animate for (k, c_now) in enumerate(c_path)
    x_now = u .+ c_now .* v

    plot(size=(760, 520),
         xlims=xlims, ylims=ylims,
         xlabel="t", ylabel="x(t)",
         title="Shooting Method: x(t) = u(t) + c v(t)",
         legend=:bottomleft, grid=true, framestyle=:box,
         background_color=:white)

    plot!(ts, u; color=:forestgreen, lw=2.2, label="u(t)")
    plot!(ts, v; color=:royalblue,  lw=2.2, label="v(t)")
    plot!(ts, x_now; color=:magenta3, lw=2.8, label="x_c(t)")

    scatter!([b], [beta]; color=:red, ms=7, markerstrokewidth=0,
             label="target x(6) = -0.5")
    scatter!([b], [x_now[end]]; color=:black, ms=5, markerstrokewidth=0,
             label="current x_c(6)")

    plot!([b, b], [x_now[end], beta]; color=:gray40, lw=1.5, ls=:dash, label="")

    # Keep visuals focused on endpoint matching without crowded text overlays.
end

gif(anim, joinpath(@__DIR__, "shootingaa.gif"); fps=2)
println("Saved: shootingaa.gif")
println("u(6) = $(u[end])")
println("v(6) = $(v[end])")
println("c*   = $(c_star)")
println("x(6) = $(x_final[end])")
