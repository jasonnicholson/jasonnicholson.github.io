# logisticbb.jl
# Logistic Curve animation: true least squares by the Gauss-Newton method
# (Example 5). The curve y = L / (1 + c e^{a (t - 1900)}) is fitted to the
# census data 1900-1990 (millions) by minimising
# E(L, c, a) = sum (y_k - f(t_k))^2, starting from the data linearization
# fit with L = 800 (Example 1), with the undamped step (9),
# J^T J dp = J^T r, one frame per iterate k = 0, 1, ..., 10.
# Left: the curve of iterate k on a long time range, with its limit L_k
# (dotted) and its inflection point (t*, L_k/2), the previous iterate in gray
# and the census points. Top right: the residuals y_k - f(t_k) at the census
# years for iterate k, with those of the previous iterate as open circles.
# Bottom right: how far iterate k is from the minimum, E_k - E_min and
# |L_k - L*| on a log scale. The minimiser (L*, c*, a*) and E_min are the
# limit of the same iteration, run to 80 steps.
# All arithmetic in 256-bit BigFloat.
# Produces: logisticbb.gif

using Plots
using Printf
using LinearAlgebra
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))
fmt7(x) = x == 0 ? "0" : um(@sprintf("%.7g", Float64(x)))
fmte(x) = x == 0 ? "0" : um(@sprintf("%.3e", Float64(x)))

setprecision(BigFloat, 256)

# --- Data (Mathews' Example 1) ---
gif_name = "logisticbb.gif"
years = 1900:10:1990
pop   = [76094000, 92407000, 106461000, 123076741, 132122446,
         152271417, 180671158, 205052174, 227224681, 249464396]
yk = [BigFloat(p) / 10^6 for p in pop]              # millions
Xk = [BigFloat(t - 1900) for t in years]

model(p, X) = p[1] / (1 + p[2] * exp(p[3] * X))
resid(p) = [yk[i] - model(p, Xk[i]) for i in eachindex(Xk)]
Efun(p) = sum(resid(p) .^ 2)

# --- Starting values: data linearization with L = 800 (Example 1) ---
function linfit(L)
    L = BigFloat(L)
    Y = [log(L / v - 1) for v in yk]
    n = length(Xk)
    sx, sxx, sy, sxy = sum(Xk), sum(Xk .^ 2), sum(Y), sum(Xk .* Y)
    A = (n * sxy - sx * sy) / (n * sxx - sx^2)
    B = (sy - A * sx) / n
    return [L, exp(B), A]                            # (L, c, a)
end

# --- Gauss-Newton step (9) ---
function gn_step(p)
    L, c, a = p
    J = zeros(BigFloat, length(Xk), 3)
    for i in eachindex(Xk)
        e = exp(a * Xk[i]); D = 1 + c * e
        J[i, :] = [1 / D, -L * e / D^2, -L * c * Xk[i] * e / D^2]
    end
    return p + (J' * J) \ (J' * resid(p))
end

K = 10                                               # iterates shown
P = [linfit(800)]
for k in 1:80
    push!(P, gn_step(P[end]))
end
pstar = P[end]
Emin  = Efun(pstar)
Es    = [Efun(p) for p in P[1:K+1]]
tstar(p) = 1900 + log(p[2]) / (-p[3])                # inflection point (3)

@printf("minimum: L* = %.12f, c* = %.12f, a* = %.14f, E_min = %.12f, change in last step %.3e\n",
        pstar[1], pstar[2], pstar[3], Emin, Float64(maximum(abs.(P[end] - P[end-1]))))
for k in 0:K
    p = P[k+1]
    @printf("k = %2d: L = %.4f, c = %.6f, a = %.8f, E = %.6f, E - Emin = %s, |L - L*| = %s, t* = %.2f, max|r| = %.4f\n",
            k, p[1], p[2], p[3], Es[k+1], fmte(Es[k+1] - Emin), fmte(abs(p[1] - pstar[1])),
            tstar(p), maximum(abs.(resid(p))))
end

# Windows
tlims = (1880.0, 2200.0); ylims = (0.0, 850.0)
rlims = (-9.0, 9.0)
klims = (-0.5, K + 0.5)
dlims = (1e-30, 1e3)
tplot = range(tlims[1], tlims[2], length=400)
cur_col, prev_col = :blue, :gray55

