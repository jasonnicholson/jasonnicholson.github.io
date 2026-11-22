# eulersmethodaa.jl
# Euler's Method for ODE's animation: forward Euler trajectory build
# Produces: eulersmethodaa.gif

using Plots
gr()

f(t, y) = 1 - t * cbrt(y)

function rk4_reference(f, t0, tf, y0, h)
    n_steps = Int(round((tf - t0) / h))
    ts = collect(range(t0, tf, length=n_steps + 1))
    ys = zeros(n_steps + 1)
    ys[1] = y0

    for i in 1:n_steps
        t = ts[i]
        y = ys[i]
        k1 = f(t, y)
        k2 = f(t + 0.5 * h, y + 0.5 * h * k1)
        k3 = f(t + 0.5 * h, y + 0.5 * h * k2)
        k4 = f(t + h, y + h * k3)
        ys[i + 1] = y + (h / 6.0) * (k1 + 2.0 * k2 + 2.0 * k3 + k4)
    end

    return ts, ys
end

t0 = 0.0
tf = 5.0
n_pts = 41
n_steps = n_pts - 1
h = (tf - t0) / n_steps
h_ref = 1e-4

ts = collect(range(t0, tf, length=n_pts))
ys = zeros(n_pts)
ys[1] = 1.0
ts_ref, ys_ref = rk4_reference(f, t0, tf, ys[1], h_ref)

for i in 1:n_steps
    ys[i + 1] = ys[i] + h * f(ts[i], ys[i])
end


ylims = (-0.1, 1.55)
open(joinpath(@__DIR__, "iterates_$(basename(@__FILE__)).txt"), "w") do io
    for k in 1:n_pts; println(io, repr(ts[k]), " ", repr(ys[k])); end
end
slopes = [(ys[k+1]-ys[k])/(ts[k+1]-ts[k]) for k in 1:n_steps]
fk = [f(ts[k], ys[k]) for k in 1:n_steps]
println("h=", h, " max|segment slope - f(t_k,y_k)| = ", maximum(abs.(slopes .- fk)))
println("ys range: ", extrema(ys), " ref range: ", extrema(ys_ref), " ref end t=", ts_ref[end], " len=", length(ts_ref))
println("y(5)=", ys[end], " ref=", ys_ref[end])
