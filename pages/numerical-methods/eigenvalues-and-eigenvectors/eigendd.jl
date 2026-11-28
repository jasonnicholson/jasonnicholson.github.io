# eigendd.jl
# Eigenvalues and Eigenvectors animation: the computation of the page's
# Example 11 section (not Mathews'), for every n = 11, ..., 40.
# A_n is the n x n transition matrix of the pattern of Mathews' Example 10:
# column j holds equal weights on rows j-1, j, j+1 (1/2, 1/2 in the first and
# last columns, 1/3 elsewhere). For each n:
#   * true eigenvalues: Sturm-sequence bisection on the symmetric tridiagonal
#     matrix similar to A_n, in 512-bit arithmetic (all are real);
#   * eigenvalue routine: Julia's eigvals (LAPACK) on Float64.(A_n);
#   * roots of the rounded characteristic polynomial: the exact rational
#     characteristic polynomial (three-term recurrence), its coefficients
#     rounded to Float64, roots found by Aberth-Ehrlich iteration in
#     Complex{BigFloat} at 512 bits (about 154 digits), so that the only error
#     is the rounding of the coefficients.
# Errors as in the page's table: both lists sorted by real part, the largest
# |Re(root) - lambda| over the pairs, and separately the largest |Im(root)|.
# Left panel: the roots in the complex plane against the true eigenvalues.
# Right panel (log scale): the two largest errors and the largest imaginary
# part against n, up to the current n.
# New animation: Mathews' Eigenvalues module has no animation, and Example 11's
# own matrix is lost from the archive.
# Produces: eigendd.gif

using Plots
using Printf
using LinearAlgebra
gr()
setprecision(BigFloat, 512)

const SUPS = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹']
sup(n) = (n < 0 ? "⁻" : "") * join(SUPS[d+1] for d in reverse(digits(abs(n))))
um(s) = replace(s, "-" => "−")
function tenpow(s)                              # "1.234e-07" -> "1.234 × 10⁻⁷"
    occursin('e', s) || return um(s)
    m, e = split(s, 'e')
    return um(m) * " × 10" * sup(parse(Int, e))
end
# Significant-figure labels; an exact 0 is stated as such
fmt(x) = x == 0 ? "0 (exact)" : tenpow(@sprintf("%#.2g", Float64(x)))

# --- Parameters ---
ns = 11:40
gif_name = "eigendd.gif"

function T(n)                                   # the transition matrix, exact
    A = zeros(Rational{BigInt}, n, n)
    for j in 1:n
        rows = [i for i in (j - 1, j, j + 1) if 1 <= i <= n]
        for i in rows
            A[i, j] = 1 // length(rows)
        end
    end
    A
end

# characteristic polynomial (monic, lowest degree first) of a tridiagonal matrix
function charpoly(A)
    n = size(A, 1)
    lin(q, c) = [-c * q; 0] .+ [0; q]           # (lambda - c) * q
    fm2 = Rational{BigInt}[1]
    fm1 = lin(fm2, A[1, 1])
    for k in 2:n
        t = lin(fm1, A[k, k])
        t[1:length(fm2)] .-= A[k, k-1] * A[k-1, k] .* fm2
        fm2, fm1 = fm1, t
    end
    fm1
end

# true eigenvalues: symmetric tridiagonal (diagonal d, off-diagonal e) by
# Sturm-count bisection; count(x) = number of eigenvalues < x
function sturm_eigs(d, e)
    n = length(d)
    function count(x)
        c = 0; q = d[1] - x
        c += q < 0
        for i in 2:n
            q = d[i] - x - e[i-1]^2 / (q == 0 ? eps(BigFloat) : q)
            c += q < 0
        end
        c
    end
    lo0 = minimum(d) - 2 * maximum(abs.(e)) - 1; hi0 = maximum(d) + 2 * maximum(abs.(e)) + 1
    ev = BigFloat[]
    for k in 1:n                                # k-th smallest
        lo, hi = lo0, hi0
        for _ in 1:320
            mid = (lo + hi) / 2
            count(mid) >= k ? (hi = mid) : (lo = mid)
        end
        push!(ev, (lo + hi) / 2)
    end
    ev
end

# Aberth-Ehrlich roots of a monic polynomial c (lowest degree first)
function aberth(c::Vector{BigFloat}, z0)
    n = length(c) - 1
    P(z) = foldr((a, acc) -> acc * z + a, c; init=zero(Complex{BigFloat}))
    dc = [k * c[k+1] for k in 1:n]
    dP(z) = foldr((a, acc) -> acc * z + a, dc; init=zero(Complex{BigFloat}))
    z = Complex{BigFloat}.(z0)
    for it in 1:5000
        maxstep = big(0.0)
        for i in 1:n
            r = P(z[i]) / dP(z[i])
            s = sum(1 / (z[i] - z[j]) for j in 1:n if j != i)
            w = r / (1 - r * s)
            z[i] -= w
            maxstep = max(maxstep, abs(w))
        end
        maxstep < big(10.0)^-60 && return z, it
    end
    error("Aberth did not converge (degree $n)")
end

