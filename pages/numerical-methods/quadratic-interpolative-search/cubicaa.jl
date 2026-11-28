# cubicaa.jl
# Cubic Interpolative Search animation: rebuild of Mathews' animation
# (Quadratic and Cubic Search module, Example 4), f(x) = 1/2 + x^5 - 4x/5,
# CubicSearch[0, 1, 7]. His GIF is lost, so the look follows the graphs of his
# Example 4 solution: f in magenta, the two points the step starts from in red,
# the new point in blue. His graphs show only [0, 1]; this window is widened to
# [-0.6, 1.05] because p1 = -0.5 lies outside [0, 1]. Each frame m = 2, ..., 8
# draws the Hermite cubic P that matches f and f' at (p_{m-2}, p_{m-1}) and its
# local minimum p_m. A lower panel zooms on the pair, p_m and p, plotting
# f(x) - f(p) against x - p, so the late steps stay visible. Where a step's
# double-precision F or alpha is rounding noise, the frame says so and the
# cubic is not drawn in the panel where its shape would depend on that noise.
# Produces: cubicaa.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
fmt(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%.4g", x)

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

# Iterate label: enough significant figures to show its distance d from p,
# ceil(-log10(d)) + 1, between 4 and 16; the exact starting point 0 is printed as 0
fmtp(x, d) = x == 0 ? "0" : @sprintf("%#.*g", clamp(ceil(Int, -log10(d)) + 1, 4, 16), x)

# Axis ticks for a range of any size (the default tick search fails near 1e-28)
function nice_ticks(lo, hi)
    s = exp10(floor(log10(max(abs(lo), abs(hi)))))
    t = Plots.PlotUtils.optimize_ticks(lo / s, hi / s; k_min=3, k_max=6)[1] .* s
    t, [v == 0 ? "0" : @sprintf("%.2e", v) for v in t]
end

const SUB = Dict(zip("0123456789", "₀₁₂₃₄₅₆₇₈₉"))
sub(n) = map(c -> SUB[c], string(n))

# --- Parameters ---
# Double-precision f and f' as in the page's tables (Mathematica evaluates
# 4x/5 for a machine number x as 0.8x)
f(x) = 0.5 + x^5 - 0.8x
fp(x) = 5x^4 - 0.8
f_str = "f(x) = 1/2 + x⁵ − 4x/5"
a0, b0 = 0.0, 1.0
mmax = 7                             # CubicSearch[0, 1, 7]: p₂, …, p₈
p_big = sqrt(big(10)) / 5            # exact minimiser: 5p⁴ = 4/5
p_true = Float64(p_big)
fexact(x) = big(1) / 2 + x^5 - 4x / 5
fpexact(x) = 5x^4 - big(4) / 5
fp_big = fexact(p_big)
xlims_full = (-0.6, 1.05)
ylims_full = (0.0, 0.95)
gif_name = "cubicaa.gif"

# --- Mathews' CubicSearch subroutine, line by line ---
P = [a0]                             # P[m+1] = p_m
h0 = 2 * (f(b0) - f(a0)) / fp(a0)
push!(P, P[1] + h0)
steps = NamedTuple[]
let p0 = P[1], p1 = P[2], h = h0, m = 1
    while m <= mmax
        F = f(p1) - f(p0)
        G = h * (fp(p1) - fp(p0))
        α = G - 2 * (F - h * fp(p0))
        disc = (G - 3α)^2 - 12h * α * fp(p0)
        @assert disc > 0
        γ = -2h * fp(p0) / ((G - 3α) + sqrt(disc))
        p2 = p0 + γ * h
        m += 1
        push!(P, p2)
        push!(steps, (m=m, p0=p0, p1=p1, h=h, F=F, G=G, α=α, γ=γ, disc=disc))
        p0, p1 = p1, p2
        h = p1 - p0
    end
end
err(x) = Float64(big(x) - p_big)     # signed error of an iterate, high precision

# Hermite cubic matching (x0, y0, d0) and (x1, y1, d1), and its derivative;
# evaluated in BigFloat from the method's double-precision data
function hermite(x0, x1, y0, y1, d0, d1)
    hh = x1 - x0
    x -> begin
        t = (x - x0) / hh
        (2t^3 - 3t^2 + 1) * y0 + (t^3 - 2t^2 + t) * hh * d0 + (-2t^3 + 3t^2) * y1 + (t^3 - t^2) * hh * d1
    end
end
function hermite_d(x0, x1, y0, y1, d0, d1)
    hh = x1 - x0
    x -> begin
        t = (x - x0) / hh
        ((6t^2 - 6t) * y0 + (-6t^2 + 6t) * y1) / hh + (3t^2 - 4t + 1) * d0 + (3t^2 - 2t) * d1
    end
end
herm_big(x0, x1) = hermite(big(x0), big(x1), big(f(x0)), big(f(x1)), big(fp(x0)), big(fp(x1)))

# Compare each step's F and α with the same quantities computed in high
# precision at the same double-precision points; locate the local minimum of
# the cubic P in high precision (Newton on P') and compare it with p_m
setprecision(BigFloat, 256)
Fnoise = Dict{Int,Bool}(); αnoise = Dict{Int,Bool}(); αhp = Dict{Int,Float64}(); Fhp = Dict{Int,Float64}()
for s in steps
    b0_, b1_ = big(s.p0), big(s.p1)
    hb = b1_ - b0_
    Fb = fexact(b1_) - fexact(b0_)
    Gb = hb * (fpexact(b1_) - fpexact(b0_))
    αb = Gb - 2 * (Fb - hb * fpexact(b0_))
    relF = Float64(abs((s.F - Fb) / Fb))
    relα = Float64(abs((s.α - αb) / αb))
    Fnoise[s.m] = relF > 0.01; αnoise[s.m] = relα > 0.01
    Fhp[s.m] = Float64(Fb); αhp[s.m] = Float64(αb)
    relG = Float64(abs((s.G - Gb) / Gb))
    xs = "-"
    if !Fnoise[s.m]
        d1 = hermite_d(big(s.p0), big(s.p1), big(f(s.p0)), big(f(s.p1)), big(fp(s.p0)), big(fp(s.p1)))
        H = big(s.p1) - big(s.p0)
        d2(x) = (d1(x + H * big(10)^-30) - d1(x - H * big(10)^-30)) / (2H * big(10)^-30)
        x = big(P[s.m+1])
        for _ in 1:60
            x -= d1(x) / d2(x)
        end
        xs = @sprintf("%+.3e (P''>0: %s)", Float64(x - big(P[s.m+1])), d2(x) > 0)
    end
    @printf("m=%d p_m=%.17g p_m-p=%+.4e h=%+.6e F=%+.6e (hp %+.6e, rel %.2g) G=%+.6e (rel %.2g) α=%+.6e (hp %+.6e, rel %.2g) γ=%.10f disc=%.4e  P-min - p_m = %s\n",
            s.m, P[s.m+1], err(P[s.m+1]), s.h, s.F, Float64(Fb), relF, s.G, relG, s.α, Float64(αb), relα, s.γ, s.disc, xs)
end
@printf("p0=%.17g p1=%.17g  h0=%.17g\n", P[1], P[2], h0)

# --- Drawing ---
xplot = range(xlims_full..., length=600)

function tangent!(plt, x, y, s, L; kw...)
    plot!(plt, [x - L, x + L], [y - s * L, y + s * L]; kw...)
end

function draw_frame(m)
    pm = P[m+1]
    dm = abs(err(pm))
    pname = "p" * sub(m)
    if m == 1
        x0, x1 = P[1], NaN
    else
        s = steps[m-1]
        x0, x1 = s.p0, s.p1
    end
    pair = m == 1 ? "" : "p$(sub(m-2)), p$(sub(m-1))"
    drawP_top = m >= 2 && !Fnoise[m] && !αnoise[m]   # whole shape of P meaningful
    drawP_zoom = m >= 2 && !Fnoise[m]                # P near the pair meaningful
    Hb = m >= 2 ? herm_big(x0, x1) : nothing

    # ---------------- Top panel: Mathews' view, widened ----------------
    if m == 1
        line2 = "start: p₀ = a = 0, h₀ = 2(f(1) − f(0))/f′(0) = $(fmt(h0)), p₁ = $(fmt(pm))"
    else
        line2 = "new point $(pname) = $(fmtp(pm, dm)) from the pair ($(pair))"
    end
    p1 = plot(xlims=xlims_full, ylims=ylims_full, xlabel="x", ylabel="y",
              title="Cubic search, m = $(m): $(f_str)\n$(line2)",
              titlefontsize=10, legend=:top, legendfontsize=7, grid=true, framestyle=:box,
              background_color=:white, xticks=-0.6:0.1:1.0, yticks=0:0.1:0.9,
              xformatter=v -> abs(v) < 1e-12 ? "0" : @sprintf("%.1f", v))
    plot!(p1, xplot, f.(xplot); color=:magenta, lw=2, label="y = f(x)")
    vline!(p1, [a0, b0]; color=:gray, ls=:dot, lw=1.5, label="interval [0, 1]")
    vline!(p1, [p_true]; color=:green, ls=:dash, lw=1, label="minimiser p = √10/5 ≈ $(fmt(p_true))")
    if drawP_top
        yP = Float64.(Hb.(big.(collect(xplot))))
        plot!(p1, xplot, ydraw.(yP, Ref(ylims_full)); color=:black, ls=:dash, lw=1.5,
              label="cubic P with f, f′ at the red points")
    end
    if m == 1
        scatter!(p1, [x0], [f(x0)]; color=:red, ms=6, msw=0, label="p₀")
        scatter!(p1, [pm], [f(pm)]; color=:blue, ms=6, msw=0, label="new point p₁")
    else
        L = 0.06
        tangent!(p1, x0, f(x0), fp(x0), L; color=:darkred, lw=2.5, label="slopes f′ at the red points")
        tangent!(p1, x1, f(x1), fp(x1), L; color=:darkred, lw=2.5, label="")
        scatter!(p1, [x0, x1], f.([x0, x1]); color=:red, ms=6, msw=0, label=pair)
        drawP_top && scatter!(p1, [pm], [Float64(Hb(big(pm)))]; color=:white, msc=:black,
                              msw=1.5, ms=6, label="local minimum of P")
        scatter!(p1, [pm], [f(pm)]; color=:blue, ms=6, msw=0, label="new point $(pname) on f")
    end

    # ---------------- Bottom panel: zoom, f(x) − f(p) against x − p ----------------
    pts = m == 1 ? [x0, pm] : [x0, x1, pm]
    offs = [err.(pts); 0.0]
    lo, hi = extrema(offs)
    w = hi - lo
    zx = (lo - 0.08w, hi + 0.08w)
    xo = collect(range(zx[1], zx[2], length=400))
    xb = p_big .+ big.(xo)                    # the points in high precision
    gz = Float64.(fexact.(xb) .- fp_big)
    ylo, yhi = 0.0, maximum(gz)
    if drawP_zoom
        qz = Float64.(Hb.(xb) .- fp_big)
        ylo = min(ylo, Float64(Hb(big(pm)) - fp_big))
    end
    pad = 0.08 * (yhi - ylo)
    zy = (ylo - pad, yhi + 1.5pad)
    gzp(x) = Float64(fexact(big(x)) - fp_big)
    if m == 1
        zt = "p₁ = p₀ + h₀ = $(fmt(pm)), outside [0, 1]\n" *
             "p₀ − p = $(fmt(err(x0))), p₁ − p = $(fmt(err(pm)))"
    else
        s = steps[m-1]
        γs = @sprintf("%.8f", s.γ)
        if Fnoise[m]
            @assert s.F == 0             # the only noisy F in this run
            zt = "F = 0: f(p$(sub(m-2))) and f(p$(sub(m-1))) round to the same double\n" *
                 "(high precision: F = $(fmt(Fhp[m]))), so α = $(fmt(s.α)) and\n" *
                 "γ = $(γs) are rounding noise; no cubic drawn\n" *
                 "$(pname) − p = $(fmt(err(pm)))"
        elseif αnoise[m]
            zt = "F = $(fmt(s.F)), G = $(fmt(s.G)), γ = $(γs)\n" *
                 "α = $(fmt(s.α)) is rounding noise (high precision: $(fmt(αhp[m]))),\n" *
                 "so P is drawn only in this zoom; $(pname) − p = $(fmt(err(pm)))"
        else
            zt = "F = $(fmt(s.F)), G = $(fmt(s.G)), α = $(fmt(s.α)), γ = $(γs)\n" *
                 "$(pname) − p = $(fmt(err(pm)))"
        end
    end
    xt = nice_ticks(zx...); yt = nice_ticks(zy...)
    p2 = plot(xlims=zx, ylims=zy, xlabel="x − p", ylabel="f(x) − f(p)",
              title=zt, titlefontsize=10, legend=false, grid=true,
              framestyle=:box, background_color=:white, xticks=xt, yticks=yt)
    plot!(p2, xo, gz; color=:magenta, lw=2)
    vline!(p2, [0.0]; color=:green, ls=:dash, lw=1)
    drawP_zoom && plot!(p2, xo, ydraw.(qz, Ref(zy)); color=:black, ls=:dash, lw=1.5)
    if m == 1
        scatter!(p2, [err(x0)], [gzp(x0)]; color=:red, ms=6, msw=0)
    else
        L = 0.06 * (zx[2] - zx[1])
        for x in (x0, x1)
            tangent!(p2, err(x), gzp(x), Float64(fpexact(big(x))), L; color=:darkred, lw=2.5)
        end
        scatter!(p2, err.([x0, x1]), gzp.([x0, x1]); color=:red, ms=6, msw=0)
        drawP_zoom && scatter!(p2, [err(pm)], [Float64(Hb(big(pm)) - fp_big)]; color=:white,
                               msc=:black, msw=1.5, ms=6)
    end
    scatter!(p2, [err(pm)], [gzp(pm)]; color=:blue, ms=6, msw=0)

    plot(p1, p2; layout=grid(2, 1, heights=[0.55, 0.45]), size=(640, 900),
         left_margin=8Plots.mm, right_margin=4Plots.mm)
end

M = mmax + 1
frames = [collect(1:M); fill(M, 2)]      # hold the last frame
anim = @animate for m in frames
    draw_frame(m)
end

gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: ", gif_name)
