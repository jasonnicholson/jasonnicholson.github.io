# galerkinbb.jl
# Galerkin's Method animation: Mathews' Example 3 (b), y'' + y + 2x(1 - x) = 0,
# y(0) = 0, y(1) = 1/2, phi_0 = x/2, with two bases side by side. One frame per
# number of basis functions, n = 1, ..., 5:
#   Mathews' basis: the first n of x(x-1), x^2(x-1)^2, x^2(x-1)^3, x^3(x-1)^3,
#                   x^4(x-1)^3 (he uses all five);
#   complete basis: x(x-1), x^2(x-1), ..., x^n(x-1), which spans every
#                   polynomial of degree <= n+1 that vanishes at 0 and 1.
# Left: both Galerkin solutions against the exact solution, in Mathews' window
# [0, 1] and with his colours (exact magenta, Galerkin solution blue).
# Middle (new): the errors |y(x) - u_n(x)| on a log scale.
# Right (new): the largest error on [0, 1] against n for both bases.
# Every trial function of Mathews' basis satisfies u'(0) + u'(1) = 1, while the
# exact solution has y'(0) + y'(1) = 0.9152; the legend shows these values.
# The Galerkin systems are solved exactly, in rational arithmetic; the errors
# are evaluated in 256-bit floating point.
# Produces: galerkinbb.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))        # exact values
const SUP = Dict(zip("0123456789-", "⁰¹²³⁴⁵⁶⁷⁸⁹⁻"))
function sci(x)                                                  # computed: 4 s.f.
    x = Float64(x)
    (1e-3 <= abs(x) < 1e4) && return um(@sprintf("%#.4g", x))
    e = floor(Int, log10(abs(x)))
    m = x / 10.0^e
    if abs(round(m, digits=3)) >= 10
        e += 1
        m = x / 10.0^e
    end
    return um(@sprintf("%.3f", m)) * "×10" * join(SUP[c] for c in string(e))
end

sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))     # 3 -> "₃"

# --- Exact polynomial arithmetic: p[k+1] is the coefficient of x^k ---
const Q = Rational{BigInt}
padd(p, q) = [get(p, i, zero(Q)) + get(q, i, zero(Q)) for i in 1:max(length(p), length(q))]
function pmul(p, q)
    r = zeros(Q, length(p) + length(q) - 1)
    for i in eachindex(p), j in eachindex(q)
        r[i+j-1] += p[i] * q[j]
    end
    return r
end
pder(p) = length(p) == 1 ? [zero(Q)] : [p[k+1] * k for k in 1:length(p)-1]
pint01(p) = sum(p[k] / k for k in eachindex(p))                 # integral over [0, 1]
ppow(p, n) = n == 0 ? [one(Q)] : pmul(p, ppow(p, n - 1))
peval(p, x) = foldr((c, s) -> c + x * s, p; init=zero(x))
const X   = [zero(Q), one(Q)]
const Xm1 = [-one(Q), one(Q)]
mono(i, j) = pmul(ppow(X, i), ppow(Xm1, j))                     # x^i (x - 1)^j

