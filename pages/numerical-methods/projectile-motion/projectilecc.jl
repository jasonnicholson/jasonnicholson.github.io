# projectilecc.jl
# Projectile Motion animation: the trajectory of a baseball aimed at Willie
# Stargell's 506.5 ft landing point (506.5, 0), under the planar models of
# Mathews' Examples 5-8, all flying at once on one clock:
#   (v)   no drag, x'' = 0, y'' = -32: Mathews' Example 5, cases 1 and 2
#         (Y0 = 3, V = 127 ft/s, theta = 43 and 47 degrees, b = 5.447778, 5.837241);
#   (vi)  linear drag, x'' = -k x', y'' = -k y' - 32, k = 0.25: Example 6, case 1
#         (Y0 = 3, V = 207, theta = 42, b = 6.84889);
#   (vii) quadratic drag, x'' = -k x' s, y'' = -k y' s - 32, s = sqrt(x'^2 + y'^2),
#         k = 0.002: Example 7, case 1, as reconstructed on the page (Mathews'
#         inputs are lost): Y0 = 3, theta = 42, V found here by a root finder so
#         that the ball lands at x = 506.5, b = its landing time;
#   Example 8's wrong model x'' = -k x'^2, y'' = -k y'^2 - 32, k = 0.002, with the
#         initial conditions of the reconstructed case, run to its own landing time.
# Each run is Mathews' RK4 for two second-order equations (his Runge4D) with
# n = 100 steps on [0, b], in double precision. The landing times, the
# reconstructed V and the highest points come from a separate fine-step RK4
# (step 1e-4, events located by bisection on the substep length).
# The lower panel (new) is the speed of each ball.
# Produces: projectilecc.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))
fmt5(x) = x == 0 ? "0" : um(@sprintf("%.5g", Float64(x)))
# Every text with a computed number is printed as it is drawn, for checking
say(s) = (println("  | ", s); s)

# --- Models: state Z = (x, x', y, y') ---
const g = 32.0
Fv(Z)        = (Z[2], 0.0, Z[4], -g)
Fvi(Z)       = (Z[2], -0.25 * Z[2], Z[4], -0.25 * Z[4] - g)
Fvii(Z)      = (s = hypot(Z[2], Z[4]); (Z[2], -0.002 * Z[2] * s, Z[4], -0.002 * Z[4] * s - g))
Fwrong(Z)    = (Z[2], -0.002 * Z[2]^2, Z[4], -0.002 * Z[4]^2 - g)

rkstep(F, Z, s) = begin
    k1 = s .* F(Z); k2 = s .* F(Z .+ k1 ./ 2); k3 = s .* F(Z .+ k2 ./ 2); k4 = s .* F(Z .+ k3)
    Z .+ (k1 .+ 2 .* k2 .+ 2 .* k3 .+ k4) ./ 6
end
Z0(Y0, V, th) = (0.0, V * cos(pi * th / 180), Float64(Y0), V * sin(pi * th / 180))

# Mathews' Runge4D: n = 100 steps on [0, b]
function runge4d(F, Z, b; n=100)
    h = b / n
    T = [j * h for j in 0:n]
    P = [Z]
    for j in 1:n
        Z = rkstep(F, Z, h); push!(P, Z)
    end
    return T, P
end

# Fine-step RK4 with event location: the apex (y' = 0) and the landing (y = 0
# while descending), each found by bisection on the substep length
function fine(F, Z; s=1e-4, tmax=20.0)
    t = 0.0; apex = nothing
    locate(Z, comp) = begin
        lo, hi = 0.0, s
        for _ in 1:60
            mid = (lo + hi) / 2
            rkstep(F, Z, mid)[comp] > 0 ? (lo = mid) : (hi = mid)
        end
        (lo + hi) / 2
    end
    while t < tmax
        Zn = rkstep(F, Z, s)
        if apex === nothing && Zn[4] <= 0
            σ = locate(Z, 4); Za = rkstep(F, Z, σ); apex = (t + σ, Za)
        end
        if apex !== nothing && Zn[3] <= 0
            σ = locate(Z, 3); Zl = rkstep(F, Z, σ)
            return (apex=apex, land=(t + σ, Zl))
        end
        Z = Zn; t += s
    end
    error("no landing before t = $tmax")
