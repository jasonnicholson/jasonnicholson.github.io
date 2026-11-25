# powerdd.jl
# Power Method animation: the Markov chains of Mathews' Examples 4 and 5,
#   P_(k+1) = A P_k   (the power method without normalization),
# Example 4: A = [0.4 0.3 0.1; 0.3 0.5 0.3; 0.3 0.2 0.6], P0 = (2000, 6000, 4000),
# Example 5: A = [0.4 0.3 0.1; 0.4 0.5 0.3; 0.2 0.2 0.6], P0 = (3400, 2400, 5000),
# one month per frame, k = 0, ..., 12 (Mathews prints P_0..P_11 for Example 4
# and P_0..P_12 for Example 5; Example 4 is carried one month further here so
# that both chains run for the same number of frames).
# New animation: Mathews' Power Method module has no animation.
# Left and middle panels: the numbers of users of brands X, Y, Z as bars, with
# the limiting distribution V1 (the eigenvector for lambda = 1 scaled to the
# total of P0) as black marks. Right panel: the largest deviation
# max_i |(P_k - V1)_i| of each chain on a log scale.
# All arithmetic is exact (Rational{BigInt}).
# Produces: powerdd.gif

using Plots
using Printf
gr()

const SUPS = ['⁰', '¹', '²', '³', '⁴', '⁵', '⁶', '⁷', '⁸', '⁹']
sup(n) = (n < 0 ? "⁻" : "") * join(SUPS[d+1] for d in reverse(digits(abs(n))))
const SUBS = ['₀', '₁', '₂', '₃', '₄', '₅', '₆', '₇', '₈', '₉']
sub(n) = join(SUBS[d+1] for d in reverse(digits(n)))
um(s) = replace(s, "-" => "−")
function tenpow(s)
    occursin('e', s) || return um(s)
    m, e = split(s, 'e')
    return um(m) * " × 10" * sup(parse(Int, e))
end
# Significant-figure labels (exact arithmetic, so a zero is an exact zero)
fmt(x) = x == 0 ? "0 (exact)" : tenpow(@sprintf("%.4g", Float64(x)))
fmtp(x) = tenpow(@sprintf("%.10g", Float64(x)))         # populations

# --- Parameters (Mathews' Examples 4 and 5) ---
q(x) = Rational{BigInt}(x)
A4 = q.([4 3 1; 3 5 3; 3 2 6]) // 10
P04 = q.([2000, 6000, 4000])
V4 = q.([3000, 4500, 4500])
A5 = q.([4 3 1; 4 5 3; 2 2 6]) // 10
P05 = q.([3400, 2400, 5000])
V5 = q.([2800, 4400, 3600])
n_months = 12
gif_name = "powerdd.gif"
A4 * V4 == V4 && A5 * V5 == V5 || error("V is not a fixed vector")
sum(P04) == sum(V4) && sum(P05) == sum(V5) || error("totals differ")

function chain(A, P0, n)
    Ps = [P0]
    for k in 1:n
        push!(Ps, A * Ps[end])
    end
    return Ps
end
P4 = chain(A4, P04, n_months)
P5 = chain(A5, P05, n_months)
dev4 = [Float64(maximum(abs.(P - V4))) for P in P4]
dev5 = [Float64(maximum(abs.(P - V5))) for P in P5]
all(>(0), dev4) && all(>(0), dev5) || error("a deviation is zero")
all(sum(P) == 12000 for P in P4) && all(sum(P) == 10800 for P in P5) ||
    error("total not preserved")

# --- Frames ---
brands = ["X", "Y", "Z"]
c4, c5 = :steelblue, :seagreen
function bars(Ps, V, k, col, name)
    P = Ps[k+1]
    p = plot(xlims=(0.4, 3.6), ylims=(0, 7500), framestyle=:box,
             xticks=(1:3, brands), xlabel="brand", ylabel="users",
             legend=:topright, legendfontsize=7, titlefontsize=9, grid=false)
    bar!(p, 1:3, Float64.(P); bar_width=0.6, color=col, linecolor=col,
         label="P" * sub(k))
    for i in 1:3
        v = Float64(V[i])
        plot!(p, [i - 0.4, i + 0.4], [v, v]; color=:black, lw=2.5,
              label=(i == 1 ? "limit V₁ = (" * join(Int.(V), ", ") * ")" : ""))
    end
    title!(p, name * ", month k = $k\nP" * sub(k) * " = (" *
              join(fmtp.(P), ", ") * ")")
    p
end
function frame(k)
    pA = bars(P4, V4, k, c4, "Example 4")
    pB = bars(P5, V5, k, c5, "Example 5")
    pC = plot(xlims=(-0.5, n_months + 0.5), ylims=(1e-4, 1e4), yscale=:log10,
              framestyle=:box, xlabel="month k", ylabel="max |(Pₖ − V₁)ᵢ|",
              legend=:bottomleft, legendfontsize=7, titlefontsize=10,
              yticks=10.0 .^ (-4:1:4), minorgrid=false)
    kr = 0:n_months
    plot!(pC, kr, dev4[end] .* (10 / 3) .^ (n_months .- kr); color=:gray, ls=:dash,
          lw=1, label="slopes 0.3ᵏ and 0.4ᵏ")
    plot!(pC, kr, dev5[end] .* 2.5 .^ (n_months .- kr); color=:gray, ls=:dash,
          lw=1, label="")
    plot!(pC, 0:k, dev4[1:k+1]; color=c4, lw=2, marker=:circle, ms=4,
          markerstrokewidth=0, label="Example 4 (λ₂ = 0.3)")
    plot!(pC, 0:k, dev5[1:k+1]; color=c5, lw=2, marker=:diamond, ms=4.5,
          markerstrokewidth=0, label="Example 5 (λ₂ = 0.4)")
    title!(pC, "Largest deviation from the limit\nEx. 4: " * fmt(dev4[k+1]) *
               ",  Ex. 5: " * fmt(dev5[k+1]))
    plot(pA, pB, pC; layout=(1, 3), size=(1350, 520),
         plot_title="Markov chains (power method without normalization), Mathews' Examples 4 and 5:  Pₖ₊₁ = A Pₖ",
         plot_titlefontsize=11, left_margin=5Plots.mm, bottom_margin=6Plots.mm,
         background_color=:white)
end

frames = vcat(collect(0:n_months), fill(n_months, 3))     # hold the last frame
anim = @animate for k in frames
    frame(k)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=1.5)
println("Saved: $gif_name  (", length(frames), " frames)")
println("dev4 = ", dev4)
println("dev5 = ", dev5)
