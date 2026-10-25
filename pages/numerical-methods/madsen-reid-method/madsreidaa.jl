# madsreidaa.jl
# Madsen-Reid Damped Newton: simple real root
# P(x) = x³ - 3x - 1,  root at x* ≈ 1.8794
# Produces: madsreidaa.gif

using Plots
gr()

# ── Polynomial ────────────────────────────────────────────────────────────────
f(x)  = x^3 - 3x - 1
fp(x) = 3x^2 - 3

# ── Parameters ────────────────────────────────────────────────────────────────
x0      = 3.0
n_iters = 8

xlims = (-0.5, 3.5)
ylims = (-5.0, 22.0)
title_str = "Madsen-Reid (simple root): P(x) = x³ − 3x − 1"

# ── Madsen-Reid helpers ───────────────────────────────────────────────────────
function alterdirection(dz::Float64, m::Float64)
    # Rotate by ~53° and scale by m  (real-axis version: imaginary part is 0
    # so the direction change just flips sign of step and scales)
    return dz * m * (-0.6)          # simplified: negate + scale (keeps real axis)
end

# ── Compute iterates + step classification ────────────────────────────────────
function mr_iterates(f, fp, x0, n_iters)
    xs     = [Float64(x0)]
    labels = Symbol[]          # :newton  or  :damped

    x  = Float64(x0)
    r0 = 2.5 * abs(x0)        # initial step-size limit

    for _ in 1:n_iters
        fval  = f(x)
        fpval = fp(x)
        f_sq  = fval^2

        abs(fpval) < 1e-14 && break   # true saddle – skip

        dz = fval / fpval             # Newton step
        r  = abs(dz)
        if r > r0                     # limit step radius
            dz = dz * (r0 / r)
        end
        r0 = r * 5.0                  # acceleration: allow 5× next time

        x_new  = x - dz
        fn_sq  = f(x_new)^2

        if fn_sq < f_sq
            push!(labels, :newton)    # pure Newton – Stage 2
        else
            push!(labels, :damped)    # backtrack  – Stage 1
            improved = false
            for _ in 1:4
                dz    = dz * 0.5
                x_new = x - dz
                fn_sq = f(x_new)^2
                if fn_sq < f_sq
                    improved = true
                    break
                end
            end
            if !improved              # alter direction as last resort
                dz    = alterdirection(dz, 1.0)
                x_new = x - dz
            end
        end

        x = x_new
        push!(xs, x)
        abs(f(x)) < 1e-10 && break
    end
    return xs, labels
end

xs, labels = mr_iterates(f, fp, x0, n_iters)
n_frames   = length(xs) - 1

# ── Animation ─────────────────────────────────────────────────────────────────
xplot = range(xlims[1], xlims[2]; length = 400)

anim = @animate for frame in 0:n_frames
    plot(size=(640, 520), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="P(x)", title=title_str,
         legend=:topleft, grid=true, framestyle=:box,
         background_color=:white)

    hline!([0.0]; color=:black, lw=1, label="")
    plot!(xplot, f.(xplot); color=:magenta, lw=2, label="P(x)")

    for k in 1:frame
        col = (k ≤ length(labels) && labels[k] == :damped) ? :orange : :steelblue
        xn  = xs[k]
        xn1 = xs[k+1]
        plot!([xn, xn1], [f(xn), 0.0]; color=col, lw=1.5, label="")
        plot!([xn1, xn1], [0.0, f(xn1)]; color=col, lw=1.5, label="")
    end

    x_cur = xs[frame + 1]
    scatter!([x_cur], [f(x_cur)]; color=:red, ms=6,
             label="x$(frame) = $(round(x_cur; digits=5))")

    # legend entries for step types
    plot!(Float64[], Float64[]; color=:steelblue, lw=2, label="Stage 2 – Newton")
    plot!(Float64[], Float64[]; color=:orange,    lw=2, label="Stage 1 – Damped")
end

gif(anim, joinpath(@__DIR__, "madsreidaa.gif"); fps=2)
println("Saved: madsreidaa.gif")