# --- Parameters (Mathews' Example 3 (b)) ---
gif_name = "galerkinbb.gif"
n_max    = 5
Lop(p)   = padd(pder(pder(p)), p)                                # L[y] = y'' + y
f        = pmul([zero(Q), Q(2)], [one(Q), -one(Q)])              # f(x) = 2x(1 - x)
phi0     = [zero(Q), Q(1, 2)]                                    # x/2
mathews  = [mono(1, 1), mono(2, 2), mono(2, 3), mono(3, 3), mono(4, 3)]
complete = [mono(i, 1) for i in 1:n_max]
setprecision(BigFloat, 256)
const BF = BigFloat
yexact(x)  = -4 - 2x + 2x^2 + 4cos(x) - 4cot(BF(1)) * sin(x) + (9 / BF(2)) / sin(BF(1)) * sin(x)
dyexact(x) = -2 + 4x - 4sin(x) - 4cot(BF(1)) * cos(x) + (9 / BF(2)) / sin(BF(1)) * cos(x)
xlims    = (0.0, 1.0)                                            # Mathews' window
ylims    = (0.0, 0.55)
elims    = (1e-10, 1e-1)                                         # error panel (log scale)
title_lines = ["Galerkin's method (Mathews' Example 3 (b)):  y″ + y + 2x(1 − x) = 0,  y(0) = 0,  y(1) = 1/2,  " *
               "uₙ = x/2 + c₁φ₁ + ⋯ + cₙφₙ",
               "Mathews' basis:  φ = x(x − 1), x²(x − 1)², x²(x − 1)³, x³(x − 1)³, x⁴(x − 1)³        " *
               "complete basis:  φ = x(x − 1), x²(x − 1), x³(x − 1), x⁴(x − 1), x⁵(x − 1)"]

# --- Galerkin solution for a basis (exact) ---
function galerkin(basis)
    n = length(basis)
    A = [pint01(pmul(basis[i], Lop(basis[j]))) for i in 1:n, j in 1:n]
    B = [-pint01(pmul(basis[i], padd(Lop(phi0), f))) for i in 1:n]
    c = A \ B
    u = phi0
    for j in 1:n
        u = padd(u, c[j] .* basis[j])
    end
    return u, c
end
uM = [galerkin(mathews[1:n]) for n in 1:n_max]
uC = [galerkin(complete[1:n]) for n in 1:n_max]

