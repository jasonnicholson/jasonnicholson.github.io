# bigoaa.jl
# Big "O" Truncation Error animation: errors of the Taylor polynomials P1, P2, P3 of e^h about 0
#   P1(h) = 1 + h,  P2(h) = 1 + h + h^2/2,  P3(h) = 1 + h + h^2/2 + h^3/6   (P3 is the e^h expansion in Mathews' Example 4)
# against h on log-log axes, with E_n(h) = e^h - P_n(h) = O(h^(n+1)), and the ratio |E_n(h)|/h^(n+1),
# which stays bounded and tends to 1/(n+1)! = 1/2, 1/6, 1/24. New animation; Mathews made none.
# h halves from frame to frame: h = 2^-k, k = 0, 1, ..., 10 (h = 1 down to 2^-10 = 0.0009765625).
# The errors are computed in 256-bit BigFloat arithmetic: in double precision e^h - P3(h) loses
# accuracy to cancellation (relative error 4e-3 at h = 2^-10), which would spoil the labels.
# Produces: bigoaa.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0;
# "#" keeps trailing zeros, so every label shows four significant figures
fmt(x) = x == 0 ? "0 (double-precision zero)" : @sprintf("%#.4g", x)
# Halving factor E(2h)/E(h) (between 4 and 18 here): three decimals
ffac(x) = @sprintf("%.3f", x)
# Exponent of 2 as superscript digits, for the title (h = 2^-k is printed exactly)
supk(k) = k == 0 ? "⁰" : "⁻" * join(("⁰¹²³⁴⁵⁶⁷⁸⁹"[nextind("⁰¹²³⁴⁵⁶⁷⁸⁹", 0, d + 1)] for d in reverse(digits(k))))

setprecision(BigFloat, 256)

# --- Approximations and their errors (BigFloat, then rounded to Float64 for plotting) ---
P(n, h::BigFloat) = sum(h^j / factorial(big(j)) for j in 0:n)
E(n, h::Float64)  = Float64(exp(big(h)) - P(n, big(h)))     # h is a power of 2 or a grid point, exact in BigFloat

orders = 1:3                                   # P1, P2, P3; error order p = n + 1
cols   = [:royalblue, :darkorange, :magenta]
mks    = [:circle, :square, :diamond]
pname  = ["P₁(h) = 1 + h", "P₂(h) = 1 + h + h²/2", "P₃(h) = 1 + h + h²/2 + h³/6"]
psup   = ["²", "³", "⁴"]
psub   = ["₁", "₂", "₃"]
lims   = [1 / 2, 1 / 6, 1 / 24]                # limits of |E_n(h)|/h^(n+1): 1/(n+1)!
limtxt = ["1/2", "1/6", "1/24"]

K   = 10                                       # frames k = 0..K, h = 2^-k
hk  = [2.0^(-k) for k in 0:K]
Ek  = [E(n, h) for n in orders, h in hk]       # errors at the frame values of h (all positive)
Rk  = [Ek[n, j] / hk[j]^(n + 1) for n in orders, j in eachindex(hk)]

# Smooth curves: 20 log-spaced points per halving, which include every frame value of h
NS  = 20
hg  = [2.0^(-i / NS) for i in 0:K*NS]
Eg  = [E(n, h) for n in orders, h in hg]
Rg  = [Eg[n, i] / hg[i]^(n + 1) for n in orders, i in eachindex(hg)]

all(Ek .> 0) && all(Eg .> 0) || error("nonpositive error cannot be drawn on log axes")

xl  = (5.0e-4, 1.6)
ylE = (1.0e-15, 1.0e1)
ylR = (3.0e-2, 1.2)
xtk = ([1e-3, 1e-2, 1e-1, 1.0], ["10⁻³", "10⁻²", "10⁻¹", "1"])
href = [xl[1], xl[2]]

