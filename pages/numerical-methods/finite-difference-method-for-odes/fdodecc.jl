# fdodecc.jl
# Finite Difference Method for ODE's animation: orders of convergence of the
# finite-difference solution and of its Richardson extrapolation, for Mathews'
# boundary value problem
#     x'' + x'/t + (1 - 1/(4t^2)) x = sqrt(t) cos t,  x(1) = 1,  x(6) = -0.5.
# The page's h-halving table: n = 25, 50, 100, 200, 400. One frame per n. Left:
# the error of the finite-difference solution X_n at its interior mesh points,
# and the error of the extrapolation (4 X_n - X_{n/2})/3 at the interior points
# of the coarser mesh, on a log scale; earlier n in gray. Right: the largest
# errors against h on log-log axes, with reference lines of slope 2 and 4.
# Everything here is new; Mathews stops at n = 50.
# The tridiagonal systems are solved and the exact solution evaluated in
# 256-bit floating point; the plots use Float64 copies.
# Produces: fdodecc.gif

using Plots
using Printf
using LinearAlgebra
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))      # exact values
fmtv(x) = um(@sprintf("%#.4g", Float64(x)))                    # computed: 4 s.f.

# --- The boundary value problem (Mathews' Examples 1-6) ---
setprecision(BigFloat, 256)
const B = BigFloat
p(t) = -1 / t
q(t) = 1 / (4t^2) - 1
r(t) = sqrt(t) * cos(t)
a, b, α, β = B(1), B(6), B(1), B(-1) / 2

# Exact solution, formula (8): x = (c1 cos t + c2 sin t)/sqrt(t) + sqrt(t) cos t/4 + t^(3/2) sin t/4
xpart(t) = sqrt(t) * cos(t) / 4 + t^(B(3) / 2) * sin(t) / 4
Mc = [cos(a)/sqrt(a) sin(a)/sqrt(a); cos(b)/sqrt(b) sin(b)/sqrt(b)]
c1, c2 = Mc \ [α - xpart(a); β - xpart(b)]
xexact(t) = (c1 * cos(t) + c2 * sin(t)) / sqrt(t) + xpart(t)
@assert abs(c1 - B("0.0588713451552886")) < 1e-15 && abs(c2 - B("0.740071095780206")) < 1e-15

# Finite-difference solution, equations (5)-(6): returns mesh and x_0, ..., x_n
function fdsolve(n)
    h = (b - a) / n
    t = [a + j * h for j in 0:n]
    ti = t[2:n]                                   # interior points t_1, ..., t_{n-1}
    sub = [-h / 2 * p(s) - 1 for s in ti]         # a_j
    dia = [2 + h^2 * q(s) for s in ti]            # d_j
    sup = [h / 2 * p(s) - 1 for s in ti]          # c_j
    rhs = [-h^2 * r(s) for s in ti]               # e_j
    rhs[1] -= sub[1] * α
    rhs[end] -= sup[end] * β
    x = Tridiagonal(sub[2:end], dia, sup[1:end-1]) \ rhs
    return t, vcat(α, x, β)
end

# --- Parameters ---
gif_name = "fdodecc.gif"
ns    = [25, 50, 100, 200, 400]
tlims = (1.0, 6.0)
elims = (1e-11, 1e-1)              # left panel (log scale)
hlims = (0.01, 0.25)               # right panel, h on a log scale
mlims = (1e-10, 1e-1)
title_str = "Orders of convergence for Mathews' problem, n = 25 to 400:  finite differences Xₙ and their extrapolation from n/2 and n"

# --- Compute ---
hs   = [(b - a) / n for n in ns]
sols = [fdsolve(n) for n in ns]
errs = [x .- xexact.(t) for (t, x) in sols]
maxE = [maximum(abs.(e)) for e in errs]
# Extrapolation from (n/2, n), at the points of the n/2 mesh (every other point)
rich = Vector{Any}(undef, length(ns))
maxR = fill(B(NaN), length(ns))
for k in 2:length(ns)
    tc, Xc = sols[k-1]
    tf, Xf = sols[k]
    @assert all(tf[1:2:end] .== tc)
    R = (4 .* Xf[1:2:end] .- Xc) ./ 3
    rich[k] = (tc, R .- xexact.(tc))
    maxR[k] = maximum(abs.(rich[k][2]))
end
# Checks against the page's h-halving table and its extrapolation sentence
for (k, v) in enumerate(["1.4638e-2", "3.6531e-3", "9.1193e-4", "2.2800e-4", "5.6994e-5"])
    @assert abs(maxE[k] / B(v) - 1) < 1e-4
end
for (k, v) in zip(2:4, ["2.869e-5", "1.788e-6", "1.115e-7"])
    @assert abs(maxR[k] / B(v) - 1) < 1e-3
