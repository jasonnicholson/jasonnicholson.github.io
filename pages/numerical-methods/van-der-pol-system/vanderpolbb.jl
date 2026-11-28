# vanderpolbb.jl
# van der Pol System animation: Mathews' Examples 2 to 5, mu = 1/16, 1/4, 1/2
# and 1, the system x' = y, y' = -x + mu (1 - x^2) y, solved with the
# fourth-order Runge-Kutta method in vector form over 0 <= t <= 60 with
# n = 6000 steps (h = 0.01). Mathews' interval, start and plots for these
# examples are lost; the page keeps Example 1's start (0, 3), outside every
# one of these cycles, and adds a run from (0, 0.5), inside them.
# One panel per example, all four advancing together, 0.25 time units per
# frame. Each panel shows both runs, the limit cycle (computed separately) and
# the located maxima of x, where a path crosses the positive x-axis.
# Produces: vanderpolbb.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))
fmtn(x, n) = x == 0 ? "0" : um(@sprintf("%#.*g", n, x))

Fmu(mu) = z -> [z[2], -z[1] + mu * (1 - z[1]^2) * z[2]]

# One step of the Runge-Kutta method of order 4, formula (5), of size s
function rkstep(F, z, s)
    K1 = s * F(z)
    K2 = s * F(z + K1 / 2)
    K3 = s * F(z + K2 / 2)
    K4 = s * F(z + K3)
    return z + (K1 + 2K2 + 2K3 + K4) / 6
end

# Runge2D: n steps of size h = (b - a)/n from z0; returns Z_0, ..., Z_n
function rk4(F, a, b, z0, n)
    h = (b - a) / n
    Z = [copy(z0)]
    for j in 1:n
        push!(Z, rkstep(F, Z[end], h))
    end
    return Z
end

# Maxima of x on a computed run: the path crosses y = 0 downwards (x > 0)
# between Z_j and Z_{j+1}; the crossing is located by bisection on the size
# of one Runge-Kutta step from Z_j.
function maxima(F, Z, a, h)
    out = Tuple{Float64,Float64}[]               # (t, x)
    for j in 1:length(Z)-1
        if Z[j][2] > 0 && Z[j+1][2] <= 0
            lo, hi = 0.0, h
            for _ in 1:60
                mid = (lo + hi) / 2
                rkstep(F, Z[j], mid)[2] > 0 ? (lo = mid) : (hi = mid)
            end
            s = (lo + hi) / 2
            push!(out, (a + (j - 1) * h + s, rkstep(F, Z[j], s)[1]))
        end
    end
    return out
end

# Limit cycle: Runge-Kutta with h = 1e-3 from (2, 0) for 200 time units, then
# two successive maxima of x located as above; their distance in time is the
# period P. One period is then sampled from the located maximum with the
# divergence mu (1 - x^2) integrated alongside, which gives the factor
# rho = exp(integral) by which a nearby gap shrinks per turn.
function limit_cycle(mu)
    F = Fmu(mu)
    hc = 1e-3
    Z = rk4(F, 0.0, 200.0, [2.0, 0.0], 200_000)
    Z2 = rk4(F, 0.0, 15.0, Z[end], 15_000)
    mx = maxima(F, Z2, 0.0, hc)
    P = mx[2][1] - mx[1][1]
    xmax = mx[2][2]
    z = [xmax, 0.0, 0.0]
    G(w) = [w[2], -w[1] + mu * (1 - w[1]^2) * w[2], mu * (1 - w[1]^2)]
    N = 20_000
    cx = [z[1]]; cy = [z[2]]
    for _ in 1:N
        z = rkstep(G, z, P / N)
        push!(cx, z[1]); push!(cy, z[2])
    end
    return (P=P, xmax=xmax, rho=exp(z[3]), cx=cx, cy=cy, closure=hypot(z[1] - xmax, z[2]))
end

# --- Examples 2 to 5 ---
mus   = [1 / 16, 1 / 4, 1 / 2, 1.0]
mustr = ["1/16", "1/4", "1/2", "1"]
exno  = [2, 3, 4, 5]
a, b, n = 0.0, 60.0, 6000
h = (b - a) / n
ts = [a + j * h for j in 0:n]
zout, zin = [0.0, 3.0], [0.0, 0.5]