function frame(k)
    j  = k + 1                                 # index of the newest h
    ig = 1:(k * NS + 1)                        # grid points from h = 1 down to h = 2^-k

    # Left: |E_n(h)| on log-log axes with the reference lines h^(n+1) (C = 1)
    p1 = plot(xscale=:log10, yscale=:log10, xlims=xl, ylims=ylE, xticks=xtk,
              yticks=(10.0 .^ (-14:2:0), ["10⁻¹⁴", "10⁻¹²", "10⁻¹⁰", "10⁻⁸", "10⁻⁶", "10⁻⁴", "10⁻²", "1"]),
              xlabel="h", ylabel="|E(h)| = |eʰ − Pₙ(h)|", title="errors (dashed: h², h³, h⁴)",
              titlefontsize=10, legend=:bottomright, legendfontsize=8,
              grid=true, framestyle=:box)
    for n in orders
        plot!(p1, href, href .^ (n + 1); color=cols[n], ls=:dash, lw=1, alpha=0.6, label="")
    end
    for n in orders
        plot!(p1, hg[ig], Eg[n, ig]; color=cols[n], lw=2, label=pname[n] * ",  O(h" * psup[n] * ")")
        scatter!(p1, hk[1:j], Ek[n, 1:j]; color=cols[n], marker=mks[n], ms=3, msw=0, label="")
        scatter!(p1, [hk[j]], [Ek[n, j]]; color=cols[n], marker=mks[n], ms=7, msw=1, label="")
    end
    for n in orders
        fac = k == 0 ? "–" : ffac(Ek[n, j-1] / Ek[n, j])
        annotate!(p1, 6.5e-4, 10.0^(0.4 - 1.1 * (n - 1)),
                  text("P" * psub[n] * ":  |E| = " * fmt(Ek[n, j]) * ",   E(2h)/E(h) = " * fac,
                       cols[n], 8, :left))
    end

    # Right: |E_n(h)| / h^(n+1), bounded and tending to 1/(n+1)!
    p2 = plot(xscale=:log10, yscale=:log10, xlims=xl, ylims=ylR, xticks=xtk,
              yticks=([0.04, 0.05, 0.1, 0.2, 0.5, 1.0], ["0.04", "0.05", "0.1", "0.2", "0.5", "1"]),
              xlabel="h", ylabel="|E(h)| / hᵖ", title="ratio |E(h)|/hᵖ  (dotted: limits 1/2, 1/6, 1/24)",
              titlefontsize=10, legend=false, grid=true, framestyle=:box)
    for n in orders
        plot!(p2, href, [lims[n], lims[n]]; color=cols[n], ls=:dot, lw=1.5)
        annotate!(p2, 0.9, lims[n] / 1.13, text(limtxt[n], cols[n], 8, :right))
    end
    for n in orders
        plot!(p2, hg[ig], Rg[n, ig]; color=cols[n], lw=2)
        scatter!(p2, hk[1:j], Rk[n, 1:j]; color=cols[n], marker=mks[n], ms=3, msw=0)
        scatter!(p2, [hk[j]], [Rk[n, j]]; color=cols[n], marker=mks[n], ms=7, msw=1)
        annotate!(p2, 6.5e-4, lims[n] * 1.15,
                  text("P" * psub[n] * ":  |E|/h" * psup[n] * " = " * fmt(Rk[n, j]), cols[n], 8, :left))
    end

    plot(p1, p2; layout=(1, 2), size=(1100, 500), left_margin=5Plots.mm, bottom_margin=5Plots.mm,
         background_color=:white,
         plot_title="Taylor polynomials of eʰ about 0:  h = 2" * supk(k) * " = " * (k == 0 ? "1" : string(hk[j])),
         plot_titlefontsize=12)
end

anim = @animate for k in vcat(0:K, fill(K, 2))        # last frame shown three times
    frame(k)
end

gif(anim, joinpath(@__DIR__, "bigoaa.gif"); fps=1)
println("Saved: bigoaa.gif")
