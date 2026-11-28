# bairstowbb.jl
# Lin-Bairstow animation, Case 2: deflation finds every root of Mathews' quintic
# P(x) = x^5 + 6x^4 - 20x^2 + 22x + 8 (his Examples 1-3).
#   Stage 1: Lin-Bairstow on P from (r0, s0) = (-2, 3), his divisor x^2 + 2x - 3.
#   Stage 2: Lin-Bairstow on the cubic quotient from Mathews' suggested start
#            r0 = -a1/a2, s0 = -a0/a2 (coefficients of the cubic).
#   The last quotient is linear and gives the fifth root directly.
# Each stage stops when the step |dr| + |ds| falls below 1e-12. Double precision.
# The open circles are the roots of P from the eigenvalues of its companion matrix,
# an independent check on the roots that deflation finds.
# Produces: bairstowbb.gif

using Plots
using Printf
using LinearAlgebra
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
fmt(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%.4g", x)
um(s) = replace(s, "-" => "−")
fmte(x) = x == 0 ? "0 (double-precision zero)" : um(@sprintf("%.2e", x))
fmtu(x) = um(fmt(x))
f6(x) = um(@sprintf("%.6f", x))

# One Lin-Bairstow step. a = [a_n, ..., a_1, a_0] (descending).
# Returns the new (r, s), the quotient coefficients [b_n, ..., b_2] and the remainder b1, b0.
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
    return r + dr, s + ds, b[1:n-1], b1, b0
end

# Quadratic synthetic division only (quotient and remainder at a fixed (r, s))
function qdiv(a, r, s)
    n = length(a) - 1
    b = similar(a)
    b[1] = a[1]; b[2] = a[2] + r * b[1]
    for k in 3:n+1
        b[k] = a[k] + r * b[k-1] + s * b[k-2]
    end
    return b[1:n-1], b[n], b[n+1]
end

# Roots of x^2 - r x - s
roots2(r, s) = (z = sqrt(complex(r^2 + 4s)); ((r + z) / 2, (r - z) / 2))

# Run one stage: iterates until |dr| + |ds| < tol
function stage(a, r0, s0; tol=1e-12, maxit=50)
    rs = [r0]; ss = [s0]; b1s = Float64[]; b0s = Float64[]
    for it in 1:maxit
        rn, sn, _, b1, b0 = bairstow_step(a, rs[end], ss[end])
        push!(b1s, b1); push!(b0s, b0)
        push!(rs, rn); push!(ss, sn)
        abs(rn - rs[end-1]) + abs(sn - ss[end-1]) < tol && break
    end
    q, b1, b0 = qdiv(a, rs[end], ss[end])
    push!(b1s, b1); push!(b0s, b0)          # remainder at every iterate, including the last
    return rs, ss, b1s, b0s, q
end

# Polynomial as text, coefficients to 6 decimals, descending powers
const SUP = Dict(0 => "", 1 => "x", 2 => "x²", 3 => "x³", 4 => "x⁴", 5 => "x⁵")
function polystr(c)
    n = length(c) - 1
    out = ""
    for (i, ci) in enumerate(c)
        p = n - i + 1
        ci == 0 && continue
        mag = abs(ci)
        cs = (mag == 1 && p > 0) ? "" : (isinteger(mag) ? string(Int(mag)) : @sprintf("%.6f", mag))
        term = cs * SUP[p]
        out = out == "" ? (ci < 0 ? "−" * term : term) : out * (ci < 0 ? " − " : " + ") * term
    end
    return out
end
quadstr(r, s) = polystr([1.0, -r, -s])

# --- Mathews' quintic and his divisor ---
P = [1.0, 6, 0, -20, 22, 8]
r1_0, s1_0 = -2.0, 3.0

# --- Stage 1 ---
rs1, ss1, b1s1, b0s1, Q3 = stage(P, r1_0, s1_0)
# --- Stage 2: Mathews' start on the cubic Q3 = x^3 + a2 x^2 + a1 x + a0 ---
r2_0, s2_0 = -Q3[3] / Q3[2], -Q3[4] / Q3[2]
rs2, ss2, b1s2, b0s2, L1 = stage(Q3, r2_0, s2_0)
# --- Last factor: linear quotient L1 = x + c ---
xlin = -L1[2] / L1[1]

found1 = collect(roots2(rs1[end], ss1[end]))
found2 = collect(roots2(rs2[end], ss2[end]))
allfound = vcat(found1, found2, [complex(xlin)])

# Independent check: eigenvalues of the companion matrix of P
n = length(P) - 1
C = zeros(n, n); C[1, :] = -P[2:end] ./ P[1]
for i in 2:n; C[i, i-1] = 1.0; end
eroots = eigvals(C)
maxdiff = maximum(minimum(abs.(eroots .- z)) for z in allfound)

println("stage 1: ", length(rs1) - 1, " steps, (r, s) = ", (rs1[end], ss1[end]), " roots ", found1)
println("   cubic quotient ", Q3, "  start of stage 2 ", (r2_0, s2_0))
println("stage 2: ", length(rs2) - 1, " steps, (r, s) = ", (rs2[end], ss2[end]), " roots ", found2)
println("   linear quotient ", L1, " root ", xlin)
println("companion eigenvalues ", sort(eroots, by=z -> (real(z), imag(z))))
println("max distance deflation vs eigenvalues = ", maxdiff)
for (k, (r, s, b1, b0)) in enumerate(zip(rs1, ss1, b1s1, b0s1))
    @printf("S1 k=%d r=%.12f s=%.12f b1=%.3e b0=%.3e roots %s\n", k - 1, r, s, b1, b0, string(roots2(r, s)))
end
for (k, (r, s, b1, b0)) in enumerate(zip(rs2, ss2, b1s2, b0s2))
    @printf("S2 k=%d r=%.12f s=%.12f b1=%.3e b0=%.3e roots %s\n", k - 1, r, s, b1, b0, string(roots2(r, s)))
end

# --- Frame list: (stage, step) ; stage 3 = deflated after stage 1, 4 = final ---
frames = Tuple{Int,Int}[]
for k in eachindex(rs1); push!(frames, (1, k)); end
push!(frames, (3, 0))
for k in eachindex(rs2); push!(frames, (2, k)); end
append!(frames, fill((4, 0), 4))   # hold the final frame

xl = (-5.7, 2.7); yl = (-1.7, 1.7)
c1, c2, c3 = :royalblue, :darkorange, :green4
Pstr = "x⁵ + 6x⁴ − 20x² + 22x + 8"

function mark_found!(p, roots, col, lab)
    scatter!(p, real.(roots), imag.(roots); color=col, ms=9, markerstrokecolor=:black, label=lab)
end
function label_root!(p, z, col)
    s = abs(imag(z)) < 1e-12 ? f6(real(z)) :
        f6(real(z)) * (imag(z) > 0 ? " + " : " − ") * @sprintf("%.6f", abs(imag(z))) * "i"
    annotate!(p, real(z), imag(z) + (imag(z) < 0 ? -0.22 : 0.22), text(s, 8, col, :center))
end

anim = @animate for (st, k) in frames
    stage_title = st == 1 ? "stage 1: Lin-Bairstow on the quintic, step " * string(k - 1) :
                  st == 2 ? "stage 2: Lin-Bairstow on the cubic quotient, step " * string(k - 1) :
                  st == 3 ? "stage 1 converged: deflate, P(x) ≈ (quadratic)(cubic)" :
                            "stage 2 converged: the last quotient is linear; all five roots found"
    p1 = plot(xlims=xl, ylims=yl, aspect_ratio=:equal, framestyle=:box, legend=:bottomleft,
              xlabel="Re x", ylabel="Im x", title=stage_title, titlefontsize=10,
              legendfontsize=7, guidefontsize=9, tickfontsize=7)
    hline!(p1, [0]; color=:gray70, lw=1, label="")
    scatter!(p1, real.(eroots), imag.(eroots); color=:white, markerstrokecolor=:black, ms=12,
             markerstrokewidth=1, label="roots of P (companion matrix)")

    # trial roots and their trail in the current stage
    if st == 1 || st == 2
        rs, ss = st == 1 ? (rs1, ss1) : (rs2, ss2)
        for m in 2:k
            a0 = roots2(rs[m-1], ss[m-1]); a1 = roots2(rs[m], ss[m])
            for i in 1:2
                plot!(p1, [real(a0[i]), real(a1[i])], [imag(a0[i]), imag(a1[i])];
                      color=:red, lw=1, alpha=0.45, label="")
            end
            scatter!(p1, real.(collect(a0)), imag.(collect(a0)); color=:red, alpha=0.3, ms=3,
                     markerstrokewidth=0, label="")
        end
        z = collect(roots2(rs[k], ss[k]))
        scatter!(p1, real.(z), imag.(z); color=:red, ms=6, label="roots of x² − r x − s, step " * string(k - 1))
    end
    if st == 2 || st == 3 || st == 4
        mark_found!(p1, found1, c1, "stage 1 factor's roots")
        foreach(z -> label_root!(p1, z, c1), found1)
    end
    if st == 4
        mark_found!(p1, found2, c2, "stage 2 factor's roots")
        foreach(z -> label_root!(p1, z, c2), found2)
        mark_found!(p1, [complex(xlin)], c3, "root of linear factor")
        label_root!(p1, complex(xlin), c3)
    end

    # text panel: the polynomial being deflated, the trial factor and its remainder
    p2 = plot(xlims=(0, 1), ylims=(0, 1), framestyle=:none, legend=false, grid=false)
    lines = String[]
    if st == 1
        r, s = rs1[k], ss1[k]
        push!(lines, "dividing P(x) = " * Pstr * " by x² − r x − s, from (r₀, s₀) = (−2, 3), Mathews' divisor x² + 2x − 3")
        push!(lines, "step " * string(k - 1) * ":  r = " * um(@sprintf("%.9f", r)) * ",  s = " * um(@sprintf("%.9f", s)))
        push!(lines, "remainder b₁(x − r) + b₀:  b₁ = " * fmtu(b1s1[k]) * ",  b₀ = " * fmtu(b0s1[k]))
        push!(lines, "factors found: none yet")
    elseif st == 3
        push!(lines, "P(x) ≈ (" * quadstr(rs1[end], ss1[end]) * ") (" * polystr(Q3) * ")")
        push!(lines, "remainder at the last step: b₁ = " * fmtu(b1s1[end]) * ",  b₀ = " * fmtu(b0s1[end]) * " (dropped)")
        push!(lines, "next: Mathews' start on the cubic, r₀ = −a₁/a₂ = " * f6(r2_0) * ",  s₀ = −a₀/a₂ = " * f6(s2_0))
        push!(lines, "factors found: " * quadstr(rs1[end], ss1[end]))
    elseif st == 2
        r, s = rs2[k], ss2[k]
        push!(lines, "dividing the cubic " * polystr(Q3) * " by x² − r x − s, from Mathews' start (r₀, s₀) = (" *
                     f6(r2_0) * ", " * f6(s2_0) * ")")
        push!(lines, "step " * string(k - 1) * ":  r = " * um(@sprintf("%.9f", r)) * ",  s = " * um(@sprintf("%.9f", s)))
        push!(lines, "remainder b₁(x − r) + b₀:  b₁ = " * fmtu(b1s2[k]) * ",  b₀ = " * fmtu(b0s2[k]))
        push!(lines, "factors found: " * quadstr(rs1[end], ss1[end]))
    else
        push!(lines, "P(x) ≈ (" * quadstr(rs1[end], ss1[end]) * ") (" * quadstr(rs2[end], ss2[end]) * ") (" *
                     polystr(L1) * ")")
        push!(lines, "steps: " * string(length(rs1) - 1) * " in stage 1, " * string(length(rs2) - 1) *
                     " in stage 2 (each stops when |Δr| + |Δs| < 10⁻¹²)")
        push!(lines, "largest distance from a deflation root to a companion-matrix root: " * fmte(maxdiff))
    end
    for (i, ln) in enumerate(lines)
        annotate!(p2, 0.01, 0.88 - 0.24 * (i - 1), text(ln, 9, :left, :black))
    end

    plot(p1, p2; layout=grid(2, 1, heights=[0.74, 0.26]), size=(1000, 700), left_margin=6Plots.mm,
         plot_title="Lin-Bairstow deflation of P(x) = " * Pstr, plot_titlefontsize=12,
         background_color=:white)
end

gif(anim, joinpath(@__DIR__, "bairstowbb.gif"); fps=1)
println("Saved: bairstowbb.gif")
