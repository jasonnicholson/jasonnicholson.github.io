# powerseriescc.jl
# Power Series animation: the page's Example 3,
#   (1 + x^2) y'' + x y' - y = 0,  exact solution y = sqrt(1 + x^2),
# whose singular points x = +-i lie off the real axis. Two series of the same
# solution, one frame per partial sum N = 2, 4, ..., 40:
#   (a) about x0 = 0, recurrence (5), a_{n+2} = -(n-1)/(n+2) a_n, a_0 = 1, a_1 = 0
#       (the binomial series of sqrt(1 + x^2)); R = |0 - i| = 1;
#   (b) about x0 = 1, t = x - 1, recurrence (6),
#       b_{n+2} = -((2n+1) b_{n+1} + (n-1) b_n) / (2(n+2)),
#       b_0 = sqrt(2), b_1 = 1/sqrt(2); R = |1 - i| = sqrt(2).
# Left: the complex plane with the singular points +-i and the two disks of
# convergence, whose real diameters are the intervals (-1, 1) and
# (1 - sqrt 2, 1 + sqrt 2); the intervals where the current partial sums have
# error below 1e-3 are drawn on the real axis. Middle and right: the partial sums
# against sqrt(1 + x^2) in the page's windows [-1.5, 1.5] x [0, 2.5] and
# [-1, 3] x [0, 3.5], and their errors on a log scale, with green shading over
# the interval about the centre on which the error stays below 1e-3.
# Coefficients are exact rationals (times sqrt 2 for (b)); values in 256-bit
# arithmetic.
# Produces: powerseriescc.gif

using Plots
using Printf
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))
fmtv(x) = um(@sprintf("%#.4g", Float64(x)))                    # computed: 4 s.f.

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))   # 12 -> "₁₂"

setprecision(BigFloat, 256)
const Q = Rational{BigInt}

# --- Parameters (the page's Example 3) ---
gif_name = "powerseriescc.gif"
Ns       = 2:2:40
Nmax     = last(Ns)
tol      = big"1e-3"
elims    = (1e-12, 1e6)
yexact(x) = sqrt(1 + x^2)
title_str = "Power series for (1 + x²)y″ + xy′ − y = 0, exact solution y = √(1 + x²): " *
            "singular points ±i, series about x₀ = 0 (R = 1) and x₀ = 1 (R = √2)"

# (a) recurrence (5)
a = zeros(Q, Nmax + 1)
a[1] = 1; a[2] = 0
for n in 0:Nmax-2
    a[n+3] = -Q(n - 1, n + 2) * a[n+1]
