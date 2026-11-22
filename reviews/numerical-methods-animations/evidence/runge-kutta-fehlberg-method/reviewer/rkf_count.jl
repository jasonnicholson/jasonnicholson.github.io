function rkf_integrate_count(f, t0, tf, y0; h0=0.1, tol=1e-6, mode=:rkf45, hmin=1e-6, hmax=0.25)
    t = t0
    y = y0
    h = h0

    ts = Float64[t]; nrej = 0; ratios = Float64[]; hs_try = Float64[]
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

        err = abs(y5 - y4); push!(hs_try, h)

        if err <= tol || h <= hmin
            t += h
            y = mode == :rkf45 ? y4 : y5
            push!(ts, t)
            push!(ys, y); push!(ratios, err/tol)
        end

        (err <= tol || h <= hmin) || (nrej += 1)
        s = err == 0.0 ? 2.0 : 0.84 * (tol / err)^(1 / 4)
        h = clamp(s * h, hmin, hmax)
    end

    return ts, ys, nrej, ratios, hs_try
end
