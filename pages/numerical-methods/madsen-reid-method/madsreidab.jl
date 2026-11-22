# madsreidab.jl
# Madsen-Reid Damped Newton: double real root
# P(x) = (x-1)²(x+2) = x³ - 3x + 2,  double root at x* = 1, simple at x* = -2
# Produces: madsreidab.gif

using Plots
gr()

# ── Polynomial ────────────────────────────────────────────────────────────────
f(x)  = x^3 - 3x + 2          # = (x-1)^2 * (x+2)
fp(x) = 3x^2 - 3

# ── Parameters ────────────────────────────────────────────────────────────────
x0      = 4.0
n_iters = 14
n_deg   = 3                   # degree of P: longest multi-step is n_deg·Δx

xlims = (-1.0, 4.5)
ylims = (-4.0, 60.0)
title_str = "Madsen-Reid (double root): P(x) = (x−1)²(x+2)"

# ── Madsen-Reid helpers ───────────────────────────────────────────────────────
function alterdirection_real(dz::Float64, m::Float64)
    # The real algorithm rotates the step by 53.13° (factor 0.6 + 0.8i), which
    # leaves the real axis. A real-axis animation cannot show that, so stop
    # loudly instead of faking it (this branch is not reached for this case).
    error("alterdirection needs a complex step; not representable on the real axis")
end

function mr_iterates(f, fp, x0, n_iters, n_deg)
    xs     = [Float64(x0)]
    labels = Symbol[]          # :newton, :multi  or  :damped
    xt     = Float64[]         # Newton point x - Δx of each step (tangent intercept)

    x  = Float64(x0)
    r0 = 2.5 * abs(x0)

    for _ in 1:n_iters
        fval  = f(x)
        fpval = fp(x)
        f_sq  = fval^2

        abs(fpval) < 1e-14 * (1 + abs(fval)) && break

        dz = fval / fpval
        r  = abs(dz)
        if r > r0
            dz = dz * (r0 / r)
        end
        r0 = r * 5.0                  # cap for next step: 5× this Newton step
        push!(xt, x - dz)

        x_new = x - dz
        fn_sq = f(x_new)^2

        if fn_sq < f_sq
            # multiple steps in the same direction: try x - 2Δx, ..., x - n_deg·Δx
            # while |P|² keeps decreasing, and keep the last improving point
            k = 1
            for p in 2:n_deg
                x_try = x - p * dz
                ft_sq = f(x_try)^2
                ft_sq < fn_sq || break
                x_new, fn_sq, k = x_try, ft_sq, p
            end
            push!(labels, k == 1 ? :newton : :multi)   # Stage 2  /  Stage 1 multi-step
        else
            push!(labels, :damped)
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
            if !improved
                dz    = alterdirection_real(dz, 1.0)
                x_new = x - dz
            end
        end

        x = x_new
        push!(xs, x)
        abs(f(x)) < 1e-10 && break
    end
    return xs, labels, xt
end

xs, labels, xt = mr_iterates(f, fp, x0, n_iters, n_deg)
n_frames   = length(xs) - 1

# ── Animation ─────────────────────────────────────────────────────────────────
xplot = range(xlims[1], xlims[2]; length = 400)

anim = @animate for frame in 0:n_frames
    # Frames 0-1 use the full window; from frame 2 on the window zooms to the
    # latest step (its start, Newton point and end), which is otherwise sub-pixel.
    xl, yl, lpos, xpl = xlims, ylims, :topleft, xplot
    if frame ≥ 2
        pts  = (xs[frame], xt[frame], xs[frame+1])
        w    = maximum(pts) - minimum(pts)
        xl   = (minimum(pts) - 0.15w, maximum(pts) + 0.15w)
        ytop = 1.25 * max(abs(f(xs[frame])), abs(f(xs[frame+1])))
        yl   = (-0.1ytop, ytop)
        lpos = xs[frame] < sum(xl)/2 ? :topright : :topleft   # keep legend off the step's start
        xpl  = range(xl[1], xl[2]; length = 400)
    end
    plot(size=(640, 520), xlims=xl, ylims=yl,
         xlabel="x", ylabel="P(x)", title=title_str,
         legend=lpos, grid=true, framestyle=:box,
         background_color=:white)

    hline!([0.0]; color=:black, lw=1, label="")
    plot!(xpl, f.(xpl); color=:magenta, lw=2, label="P(x)")

    for k in 1:frame
        col = labels[k] == :damped ? :orange : labels[k] == :multi ? :seagreen : :steelblue
        xn  = xs[k]
        xn1 = xs[k+1]
        fxn = f(xn)
        if labels[k] == :multi
            # tangent line down to the Newton point, then along the axis to x - kΔx
            plot!([xn, xt[k]], [fxn, 0.0]; color=col, lw=1.5, label="")
            plot!([xt[k], xn1], [0.0, 0.0]; color=col, lw=3, label="")
        else
            plot!([xn, xn1], [fxn, 0.0]; color=col, lw=1.5, label="")
        end
        plot!([xn1, xn1], [0.0, f(xn1)]; color=col, lw=1.5, label="")
    end

    x_cur = xs[frame + 1]
    scatter!([x_cur], [f(x_cur)]; color=:red, ms=6,
             label="x$(frame) = $(round(x_cur; sigdigits=9))")

    plot!(Float64[], Float64[]; color=:steelblue, lw=2, label="Stage 2 – Newton")
    plot!(Float64[], Float64[]; color=:seagreen,  lw=2, label="Stage 1 – multi-step kΔx")
    plot!(Float64[], Float64[]; color=:orange,    lw=2, label="Stage 1 – Damped")
end

gif(anim, joinpath(@__DIR__, "madsreidab.gif"); fps=2)
println("Saved: madsreidab.gif")