end
# state at a given time (fine-step RK4)
function state_at(F, Z, t; s=1e-4)
    m = floor(Int, t / s)
    for _ in 1:m
        Z = rkstep(F, Z, s)
    end
    return rkstep(F, Z, t - m * s)
end

# --- Reconstructed Example 7 case 1: V with landing x = 506.5 (bisection) ---
landx(V) = fine(Fvii, Z0(3, V, 42)).land[2][1]
let lo = 200.0, hi = 215.0
    for _ in 1:50
        mid = (lo + hi) / 2
        landx(mid) < 506.5 ? (lo = mid) : (hi = mid)
    end
    global V7 = (lo + hi) / 2
end
ev7 = fine(Fvii, Z0(3, V7, 42))
b7 = ev7.land[1]
@printf("reconstructed Ex7 case 1: V = %.6f ft/s (%.4f mph), lands t = %.6f at x = %.6f, speed %.4f; apex t = %.5f (%.4f, %.4f)\n",
        V7, V7 * 60 / 88, b7, ev7.land[2][1], hypot(ev7.land[2][2], ev7.land[2][4]), ev7.apex[1],
        ev7.apex[2][1], ev7.apex[2][3])
evw = fine(Fwrong, Z0(3, V7, 42))
bw = evw.land[1]
Zw7 = state_at(Fwrong, Z0(3, V7, 42), b7)
@printf("wrong model: lands t = %.6f at x = %.4f, vy = %.4f, speed %.4f; apex t = %.5f (%.4f, %.4f); at t = b7: (%.4f, %.4f)\n",
        bw, evw.land[2][1], evw.land[2][4], hypot(evw.land[2][2], evw.land[2][4]), evw.apex[1],
        evw.apex[2][1], evw.apex[2][3], Zw7[1], Zw7[3])

green, blue, red = RGB(0, 0.75, 0), RGB(0, 0, 1), RGB(1, 0, 0)
orange = RGB(0.95, 0.5, 0)
runs = [
    (id="(v) 43°", lbl="(v) no drag, 127 ft/s at 43° (Example 5, case 1)", F=Fv, Z=Z0(3, 127, 43), b=5.447778,
     col=green, ls=:solid),
    (id="(v) 47°", lbl="(v) no drag, 127 ft/s at 47° (Example 5, case 2)", F=Fv, Z=Z0(3, 127, 47), b=5.837241,
     col=green, ls=:dash),
    (id="(vi)", lbl="(vi) linear drag k = 0.25, 207 ft/s at 42° (Example 6, case 1)", F=Fvi, Z=Z0(3, 207, 42),
     b=6.84889, col=blue, ls=:solid),
    (id="(vii)", lbl="(vii) quadratic drag k = 0.002, $(fmt5(V7)) ft/s at 42° (Example 7, reconstructed)",
     F=Fvii, Z=Z0(3, V7, 42), b=b7, col=red, ls=:solid),
    (id="Ex. 8", lbl="Example 8's wrong model, same launch as (vii)", F=Fwrong, Z=Z0(3, V7, 42), b=bw,
     col=orange, ls=:dashdot),
]
R = map(runs) do r
    T, P = runge4d(r.F, r.Z, r.b)
    ev = fine(r.F, r.Z)
    X = [p[1] for p in P]; Y = [p[3] for p in P]; S = [hypot(p[2], p[4]) for p in P]
    (r..., T=T, X=X, Y=Y, S=S, tap=ev.apex[1], xap=ev.apex[2][1], yap=ev.apex[2][3],
     tl=ev.land[1], xl=ev.land[2][1])
end
for r in R
    @printf("%-75s RK4 final (%.4f, %.4f) at b = %.6f, final speed %.4f; apex t = %.5f (%.4f, %.4f); fine landing t = %.6f x = %.4f\n",
            r.lbl, r.X[end], r.Y[end], r.b, r.S[end], r.tap, r.xap, r.yap, r.tl, r.xl)
end