end
for k in eachindex(ns)
    @printf("n = %3d  h = %-7s max|X_n - x| = %s", ns[k], fmt(hs[k]), fmtv(maxE[k]))
    k > 1 && @printf("  ratio %s   extrapolated (%d,%d): %s", fmtv(maxE[k] / maxE[k-1]),
                     ns[k-1], ns[k], fmtv(maxR[k]))
    k > 2 && @printf("  ratio %s", fmtv(maxR[k] / maxR[k-1]))
    println()
end
for k in 2:length(ns)
    @printf("  smallest |R - x| at interior coarse points, pair %d: %s\n", ns[k],
            fmtv(minimum(abs.(rich[k][2][2:end-1]))))
    @printf("  smallest |X - x| at interior points, n = %d: %s\n", ns[k],
            fmtv(minimum(abs.(errs[k][2:end-1]))))
end

inner(v) = v[2:end-1]              # the error is exactly zero at t = 1 and 6
# Log panels, drawn position only: a value below the panel is drawn one decade
# below the bottom edge, so the curve visibly leaves the panel there.
logdraw(e) = max(Float64(abs(e)), elims[1] / 10)
hsf = Float64.(hs)
# Reference lines through the first point of each kind
ref2(h) = Float64(maxE[1]) * (h / hsf[1])^2
ref4(h) = Float64(maxR[2]) * (h / hsf[2])^4
hgrid = 10.0 .^ range(log10(hlims[1]), log10(hlims[2]), length=50)
sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))

function draw_frame(k)
    n = ns[k]
    pL = plot(xlims=tlims, ylims=elims, yscale=:log10, framestyle=:box, xlabel="t",
              ylabel="size of the error, interior points", legend=:bottomright,
              legendfontsize=8, titlefontsize=10, grid=true, yticks=10.0 .^ (-11:-1))
    for j in 1:k-1
        plot!(pL, inner(Float64.(sols[j][1])), logdraw.(inner(errs[j])); color=:lightsteelblue,
              lw=1, label=j == 1 ? "earlier Xₙ" : "")
        j >= 2 && plot!(pL, inner(Float64.(rich[j][1])), logdraw.(inner(rich[j][2]));
                        color=:pink, lw=1, label=j == 2 ? "earlier extrapolations" : "")
    end
    plot!(pL, inner(Float64.(sols[k][1])), logdraw.(inner(errs[k])); color=:royalblue,
          lw=2, label="|X$(sub(n)) − x|  (n = $n)")
    if k >= 2
        plot!(pL, inner(Float64.(rich[k][1])), logdraw.(inner(rich[k][2])); color=:red,
              lw=2, label="|(4X$(sub(n)) − X$(sub(ns[k-1])))/3 − x|")
    end
    title!(pL, k == 1 ? "n = $n,  h = $(fmt(hs[k])):  no extrapolation yet" :
                        "n = $n,  h = $(fmt(hs[k])):  extrapolated from n = $(ns[k-1]) and $n")

    pR = plot(xlims=hlims, ylims=mlims, xscale=:log10, yscale=:log10, framestyle=:box,
              xlabel="h  (finest mesh used)", ylabel="largest error", legend=:bottomright,
              legendfontsize=8, titlefontsize=10, grid=true, yticks=10.0 .^ (-10:-1),
              xticks=([0.0125, 0.025, 0.05, 0.1, 0.2], ["0.0125", "0.025", "0.05", "0.1", "0.2"]))
    plot!(pR, hgrid, ref2.(hgrid); color=:royalblue, ls=:dash, lw=1, alpha=0.6,
          label="slope 2 (error ∝ h²)")
    plot!(pR, hgrid, ref4.(hgrid); color=:red, ls=:dash, lw=1, alpha=0.6,
          label="slope 4 (error ∝ h⁴)")
    plot!(pR, hsf[1:k], Float64.(maxE[1:k]); color=:royalblue, lw=2, marker=:circle,
          ms=5, markerstrokewidth=0, label="finite differences Xₙ")
    if k >= 2
        plot!(pR, hsf[2:k], Float64.(maxR[2:k]); color=:red, lw=2, marker=:square,
              ms=5, markerstrokewidth=0, label="extrapolation from n/2 and n")
    end
    # Ratios in parentheses: this largest error divided by the one for the previous n
    ttl = "largest error of X$(sub(n)):  $(fmtv(maxE[k]))"
    k >= 2 && (ttl *= "  (× $(fmtv(maxE[k] / maxE[k-1])))")
    ttl *= k >= 2 ? "\nof the extrapolation:  $(fmtv(maxR[k]))" : "\n "
    k >= 3 && (ttl *= "  (× $(fmtv(maxR[k] / maxR[k-1])))")
    title!(pR, ttl)

    plot(pL, pR; layout=(1, 2), size=(1150, 520), plot_title=title_str,
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         top_margin=2Plots.mm, background_color=:white)
end

anim = Animation()
for k in eachindex(ns)
    draw_frame(k)
    frame(anim)
    frame(anim)                                      # two seconds per frame
end
frame(anim)                                          # hold the last frame (3 s)
gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: ", gif_name)
