# fdodeaa.jl
# Finite Difference Method for ODE's animation: refining the grid for Mathews'
# boundary value problem
#     x'' + x'/t + (1 - 1/(4t^2)) x = sqrt(t) cos t,  x(1) = 1,  x(6) = -0.5,
# i.e. x'' = p x' + q x + r with p = -1/t, q = 1/(4t^2) - 1, r = sqrt(t) cos t.
# One frame per number of subintervals n = 5, 10, 25, 50, 100, 200, 400
# (25 and 50 are Mathews' Examples 2 and 3). Left: the finite-difference
# solution against the exact solution, on the t-range of Mathews' graphs,
# with the exact solution magenta as in his graphs. Right (new): the error
# |x_j - x(t_j)| at the interior mesh points on a log scale, earlier n in gray.
# The tridiagonal systems are solved and the exact solution evaluated in
# 256-bit floating point; the plots use Float64 copies.
# Produces: fdodeaa.gif

using Plots
using Printf
using LinearAlgebra
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))      # exact values
fmtv(x) = um(@sprintf("%#.4g", Float64(x)))                    # computed: 4 s.f.

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

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
gif_name = "fdodeaa.gif"
ns    = [5, 10, 25, 50, 100, 200, 400]
tlims = (1.0, 6.0)                 # Mathews' graphs: 1 <= t <= 6
xlims_sol = (-3.5, 1.5)
elims = (1e-7, 1.0)
title_str = "Finite differences for  x″ + x′/t + (1 − 1/(4t²)) x = √t cos t,  x(1) = 1,  x(6) = −0.5:  refining the grid"

# --- Compute ---
sols = [fdsolve(n) for n in ns]
errs = [x .- xexact.(t) for (t, x) in sols]
maxerr = [maximum(abs.(e)) for e in errs]
argmx  = [sols[k][1][argmax(abs.(errs[k]))] for k in eachindex(ns)]
hs     = [(b - a) / n for n in ns]
# Checks against the page: Example 1 table and the h-halving table
@assert abs(sols[3][2][20] - B("-2.919846")) < 1e-6           # x_19 at t = 4.8, n = 25
@assert abs(maxerr[3] - B("0.0146383")) < 1e-7
@assert abs(maxerr[4] - B("0.0036531")) < 1e-7
@assert abs(maxerr[7] - B("5.6994e-5")) < 1e-9
for k in eachindex(ns)
    @printf("n = %3d  h = %-7s max|x_j - x(t_j)| = %s at t = %s   max/h^2 = %s\n", ns[k],
            fmt(hs[k]), fmtv(maxerr[k]), fmt(argmx[k]), fmtv(maxerr[k] / hs[k]^2))
end

tf = range(B(1), B(6), length=1001)
tff = Float64.(tf)
xff = Float64.(xexact.(tf))

# Log panel, drawn position only: an error below the panel is drawn one decade
# below the bottom edge, so the curve visibly leaves the panel there. The panel
# shows the interior mesh points only; the error is exactly zero at t = 1 and 6.
logdraw(e) = max(Float64(abs(e)), elims[1] / 10)
inner(v) = v[2:end-1]

function draw_frame(k)
    n = ns[k]
    t, x = Float64.(sols[k][1]), Float64.(sols[k][2])
    mk = n <= 50 ? (:circle, n <= 25 ? 4 : 3) : (:none, 0)
    pL = plot(xlims=tlims, ylims=xlims_sol, framestyle=:box, xlabel="t", ylabel="x",
              legend=:bottomleft, legendfontsize=8, titlefontsize=10, grid=true)
    plot!(pL, tff, xff; color=:magenta, lw=2.5, label="exact solution x(t)")
    plot!(pL, t, ydraw.(x, Ref(xlims_sol)); color=:royalblue, lw=1.8, marker=mk[1],
          ms=mk[2], markerstrokewidth=0, label="finite differences, n = $n (points joined)")
    title!(pL, "n = $n,  h = $(fmt(hs[k])):  max |xⱼ − x(tⱼ)| = $(fmtv(maxerr[k])) at t = $(fmt(argmx[k]))")

    pR = plot(xlims=tlims, ylims=elims, yscale=:log10, framestyle=:box, xlabel="t",
              ylabel="|xⱼ − x(tⱼ)|, interior mesh points", legend=:bottomright,
              legendfontsize=8, titlefontsize=10, grid=true, yticks=10.0 .^ (-7:0))
    for j in 1:k-1
        plot!(pR, inner(Float64.(sols[j][1])), logdraw.(inner(errs[j])); color=:gray70, lw=1,
              label=j == 1 ? "earlier n" : "")
    end
    plot!(pR, inner(t), logdraw.(inner(errs[k])); color=:royalblue, lw=2, marker=mk[1], ms=mk[2],
          markerstrokewidth=0, label="n = $n")
    title!(pR, "max error / h² = $(fmtv(maxerr[k] / hs[k]^2))")

    plot(pL, pR; layout=(1, 2), size=(1150, 520), plot_title=title_str,
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white)
end

anim = Animation()
for k in eachindex(ns)
    draw_frame(k)
    frame(anim)
end
for _ in 1:2                                         # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: ", gif_name)
