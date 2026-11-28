# harvestdd.jl
# Harvesting Model animation: sweeping the harvest rate k through the three
# cases for x' = 4x - x^2 - k (a = 4, b = 1, the a and b of Mathews' case (ii)
# example). One frame per k = 0, 0.1, ..., 6: k < 4 is case (ii) (two
# stationary points r1 < r2), k = 4 is case (i) (one double point x = 2), and
# k > 4 is case (iii) (none). k = 0 is the logistic equation and k = 3 is
# Mathews' Examples 9 to 15.
# Left: the exact solutions (formulas (5), (6), (7), evaluated in 256-bit
# arithmetic) for x0 = 0.5, 1, ..., 6 on 0 <= t <= 2, each drawn only up to its
# extinction time t0, where a cross marks x = 0. Blue: survives (tends to r2),
# red: dies out, black: stationary. The band 0 <= x < r1 where populations die
# out is shaded (all of x >= 0 when there is no stationary point).
# Right (new): the rate x' = f(x) = 4x - x^2 - k, drawn sideways so that x is
# on the same vertical axis as on the left, with the phase line x' = 0 and
# arrows showing whether x increases or decreases. A filled dot marks the
# stable stationary point r2, an open dot the unstable r1, a gray diamond
# the double point.
# Produces: harvestdd.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))
kstr(j) = string(j ÷ 10, ".", j % 10)                # k = j/10 exactly, as a decimal

# Drawn position only (horizontal, for the rate panel): lets the parabola visibly
# leave the panel instead of running along its edge.
fdraw(v, fl) = clamp(v, fl[1] - (fl[2] - fl[1]), fl[2] + (fl[2] - fl[1]))

setprecision(BigFloat, 256)
const Q = Rational{BigInt}

# --- Parameters ---
gif_name = "harvestdd.gif"
a, b     = 4, 1
js       = 0:60                                      # k = j/10
x0s      = Q.(1:12) .// 2                            # 0.5, 1, ..., 6
tend     = 2
nt       = 400
tlims    = (0.0, 2.0)
ylims    = (-0.3, 6.5)
flims    = (-8.0, 4.5)                               # rate axis of the right panel
holds    = Dict(0 => 6, 30 => 8, 40 => 8, 60 => 12)  # extra frames at k = 0, 3, 4, 6
title_str = "Harvesting x′ = 4x − x² − k  (a = 4, b = 1):  sweeping the harvest rate k " *
            "from 0 to 6 through cases (ii), (i) and (iii)"

# --- Exact solution with x(0) = x0 for harvest rate k (exact rational k) ---
# Returns (x(t) function, t0 or nothing, fate) with fate :survives, :stationary, :dies
function solution(kq::Q, x0q::Q)
    k, x0 = BigFloat(kq), BigFloat(x0q)
    D = a^2 - 4b * kq                                # exact discriminant
    if D > 0                                         # case (ii), formula (6)
        s = sqrt(BigFloat(D))
        r1, r2 = (a - s) / (2b), (a + s) / (2b)
        if x0 == r1 || x0 == r2
            return (t -> x0, nothing, :stationary)
        end
        q = (x0 - r2) / (x0 - r1)                   # (x - r2)/(x - r1) = q e^(-s t)
        xt = t -> (e = q * exp(-s * t); (r2 - r1 * e) / (1 - e))
        x0 > r1 && return (xt, nothing, :survives)
        t0 = log(r1 * (r2 - x0) / (r2 * (r1 - x0))) / s
        return (xt, t0, :dies)
    elseif D == 0                                    # case (i), formula (5)
        c = BigFloat(a) / (2b)
        x0 == c && return (t -> x0, nothing, :stationary)
        xt1 = t -> c + (x0 - c) / (1 + b * (x0 - c) * t)
        x0 > c && return (xt1, nothing, :survives)
        t0 = 4b * x0 / (a * (a - 2b * x0))
        return (xt1, t0, :dies)
    else                                             # case (iii), formula (7)
        w = sqrt(BigFloat(-D))
        c = atan((2b * x0 - a) / w)
        xt3 = t -> BigFloat(a) / (2b) - w / (2b) * tan(w * t / 2 - c)
        t0 = 2 / w * (atan(a / w) + c)
        return (xt3, t0, :dies)
    end
end

function stationary(kq::Q)
    D = a^2 - 4b * kq
    D > 0 && return ((a - sqrt(BigFloat(D))) / (2b), (a + sqrt(BigFloat(D))) / (2b))
    D == 0 && return (BigFloat(a) / (2b),)
    return ()
end

fatecol = Dict(:survives => :royalblue, :dies => :red, :stationary => :black)

