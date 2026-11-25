# frobeniusaa.jl
# Frobenius Series Solution animation: Mathews' Example 1,
# x^2 y'' + x y' + (x^2 - 1/4) y = 0, whose indicial roots r = 1/2 and
# r = -1/2 give the two Frobenius solutions
#   y1(x) = x^(1/2) (1 - x^2/3! + x^4/5! - ...) = sin(x)/sqrt(x),
#   y2(x) = x^(-1/2) (1 - x^2/2! + x^4/4! - ...) = cos(x)/sqrt(x).
# One frame per partial sum S_N(x) = x^r sum_{n=0}^{N} c_n x^n, N = 0, 2, ..., 20,
# drawn against the closed form on 0 < x <= 10 (left: y1, right: y2). The bottom
# row plots the error |S_N(x) - y(x)| on a log scale with the tolerance 1e-3
# dashed. Green shading marks 0 < x < x*, where x* is the first x > 0 at which
# the error reaches 1e-3 (the x* of the page's table for Example 1).
# The coefficients come from recurrence (6) in exact rational arithmetic and are
# checked against the closed forms (-1)^k/(2k+1)! and (-1)^k/(2k)!; the errors
# are evaluated in 256-bit arithmetic and x* is refined by bisection.
# Mathews' plots for this example are lost, so the window is chosen here.
# Produces: frobeniusaa.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))      # exact values
fmtv(x) = um(@sprintf("%#.4g", Float64(x)))                    # computed: 4 s.f.

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))   # 12 -> "₁₂"

setprecision(BigFloat, 256)
const Q = Rational{BigInt}

# --- Parameters (Mathews' Example 1) ---
gif_name = "frobeniusaa.gif"
Ns       = 0:2:20                  # partial sums through x^N
tol      = big"1e-3"
xmax     = 10
xlims    = (0.0, Float64(xmax))
ylims    = (-1.0, 1.5)
elims    = (1e-9, 1e3)             # error panels (log scale)
title_str = "Frobenius series (Mathews' Example 1):  x²y″ + xy′ + (x² − ¼)y = 0,  " *
            "partial sums S_N(x) = xʳ (c₀ + c₁x + ⋯ + c_N xᴺ)"