end
binom_half(k) = prod(Q[(Q(1, 2) - j + 1) / j for j in 1:k]; init=Q(1))
@assert all(a[2k+1] == binom_half(k) for k in 0:Nmax÷2)
@assert all(a[n+1] == 0 for n in 1:2:Nmax)
@assert a[[3, 5, 7, 9, 11, 13]] == Q[1//2, -1//8, 1//16, -5//128, 7//256, -21//1024]

# (b) recurrence (6) for c_n = b_n / sqrt 2: c_0 = 1, c_1 = 1/2
c = zeros(Q, Nmax + 1)
c[1] = 1; c[2] = Q(1, 2)
for n in 0:Nmax-2
    c[n+3] = -((2n + 1) * c[n+2] + (n - 1) * c[n+1]) / (2 * (n + 2))
end
@assert c[1:9] == Q[1, 1//2, 1//8, -1//16, 3//128, -1//256, -3//1024, 7//2048, -61//32768]

cases = [
    (name = "about x₀ = 0", x0 = big(0), co = BigFloat.(a), xlims = (-1.5, 1.5),
     ylims = (0.0, 2.5), R = big(1), col = :royalblue, Rlbl = "|x| = 1 (R = 1)",
     sl = "S"),
    (name = "about x₀ = 1", x0 = big(1), co = sqrt(big(2)) .* BigFloat.(c), xlims = (-1.0, 3.0),
     ylims = (0.0, 3.5), R = sqrt(big(2)), col = :darkorange, Rlbl = "|x − 1| = √2 (R = √2)",
     sl = "S"),
]
psum(cs, N, x) = (t = x - cs.x0; s = zero(BigFloat); for n in N:-1:0; s = s * t + cs.co[n+1]; end; s)

# --- Grids: step 0.001 on each window ---
grids = [[big(cs.xlims[1]) + (big(cs.xlims[2]) - big(cs.xlims[1])) * i / round(Int, 1000 * (cs.xlims[2] - cs.xlims[1]))
          for i in 0:round(Int, 1000 * (cs.xlims[2] - cs.xlims[1]))] for cs in cases]
Sv  = [[[Float64(psum(cs, N, x)) for x in grids[j]] for N in Ns] for (j, cs) in enumerate(cases)]
err = [[[Float64(abs(psum(cs, N, x) - yexact(x))) for x in grids[j]] for N in Ns]
       for (j, cs) in enumerate(cases)]
yex = [Float64.(yexact.(g)) for g in grids]

# Interval about the centre on which the error is below tol: march out from x0
# in steps of 0.001 on each side, then bisect (no window clipping needed: checked).
function edge(cs, N, dir)
    g(x) = abs(psum(cs, N, x) - yexact(x)) - tol
    h = big"0.001" * dir
    x = cs.x0
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
edges = [[(edge(cs, N, -1), edge(cs, N, 1)) for N in Ns] for cs in cases]

# --- Report ---
for (j, cs) in enumerate(cases)
    println(cs.name, ":  R = ", fmtv(cs.R), ",  interval (", fmtv(cs.x0 - cs.R), ", ", fmtv(cs.x0 + cs.R), ")")
    for (k, N) in enumerate(Ns)
        lo, hi = edges[j][k]
        @assert big(cases[j].xlims[1]) < lo && hi < big(cases[j].xlims[2])
        outside = [Float64(x) for (x, v) in zip(grids[j], Sv[j][k]) if v < cs.ylims[1] || v > cs.ylims[2]]
        @printf("  N = %2d: err<1e-3 on [%s, %s]  max err in window %s  S_N leaves window at %d grid pts%s\n",
                N, fmtv(lo), fmtv(hi), fmt(maximum(err[j][k])), length(outside),
                isempty(outside) ? "" : @sprintf(" (|x - x0| >= %s)", fmt(minimum(abs.(outside .- Float64(cs.x0))))))
        back = [x for (x, e) in zip(grids[j], err[j][k]) if (x < lo || x > hi) && e < tol]
        isempty(back) || @printf("     error below tol again at %d grid points in [%s, %s]\n",
                                 length(back), fmt(first(back)), fmt(last(back)))
    end
end
@printf("x = 1.5: about 0, N = 40: S = %s, err %s;  about 1, N = 40: err %s\n",
        fmtv(psum(cases[1], 40, big"1.5")), fmt(abs(psum(cases[1], 40, big"1.5") - yexact(big"1.5"))),
        fmt(abs(psum(cases[2], 40, big"1.5") - yexact(big"1.5"))))

logdraw(e) = clamp(e, elims[1] / 10, elims[2] * 10)
shade!(p, a, b, yl; label="") = plot!(p, Shape([a, b, b, a], [yl[1], yl[1], yl[2], yl[2]]);
                                      color=:palegreen, alpha=0.45, linealpha=0, label=label)
circ(z0, r) = (θ = range(0, 2π, length=361); (z0 .+ r .* cos.(θ), r .* sin.(θ)))

function draw_frame(k)
    N = Ns[k]
    # complex plane
    pC = plot(xlims=(-1.3, 2.7), ylims=(-1.9, 1.9), aspect_ratio=:equal, framestyle=:box,
              xlabel="Re x", ylabel="Im x", legend=:outerbottom, legendfontsize=8,
              titlefontsize=11, grid=true, title="complex x-plane")
    hline!(pC, [0.0]; color=:black, lw=0.5, label="")
    vline!(pC, [0.0]; color=:black, lw=0.5, label="")
    for (j, cs) in enumerate(cases)
        cx, cy = circ(Float64(cs.x0), Float64(cs.R))
        plot!(pC, cx, cy; color=cs.col, lw=2, label="disk " * cs.name)
        lo, hi = Float64.(edges[j][k])
        off = j == 1 ? 0.07 : -0.07
        plot!(pC, [lo, hi], [off, off]; color=cs.col, lw=5, label="")
        scatter!(pC, [Float64(cs.x0)], [0.0]; color=cs.col, ms=5, markerstrokewidth=0, label="")
    end
    scatter!(pC, [0.0, 0.0], [1.0, -1.0]; color=:red, marker=:xcross, ms=9, markerstrokewidth=3,
             label="singular points ±i")
    annotate!(pC, [(0.12, 1.2, text("i", 10, :red, :left)), (0.12, -1.2, text("−i", 10, :red, :left))])
    annotate!(pC, [(-1.2, 1.7, text("bars: error < 10⁻³ (N = $N)", 8, :left))])

    tops = []; bots = []
    for (j, cs) in enumerate(cases)
        lo, hi = Float64.(edges[j][k])
        x0 = Float64(cs.x0); R = Float64(cs.R)
        xs = Float64.(grids[j])
        pT = plot(xlims=cs.xlims, ylims=cs.ylims, framestyle=:box, xlabel="x", ylabel="y",
                  legend=:top, legendfontsize=8, titlefontsize=10, grid=true)
        shade!(pT, lo, hi, cs.ylims; label="error < 10⁻³")
        vline!(pT, [x0 - R, x0 + R]; color=:gray30, ls=:dash, lw=1.5, label=cs.Rlbl)
        plot!(pT, xs, yex[j]; color=:magenta, lw=2.5, label="√(1 + x²)")
        plot!(pT, xs, ydraw.(Sv[j][k], Ref(cs.ylims)); color=cs.col, lw=2,
              label="$(cs.sl)$(sub(N))(x), $(cs.name)")
        title!(pT, "$(cs.name), N = $N:  error < 10⁻³ on [$(fmtv(lo)), $(fmtv(hi))]")

        pB = plot(xlims=cs.xlims, ylims=elims, yscale=:log10, framestyle=:box, xlabel="x",
                  ylabel="|$(cs.sl)_N(x) − √(1 + x²)|", legend=:top, legendfontsize=8,
                  titlefontsize=10, grid=true, yticks=10.0 .^ (-12:3:6))
        shade!(pB, lo, hi, elims)
        vline!(pB, [x0 - R, x0 + R]; color=:gray30, ls=:dash, lw=1.5, label="")
        for kk in 1:k-1
            plot!(pB, xs, logdraw.(err[j][kk]); color=:gray80, lw=1, label=kk == 1 ? "earlier N" : "")
        end
        hline!(pB, [1e-3]; color=:darkgreen, ls=:dash, lw=1.5, label="tolerance 10⁻³")
        plot!(pB, xs, logdraw.(err[j][k]); color=cs.col, lw=2, label="N = $N")
        title!(pB, "error of $(cs.sl)$(sub(N)) $(cs.name)")
        push!(tops, pT); push!(bots, pB)
    end
    l = @layout [a{0.3w} grid(2, 2)]
    plot(pC, tops[1], tops[2], bots[1], bots[2]; layout=l, size=(1500, 820),
         plot_title=title_str, plot_titlefontsize=12, left_margin=5Plots.mm,
         bottom_margin=4Plots.mm, background_color=:white)
end

anim = Animation()
for k in eachindex(Ns)
    draw_frame(k)
    frame(anim)
end
for _ in 1:2                                          # hold the last frame
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=2)
println("Saved: ", gif_name)
