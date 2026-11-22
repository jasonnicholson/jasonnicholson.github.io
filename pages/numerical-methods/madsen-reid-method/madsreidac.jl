# madsreidac.jl
# Madsen-Reid method (as implemented by Vestermark): complex roots
# P(z) = z² + 4,  roots at z* = ±2i
# Starting on the real axis, two helpful halvings at z1 trigger the saddle-point
# rotation (alterdirection), which takes the iterates off the real axis.
# The reference solves a quadratic in closed form; here its iteration loop is
# run on the quadratic itself, from the reference's own start z0 = 1, r0 = 5.
# Produces: madsreidac.gif

using Plots, Printf
gr()

# ── Polynomial ────────────────────────────────────────────────────────────────
coeff = [1.0, 0.0, 4.0]                # z² + 4, leading coefficient first
f(z)  = z^2 + 4

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

# ── Compute iterates in ℂ ─────────────────────────────────────────────────────
z0      = complex(1.0, 0.0)            # reference start: ±u/2, u = startpoint = 2
r0_init = 5.0                          # reference: r0 = 2.5u = 5
steps   = newton_real_iterates(coeff, z0, r0_init)
zs      = [z0; [s.z for s in steps]]
kinds   = [s.kind for s in steps]
stage2  = [!s.stage1 for s in steps]
n_frames = length(steps)

println("Iterates:"); print_trace(steps)

# ── Plot domain ───────────────────────────────────────────────────────────────
# Collect all real and imag parts to choose good axis limits
all_re = real.(zs)
all_im = imag.(zs)
re_lo  = min(-2.5, minimum(all_re) - 0.5)
re_hi  = max( 2.5, maximum(all_re) + 0.5)
im_lo  = min(-2.8, minimum(all_im) - 0.5)
im_hi  = max( 2.8, maximum(all_im) + 0.5)

# Clamp to something reasonable for a compact animation
re_lo = max(re_lo, -4.0);  re_hi = min(re_hi, 4.0)
im_lo = max(im_lo, -3.0);  im_hi = min(im_hi, 3.5)

title_str = "Madsen-Reid (complex roots): P(z) = z² + 4"

stepcolor(kd) = kd in (:halved, :rotated) ? :orange : kd == :lengthened ? :seagreen : :steelblue
fmt(v) = v == 0 ? "0" : abs(v) < 5e-4 ? @sprintf("%.1e", v) : @sprintf("%.3f", v)

# ── Animation ─────────────────────────────────────────────────────────────────
anim = @animate for frame in 0:n_frames
    plot(size=(720, 580),
         xlims=(re_lo, re_hi), ylims=(im_lo, im_hi),
         xlabel="Re(z)", ylabel="Im(z)", title=title_str,
         legend=:outertopright, grid=true, framestyle=:box,
         aspect_ratio=:equal,
         background_color=:white)

    # Axes
    hline!([0.0]; color=:black, lw=0.8, label="")
    vline!([0.0]; color=:black, lw=0.8, label="")

    # Target roots
    scatter!([0.0, 0.0], [2.0, -2.0]; color=:green, ms=10, shape=:star5,
             label="roots ±2i")

    # Real axis marker
    hline!([0.0]; color=:gray, lw=0.5, ls=:dash, label="")

    # Path so far
    if frame ≥ 1
        for k in 1:frame
            plot!([real(zs[k]), real(zs[k+1])],
                  [imag(zs[k]), imag(zs[k+1])];
                  color=stepcolor(kinds[k]), lw=1.5, label="")
        end
    end

    # Current point
    z_cur = zs[frame + 1]
    lab = "z$(frame) = $(fmt(real(z_cur))) + $(fmt(imag(z_cur)))i" *
          (frame == 0 ? "" : "  (Stage $(stage2[frame] ? 2 : 1))")
    scatter!([real(z_cur)], [imag(z_cur)]; color=:red, ms=7, label=lab)

    # Starting point marker
    scatter!([real(z0)], [imag(z0)]; color=:black, ms=5, shape=:diamond,
             label="z₀ = 1 (real)")

    plot!(Float64[], Float64[]; color=:steelblue, lw=2, label="plain Newton step")
    plot!(Float64[], Float64[]; color=:orange,    lw=2, label="halved / rotated step")
end

gif(anim, joinpath(@__DIR__, "madsreidac.gif"); fps=2)
println("Saved: madsreidac.gif")