# --- Windows and clock ---
xlims = (0.0, 580.0)
ylims = (0.0, 300.0)                         # room above the flights for the legend
slims = (0.0, 220.0)
tend = maximum(r.b for r in R)
n_frames = 70
taus = [tend * j / n_frames for j in 0:n_frames]
title_str = "Projectile Motion II: baseballs aimed at Stargell's 506.5 ft (Examples 5–8), RK4, n = 100 on [0, b]"

visible(r, tau) = [i for i in eachindex(r.T) if r.T[i] <= tau * (1 + 1e-12)]

function draw_frame(j)
    tau = taus[j+1]
    pT = plot(xlims=xlims, ylims=ylims, framestyle=:box, xlabel="x (ft)", ylabel="y (ft)",
              xticks=0:50:550, yticks=0:50:300, legend=:topleft, legendfontsize=8,
              titlefontsize=10, grid=true)
    scatter!(pT, [506.5], [0.0]; marker=:star5, ms=9, color=:gold, msc=:black, msw=0.6,
             label="Stargell's landing point (506.5, 0)")
    for r in R
        idx = visible(r, tau)
        plot!(pT, r.X[idx], r.Y[idx]; color=r.col, lw=2, ls=r.ls, label=say(r.lbl))
        done = idx[end] == length(r.T)
        scatter!(pT, [r.X[idx[end]]], [r.Y[idx[end]]]; color=r.col, ms=done ? 7 : 5,
                 marker=done ? :xcross : :circle, msw=0, label="")
        tau >= r.tap && scatter!(pT, [r.xap], [r.yap]; color=r.col, ms=5, msc=:black, msw=0.6,
                                 label="")
    end
    if tau >= b7
        scatter!(pT, [Zw7[1]], [Zw7[3]]; color=:white, msc=orange, msw=1.5, ms=6,
                 label=say("wrong model at t = $(fmt5(b7)), when (vii) lands: ($(fmt5(Zw7[1])), $(fmt(Zw7[3])))"))
    end
    scatter!(pT, [NaN], [NaN]; color=:white, msc=:black, msw=0.6, ms=5,
             label="highest point (fine-step RK4)")
    scatter!(pT, [NaN], [NaN]; color=:black, marker=:xcross, ms=7, label="end of the run, t = b")
    tops = join(["$(r.id) $(fmt(r.yap))" for r in R if tau >= r.tap], ",  ")
    title!(pT, say("t = $(fmt(tau)) s" * (isempty(tops) ? "" : ";  highest points so far: $(tops) ft")))

    pS = plot(xlims=(0, 7), ylims=slims, framestyle=:box, xlabel="t (s)", ylabel="speed (ft/s)",
              xticks=0:1:7, yticks=0:25:200, legend=:bottomleft, legendfontsize=8,
              titlefontsize=10, grid=true)
    hline!(pS, [sqrt(g / 0.002)]; color=red, ls=:dot, lw=1.2,
           label=say("terminal speed √(g/k) = $(fmt(sqrt(g / 0.002))) of (vii)"))
    for r in R
        idx = visible(r, tau)
        plot!(pS, r.T[idx], r.S[idx]; color=r.col, lw=2, ls=r.ls, label="")
        done = idx[end] == length(r.T)
        scatter!(pS, [r.T[idx[end]]], [r.S[idx[end]]]; color=r.col, ms=done ? 7 : 5,
                 marker=done ? :xcross : :circle, msw=0, label="")
    end
    ends = ["$(r.id) $(fmt(r.S[end]))" for r in R if visible(r, tau)[end] == length(r.T)]
    title!(pS, say("speed √(x′² + y′²)" * (isempty(ends) ? "" :
               ";  at the end of the run: " * join(ends, ",  ") * " ft/s")))

    plot(pT, pS; layout=grid(2, 1, heights=[0.64, 0.36]), size=(1150, 900), plot_title=title_str,
         plot_titlefontsize=12, left_margin=6Plots.mm, bottom_margin=3Plots.mm,
         background_color=:white)
end

anim = Animation()
for j in 0:n_frames
    println("frame j = ", j)
    draw_frame(j)
    frame(anim)
    j == 0 && (frame(anim); frame(anim); frame(anim))      # hold the start
end
for _ in 1:15                                              # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "projectilecc.gif"); fps=8)
println("Saved: projectilecc.gif")