cases = map(eachindex(mus)) do i
    F = Fmu(mus[i])
    Zo = rk4(F, a, b, zout, n)
    Zi = rk4(F, a, b, zin, n)
    mo = maxima(F, Zo, a, h)
    mi = maxima(F, Zi, a, h)
    cyc = limit_cycle(mus[i])
    @printf("mu = %s: cycle P = %.7f, max x = %.7f, rho = %.6e, closure %.1e\n",
            mustr[i], cyc.P, cyc.xmax, cyc.rho, cyc.closure)
    println("   outside maxima t: ", join([@sprintf("%.3f", m[1]) for m in mo], ", "))
    println("   outside maxima x: ", join([@sprintf("%.9f", m[2]) for m in mo], ", "))
    println("   inside  maxima t: ", join([@sprintf("%.3f", m[1]) for m in mi], ", "))
    println("   inside  maxima x: ", join([@sprintf("%.9f", m[2]) for m in mi], ", "))
    @printf("   end points: outside (%.6f, %.6f), inside (%.6f, %.6f)\n",
            Zo[end]..., Zi[end]...)
    (mu=mus[i], s=mustr[i], ex=exno[i], xo=first.(Zo), yo=last.(Zo), xi=first.(Zi),
     yi=last.(Zi), mo=mo, mi=mi, cyc=cyc)
end

# --- Drawing ---
cO, cI = :magenta, :dodgerblue
lim = (-3.7, 3.7)
digits = 7                       # maxima shown to 7 significant figures

function panel(c, j)
    t = ts[j+1]
    p = plot(xlims=lim, ylims=lim, aspect_ratio=:equal, framestyle=:box, xticks=-3:3,
             yticks=-3:3, xlabel="x", ylabel="y = x′", grid=true, legend=false,
             titlefontsize=9, guidefontsize=9)
    hline!(p, [0]; color=:black, lw=0.6)
    vline!(p, [0]; color=:black, lw=0.6)
    plot!(p, c.xo[1:j+1], c.yo[1:j+1]; color=cO, lw=1.3)
    plot!(p, c.xi[1:j+1], c.yi[1:j+1]; color=cI, lw=1.3)
    plot!(p, c.cyc.cx, c.cyc.cy; color=:black, ls=:dash, lw=1.2)
    ko = count(m -> m[1] <= t, c.mo)
    ki = count(m -> m[1] <= t, c.mi)
    ko > 0 && scatter!(p, [m[2] for m in c.mo[1:ko]], zeros(ko); color=cO, marker=:diamond,
                       ms=4, markerstrokecolor=:black, markerstrokewidth=0.5)
    ki > 0 && scatter!(p, [m[2] for m in c.mi[1:ki]], zeros(ki); color=cI, marker=:diamond,
                       ms=4, markerstrokecolor=:black, markerstrokewidth=0.5)
    scatter!(p, [c.xo[j+1]], [c.yo[j+1]]; color=cO, ms=5)
    scatter!(p, [c.xi[j+1]], [c.yi[j+1]]; color=cI, ms=5)
    lo = ko == 0 ? "none yet" : "no. $ko = $(fmtn(c.mo[ko][2], digits))"
    li = ki == 0 ? "none yet" : "no. $ki = $(fmtn(c.mi[ki][2], digits))"
    title!(p, "Example $(c.ex), μ = $(c.s):  cycle max x = $(fmtn(c.cyc.xmax, digits)),  " *
              "ρ = $(fmtn(c.cyc.rho, 4))\nlatest max of x:  outside $lo,  inside $li")
    return p
end

# Legend row (a plot with no axes, holding only the legend entries)
function legend_panel()
    p = plot(framestyle=:none, grid=false, showaxis=false, xlims=(0, 1), ylims=(0, 1),
             legend=:inside, legend_columns=2, legendfontsize=9, foreground_color_legend=nothing)
    plot!(p, [NaN], [NaN]; color=cO, lw=2, label="Runge-Kutta from (0, 3), outside the cycle")
    plot!(p, [NaN], [NaN]; color=cI, lw=2, label="Runge-Kutta from (0, 0.5), inside the cycle")
    plot!(p, [NaN], [NaN]; color=:black, ls=:dash, lw=1.2, label="limit cycle")
    scatter!(p, [NaN], [NaN]; color=:gray70, marker=:diamond, ms=5, markerstrokecolor=:black,
             label="maxima of x (path crosses y = 0, x > 0)")
    return p
end
legp = legend_panel()

function draw_frame(j)
    t = ts[j+1]
    ps = [panel(c, j) for c in cases]
    l = @layout [grid(2, 2); a{0.07h}]
    plot(ps..., legp; layout=l, size=(1060, 1100),
         plot_title="van der Pol, Examples 2 to 5:  x′ = y,  y′ = −x + μ(1 − x²) y,  " *
                    "Runge-Kutta, h = 0.01:   t = $(@sprintf("%.2f", t))",
         plot_titlefontsize=11, left_margin=3Plots.mm, background_color=:white)
end

anim = Animation()
for j in 0:25:n
    draw_frame(j)
    frame(anim)
end
for _ in 1:35                                          # hold the last frame about 3 s
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "vanderpolbb.gif"); fps=12)
println("Saved: vanderpolbb.gif")
