# lorenzbb.jl
# Lorenz Attractor animation: Example 2's interval [0, 50] and sensitive
# dependence on the initial values.
# x' = σ(y − x), y' = r x − y − x z, z' = x y − b z with σ = 10, r = 28, b = 8/3.
# Two true solutions, from A = (10, −10, 20) (Example 1's start) and from
# A' = (10 + 10⁻¹⁰, −10, 20), both computed by a Taylor series method of order
# 30 with step 0.01 in 200-bit (about 60-digit) BigFloat arithmetic, so that
# what separates them is the change in the initial value, not numerical error.
# 0.25 time units per frame.
# Left: projection on the xy-plane (Mathews plots this projection in Example 2),
# the whole path faint and the last 1.5 time units bold.
# Top right: x(t) of both (Mathews plots x(t) in Example 2).
# Bottom right: the distance between the two solutions on a log scale, with the
# line 10⁻¹⁰ e^(0.90 t) (growth at the largest Lyapunov exponent, about 0.90).
# Produces: lorenzbb.gif

using Plots
using Printf
gr()

um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", x))      # significant figures
fmt3(x) = um(@sprintf("%#.3g", x))
fmtt(t) = um(@sprintf("%.2f", t))                     # times on the grid 0.01 j

# --- Two solutions in BigFloat, integrated side by side ---
setprecision(BigFloat, 200)
function taylor_lorenz(σ, r, b, u0, hT, nsteps; N=30)
    T = BigFloat
    X = zeros(T, N + 1); Y = zeros(T, N + 1); Zc = zeros(T, N + 1)
    u = copy(u0)
    out = Vector{Vector{BigFloat}}(undef, nsteps + 1); out[1] = copy(u)
    for n in 1:nsteps
        X[1], Y[1], Zc[1] = u
        for k in 0:N-1                    # Taylor coefficients from the equations
            xz = zero(T); xy = zero(T)
            for i in 0:k
                xz += X[i+1] * Zc[k-i+1]; xy += X[i+1] * Y[k-i+1]
            end
            X[k+2] = σ * (Y[k+1] - X[k+1]) / (k + 1)
            Y[k+2] = (r * X[k+1] - Y[k+1] - xz) / (k + 1)
            Zc[k+2] = (xy - b * Zc[k+1]) / (k + 1)
        end
        u = [evalpoly(hT, X), evalpoly(hT, Y), evalpoly(hT, Zc)]
        out[n+1] = u
    end
    return out
end