# Checks against the page: Mathews' five coefficients, and the boundary values
@assert uM[5][2] == Q[-9521//29588, 4950923615//7458572628, 12727//13626,
                     -774530317//573736356, 18304//6813] "Mathews' coefficients"
for (u, _) in vcat(uM, uC)
    @assert peval(u, Q(0)) == 0 && peval(u, Q(1)) == 1 // 2
end
@assert abs(yexact(BF(0))) < BF(10)^-70 && abs(yexact(BF(1)) - BF(1) / 2) < BF(10)^-70

# u'(0) + u'(1), exact
dsum(u) = (du = pder(u); peval(du, Q(0)) + peval(du, Q(1)))
dsM = [dsum(u) for (u, _) in uM]
dsC = [dsum(u) for (u, _) in uC]
dsY = dyexact(BF(0)) + dyexact(BF(1))
@assert all(dsM .== 1) "every trial function of Mathews' basis has u'(0) + u'(1) = 1"

# --- Errors on a 6001-point grid, largest error refined by golden-section search ---
N  = 6001
xb = [BF(k - 1) / (N - 1) for k in 1:N]
yb = yexact.(xb)
err(u) = (ub = BF.(u); [yb[k] - peval(ub, xb[k]) for k in 1:N])
function maxabs(u)
    ub = BF.(u)
    g(x) = abs(yexact(x) - peval(ub, x))
    e = abs.(err(u))
    k = argmax(e)
    lo, hi = xb[max(k - 1, 1)], xb[min(k + 1, N)]
    φ = (sqrt(BF(5)) - 1) / 2
    for _ in 1:200
        m1 = hi - φ * (hi - lo); m2 = lo + φ * (hi - lo)
        g(m1) >= g(m2) ? (hi = m2) : (lo = m1)
    end
    xm = (lo + hi) / 2
    return g(xm) >= e[k] ? (g(xm), xm) : (e[k], xb[k])
end
eM = [err(u) for (u, _) in uM];  mM = [maxabs(u) for (u, _) in uM]
eC = [err(u) for (u, _) in uC];  mC = [maxabs(u) for (u, _) in uC]
@printf("exact y'(0) + y'(1) = %s\n", sci(dsY))
for n in 1:n_max
    @printf("n = %d: Mathews' basis max|y - u| = %s at x = %.4f (u'(0)+u'(1) = %s);  complete basis max|y - u| = %s at x = %.4f (u'(0)+u'(1) = %s = %s)\n",
            n, sci(mM[n][1]), Float64(mM[n][2]), string(dsM[n]),
            sci(mC[n][1]), Float64(mC[n][2]), string(dsC[n]), sci(dsC[n]))
end

# Drawing helpers
xs = Float64.(xb)
ys = Float64.(yb)
# Log panel, drawn position only: an error below the panel (including the exact
# zeros at x = 0 and x = 1) is drawn one decade below the bottom edge, so the
# curve visibly leaves the panel there.
logdraw(e) = max(Float64(abs(e)), elims[1] / 10)
dslabel(d) = d == 1 ? "1" : sci(d)

# --- Animation: one value of n per frame ---
function draw_frame(n)
    pL = plot(xlims=xlims, ylims=ylims, framestyle=:box, xlabel="x", ylabel="y",
              legend=:bottomright, legendfontsize=8, titlefontsize=10, grid=true,
              title="n = $n basis function$(n == 1 ? "" : "s")   (in brackets: u′(0) + u′(1))")
    plot!(pL, xs, ys; color=:magenta, lw=4, label="exact y   ($(sci(dsY)))")
    plot!(pL, xs, Float64.(peval.(Ref(BF.(uM[n][1])), xb)); color=:royalblue, lw=2,
          label="u$(sub(n)), Mathews' basis   ($(dslabel(dsM[n])))")
    plot!(pL, xs, Float64.(peval.(Ref(BF.(uC[n][1])), xb)); color=:darkorange, lw=2, ls=:dash,
          label="u$(sub(n)), complete basis   ($(dslabel(dsC[n])))")
    scatter!(pL, [0.0, 1.0], [0.0, 0.5]; color=:red, ms=4, label="y(0) = 0, y(1) = 1/2")

    pM = plot(xlims=xlims, ylims=elims, yscale=:log10, framestyle=:box, xlabel="x",
              ylabel="|y(x) − uₙ(x)|", legend=:bottom, legendfontsize=8,
              titlefontsize=10, grid=true, yticks=10.0 .^ (-10:-1))
    plot!(pM, xs, logdraw.(eM[n]); color=:royalblue, lw=3.5, label="Mathews' basis")
    plot!(pM, xs, logdraw.(eC[n]); color=:darkorange, lw=2, label="complete basis")
    title!(pM, "max |y − u$(sub(n))|:  Mathews' $(sci(mM[n][1])),  complete $(sci(mC[n][1]))")

    pR = plot(xlims=(0.5, n_max + 0.5), ylims=elims, yscale=:log10, framestyle=:box,
              xlabel="n", ylabel="largest error on [0, 1]", legend=:bottomleft,
              legendfontsize=8, titlefontsize=10, grid=true, yticks=10.0 .^ (-10:-1),
              xticks=1:n_max, title="largest error against n")
    plot!(pR, 1:n, [Float64(m[1]) for m in mM[1:n]]; color=:royalblue, marker=:circle, ms=5,
          lw=1, label="Mathews' basis")
    plot!(pR, 1:n, [Float64(m[1]) for m in mC[1:n]]; color=:darkorange, marker=:diamond, ms=5,
          lw=1, label="complete basis")

    pT = plot(xlims=(0, 1), ylims=(0, 1), framestyle=:none, grid=false, legend=false)
    annotate!(pT, 0.5, 0.72, text(title_lines[1], 12, :center))
    annotate!(pT, 0.5, 0.18, text(title_lines[2], 10, :center))
    plot(pT, pL, pM, pR; layout=@layout([t{0.09h}; grid(1, 3)]), size=(1500, 580),
         left_margin=6Plots.mm, bottom_margin=6Plots.mm, background_color=:white)
end

anim = Animation()
for n in 1:n_max
    draw_frame(n)
    frame(anim)
end
for _ in 1:2                                         # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: ", gif_name)
