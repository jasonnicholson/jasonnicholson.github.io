# madsreidab.jl
# Madsen-Reid method (as implemented by Vestermark): double real root
# P(x) = (x-1)²(x+2) = x³ - 3x + 2,  double root at x* = 1, simple at x* = -2
# Produces: madsreidab.gif

using Plots, Printf
gr()

# ── Polynomial ────────────────────────────────────────────────────────────────
coeff = [1.0, 0.0, -3.0, 2.0]          # x³ - 3x + 2, leading coefficient first
f(x)  = x^3 - 3x + 2                   # = (x-1)^2 * (x+2), for drawing the curve

# ── Parameters ────────────────────────────────────────────────────────────────
x0  = 4.0                     # the case's own start (not the reference's start rule)
r0  = 5.0 * abs(x0)           # initial cap, r0 = 2.5u for a start at u/2 as in the reference

xlims = (-1.0, 4.5)
ylims = (-4.0, 60.0)
title_str = "Madsen-Reid (double root): P(x) = (x−1)²(x+2)"

# ── Madsen's method as implemented by Vestermark ──────────────────────────────
# A port of the iteration loop of newton_real (Newton_Real.cpp, H. Vestermark,
# Future Team ApS, 2002, https://www.hvks.com/Numerical/Downloads/Newton_Real.cpp).
# a = coefficients, leading first (a[1] here is a[0] in the C++). Only the loop
# for the first root is run; deflation and the closed-form quadratic are not.
# One line departs from the reference: see the fz0 comment in the loop.
const MAXITER = 50

# |P(z)|² and P(z) by the reference's real-coefficient Horner scheme
function feval(a, n, z)
    p = -2.0 * real(z)
    q = real(z) * real(z) + imag(z) * imag(z)
    s = 0.0; r = a[1]
    for i in 1:n-1
        t = a[i+1] - p * r - q * s
        s = r; r = t
    end
    fz = complex(a[n+1] + real(z) * r - q * s, imag(z) * r)
    return real(fz) * real(fz) + imag(fz) * imag(fz), fz
end

# Adams' upper bound for the rounding error of P(z), squared
function upperbound(a, n, z)
    p = -2.0 * real(z)
    q = real(z) * real(z) + imag(z) * imag(z)
    u = sqrt(q)
    s = 0.0; r = a[1]; e = abs(r) * (3.5 / 4.5)
    for i in 1:n-1
        t = a[i+1] - p * r - q * s
        s = r; r = t
        e = u * e + abs(t)
    end
    t = a[n+1] + real(z) * r - q * s
    e = u * e + abs(t)
    e = (9.0 * e - 7.0 * (abs(t) + abs(r) * u) + abs(real(z)) * abs(r) * 2.0) * 2.0^(-52)
    return e * e
end

# rotate by 53.13° (multiply by 0.6 + 0.8i) and scale by m
function alterdirection(dz::ComplexF64, m::Float64)::ComplexF64
    x = (real(dz) * 0.6 - imag(dz) * 0.8) * m
    y = (real(dz) * 0.8 + imag(dz) * 0.6) * m
    return complex(x, y)
end

# One record per iteration: start point, Newton point (after the r0 cap),
# accepted point, step kind, stage, lengthening multiple k, number of halvings.
function newton_real_iterates(coeff, z_start, r0_start)
    a  = Float64.(coeff)
    n  = length(a) - 1
    a1 = [a[i] * (n - i + 1) for i in 1:n]          # coefficients of P'
    z0  = complex(0.0, 0.0)                         # reference's initial state
    f0  = ff = 2.0 * a[n+1] * a[n+1]
    fz0 = complex(a[n], 0.0)
    z   = ComplexF64(z_start)
    dz  = z
    f, fz = feval(a, n, z)
    r0  = r0_start
    r   = sqrt(real(dz) * real(dz) + imag(dz) * imag(dz))
    eps = 4 * n * n * f0 * 2.0^(-106)
    stage1 = true
    steps  = NamedTuple[]
    itercnt = 0
    while (real(z) + real(dz) != real(z) || imag(z) + imag(dz) != imag(z)) &&
          f > eps && itercnt < MAXITER
        z_from = z
        u, fz1 = feval(a1, n - 1, z)
        saddle = (u == 0.0)
        limited = false
        if saddle                                   # true saddle point
            dz = alterdirection(dz, 5.0)
        else
            dz = complex((real(fz) * real(fz1) + imag(fz) * imag(fz1)) / u,
                         (imag(fz) * real(fz1) - real(fz) * imag(fz1)) / u)
            # which stage are we on (fz0 is P' at the previous iterate)
            fwz = fz0 - fz1
            wz  = z0 - z
            f2  = (real(fwz) * real(fwz) + imag(fwz) * imag(fwz)) /
                  (real(wz) * real(wz) + imag(wz) * imag(wz))
            stage1 = f2 / u > u / f / 4 || f != ff
            r = sqrt(real(dz) * real(dz) + imag(dz) * imag(dz))
            if r > r0                               # cap at r0, with rotation
                dz = alterdirection(dz, r0 / r)
                limited = true
            end
            r0 = r * 5.0
        end
        z0 = z
        # The one departure from newton_real, which stores fz0 = fz (P, not P'):
        # Madsen & Reid's test (2.9) needs P'(z_{k-1}) - P'(z_k), so store P'.
        f0 = f; fz0 = fz1
        zN = z0 - dz
        kind, k, nhalf, rounding = :plain, 1, 0, 0
        while true                                  # iter2:
            z = z0 - dz
            f, fz = feval(a, n, z)
            ff = f
            kind, k, nhalf = :plain, 1, 0
            if stage1
                wz = z
                div2 = f > f0
                for i in 1:n
                    if div2
                        dz *= complex(0.5)
                        wz = z0 - dz
                    else
                        wz -= dz
                    end
                    fw, fwz = feval(a, n, wz)
                    fw >= f && break
                    f = fw; fz = fwz; z = wz
                    div2 ? (nhalf = i) : (k = i + 1)
                    if div2 && i == 2               # two halvings helped: saddle point
                        dz = alterdirection(dz, 0.5)
                        z = z0 - dz
                        f, fz = feval(a, n, z)
                        kind = :rotated
                        break
                    end
                end
                if kind != :rotated
                    kind = div2 ? (nhalf > 0 ? :halved : :plain_increase) :
                                  (k > 1 ? :lengthened : :plain)
                end
            else
                eps = upperbound(a, n, z)           # Stage 2: Adams' test
                kind = :stage2
            end
            if r < sqrt(real(z) * real(z) + imag(z) * imag(z)) * 2.0^(-26) && f >= f0
                z = z0                              # domain of rounding errors
                dz = alterdirection(dz, 0.5)
                if z + dz != z
                    rounding += 1
                    continue
                end
            end
            break
        end
        push!(steps, (z_from=z_from, zN=zN, z=z, kind=kind, stage1=stage1, k=k,
                      nhalf=nhalf, f=f, eps=eps, limited=limited, saddle=saddle,
                      rounding=rounding))
        itercnt += 1
    end
    return steps