σ, r, b = BigFloat(10), BigFloat(28), BigFloat(8) / 3
δ = BigFloat(10)^-10
A  = BigFloat[10, -10, 20]
A2 = BigFloat[10, -10, 20] + [δ, 0, 0]
hT, nsteps = BigFloat(1) / 100, 5000                  # [0, 50]
SA = taylor_lorenz(σ, r, b, A, hT, nsteps)
SB = taylor_lorenz(σ, r, b, A2, hT, nsteps)
t = [0.01 * j for j in 0:nsteps]
ZA = reduce(vcat, (Float64.(u)' for u in SA))
ZB = reduce(vcat, (Float64.(u)' for u in SB))
d = [Float64(sqrt(sum((SA[j] - SB[j]) .^ 2))) for j in 1:nsteps+1]   # in BigFloat

λ = 0.90
jc = [findfirst(>(c), d) for c in (1e-8, 1e-6, 1e-4, 1e-2, 1.0)]
for (c, j) in zip((1e-8, 1e-6, 1e-4, 1e-2, 1.0), jc)
    @printf("first t with distance > %g: %.2f\n", c, t[j])
end
j1 = jc[end]; t1 = t[j1]
@printf("distance at t = 10, 20, 30, 40, 50: %s\n",
        join((@sprintf("%.4g", d[round(Int, 100tt)+1]) for tt in 10:10:50), ", "))
@printf("max distance on [0, 50]: %.4g at t = %.2f; min on [t1, 50]: %.4g\n",
        maximum(d), t[argmax(d)], minimum(d[j1:end]))
@printf("A at t = 50: (%.6f, %.6f, %.6f)\n", ZA[end, :]...)
@printf("A' at t = 50: (%.6f, %.6f, %.6f)\n", ZB[end, :]...)
signchanges(x) = count(i -> sign(x[i]) != sign(x[i+1]) && x[i] != 0, 1:length(x)-1)
@printf("x sign changes on [0, 50]: A %d, A' %d\n", signchanges(ZA[:, 1]), signchanges(ZB[:, 1]))
for (k, nm) in enumerate(("x", "y", "z"))
    @printf("%s range: A [%.3f, %.3f], A' [%.3f, %.3f]\n", nm,
            extrema(ZA[:, k])..., extrema(ZB[:, k])...)
end
# fitted growth rate of log(distance) on [2, t1] (least squares)
let jj = 201:j1, tt = t[jj], yy = log.(d[jj])
    tm, ym = sum(tt) / length(tt), sum(yy) / length(yy)
    @printf("least-squares slope of ln(distance) on [2, %.2f]: %.4f\n", t1,
            sum((tt .- tm) .* (yy .- ym)) / sum((tt .- tm) .^ 2))
end

# --- Drawing ---
cA, cB = :navy, :crimson
xl, yl = (-20, 20), (-27, 27)
dl = (1e-11, 1e2)
q = 6 * sqrt(2)
trail = 150                                           # 1.5 time units in bold
step = 25                                             # 0.25 time units per frame
title_str = "Lorenz system, Example 2 (σ = 10, r = 28, b = 8/3, 0 ≤ t ≤ 50):  " *
            "true solutions from  A = (10, −10, 20)  and  A′ = A + (10⁻¹⁰, 0, 0)"

function draw_frame(j)
    tj = t[j]
    k0 = max(1, j - trail)
    pP = plot(xlims=xl, ylims=yl, framestyle=:box, xlabel="x", ylabel="y", grid=true,
              legend=:topleft, legendfontsize=7, titlefontsize=10)
    plot!(pP, ZA[1:j, 1], ZA[1:j, 2]; color=cA, lw=0.6, alpha=0.25, label="")
    plot!(pP, ZB[1:j, 1], ZB[1:j, 2]; color=cB, lw=0.6, alpha=0.25, label="")
    plot!(pP, ZA[k0:j, 1], ZA[k0:j, 2]; color=cA, lw=2.4, label="from A")
    plot!(pP, ZB[k0:j, 1], ZB[k0:j, 2]; color=cB, lw=1.2, label="from A′")
    scatter!(pP, [q, -q], [q, -q]; color=:black, ms=3, markerstrokewidth=0,
             label="C₊, C₋ (projected)")
    scatter!(pP, [ZA[j, 1]], [ZA[j, 2]]; color=cA, ms=6, markerstrokewidth=0, label="")
    scatter!(pP, [ZB[j, 1]], [ZB[j, 2]]; color=cB, ms=4, markerstrokewidth=0, label="")
    title!(pP, "xy-projection at t = $(fmtt(tj))  (bold: last 1.5 time units)")

    px = plot(xlims=(0, 50), ylims=(-20, 20), framestyle=:box, xlabel="t", ylabel="x",
              grid=true, legend=false, titlefontsize=10)
    plot!(px, t[1:j], ZA[1:j, 1]; color=cA, lw=1.8)
    plot!(px, t[1:j], ZB[1:j, 1]; color=cB, lw=0.9)
    title!(px, "x(t):  from A $(fmt(ZA[j,1])),   from A′ $(fmt(ZB[j,1]))")

    pd = plot(xlims=(0, 50), ylims=dl, yscale=:log10, framestyle=:box, xlabel="t",
              ylabel="distance", grid=true, legend=:bottomright, legendfontsize=7,
              titlefontsize=10, yticks=10.0 .^ (-11:2:1))
    plot!(pd, [0, 50], 1e-10 .* exp.(λ .* [0, 50]); color=:gray50, ls=:dash, lw=1,
          label="10⁻¹⁰·exp(0.90 t)")
    hline!(pd, [1.0]; color=:gray70, ls=:dot, lw=1, label="")
    plot!(pd, t[1:j], d[1:j]; color=:black, lw=1.4, label="distance between the two")
    if j >= j1
        scatter!(pd, [t1], [d[j1]]; color=:red, ms=5, markerstrokewidth=0,
                 label="first > 1 at t = $(fmtt(t1))")
    end
    title!(pd, "distance at t = $(fmtt(tj)):  $(fmt3(d[j]))")

    l = @layout [a{0.46w} [b; c]]
    plot(pP, px, pd; layout=l, size=(1200, 640), plot_title=title_str,
         plot_titlefontsize=11, left_margin=4Plots.mm, bottom_margin=4Plots.mm,
         background_color=:white)
end

anim = Animation()
for k in 0:div(nsteps, step)
    draw_frame(1 + step * k)
    frame(anim)
end
for _ in 1:30                              # hold the last frame 3 s
    frame(anim)
end
gif(anim, joinpath(@__DIR__, "lorenzbb.gif"); fps=10)
println("Saved: lorenzbb.gif")