# Recurrence (6): [(n + r)^2 - 1/4] c_n = -c_{n-2}, with c_0 = 1 and c_1 = 0
function frob_coeffs(r::Q, N)
    c = zeros(Q, N + 1)
    c[1] = 1
    for n in 2:N
        c[n+1] = -c[n-1] / ((n + r)^2 - 1 // 4)
    end
    return c
end
sols = [
    (name = "y₁", r = Q(1, 2),  rstr = "½",  exact = x -> sin(x) / sqrt(x),
     exact_lbl = "y₁ = sin x / √x", closed = k -> Q((-1)^k, factorial(big(2k + 1)))),
    (name = "y₂", r = Q(-1, 2), rstr = "−½", exact = x -> cos(x) / sqrt(x),
     exact_lbl = "y₂ = cos x / √x", closed = k -> Q((-1)^k, factorial(big(2k)))),
]
coef = [frob_coeffs(s.r, last(Ns)) for s in sols]
for (s, c) in zip(sols, coef)
    for n in 0:last(Ns)
        want = isodd(n) ? zero(Q) : s.closed(n ÷ 2)
        @assert c[n+1] == want "coefficient c_$n of $(s.name) does not match its closed form"
    end
end

# Partial sum S_N(x) = x^r * sum_{n=0}^{N} c_n x^n (Horner, in the type of x)
function psum(c, r, N, x)
    s = zero(x)
    for n in N:-1:0
        s = s * x + c[n+1]
    end
    return x^r * s
end

# --- Errors on a grid of 0 < x <= xmax, in 256-bit arithmetic ---
# Uniform step xmax/4000, geometric points from 1e-6 up to the first uniform
# point (so that curves near x = 0 reach the bottom of the log panels), and
# x = 2 pi, where the error of S_0 for y2, (1 - cos x)/sqrt(x), is exactly 0.
npts = 4000
xb = [BigFloat(xmax) * i / npts for i in 1:npts]
xb = sort(vcat([big(10)^e for e in range(-6, log10(xmax / npts), length=41)[1:end-1]],
               xb, [2 * BigFloat(π)]))
xs = Float64.(xb)
yex  = [s.exact.(xb) for s in sols]
err  = [[abs.(psum.(Ref(coef[j]), BigFloat(sols[j].r), N, xb) .- yex[j]) for N in Ns]
        for j in 1:2]

# x*: the first x > 0 at which |S_N - y| reaches tol (scan, then bisection)
function xstar(j, N)
    g(x) = abs(psum(coef[j], BigFloat(sols[j].r), N, x) - sols[j].exact(x)) - tol
    h = big"0.001"
    x = h
    while g(x) < 0
        x += h
    end
    lo, hi = x - h, x
    for _ in 1:120
        m = (lo + hi) / 2
        g(m) < 0 ? (lo = m) : (hi = m)
    end
    return (lo + hi) / 2
end
xst = [[xstar(j, N) for N in Ns] for j in 1:2]

for (k, N) in enumerate(Ns)
    @printf("N = %2d:  x*(y1) = %s   x*(y2) = %s   max err on (0, %g]: y1 %s, y2 %s\n",
            N, fmtv(xst[1][k]), fmtv(xst[2][k]), xmax,
            fmtv(maximum(err[1][k])), fmtv(maximum(err[2][k])))
end
# Does the error dip back below tol beyond x*? (grid points only, reported)
for j in 1:2, (k, N) in enumerate(Ns)
    back = [x for (x, e) in zip(xs, err[j][k]) if x > xst[j][k] + 1e-9 && e < tol]
    isempty(back) || @printf("%s, N = %d: error below tol again on grid points in [%.4f, %.4f] (%d points)\n",
                             sols[j].name, N, first(back), last(back), length(back))
end

# Where does S_N - y change sign on the grid for x >= 0.1 (dips of the log error
# curves)? Below x = 0.1 the error of S_N for N >= 12 is under 1e-20, far below
# the panels, and near x = 1e-6 under the 256-bit resolution.
for j in 1:2, (k, N) in enumerate(Ns)
    d = psum.(Ref(coef[j]), BigFloat(sols[j].r), N, xb) .- yex[j]
    sc = [Float64(xb[i]) for i in 1:length(xb)-1
          if xb[i] >= 0.1 && sign(d[i]) * sign(d[i+1]) < 0]
    isempty(sc) || @printf("%s, N = %d: S_N - y changes sign near x = %s\n", sols[j].name, N,
                           join([@sprintf("%.3f", x) for x in sc], ", "))
end

# Log panel, drawn position only: an error below the panel is drawn one decade
# below the bottom edge, so the curve visibly leaves the panel there.
logdraw(e) = max(Float64(e), elims[1] / 10)
function shade!(p, a, b, yl; label="")
    plot!(p, Shape([a, b, b, a], [yl[1], yl[1], yl[2], yl[2]]);
          color=:palegreen, alpha=0.45, linealpha=0, label=label)
end

# --- Animation: one partial sum per frame ---
function draw_frame(k)
    N = Ns[k]
    panels = []
    for j in 1:2
        s  = sols[j]
        xk = Float64(xst[j][k])
        pT = plot(xlims=xlims, ylims=ylims, framestyle=:box, xlabel="x", ylabel="y",
                  legend=:topright, legendfontsize=8, titlefontsize=10, grid=true)
        shade!(pT, 0.0, xk, ylims; label="error < 10⁻³ on 0 < x < x*")
        hline!(pT, [0.0]; color=:black, lw=0.5, label="")
        plot!(pT, xs, ydraw.(Float64.(yex[j]), Ref(ylims)); color=:magenta, lw=2.5,
              label=s.exact_lbl)
        plot!(pT, xs, ydraw.(Float64.(psum.(Ref(coef[j]), BigFloat(s.r), N, xb)), Ref(ylims));
              color=:royalblue, lw=2, label="S$(sub(N)),  r = $(s.rstr)")
        vline!(pT, [xk]; color=:darkgreen, ls=:dash, lw=1.5, label="")
        title!(pT, "$(s.name): N = $N,  x* = $(fmtv(xst[j][k]))")

        pB = plot(xlims=xlims, ylims=elims, yscale=:log10, framestyle=:box, xlabel="x",
                  ylabel="|S_N(x) − $(s.name)(x)|", legend=:bottomright, legendfontsize=8,
                  titlefontsize=10, grid=true, yticks=10.0 .^ (-9:3:3))
        shade!(pB, 0.0, xk, elims)
        for kk in 1:k-1
            plot!(pB, xs, logdraw.(err[j][kk]); color=:gray70, lw=1,
                  label=kk == 1 ? "earlier N" : "")
        end
        hline!(pB, [1e-3]; color=:darkgreen, ls=:dash, lw=1.5, label="tolerance 10⁻³")
        plot!(pB, xs, logdraw.(err[j][k]); color=:royalblue, lw=2, label="N = $N")
        title!(pB, "error of S$(sub(N)) for $(s.name)")
        push!(panels, (pT, pB))
    end
    plot(panels[1][1], panels[2][1], panels[1][2], panels[2][2]; layout=(2, 2),
         size=(1150, 820), plot_title=title_str, plot_titlefontsize=12,
         left_margin=5Plots.mm, bottom_margin=4Plots.mm, background_color=:white)
end

anim = Animation()
for k in eachindex(Ns)
    draw_frame(k)
    frame(anim)
end
for _ in 1:2                                         # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: ", gif_name)