results = []
for n in ns
    A = T(n)
    p = charpoly(A)
    # exact check of the recurrence against det(A - lambda I) at two points
    for x in (big(1) // 7, big(-2) // 3)
        det(A - x * I) == (-1)^n * sum(p[k+1] * x^k for k in 0:n) || error("charpoly n=$n")
    end
    d = BigFloat.(diag(A))
    e = [sqrt(BigFloat(A[k+1, k] * A[k, k+1])) for k in 1:n-1]
    ref = sturm_eigs(d, e)
    pr = BigFloat.(Float64.(p))                 # coefficients rounded to double
    # start near the true eigenvalues, all in the upper half-plane at different
    # heights: a start that is symmetric under conjugation cannot separate two
    # close real roots. The roots found do not depend on the start; it only
    # saves iterations.
    z, its = aberth(pr, [ref[k] + big(0.002) * k / n + im * big(0.01) * (1 + k / n) for k in 1:n])
    # a real root reached through complex iterates keeps a tiny imaginary part
    # (below 1e-200 here, printed below); parts below 1e-60 are set to exact 0,
    # while every genuinely complex root has |Im| > 1e-3
    snap = maximum(abs(imag(w)) for w in z if abs(imag(w)) < big(10.0)^-60; init=big(0.0))
    z = [abs(imag(w)) < big(10.0)^-60 ? Complex(real(w), big(0.0)) : w for w in z]
    z = sort(z, by=w -> (real(w), imag(w)))
    w = sort(eigvals(Float64.(A)), by=x -> (real(x), imag(x)))
    err_eig = maximum(abs.(BigFloat.(real.(w)) .- ref))
    im_eig = maximum(abs.(imag.(w)))
    err_root = maximum(abs.(real.(z) .- ref))
    im_root = maximum(abs.(imag.(z)))
    push!(results, (n=n, ref=Float64.(ref), roots=ComplexF64.(z), err_eig=Float64(err_eig),
                    im_eig=im_eig, err_root=Float64(err_root), im_root=Float64(im_root)))
    @printf("n=%2d  eig err %.2e (imag %.1e)  roots err %.3e  imag %.3e  (Aberth %d its)\n",
            n, err_eig, im_eig, err_root, im_root, its)
    @printf("      largest imaginary part set to 0: %.1e; smallest nonzero |Im|: %s\n", snap,
            any(!=(0), imag.(z)) ? @sprintf("%.3e", minimum(abs(imag(w)) for w in z if imag(w) != 0)) : "none")
end

# --- Frames ---
c_true, c_root, c_eig = :black, :crimson, :royalblue
imax = maximum(r.im_root for r in results)
rmin = minimum(minimum(real.(r.roots)) for r in results)
rmax = maximum(maximum(real.(r.roots)) for r in results)
xl = (-0.45, 1.1); yl = (-0.12, 0.12)
(rmin > xl[1] && rmax < xl[2] && imax < yl[2]) || error("a root lies outside the window")

function frame(i)
    r = results[i]
    p1 = plot(xlims=xl, ylims=yl, framestyle=:box, legend=:outerbottom, legendfontsize=7,
              xlabel="Re λ", ylabel="Im λ", grid=true, title="n = $(r.n): eigenvalues in the complex plane",
              titlefontsize=9)
    hline!(p1, [0]; color=:gray60, lw=0.8, label="")
    scatter!(p1, r.ref, zeros(length(r.ref)); marker=:vline, ms=9, color=c_true,
             markerstrokewidth=1.5, label="true eigenvalues (all real)")
    scatter!(p1, real.(r.roots), imag.(r.roots); marker=:circle, ms=3.5, color=c_root,
             markerstrokewidth=0, label="roots of p with coefficients rounded to double")
    p2 = plot(xlims=(10, 41), ylims=(1e-17, 1), yscale=:log10, framestyle=:box,
              legend=:outerbottom, legendfontsize=7, xlabel="n", ylabel="largest error",
              yticks=10.0 .^ (-16:2:0), minorgrid=false, xticks=10:5:40,
              title="errors against the true eigenvalues", titlefontsize=9)
    rs = results[1:i]
    nn = [q.n for q in rs]
    plot!(p2, nn, [q.err_root for q in rs]; color=c_root, lw=1.5, marker=:circle, ms=3,
          markerstrokewidth=0, label="roots of rounded p: max |Re r − λ|")
    pos = [q for q in rs if q.im_root > 0]
    plot!(p2, [q.n for q in pos], [q.im_root for q in pos]; color=c_root, ls=:dash, lw=1,
          marker=:utriangle, ms=4, markerstrokewidth=0, seriestype=(isempty(pos) ? :path : :path),
          label="roots of rounded p: max |Im r| (0 is not drawn)")
    plot!(p2, nn, [q.err_eig for q in rs]; color=c_eig, lw=1.5, marker=:diamond, ms=3,
          markerstrokewidth=0, label="eigenvalue routine (LAPACK, double)")
    plot(p1, p2; layout=grid(1, 2, widths=[0.55, 0.45]), size=(1100, 620),
         plot_title="Transition matrices of the Example 10 pattern: roots of the rounded characteristic polynomial vs an eigenvalue routine\n" *
                    "n = $(r.n):  roots of rounded p: max error " * fmt(r.err_root) *
                    ", max |Im| " * (r.im_root == 0 ? "0 (all roots real)" : fmt(r.im_root)) * ";  eigenvalue routine: max error " * fmt(r.err_eig),
         plot_titlefontsize=10, plot_titlevspan=0.1, left_margin=3Plots.mm,
         bottom_margin=4Plots.mm, background_color=:white)
end

frames = vcat(collect(eachindex(results)), fill(length(results), 3))
anim = @animate for i in frames
    frame(i)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=2)
println("Saved: $gif_name  (", length(frames), " frames)")