function draw_frame(j; verbose=false)
    kq = Q(j, 10)
    k = Float64(kq)
    D = a^2 - 4b * kq
    st = Float64.(stationary(kq))
    pL = plot(xlims=tlims, ylims=ylims, framestyle=:box, xlabel="t", ylabel="x",
              legend=:topright, legendfontsize=8, titlefontsize=10, grid=true,
              yticks=0:1:6)
    # band where populations die out: 0 <= x < r1 (or a/(2b), or everything)
    top = length(st) == 2 ? st[1] : length(st) == 1 ? st[1] : ylims[2]
    if top > 0
        plot!(pL, Shape([tlims[1], tlims[2], tlims[2], tlims[1]], [0, 0, top, top]);
              color=:mistyrose, linealpha=0, label="x₀ here dies out")
    end
    for (n, r) in enumerate(st)
        hline!(pL, [r]; color=:black, ls=:dash, lw=1,
               label=n == 1 ? (length(st) == 2 ? "stationary r₁, r₂" : "stationary x = a/(2b)") : "")
    end
    hline!(pL, [0.0]; color=:gray40, lw=0.8, label="")
    sols = [(x0, solution(kq, x0)...) for x0 in x0s]
    fates = Set(sol[4] for sol in sols)
    has_x = any(sol[3] !== nothing && sol[3] <= tend for sol in sols)
    # legend entries in a fixed order, for the kinds present in this frame
    :survives in fates && plot!(pL, [NaN], [NaN]; color=fatecol[:survives], lw=1.8,
                                label="survives (→ r₂ or a/(2b))")
    :stationary in fates && plot!(pL, [NaN], [NaN]; color=fatecol[:stationary], lw=1.8,
                                  label="stationary")
    :dies in fates && plot!(pL, [NaN], [NaN]; color=fatecol[:dies], lw=1.8, label="dies out")
    has_x && scatter!(pL, [NaN], [NaN]; color=:black, marker=:xcross, ms=5,
                      label="extinction, x(t₀) = 0")
    lines = String[]
    for (x0, xt, t0, fate) in sols
        tstop = t0 === nothing ? BigFloat(tend) : min(t0, BigFloat(tend))
        ts = [tstop * i / nt for i in 0:nt]
        xs = Float64.(xt.(ts))
        if t0 !== nothing && t0 <= tend
            xs[end] = 0.0                            # x(t0) = 0 exactly
        end
        plot!(pL, Float64.(ts), xs; color=fatecol[fate], lw=1.8, label="")
        if t0 !== nothing && t0 <= tend
            scatter!(pL, [Float64(t0)], [0.0]; color=:black, marker=:xcross, ms=5, label="")
        end
        push!(lines, @sprintf("x0=%s %s t0=%s x(end)=%.10g", fmt(x0), fate,
                              t0 === nothing ? "-" : @sprintf("%.10g", Float64(t0)),
                              Float64(xs[end])))
    end
    verbose && println("k = ", kstr(j), ": ", join(lines, "; "))
    case = D > 0 ? "case (ii): two stationary points r₁ = $(fmt(st[1])), r₂ = $(fmt(st[2]))" :
           D == 0 ? "case (i): one double point x = $(fmt(st[1]))" :
           "case (iii): no stationary point, every population dies out"
    note = j == 0 ? "  (no harvest: the logistic equation)" :
           j == 30 ? "  (Mathews' Examples 9–15)" : ""
    title!(pL, "k = $(kstr(j)):  a² − 4bk = $(fmt(D)),  $(case)$(note)")
    verbose && println("    title: ", "k = $(kstr(j)):  a² − 4bk = $(fmt(D)),  ", case,
                       " | rate title: largest rate $(fmt(a^2 / (4b) - k)) at x = 2",
                       " | stationary: ", join(fmt.(st), ", "))

    # Right: rate panel, x vertical, f(x) horizontal
    pR = plot(xlims=flims, ylims=ylims, framestyle=:box, xlabel="rate  x′ = 4x − x² − k",
              ylabel="x", legend=:topleft, legendfontsize=8, titlefontsize=10, grid=true,
              yticks=0:1:6)
    if top > 0
        plot!(pR, Shape([flims[1], flims[2], flims[2], flims[1]], [0, 0, top, top]);
              color=:mistyrose, linealpha=0, label="")
    end
    xg = range(ylims[1], ylims[2], length=600)
    fx = 4 .* xg .- xg .^ 2 .- k
    vline!(pR, [0.0]; color=:gray40, lw=1, label="")
    plot!(pR, fdraw.(fx, Ref(flims)), xg; color=:darkgreen, lw=2.2, label="x′ = f(x)")
    # phase-line arrows at x = 0.25, 0.75, ..., 6.25 (skipped where f is exactly 0)
    xa = 0.25:0.5:6.25
    fa = 4 .* xa .- xa .^ 2 .- k
    up = xa[fa .> 0]
    dn = xa[fa .< 0]
    isempty(up) || scatter!(pR, zeros(length(up)), up; marker=:utriangle, ms=5,
                            color=:royalblue, msw=0, label="x increases")
    isempty(dn) || scatter!(pR, zeros(length(dn)), dn; marker=:dtriangle, ms=5,
                            color=:red, msw=0, label="x decreases")
    if length(st) == 2
        scatter!(pR, [0.0], [st[2]]; color=:black, ms=6, label="stable r₂ = $(fmt(st[2]))")
        scatter!(pR, [0.0], [st[1]]; color=:white, msc=:black, msw=1.5, ms=6,
                 label="unstable r₁ = $(fmt(st[1]))")
    elseif length(st) == 1
        scatter!(pR, [0.0], [st[1]]; color=:gray55, msc=:black, msw=1.5, ms=7,
                 marker=:diamond, label="double point x = $(fmt(st[1]))")
    end
    title!(pR, "largest rate $(fmt(a^2 / (4b) - k)) at x = 2")

    plot(pL, pR; layout=grid(1, 2, widths=[0.62, 0.38]), size=(1200, 540),
         plot_title=title_str, plot_titlefontsize=12, left_margin=5Plots.mm,
         bottom_margin=5Plots.mm, background_color=:white)
end

anim = Animation()
for j in js
    draw_frame(j; verbose=true)
    frame(anim)
    for _ in 1:get(holds, j, 0)
        frame(anim)
    end
end
gif(anim, joinpath(@__DIR__, gif_name); fps=6)
println("Saved: ", gif_name)
