# fdodebb.jl
# Finite Difference Method for ODE's animation: Richardson extrapolation for
# Mathews' boundary value problem (his Examples 2-6)
#     x'' + x'/t + (1 - 1/(4t^2)) x = sqrt(t) cos t,  x(1) = 1,  x(6) = -0.5.
# X1 = finite differences with n = 25, X2 with n = 50, X3 = (4 X2 - X1)/3,
# all compared at the 26 points t = 1.0, 1.2, ..., 6.0 that the two meshes
# share, as in Mathews' Examples 4 and 6. One curve is added per frame:
# X1 - x, X2 - x, X2 - X1 (Mathews' Example 4 graph, green as in his) with the
# error estimate -(4/3)(X2 - X1), and X3 - x. Left: the signed values on a
# linear scale. Right (new): their sizes on a log scale.
# The tridiagonal systems are solved and the exact solution evaluated in
# 256-bit floating point; the plots use Float64 copies.
# Produces: fdodebb.gif

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
gif_name = "fdodebb.gif"
tlims = (1.0, 6.0)                 # Mathews' graphs: 1 <= t <= 6
slims = (-0.018, 0.013)            # signed panel
elims = (1e-8, 1e-1)               # log panel
title_str = "Richardson extrapolation (Mathews' Examples 4–6):  X₃ = (4X₂ − X₁)/3 from n = 25 (X₁) and n = 50 (X₂),  at t = 1, 1.2, …, 6"

# --- Compute ---
t1, X1 = fdsolve(25)
t2, X2f = fdsolve(50)
@assert all(t2[1:2:end] .== t1)
X2 = X2f[1:2:end]                  # Mathews: points 1, 3, ..., 51 of X2
X3 = (4 .* X2 .- X1) ./ 3
xe = xexact.(t1)
E1, E2, E3 = X1 .- xe, X2 .- xe, X3 .- xe
D = X2 .- X1
Est = -(B(4) / 3) .* D             # Example 4: X1 - x ≈ -(4/3)(X2 - X1)

mx(v) = (m = maximum(abs.(v)); (m, t1[argmax(abs.(v))]))
(m1, a1), (m2, a2), (m3, a3), (mD, aD) = mx(E1), mx(E2), mx(E3), mx(D)
# Checks against the page (Examples 4-6)
@assert abs(m1 - B("0.0146383")) < 1e-7 && abs(m2 - B("0.00363805")) < 1e-8
@assert abs(m3 - B("0.0000286914")) < 1e-10 && abs(mD - B("0.011000211")) < 1e-9
@assert all(abs(s - B(24) / 5) < 1e-60 for s in (a1, a2, a3, aD))
@printf("max|E1| = %s at %s, max|E2| = %s, max|D| = %s, max|E3| = %s\n",
        fmtv(m1), fmt(a1), fmtv(m2), fmtv(mD), fmtv(m3))
@printf("ratios: E2/E1 = %s, E1/E3 = %s, E2/E3 = %s, (4/3)max|D| = %s\n",
        fmtv(m2 / m1), fmtv(m1 / m3), fmtv(m2 / m3), fmtv(4mD / 3))
@printf("max|Est - E1| = %s\n", fmtv(maximum(abs.(Est .- E1))))

tt = Float64.(t1)
inner(v) = v[2:end-1]              # the log panel omits t = 1 and 6, where all are 0
# Log panel, drawn position only: a value below the panel is drawn one decade
# below the bottom edge, so the curve visibly leaves the panel there.
logdraw(e) = max(Float64(abs(e)), elims[1] / 10)

curves = [
    (E1,  "X₁ − x  (n = 25)",              :royalblue,  :solid, :circle),
    (E2,  "X₂ − x  (n = 50)",              :darkorange, :solid, :diamond),
    (D,   "X₂ − X₁  (Mathews' Example 4)", :green3,     :solid, :utriangle),
    (E3,  "X₃ − x  (extrapolated)",        :red,        :solid, :square),
]
left_titles = [
    "X₁: finite differences with n = 25,  h = 0.2",
    "X₂: n = 50,  h = 0.1,  at every other mesh point",
    "X₂ − X₁ ≈ −(3/4)(X₁ − x), so X₁ − x ≈ −(4/3)(X₂ − X₁)",
    "X₃ = X₂ + (X₂ − X₁)/3 removes most of the error",
]
right_titles = [
    "max |X₁ − x| = $(fmtv(m1)) at t = $(fmt(a1))",
    "max |X₂ − x| = $(fmtv(m2)) at t = $(fmt(a2)),  $(fmtv(m2 / m1)) × max |X₁ − x|",
    "max |X₂ − X₁| = $(fmtv(mD)) at t = $(fmt(aD)),  (4/3) × that = $(fmtv(4mD / 3))",
    "max |X₃ − x| = $(fmtv(m3)) at t = $(fmt(a3)) = max |X₁ − x| / $(fmtv(m1 / m3))",
]

function draw_frame(k)
    pL = plot(xlims=tlims, ylims=slims, framestyle=:box, xlabel="t", ylabel="difference",
              legend=:bottomleft, legendfontsize=8, titlefontsize=10, grid=true)
    hline!(pL, [0.0]; color=:black, lw=0.8, label="")
    pR = plot(xlims=tlims, ylims=elims, yscale=:log10, framestyle=:box, xlabel="t",
              ylabel="size (log scale), t = 1.2, …, 5.8", legend=:bottomleft,
              legendfontsize=8, titlefontsize=10, grid=true, yticks=10.0 .^ (-8:-1))
    for j in 1:k
        v, lbl, col, _, mk = curves[j]
        lw = j == k ? 2.2 : 1.4
        plot!(pL, tt, Float64.(v); color=col, lw=lw, marker=mk, ms=3.5,
              markerstrokewidth=0, label=lbl)
        plot!(pR, inner(tt), logdraw.(inner(v)); color=col, lw=lw, marker=mk, ms=3.5,
              markerstrokewidth=0, label=lbl)
        if j == 3
            plot!(pL, tt, Float64.(Est); color=:black, lw=1.2, ls=:dash,
                  label="−(4/3)(X₂ − X₁), estimate of X₁ − x")
        end
    end
    title!(pL, left_titles[k])
    title!(pR, right_titles[k])
    plot(pL, pR; layout=(1, 2), size=(1150, 520), plot_title=title_str,
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white)
end

anim = Animation()
for k in 1:4
    draw_frame(k)
    frame(anim)
    frame(anim)                                      # two seconds per frame
end
frame(anim)                                          # hold the last frame (3 s)
gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: ", gif_name)
