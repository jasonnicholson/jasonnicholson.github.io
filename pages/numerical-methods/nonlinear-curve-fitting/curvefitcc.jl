# curvefitcc.jl
# Nonlinear Curve Fitting animation: from the data-linearization fits of Mathews'
# Example 3, data (1,2), (2,4), (3,8), (4,13), (5,21), to the least-squares fits in y.
# Both models, the exponential y = c e^(a x) (left) and the power function y = c x^a
# (right), are refined by the plain (undamped) Gauss-Newton method on
#   E(c, a) = sum_k (f(x_k; c, a) - y_k)^2,
# started from the linearized fit: at each step the residual vector r = f - y is
# replaced by its linearization r + J d, J = [df/dc df/da], and the step d solves
# the linear least-squares problem min |r + J d| (here by QR, Julia's J \ (-r)).
# One frame per step k = 0, 1, ..., 8.
#   top row:    the data, the linearized fit (gray, dashed), the current iterate and
#               its residuals f(x_k) - y_k;
#   middle row: contours of E over the (a, c)-plane with the path of the iterates;
#   bottom:     E after each step, for both models, on a log scale.
# The page's table of direct least-squares fits gives the end points; the script
# checks its converged iterates against them. Mathews' module stops at the
# linearized fits and his graphs of Example 3 are lost, so the animation is new and
# its windows are chosen here.
# Produces: curvefitcc.gif

using Plots
using Printf
using LinearAlgebra
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmt(x)  = x == 0 ? "0" : um(@sprintf("%#.4g", x))      # computed values, 4 s.f.
fmt3(x) = x == 0 ? "0" : um(@sprintf("%#.3g", x))
fmt6(x) = x == 0 ? "0" : um(@sprintf("%#.6g", x))      # 6 s.f., as on the page

# Drawn position only: lets an off-scale curve visibly leave the frame instead of
# running along its edge. Labels and computations always use the true value.
ydraw(y, yl) = clamp(y, yl[1] - (yl[2] - yl[1]), yl[2] + (yl[2] - yl[1]))

sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))   # 12 -> "₁₂"

# --- Parameters (Mathews' Example 3) ---
gif_name = "curvefitcc.gif"
xd = [1.0, 2.0, 3.0, 4.0, 5.0]
yd = [2.0, 4.0, 8.0, 13.0, 21.0]
kmax   = 8
n_hold = 3
xylims = (0.0, 5.5, 0.0, 26.0)

models = [
    (name = "exponential", short = "exp", form = "c eᵃˣ",
     f  = (x, c, a) -> c * exp(a * x),
     J  = (x, c, a) -> [exp(a * x)  c * x * exp(a * x)],
     X  = x -> x, curve = (c, a) -> "$(fmt6(c)) e^($(fmt6(a)) x)",
     alims = (0.45, 0.65), clims = (0.9, 1.9),
     direct = (c = 1.56571, a = 0.521523, E = 1.07912)),      # page table, 6 s.f.
    (name = "power", short = "pow", form = "c xᵃ",
     f  = (x, c, a) -> c * x^a,
     J  = (x, c, a) -> [x^a  c * log(x) * x^a],
     X  = x -> log(x), curve = (c, a) -> "$(fmt6(c)) x^$(fmt6(a))",
     alims = (1.35, 1.95), clims = (0.8, 2.0),
     direct = (c = 1.06460, a = 1.84138, E = 1.50774)),
]

Efun(m, c, a) = sum((m.f.(xd, c, a) .- yd) .^ 2)

# Linearized fit: least-squares line Y = A X + B through (X(x_k), ln y_k), a = A, c = e^B
function linfit(m)
    X = m.X.(xd); Y = log.(yd); n = length(X)
    Δ = n * sum(X .^ 2) - sum(X)^2
    A = (n * sum(X .* Y) - sum(X) * sum(Y)) / Δ
    B = (sum(X .^ 2) * sum(Y) - sum(X) * sum(X .* Y)) / Δ
    return exp(B), A
end

# Gauss-Newton iterates (c_k, a_k), k = 0..kmax
function gauss_newton(m)
    c, a = linfit(m)
    path = [(c, a)]
    for k in 1:kmax
        r = m.f.(xd, c, a) .- yd
        Jm = reduce(vcat, [m.J(x, c, a) for x in xd])
        d = Jm \ (-r)
        c += d[1]; a += d[2]
        push!(path, (c, a))
    end
    return path
end

paths = [gauss_newton(m) for m in models]
Es    = [[Efun(m, c, a) for (c, a) in p] for (m, p) in zip(models, paths)]
for (m, p, E) in zip(models, paths, Es)
    println(m.name, ":")
    for k in 0:kmax
        c, a = p[k+1]
        step = k == 0 ? NaN : max(abs(c - p[k][1]), abs(a - p[k][2]))
        @printf("  k = %d  c = %.10f  a = %.10f  E = %.10g  max|step| = %.3g\n", k, c, a, E[k+1], step)
    end
    c, a = p[end]
    @assert abs(c - m.direct.c) < 5e-6 && abs(a - m.direct.a) < 5e-6 &&
            abs(Es[findfirst(==(m), models)][end] - m.direct.E) < 5e-6
end
@assert abs(Es[1][1] - 4.52766) < 5e-6      # page: E1 of the linearized exponential fit
@assert abs(Es[2][1] - 9.02945) < 5e-6      # page: E2 of the linearized power fit