pstr(p) = um(@sprintf("L = %.4f,  c = %.7g,  a = %.7g", p[1], p[2], p[3]))

function draw_frame(k)
    p = P[k+1]
    # Left: the curve on a long range
    pL = plot(xlims=tlims, ylims=ylims, framestyle=:box, grid=true, xlabel="year t",
              ylabel="population (millions)", legend=:bottomright, legendfontsize=8,
              titlefontsize=10, title="iterate k = $k:  " * pstr(p))
    if k > 0
        q = P[k]
        plot!(pL, tplot, Float64.(model.(Ref(q), tplot .- 1900)); color=prev_col, lw=1.5,
              ls=:dash, label="previous iterate k = $(k-1), L = $(fmt7(q[1]))")
    end
    hline!(pL, [Float64(p[1])]; color=cur_col, ls=:dot, lw=1.2,
           label="limit L = $(fmt7(p[1]))")
    plot!(pL, tplot, Float64.(model.(Ref(p), tplot .- 1900)); color=cur_col, lw=2.2,
          label="iterate k = $k")
    scatter!(pL, [Float64(tstar(p))], [Float64(p[1] / 2)]; color=cur_col, marker=:diamond,
             ms=6, label="inflection point t* = $(fmt7(tstar(p))), y = L/2")
    scatter!(pL, collect(years), Float64.(yk); color=:black, ms=3.5,
             label="census 1900–1990")

    # Top right: residuals
    r = Float64.(resid(p))
    pR1 = plot(xlims=(1895, 1995), ylims=rlims, framestyle=:box, grid=true,
               xlabel="year t", ylabel="yₖ − f(tₖ)  (millions)", legend=:bottomleft,
               legendfontsize=8, titlefontsize=10,
               title=um(@sprintf("residuals:  E = Σ (yₖ − f(tₖ))² = %.6f", Es[k+1])))
    hline!(pR1, [0.0]; color=:black, lw=1, label="")
    if k > 0
        scatter!(pR1, collect(years), Float64.(resid(P[k])); color=:white,
                 markerstrokecolor=prev_col, msw=1.5, ms=6,
                 label=um(@sprintf("previous iterate, E = %.6f", Es[k])))
    end
    sticks!(pR1, collect(years), r; color=cur_col, lw=2, label="")
    scatter!(pR1, collect(years), r; color=cur_col, ms=4.5, label="iterate k = $k")

    # Bottom right: distance from the minimum
    ks = 0:k
    dE = [Float64(Es[i+1] - Emin) for i in ks]     # all > 0 (printed above)
    dL = [Float64(abs(P[i+1][1] - pstar[1])) for i in ks]
    pR2 = plot(xlims=klims, ylims=dlims, yscale=:log10, framestyle=:box, grid=true,
               xlabel="iteration k", ylabel="distance from the minimum",
               xticks=0:K, yticks=10.0 .^ (-30:5:0), legend=:bottomleft,
               legendfontsize=8, titlefontsize=10,
               title="Eₖ − Eₘᵢₙ = $(fmte(Es[k+1] - Emin)),  |Lₖ − L*| = $(fmte(abs(p[1] - pstar[1])))")
    plot!(pR2, ks, dE; color=:darkorange, lw=1.5, marker=:circle, ms=4.5,
          label="Eₖ − Eₘᵢₙ  (Eₘᵢₙ = $(fmt7(Emin)) million²)")
    plot!(pR2, ks, dL; color=:purple, lw=1.5, marker=:utriangle, ms=4.5,
          label="|Lₖ − L*|  (L* = $(fmt7(pstar[1])) million)")

    l = @layout [a{0.55w} grid(2, 1)]
    plot(pL, pR1, pR2; layout=l, size=(1250, 760),
         plot_title="True least squares logistic curve by Gauss–Newton, U.S. census 1900–1990, " *
                    "from the L = 800 linearization fit",
         plot_titlefontsize=13, left_margin=5Plots.mm, bottom_margin=4Plots.mm,
         background_color=:white)
end

anim = Animation()
for k in 0:K
    draw_frame(k)
    for _ in 1:(k == K ? 14 : 5)
        frame(anim)
    end
end
gif(anim, joinpath(@__DIR__, gif_name); fps=4)
println("Saved: ", gif_name)
