# madsreidac.jl
# Madsen-Reid Damped Newton: complex roots
# P(z) = z² + 4,  roots at z* = ±2i
# Starting on the real axis, the algorithm detects stagnation and uses
# alterdirection to escape into the complex plane and find the complex root.
# Produces: madsreidac.gif

using Plots, Printf
gr()

# ── Polynomial ────────────────────────────────────────────────────────────────
f(z)  = z^2 + 4
fp(z) = 2z

# ── Madsen-Reid alterdirection (complex) ─────────────────────────────────────
function alterdirection(dz::ComplexF64, m::Float64)::ComplexF64
    x = (real(dz) * 0.6 - imag(dz) * 0.8) * m
    y = (real(dz) * 0.8 + imag(dz) * 0.6) * m
    return complex(x, y)
end

# ── Compute iterates in ℂ ─────────────────────────────────────────────────────
function mr_complex_iterates(f, fp, z0::ComplexF64, r0_init::Float64, n_iters::Int)
    zs     = [z0]
    labels = Symbol[]

    z  = z0
    r0 = r0_init

    for _ in 1:n_iters
        fz   = f(z)
        fpz  = fp(z)
        f_sq = abs2(fz)

        local dz::ComplexF64
        if abs(fpz) < 1e-14 * (1.0 + abs(fz))
            dz = alterdirection(complex(r0 * 0.1, 0.0), 1.0)
        else
            dz = fz / fpz
        end

        r = abs(dz)
        if r > r0
            dz = alterdirection(dz, r0 / r)
        end
        r0 = r * 5.0

        z_new    = z - dz
        fn_sq    = abs2(f(z_new))

        if fn_sq < f_sq
            push!(labels, :newton)
        else
            push!(labels, :damped)
            improved = false
            for _ in 1:4
                dz    = dz * 0.5
                z_new = z - dz
                fn_sq = abs2(f(z_new))
                if fn_sq < f_sq
                    improved = true
                    break
                end
            end
            if !improved
                dz    = alterdirection(dz, 1.0)
                z_new = z - dz
            end
        end

        z = z_new
        push!(zs, z)
        abs(f(z)) < 1e-10 && break
    end
    return zs, labels
end

z0     = complex(1.0, 0.0)
r0_init = 5.0                  # 2.5 * startpoint([1,0,4]) = 2.5 * 2
zs, labels = mr_complex_iterates(f, fp, z0, r0_init, 25)
n_frames = length(zs) - 1

println("Iterates:")
for (i, z) in enumerate(zs)
    @printf("  z_%02d = %8.5f + %8.5fi   |f|² = %.6g\n",
            i-1, real(z), imag(z), abs2(f(z)))
end

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
            col = (k ≤ length(labels) && labels[k] == :damped) ? :orange : :steelblue
            plot!([real(zs[k]), real(zs[k+1])],
                  [imag(zs[k]), imag(zs[k+1])];
                  color=col, lw=1.5, label="")
        end
    end

    # Current point
    z_cur = zs[frame + 1]
    scatter!([real(z_cur)], [imag(z_cur)]; color=:red, ms=7,
             label="z$(frame) = $(round(real(z_cur);digits=3)) + $(round(imag(z_cur);digits=3))i")

    # Starting point marker
    scatter!([real(z0)], [imag(z0)]; color=:black, ms=5, shape=:diamond,
             label="z₀ = 1 (real)")

    plot!(Float64[], Float64[]; color=:steelblue, lw=2, label="Stage 2 – Newton")
    plot!(Float64[], Float64[]; color=:orange,    lw=2, label="Stage 1 – Damped / alterdirection")
end

gif(anim, joinpath(@__DIR__, "madsreidac.gif"); fps=2)
println("Saved: madsreidac.gif")