end

function print_trace(steps)
    for (j, s) in enumerate(steps)
        @printf("  %2d stage%d %-14s k=%d halvings=%d cap=%d saddle=%d rounding=%d  z = %s  |P|² = %.17g  eps = %.17g\n",
                j, s.stage1 ? 1 : 2, s.kind, s.k, s.nhalf, s.limited, s.saddle, s.rounding,
                repr(s.z), s.f, s.eps)
    end
end

# ── Compute iterates ──────────────────────────────────────────────────────────
steps = newton_real_iterates(coeff, complex(x0, 0.0), r0)
println("Iterates:"); print_trace(steps)
# A rotated step (cap, saddle-point or rounding branch) would leave the real
# axis, which this plot cannot show: stop loudly rather than fake it.
all(s -> imag(s.z) == 0.0 && imag(s.zN) == 0.0, steps) ||
    error("a step left the real axis; not representable on this plot")
xs     = [x0; [real(s.z) for s in steps]]
xt     = [real(s.zN) for s in steps]          # Newton point x - Δx (tangent intercept)
kinds  = [s.kind for s in steps]
stage2 = [!s.stage1 for s in steps]
n_frames = length(steps)

stepcolor(kd) = kd in (:halved, :rotated) ? :orange : kd == :lengthened ? :seagreen : :steelblue

# ── Animation ─────────────────────────────────────────────────────────────────
xplot = range(xlims[1], xlims[2]; length = 400)

anim = @animate for frame in 0:n_frames
    # Frames 0-1 use the full window; from frame 2 on the window zooms to the
    # latest step (its start, Newton point and end), which is otherwise sub-pixel.
    xl, yl, lpos, xpl, xfmt = xlims, ylims, :topleft, xplot, :auto
    if frame ≥ 2
        pts  = (xs[frame], xt[frame], xs[frame+1])
        w    = maximum(pts) - minimum(pts)
        xl   = (minimum(pts) - 0.15w, maximum(pts) + 0.15w)
        ytop = 1.25 * max(abs(f(xs[frame])), abs(f(xs[frame+1])))
        yl   = (-0.1ytop, ytop)
        lpos = xs[frame] < sum(xl)/2 ? :topright : :topleft   # keep legend off the step's start
        xpl  = range(xl[1], xl[2]; length = 400)
        nd   = clamp(ceil(Int, -log10(w)) + 1, 1, 12)    # enough decimals to tell ticks apart
        xfmt = x -> @sprintf("%.*f", nd, x)
    end
    plot(size=(640, 520), xlims=xl, ylims=yl,
         xlabel="x", ylabel="P(x)", title=title_str,
         legend=lpos, grid=true, framestyle=:box, xformatter=xfmt,
         background_color=:white)

    hline!([0.0]; color=:black, lw=1, label="")
    plot!(xpl, f.(xpl); color=:magenta, lw=2, label="P(x)")

    for k in 1:frame
        col = stepcolor(kinds[k])
        xn  = xs[k]
        xn1 = xs[k+1]
        fxn = f(xn)
        # tangent line down to the Newton point, then along the axis to x - kΔx
        # (zoomed frames draw only the current step's axis part, so older
        # steps' thick segments do not cover the window)
        plot!([xn, xt[k]], [fxn, 0.0]; color=col, lw=1.5, label="")
        (frame < 2 || k == frame) && xt[k] != xn1 &&
            plot!([xt[k], xn1], [0.0, 0.0]; color=col, lw=3, label="")
        plot!([xn1, xn1], [0.0, f(xn1)]; color=col, lw=1.5, label="")
    end

    x_cur = xs[frame + 1]
    lab = frame == 0 ? "x0 = $(x_cur)" :
          "x$(frame) = $(round(x_cur; sigdigits=11))  (Stage $(stage2[frame] ? 2 : 1))"
    scatter!([x_cur], [f(x_cur)]; color=:red, ms=6, label=lab)

    plot!(Float64[], Float64[]; color=:steelblue, lw=2, label="plain Newton step x − Δx")
    plot!(Float64[], Float64[]; color=:seagreen,  lw=2, label="lengthened step x − kΔx")
    plot!(Float64[], Float64[]; color=:orange,    lw=2, label="halved / rotated step")
end

gif(anim, joinpath(@__DIR__, "madsreidab.gif"); fps=2)
println("Saved: madsreidab.gif")
