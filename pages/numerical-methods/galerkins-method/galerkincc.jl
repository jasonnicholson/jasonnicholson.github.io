# galerkincc.jl
# Galerkin's Method animation: Mathews' Example 4 (b), y'' + 2y + 2x(x - pi) = 0,
# y(0) = 0, y(pi) = 1, phi_0 = x/pi, with the sine basis sin x, sin 2x, ...,
# sin nx. One frame per number of basis functions, n = 1, ..., 15 (Mathews uses
# n = 7).
# Left: u_n against the exact solution, in Mathews' window [0, pi] and with his
# colours (exact magenta, Galerkin solution blue).
# Middle (new): the error |y(x) - u_n(x)| on a log scale.
# Right (new): the Galerkin coefficients |c_k| against k on a log scale, with
# the Fourier sine coefficients of y - phi_0, computed separately by numerical
# quadrature of the exact solution, and the large-k asymptote 4/(pi k^3).
# The Galerkin system A c = B: since L[sin jx] = (2 - j^2) sin jx and the sines
# are orthogonal on [0, pi], a_ij = (2 - j^2)(pi/2) for i = j and 0 otherwise,
# and b_k = 2(-1)^k/k + 8/k^3 (k odd) or 2(-1)^k/k (k even); these closed forms
# are the exact integrals (see the page, Example 4 (b), Step 3). All arithmetic
# is 256-bit floating point.
# Produces: galerkincc.gif

using Plots
using Printf
using LinearAlgebra
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

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))     # 12 -> "₁₂"

# --- Parameters (Mathews' Example 4 (b)) ---
gif_name = "galerkincc.gif"
n_max    = 15
setprecision(BigFloat, 256)
const BF = BigFloat
const PI = BF(pi)
const s2 = sqrt(BF(2))
yexact(x) = 1 + PI * x - x^2 - cos(s2 * x) + cot(s2 * PI) * sin(s2 * x)
phi0(x)   = x / PI
xlims    = (0.0, Float64(PI))                                    # Mathews' window
ylims    = (0.0, 4.8)
elims    = (1e-7, 1.0)                                           # error panel (log scale)
clims    = (1e-5, 10.0)                                          # coefficient panel
title_str = "Galerkin's method (Mathews' Example 4 (b)):  y″ + 2y + 2x(x − π) = 0,  y(0) = 0,  y(π) = 1,  " *
            "uₙ(x) = x/π + c₁ sin x + c₂ sin 2x + ⋯ + cₙ sin nx"

# --- Galerkin system and solution for n = n_max ---
akk(k) = (2 - BF(k)^2) * PI / 2
bk(k)  = 2 * BF(-1)^k / k + (isodd(k) ? 8 / BF(k)^3 : zero(BF))
A = Diagonal([akk(k) for k in 1:n_max])
B = [bk(k) for k in 1:n_max]
c = A \ B
# A is diagonal, so the first n coefficients do not change when n grows:
# u_n uses c[1:n] for every n.
# Check against the page's table of c_k for Mathews' n = 7 (6 significant figures)
page_c = [3.81972, -0.318310, 0.0336836, -0.0227364, 0.00930018, -0.00624137, 0.00355411]
@assert all(abs.(Float64.(c[1:7]) .- page_c) .<= 5e-6 .* abs.(page_c)) "page's c_k"
@assert all(sign(c[k]) == (isodd(k) ? 1 : -1) for k in 1:n_max) "signs alternate"

# --- Grid on [0, pi] (20001 points, as on the page) ---
N  = 20001
xb = [PI * (k - 1) / (N - 1) for k in 1:N]
yb = yexact.(xb)
gb = yb .- phi0.(xb)                                              # y - phi_0
@assert abs(yb[1]) < BF(10)^-70 && abs(yb[end] - 1) < BF(10)^-70

# Fourier sine coefficients of y - phi_0 by composite Simpson's rule on the grid
wS = [k == 1 || k == N ? 1 : (iseven(k) ? 4 : 2) for k in 1:N] .* (PI / (N - 1) / 3)
fourier = [2 / PI * sum(wS .* gb .* sin.(k .* xb)) for k in 1:n_max]
relgap = maximum(abs.(fourier .- c) ./ abs.(c))
@printf("max relative difference between Galerkin c_k and quadrature Fourier coefficients, k <= %d: %.2e\n",
        n_max, Float64(relgap))
@assert relgap < 1e-6

# --- u_n and its error; largest error refined by golden-section search ---
S = [zeros(BF, N) for _ in 1:n_max]                              # S[n] = sum_{k<=n} c_k sin kx
for n in 1:n_max
    S[n] = (n == 1 ? zeros(BF, N) : S[n-1]) .+ c[n] .* sin.(n .* xb)