# --- Contour grids of E over (a, c) ---
# Each panel draws, and its title lists, only the levels above that model's minimum E
# (1.07912 and 1.50774), so the power panel's innermost contour is E = 2.
const Elevels = [1.1, 1.25, 1.5, 2, 3, 5, 10, 20, 50, 100, 200, 500]
lev(x) = isinteger(x) ? string(Int(x)) : string(x)
grids = map(models) do m
    ag = range(m.alims..., length=241)
    cg = range(m.clims..., length=241)
    E = [Efun(m, c, a) for c in cg, a in ag]
    levels = filter(>(m.direct.E), Elevels)
    @assert minimum(E) < levels[1] && maximum(E) > levels[end]   # every listed level is drawn
    label = join(lev.(filter(<=(10), levels)), ", ") * ", …, " * lev(levels[end])
    (ag = ag, cg = cg, E = E, levels = levels, label = label)
end

xplot = range(0.02, xylims[2], length=400)
frames = vcat(collect(0:kmax), fill(kmax, n_hold))

function draw_frame(k)
    top = []; mid = []
    for (j, m) in enumerate(models)
        c, a = paths[j][k+1]
        c0, a0 = paths[j][1]
        E = Es[j][k+1]
        # xy-plane
        p = plot(xlims=xylims[1:2], ylims=xylims[3:4], framestyle=:box, grid=true,
                 xlabel="x", ylabel="y", legend=:topleft, legendfontsize=8, titlefontsize=10)
        plot!(p, xplot, ydraw.(m.f.(xplot, c0, a0), Ref(xylims[3:4])); color=:gray55, lw=1.5,
              ls=:dash, label="linearized fit (k = 0)")
        yk = m.f.(xd, c, a)
        for i in eachindex(xd)
            plot!(p, [xd[i], xd[i]], [yd[i], ydraw(yk[i], xylims[3:4])]; color=:darkorange,
                  lw=2, label=i == 1 ? "residuals f(xₖ) − yₖ" : "")
        end
        plot!(p, xplot, ydraw.(m.f.(xplot, c, a), Ref(xylims[3:4])); color=:royalblue, lw=2.5,
              label="Gauss–Newton iterate $k")
        scatter!(p, xd, yd; color=:black, ms=5, label="data (xₖ, yₖ)")
        r = yk .- yd
        imax = argmax(abs.(r))
        title!(p, "$(m.name) fit  f(x) = $(m.curve(c, a)),  step k = $k\n" *
                  "E = $(fmt6(E)),  largest residual $(fmt(r[imax])) at ($(Int(xd[imax])), $(Int(yd[imax])))")
        push!(top, p)

        # (a, c)-plane
        g = grids[j]
        q = plot(xlims=m.alims, ylims=m.clims, framestyle=:box, grid=false, xlabel="a",
                 ylabel="c", legend=:topright, legendfontsize=8, titlefontsize=10)
        contour!(q, g.ag, g.cg, g.E; levels=g.levels, color=:gray60, clabels=false,
                 colorbar=false, lw=1)
        pa = [pp[2] for pp in paths[j][1:k+1]]
        pc = [pp[1] for pp in paths[j][1:k+1]]
        plot!(q, pa, pc; color=:royalblue, lw=1.5, label="")
        scatter!(q, pa[2:end], pc[2:end]; color=:royalblue, ms=4, label="")
        scatter!(q, [a], [c]; color=:royalblue, ms=12, label="iterate $k")
        scatter!(q, [a0], [c0]; color=:gray55, ms=6, label="linearized fit")
        scatter!(q, [m.direct.a], [m.direct.c]; color=:red, marker=:star5, ms=9,
                 label="least-squares minimum of E")
        step = k == 0 ? "" : ",  max(|Δc|, |Δa|) = $(fmt3(max(abs(c - paths[j][k][1]), abs(a - paths[j][k][2]))))"
        title!(q, "E(a, c) for $(m.form):  contours $(g.label)\n" *
              "a = $(fmt6(a)),  c = $(fmt6(c))$step")
        push!(mid, q)
    end

    # E after each step
    b = plot(xlims=(-0.3, kmax + 0.3), ylims=(0.8, 20), yscale=:log10, framestyle=:box,
             grid=true, xlabel="Gauss–Newton step k", ylabel="E = Σ(f(xₖ) − yₖ)²",
             legend=:topright, legendfontsize=8, titlefontsize=10, xticks=0:kmax,
             yticks=([1, 2, 5, 10, 20], ["1", "2", "5", "10", "20"]))
    cols = [:purple, :seagreen]
    for (j, m) in enumerate(models)
        hline!(b, [m.direct.E]; color=cols[j], ls=:dot, lw=1.5,
               label="minimum E for $(m.form): $(fmt6(m.direct.E))")
        plot!(b, 0:k, Es[j][1:k+1]; color=cols[j], lw=2, marker=:circle, ms=5,
              label="E for $(m.form)")
    end
    hist(j) = k == 0 ? "E₀ = $(fmt6(Es[j][1]))" :
                       "E₀ = $(fmt6(Es[j][1])) → E$(sub(k)) = $(fmt6(Es[j][k+1]))"
    title!(b, "$(hist(1)) (exponential);   $(hist(2)) (power)")

    l = @layout [a b; c d; e{0.24h}]
    plot(top[1], top[2], mid[1], mid[2], b; layout=l, size=(1150, 1150),
         plot_title="Example 3: Gauss–Newton steps from the linearized fits to the least-squares fits in y",
         plot_titlefontsize=12, left_margin=5Plots.mm, bottom_margin=3Plots.mm,
         background_color=:white)
end

anim = Animation()
for k in frames
    draw_frame(k)
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: ", gif_name, " (", length(frames), " frames)")
