# rungekuttafehlbergaa.jl
# Runge-Kutta-Fehlberg method animation: adaptive RKF45 vs RKF54 on Example 1 IVP
# Produces: rungekuttafehlbergaa.gif

using Plots
gr()

f(t, y) = 1 + y^2
y_exact(t) = tan(t + atan(0.5))

function rkf_integrate(f, t0, tf, y0; h0=0.1, tol=1e-6, mode=:rkf45, hmin=1e-6, hmax=0.25)
    t = t0
    y = y0
    h = h0

    ts = Float64[t]
    ys = Float64[y]

    while t < tf
        if t + h > tf
            h = tf - t
        end

        k1 = h * f(t, y)
        k2 = h * f(t + h / 4, y + k1 / 4)
        k3 = h * f(t + 3h / 8, y + 3k1 / 32 + 9k2 / 32)
        k4 = h * f(t + 12h / 13, y + 1932k1 / 2197 - 7200k2 / 2197 + 7296k3 / 2197)
        k5 = h * f(t + h, y + 439k1 / 216 - 8k2 + 3680k3 / 513 - 845k4 / 4104)
        k6 = h * f(t + h / 2, y - 8k1 / 27 + 2k2 - 3544k3 / 2565 + 1859k4 / 4104 - 11k5 / 40)

        y4 = y + 25k1 / 216 + 1408k3 / 2565 + 2197k4 / 4104 - k5 / 5
        y5 = y + 16k1 / 135 + 6656k3 / 12825 + 28561k4 / 56430 - 9k5 / 50 + 2k6 / 55

        err = abs(y5 - y4)

        if err <= tol || h <= hmin
            t += h
            y = mode == :rkf45 ? y4 : y5
            push!(ts, t)
            push!(ys, y)
        end

        s = err == 0.0 ? 2.0 : 0.84 * (tol / err)^(1 / 4)
        h = clamp(s * h, hmin, hmax)
    end

    return ts, ys
end

t0 = 0.0
tf = 1.1
y0 = 0.5
tol = 1e-6

ts45, ys45 = rkf_integrate(f, t0, tf, y0; h0=0.1, tol=tol, mode=:rkf45)
ts54, ys54 = rkf_integrate(f, t0, tf, y0; h0=0.1, tol=tol, mode=:rkf54)

x_ref = range(t0, tf, length=800)
y_ref = y_exact.(x_ref)

xlims = (0.0, 1.1)
ylims = (0.0, 20.0)

using Printf
for (nm,ts,ys) in (("45",ts45,ys45),("54",ts54,ys54))
  println("mode RKF$nm npts=$(length(ts))  final t=$(ts[end]) y=$(ys[end]) exact=$(y_exact(ts[end]))")
  for i in eachindex(ts)
    @printf("%3d t=%.10f h=%.3e y=%.10f exact=%.10f err=%.3e relerr=%.3e onscreen=%s\n", i, ts[i], i>1 ? ts[i]-ts[i-1] : 0.0, ys[i], y_exact(ts[i]), ys[i]-y_exact(ts[i]), (ys[i]-y_exact(ts[i]))/y_exact(ts[i]), ys[i]<=20)
  end
end