end
ub(n) = phi0.(xb) .+ S[n]
uf(n, x) = phi0(x) + sum(c[k] * sin(k * x) for k in 1:n)
function maxabs(n, e)
    g(x) = abs(yexact(x) - uf(n, x))
    k = argmax(abs.(e))
    lo, hi = xb[max(k - 1, 1)], xb[min(k + 1, N)]
    φ = (sqrt(BF(5)) - 1) / 2
    for _ in 1:200
        m1 = hi - φ * (hi - lo); m2 = lo + φ * (hi - lo)
        g(m1) >= g(m2) ? (hi = m2) : (lo = m1)
    end
    xm = (lo + hi) / 2
    return g(xm) >= abs(e[k]) ? (g(xm), xm) : (abs(e[k]), xb[k])
end
errs = [yb .- ub(n) for n in 1:n_max]
mx   = [maxabs(n, errs[n]) for n in 1:n_max]
for n in 1:n_max
    @printf("n = %2d: c_n = %s;  max|y - u_n| = %s at x = %.4f;  n^2 * max = %.4f\n", n,
            sci(c[n]), sci(mx[n][1]), Float64(mx[n][2]), n^2 * Float64(mx[n][1]))
end
let us = [Float64(v) for n in 1:n_max for v in ub(n)]
    @printf("range of u_n over [0, pi], n = 1..%d: [%.4f, %.4f]; max of y: %.4f\n", n_max,
            minimum(us), maximum(us), maximum(Float64.(yb)))
end

# Drawing helpers
xs = Float64.(xb)
ys = Float64.(yb)
# Log panel, drawn position only: an error below the panel (including the exact
# zeros at x = 0 and x = pi) is drawn one decade below the bottom edge, so the
# curve visibly leaves the panel there.
logdraw(e) = max(Float64(abs(e)), elims[1] / 10)
pticks = ([0, π / 4, π / 2, 3π / 4, π], ["0", "π/4", "π/2", "3π/4", "π"])
kk = range(1, n_max, length=200)

# --- Animation: one value of n per frame ---
function draw_frame(n)
    pL = plot(xlims=xlims, ylims=ylims, framestyle=:box, xlabel="x", ylabel="y",
              legend=:topleft, legendfontsize=8, titlefontsize=10, grid=true, xticks=pticks,
              title=n == 1 ? "n = 1 basis function, sin x" :
                    "n = $n basis functions, sin x, …, sin $(n)x")
    for k in 1:n-1
        plot!(pL, xs, ydraw.(Float64.(ub(k)), Ref(ylims)); color=:gray75, lw=1,
              label=k == 1 ? (n == 2 ? "u₁" : "u₁ … u$(sub(n-1))") : "")
    end
    plot!(pL, xs, ys; color=:magenta, lw=2.5, label="exact y")
    plot!(pL, xs, ydraw.(Float64.(ub(n)), Ref(ylims)); color=:royalblue, lw=2,
          label="Galerkin u$(sub(n))")
    scatter!(pL, [0.0, π], [0.0, 1.0]; color=:red, ms=4, label="y(0) = 0, y(π) = 1")

    pM = plot(xlims=xlims, ylims=elims, yscale=:log10, framestyle=:box, xlabel="x",
              ylabel="|y(x) − uₙ(x)|", legend=:bottomleft, legendfontsize=8,
              titlefontsize=10, grid=true, yticks=10.0 .^ (-7:0), xticks=pticks)
    plot!(pM, xs, logdraw.(errs[n]); color=:royalblue, lw=2, label="|y − u$(sub(n))|")
    title!(pM, "max |y − u$(sub(n))| on [0, π] = $(sci(mx[n][1])) at x = $(@sprintf("%.3f", Float64(mx[n][2])))")

    pR = plot(xlims=(0.5, n_max + 0.5), ylims=clims, yscale=:log10, framestyle=:box,
              xlabel="k", ylabel="|cₖ|", legend=:bottomleft, legendfontsize=8,
              titlefontsize=10, grid=true, xticks=1:n_max, yticks=10.0 .^ (-5:1),
              title="Galerkin coefficients:  c$(sub(n)) = $(sci(c[n]))")
    plot!(pR, kk, 4 ./ (π .* kk .^ 3); color=:gray50, ls=:dash, lw=1.5,
          label="4/(πk³), large-k asymptote")
    scatter!(pR, 1:n, Float64.(abs.(fourier[1:n])); markershape=:circle, ms=9,
             markercolor=RGBA(1, 1, 1, 0), markerstrokecolor=:black, markerstrokewidth=1.5,
             label="Fourier sine coefficient of y − x/π, by quadrature")
    scatter!(pR, 1:n, Float64.(abs.(c[1:n])); color=:royalblue, ms=6,
             label="Galerkin |cₖ| from A c = B (cₖ > 0 for odd k, < 0 for even k)")

    plot(pL, pM, pR; layout=(1, 3), size=(1500, 520), plot_title=title_str,
         plot_titlefontsize=12, left_margin=6Plots.mm, bottom_margin=6Plots.mm,
         background_color=:white)
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
