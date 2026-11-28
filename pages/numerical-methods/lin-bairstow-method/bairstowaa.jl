# bairstowaa.jl
# Lin-Bairstow animation, Case 1: Mathews' Example 4, P(x) = x^4 + x^3 + 3x^2 + 4x + 6,
# from (r0, s0) = (-2.1, -1.9), five steps as in his Bairstow[r0, s0, 5].
# Panels: the (r, s) iterates (zoomed per frame about the limit (-2, -2)), the roots of
# the trial factor x^2 - r x - s in the complex plane, a per-frame zoom on its upper root,
# and log10 of the error ||(r + 2, s + 2)||.
# The iteration runs in 256-bit BigFloat so that errors below double-precision round-off
# (1.4e-17 at step 4, 3.2e-35 at step 5) are the method's own, not round-off.
# Produces: bairstowaa.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
fmt(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%.4g", x)
# Unicode minus for labels
um(s) = replace(s, "-" => "−")
fmte(x) = um(@sprintf("%.2e", x))

setprecision(BigFloat, 256)

# One Lin-Bairstow step. a = [a_n, ..., a_1, a_0] (descending).
# b_n = a_n, b_{n-1} = a_{n-1} + r b_n, b_k = a_k + r b_{k+1} + s b_{k+2};
# c's by the same recursion on the b's; Cramer's rule on
# [c1 c2; c2 c3] [dr; ds] = -[b0; b1].
function bairstow_step(a, r, s)
    n = length(a) - 1
    b = similar(a); c = similar(a)
    b[1] = a[1]; b[2] = a[2] + r * b[1]
    for k in 3:n+1
        b[k] = a[k] + r * b[k-1] + s * b[k-2]
    end
    c[1] = b[1]; c[2] = b[2] + r * c[1]
    for k in 3:n
        c[k] = b[k] + r * c[k-1] + s * c[k-2]
    end
    b0, b1 = b[n+1], b[n]
    c1, c2, c3 = c[n], c[n-1], c[n-2]
    d0 = c1 * c3 - c2^2
    dr = (-b0 * c3 + b1 * c2) / d0
    ds = (-b1 * c1 + b0 * c2) / d0
    return r + dr, s + ds
end

# Roots of x^2 - r x - s: (r +/- sqrt(r^2 + 4s)) / 2, upper (Im >= 0) first
roots2(r, s) = (z = sqrt(complex(r^2 + 4s)); ((r + z) / 2, (r - z) / 2))

# --- Parameters (Mathews, Example 4) ---
a = BigFloat[1, 1, 3, 4, 6]
r0 = BigFloat(-21) / 10
s0 = BigFloat(-19) / 10
nsteps = 5
rlim, slim = BigFloat(-2), BigFloat(-2)          # x^2 + 2x + 2
xlim_root = complex(BigFloat(-1), BigFloat(1))  # its upper root -1 + i

# --- Iterates ---
rs = [r0]; ss = [s0]
for j in 1:nsteps
    rn, sn = bairstow_step(a, rs[end], ss[end])
    push!(rs, rn); push!(ss, sn)
end
# deviations from the limit, exact in BigFloat, then stored as Float64 (no underflow here)
dr = Float64.(rs .+ 2); ds = Float64.(ss .+ 2)
err = Float64.(hypot.(rs .+ 2, ss .+ 2))
xup = [roots2(rs[j], ss[j])[1] for j in eachindex(rs)]
dx = ComplexF64.(xup .- xlim_root)
xroots = [ComplexF64.(roots2(rs[j], ss[j])) for j in eachindex(rs)]

for j in eachindex(rs)
    @printf("j=%d  r=%.12f  s=%.12f  err=%.3e  upper root %.10f%+.10fi  |dev|=%.3e\n",
            j - 1, Float64(rs[j]), Float64(ss[j]), err[j], real(xroots[j][1]), imag(xroots[j][1]), abs(dx[j]))
end

# Roots of P: -1 +/- i (the factor) and 1/2 +/- (sqrt(11)/2) i (the quotient x^2 - x + 3)
qroots = [0.5 + sqrt(11) / 2 * im, 0.5 - sqrt(11) / 2 * im]
froots = [-1.0 + 1.0im, -1.0 - 1.0im]

sub = Dict('0' => '₀', '1' => '₁', '2' => '₂', '3' => '₃', '4' => '₄', '5' => '₅')
jsub(j) = join(sub[c] for c in string(j))
sup = Dict('0' => '⁰', '1' => '¹', '2' => '²', '3' => '³', '4' => '⁴', '5' => '⁵',
           '6' => '⁶', '7' => '⁷', '8' => '⁸', '9' => '⁹', '-' => '⁻')
# axis unit for a zoom window of half-width w: 10^k with k = floor(log10(w))
unitexp(w) = floor(Int, log10(w))
unitlabel(k) = k == 0 ? "" : "  (× 10" * join(sup[c] for c in string(k)) * ")"

# zoom half-width for frame j: covers the previous and the current point
function halfwidth(v, j)
    m = j == 1 ? v[1] : max(v[j-1], v[j])
    return 1.3 * m
end

frames = vcat(1:nsteps+1, fill(nsteps + 1, 3))   # hold the last frame
anim = @animate for j in frames
    jj = j - 1

    # (A) (r, s) plane, deviations from (-2, -2), zoomed per frame
    w = halfwidth(max.(abs.(dr), abs.(ds)), j)
    k = unitexp(w); u = 10.0^k
    pA = plot(xlims=(-w / u, w / u), ylims=(-w / u, w / u), aspect_ratio=:equal,
              xlabel="r + 2" * unitlabel(k), ylabel="s + 2" * unitlabel(k), framestyle=:box,
              legend=:outerright, title="(r, s) − (−2, −2), zoomed to ±" * fmte(w), titlefontsize=10,
              legendfontsize=7, guidefontsize=9, tickfontsize=7)
    hline!(pA, [0]; color=:gray80, lw=1, label="")
    vline!(pA, [0]; color=:gray80, lw=1, label="")
    plot!(pA, dr[1:j] ./ u, ds[1:j] ./ u; color=:steelblue, lw=1.5, label="")
    if j > 1
        scatter!(pA, [dr[j-1] / u], [ds[j-1] / u]; color=:white, markerstrokecolor=:steelblue,
                 ms=6, label="(r" * jsub(jj - 1) * ", s" * jsub(jj - 1) * ")")
    end
    scatter!(pA, [0.0], [0.0]; color=:black, marker=:xcross, ms=7, label="limit (−2, −2)")
    scatter!(pA, [dr[j] / u], [ds[j] / u]; color=:red, ms=6,
             label="(r" * jsub(jj) * ", s" * jsub(jj) * ")")

    # (B) complex plane, fixed window: roots of the trial factor
    pB = plot(xlims=(-1.8, 1.2), ylims=(-2.0, 2.0), aspect_ratio=:equal,
              xlabel="Re x", ylabel="Im x", framestyle=:box, legend=:outerright,
              title="roots of x² − r" * jsub(jj) * "x − s" * jsub(jj), titlefontsize=10,
              legendfontsize=7, guidefontsize=9, tickfontsize=7)
    hline!(pB, [0]; color=:gray80, lw=1, label="")
    scatter!(pB, real.(qroots), imag.(qroots); color=:white, markerstrokecolor=:gray50,
             ms=7, label="roots of Q = x² − x + 3")
    scatter!(pB, real.(froots), imag.(froots); color=:white, markerstrokecolor=:black,
             ms=8, label="−1 ± i")
    for k in 1:j
        up = xroots[k]
        plot!(pB, [real(xroots[max(k - 1, 1)][1]), real(up[1])],
              [imag(xroots[max(k - 1, 1)][1]), imag(up[1])]; color=:red, lw=1, alpha=0.5, label="")
        plot!(pB, [real(xroots[max(k - 1, 1)][2]), real(up[2])],
              [imag(xroots[max(k - 1, 1)][2]), imag(up[2])]; color=:red, lw=1, alpha=0.5, label="")
    end
    scatter!(pB, real.(collect(xroots[j])), imag.(collect(xroots[j])); color=:red, ms=5,
             label="trial roots, step " * string(jj))

    # (C) zoom on the upper trial root, relative to -1 + i
    wz = halfwidth(abs.(dx), j)
    kz = unitexp(wz); uz = 10.0^kz
    pC = plot(xlims=(-wz / uz, wz / uz), ylims=(-wz / uz, wz / uz), aspect_ratio=:equal,
              xlabel="Re x₊ + 1" * unitlabel(kz), ylabel="Im x₊ − 1" * unitlabel(kz), framestyle=:box,
              legend=:outerright, title="upper root: |x₊ − (−1 + i)| = " * fmte(abs(dx[j])), titlefontsize=10,
              legendfontsize=7, guidefontsize=9, tickfontsize=7)
    hline!(pC, [0]; color=:gray80, lw=1, label="")
    vline!(pC, [0]; color=:gray80, lw=1, label="")
    plot!(pC, real.(dx[1:j]) ./ uz, imag.(dx[1:j]) ./ uz; color=:red, lw=1.5, alpha=0.6, label="")
    if j > 1
        scatter!(pC, [real(dx[j-1]) / uz], [imag(dx[j-1]) / uz]; color=:white, markerstrokecolor=:red,
                 ms=6, label="x₊, step " * string(jj - 1))
    end
    scatter!(pC, [0.0], [0.0]; color=:black, marker=:xcross, ms=7, label="−1 + i")
    scatter!(pC, [real(dx[j]) / uz], [imag(dx[j]) / uz]; color=:red, ms=6,
             label="x₊, step " * string(jj))

    # (D) log10 error
    pD = plot(xlims=(-0.4, nsteps + 0.6), ylims=(-38, 2), framestyle=:box, legend=:bottomleft,
              xlabel="step j", ylabel="log₁₀ ‖(rⱼ + 2, sⱼ + 2)‖",
              title="error: exponent roughly doubles each step from j = 2 on",
              titlefontsize=10, legendfontsize=7, guidefontsize=9, tickfontsize=7,
              xticks=0:nsteps)
    le = log10.(err)
    plot!(pD, 0:jj, le[1:j]; color=:purple, lw=1.5, marker=:circle, ms=5, label="error (256-bit arithmetic)")
    for k in 1:j
        if k == nsteps + 1   # last point: label to its left so it stays inside the frame
            annotate!(pD, k - 1 - 0.15, le[k], text(fmte(err[k]), 7, :right, :purple))
        else
            annotate!(pD, k - 1 + 0.12, le[k] + (k == 1 ? -2.6 : 2.6), text(fmte(err[k]), 7, :left, :purple))
        end
    end

    plot(pA, pB, pC, pD; layout=(2, 2), size=(1000, 1040),
         plot_title="Lin-Bairstow on P(x) = x⁴ + x³ + 3x² + 4x + 6 from (r₀, s₀) = (−2.1, −1.9)\nstep " * string(jj) *
                    ": (r" * jsub(jj) * ", s" * jsub(jj) * ") = (" * um(@sprintf("%.12f", rs[j])) * ", " *
                    um(@sprintf("%.12f", ss[j])) * ")",
         plot_titlefontsize=11, background_color=:white, left_margin=4Plots.mm, bottom_margin=4Plots.mm)
end

gif(anim, joinpath(@__DIR__, "bairstowaa.gif"); fps=1)
println("Saved: bairstowaa.gif")
