# compartmentcc.jl
# Compartment Model animation: Mathews' Example 3, the open five-tank chain
# V = (60, 80, 100, 120, 150), r = 24, X(0) = (10, 0, 0, 0, 0), growing in time
# on 0 <= t <= 50.
# The solution is built by the eigenvalue method of the page: eigenvalues -k_j,
# eigenvectors from recursion (4), constants from the triangular system
# c_1 V_1 + ... + c_n V_n = X_0, all in exact rational arithmetic; the sum of
# exponentials is then evaluated in 256-bit arithmetic.
# Top: the tanks, drawn with widths proportional to their volumes and a common
# height, so the shaded height is the concentration x_i/V_i and the shaded area
# is proportional to the amount x_i. The tray on the right collects what has
# been washed out, 10 - S(t), drawn to the same area scale.
# Bottom left: x_1, ..., x_5 (Mathews' red, brown, orange, green, blue, his
# green darkened) and the sum S (magenta) in his window [0, 50] x [0, 10]; each
# tank's maximum is marked once it has passed. Bottom right: Mathews' stacked
# plot x_1, x_1 + x_2, ..., S, with the washed-out amount above S in gray.
# Produces: compartmentcc.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))
tstr(j) = string(j ÷ 2, j % 2 == 1 ? ".5" : "")      # t = j/2 exactly

setprecision(BigFloat, 256)
const Q = Rational{BigInt}

# --- Parameters (Mathews' Example 3) ---
gif_name = "compartmentcc.gif"
V     = Q[60, 80, 100, 120, 150]
r     = Q(24)
X0    = Q[10, 0, 0, 0, 0]
tend  = 50
js    = 0:100                                  # frame times t = j/2
nsub  = 10                                     # curve samples per half unit of t
tlims = (0.0, 50.0)
ylims = (0.0, 10.0)
cols  = [RGB(1, 0, 0), RGB(0.6, 0.4, 0.2), RGB(1, 0.5, 0), RGB(0, 0.55, 0), RGB(0, 0, 1)]
# red, brown, orange, green (darkened), blue
magenta = RGB(1, 0, 1)
hold_end = 12
head  = "Example 3, open chain  V = (60, 80, 100, 120, 150),  r = 24,  X(0) = (10, 0, 0, 0, 0)"
fs    = 8                                      # tank label font size
n = length(V)
sub = ["₁", "₂", "₃", "₄", "₅"]
Sname = "S(t) = " * join(["x" * sub[i] for i in 1:n], " + ")
stack_title = n <= 3 ?
    "stacked: " * join([join(["x" * sub[m] for m in 1:i], " + ") for i in 1:n], ",  ") * " = S" :
    "stacked: x₁,  x₁ + x₂,  …,  x₁ + ⋯ + x$(sub[n]) = S"

# --- Eigenvalue method in exact arithmetic ---
k = r ./ V                                     # k_i = r / V_i, eigenvalues -k_i
vecs = Vector{Vector{Q}}()
for j in 1:n
    v = zeros(Q, n)
    v[j] = 1
    for i in j+1:n
        v[i] = k[i-1] / (k[i] - k[j]) * v[i-1]  # recursion (4)
    end
    push!(vecs, v)
end
c = zeros(Q, n)                                # c_1 V_1 + ... + c_n V_n = X0 (triangular)
for i in 1:n
    c[i] = (X0[i] - sum(c[j] * vecs[j][i] for j in 1:i-1; init=Q(0))) / vecs[i][i]
end
# x_i(t) = sum_j coef[i, j] e^{-k_j t}; written over a common denominator so that the
# t = 0 values are exact
coef = [c[j] * vecs[j][i] for i in 1:n, j in 1:n]
den  = [lcm(denominator.(coef[i, :])) for i in 1:n]
num  = [BigInt(coef[i, j] * den[i]) for i in 1:n, j in 1:n]
println("k = ", k, "\nc = ", c, "\ncoef = ", coef)
function X(t)
    e = [exp(-BigFloat(k[j]) * t) for j in 1:n]
    [sum(num[i, j] * e[j] for j in 1:n) / den[i] for i in 1:n]
end
dX(t) = (e = [exp(-BigFloat(k[j]) * t) for j in 1:n];
         [sum(-k[j] * num[i, j] * e[j] for j in 1:n) / den[i] for i in 1:n])
# check the solution against the equations and the initial values
A = zeros(Q, n, n)
for i in 1:n
    A[i, i] = -k[i]
    i > 1 && (A[i, i-1] = k[i-1])
end
println("X(0) = ", X(BigFloat(0)))
println("max residual |X' - AX| on t = 0:0.5:$(tend): ",
        Float64(maximum(maximum(abs.(dX(t) - BigFloat.(A) * X(t))) for t in BigFloat.(0:0.5:tend))))

# --- Maximum of each tank i >= 2: the root of x_i'(t) = 0 (bisection, 256-bit) ---
function peak(i)
    a, b = BigFloat(0.01), BigFloat(0.01)
    while dX(b)[i] > 0
        a = b; b += 0.25
    end
    for _ in 1:300
        m = (a + b) / 2
        dX(m)[i] > 0 ? (a = m) : (b = m)
    end
    t = (a + b) / 2
    (t, X(t)[i])
end
peaks = Dict(i => peak(i) for i in 2:n)
for i in 2:n
    @printf("tank %d max %.12g at t = %.12g\n", i, Float64(peaks[i][2]), Float64(peaks[i][1]))
end

# --- Curves on the fine grid t = m/(2 nsub) ---
tf = [BigFloat(m) / (2nsub) for m in 0:2nsub*tend]
Xf = [Float64.(X(t)) for t in tf]
xf = [[Xf[m][i] for m in eachindex(tf)] for i in 1:n]
Sf = [sum(Xf[m]) for m in eachindex(tf)]
tF = Float64.(tf)

# --- Tank geometry: widths proportional to V, common height 1 ---
gap   = 40.0
xL    = 130.0                                  # left edge of tank 1
lefts = Float64[]
let x = xL
    for i in 1:n
        push!(lefts, x); x += Float64(V[i]) + gap
    end
end
trayw = Float64(V[1])                          # tray: tank 1's width, full = 10 units
trayL = lefts[end] + Float64(V[end]) + gap
cref  = X0[1] / V[1]                           # full height = initial concentration of tank 1
Wtot  = trayL + trayw + 20
rect(x0, x1, y0, y1) = Shape([x0, x1, x1, x0], [y0, y0, y1, y1])

function arrow!(p, x0, x1, y; lab="")
    plot!(p, [x0, x1], [y, y]; color=:gray30, lw=2, arrow=arrow(:closed, :head, 0.6, 0.35), label="")
    lab == "" || annotate!(p, (x0 + x1) / 2, y + 0.13, text(lab, 9, :gray20, :center))
end

function frame_at(j; verbose=false)
    t = BigFloat(j) / 2
    x = X(t)
    S = sum(x)
    out = X0[1] + sum(X0[2:end]) - S           # washed out = total at t = 0 minus S
    mf = j * nsub + 1                          # index of t in the fine grid
    lines = String[]

    # Top: tanks
    ttl = head * ":   " *
          "t = $(tstr(j)),   S(t) = $(fmt(S)),   10 − S(t) = $(fmt(out))"
    push!(lines, ttl)
    pT = plot(xlims=(0, Wtot), ylims=(-1.18, 1.42), axis=false, ticks=false, grid=false,
              legend=false, title=ttl, titlefontsize=11)
    arrow!(pT, 12, xL - 4, 0.88; lab="pure water, r = $(Int(r))")
    for i in 1:n
        L, R = lefts[i], lefts[i] + Float64(V[i])
        h = Float64(x[i] / V[i] / cref)
        plot!(pT, rect(L, R, 0, 1); color=RGB(0.93, 0.96, 1.0), linecolor=:black, lw=1.5)
        h > 0 && plot!(pT, rect(L, R, 0, h); color=cols[i], fillalpha=0.75, linealpha=0)
        plot!(pT, rect(L, R, 0, 1); fillalpha=0, linecolor=:black, lw=1.5)
        xr = i < n ? lefts[i+1] - 4 : trayL - 4
        arrow!(pT, R + 4, xr, 0.88)
        s1 = "tank $i, V$(sub[i]) = $(Int(V[i]))"
        s2 = "x$(sub[i]) = $(fmt(x[i]))"
        s3 = "x$(sub[i])/V$(sub[i]) = $(fmt(x[i] / V[i]))"
        s4 = i == 1 ? "decreasing" : x[i] == 0 ? "empty" :
             (t >= peaks[i][1] ? "max $(fmt(peaks[i][2])) at t = $(fmt(peaks[i][1]))" : "rising")
        for (q, s) in enumerate((s1, s2, s3, s4))
            annotate!(pT, (L + R) / 2, -0.16 - 0.25(q - 1), text(s, fs, q == 2 ? cols[i] : :black, :center))
        end
        push!(lines, join((s1, s2, s3, s4), " | "))
    end
    hT = Float64(out / X0[1])
    plot!(pT, rect(trayL, trayL + trayw, 0, 1); color=:white, linecolor=:gray40, lw=1.2, ls=:dash)
    hT > 0 && plot!(pT, rect(trayL, trayL + trayw, 0, hT); color=:gray60, fillalpha=0.75, linealpha=0)
    for (q, s) in enumerate(("washed out", "10 − S = $(fmt(out))", "same area scale"))
        annotate!(pT, trayL + trayw / 2, -0.16 - 0.25(q - 1), text(s, fs, :black, :center))
    end
    annotate!(pT, 8, 1.3, text("shaded height = concentration xᵢ/Vᵢ (full = 10/$(Int(V[1])) = $(fmt(cref)));  " *
                              "widths ∝ Vᵢ, so shaded area ∝ amount xᵢ;  every pipe carries r = $(Int(r))", 9, :gray20, :left))

    # Bottom left: the amounts and their sum
    pC = plot(xlims=tlims, ylims=ylims, framestyle=:box, xlabel="t", ylabel="amount",
              legend=:topright, legendfontsize=8, titlefontsize=10, grid=true,
              title="amounts xᵢ(t) and their sum S(t)")
    for i in 1:n
        plot!(pC, tF[1:mf], xf[i][1:mf]; color=cols[i], lw=2.2, label="x$(sub[i])(t)")
    end
    plot!(pC, tF[1:mf], Sf[1:mf]; color=magenta, lw=2.2, label=Sname)
    for i in 1:n
        scatter!(pC, [tF[mf]], [Float64(x[i])]; color=cols[i], ms=5, msw=0, label="")
    end
    scatter!(pC, [tF[mf]], [Float64(S)]; color=magenta, ms=5, msw=0, label="")
    if t >= peaks[2][1]
        scatter!(pC, [NaN], [NaN]; marker=:diamond, ms=6, color=:white, msc=:black, msw=2,
                 label="maximum of a tank")
    end
    for i in 2:n
        if t >= peaks[i][1]
            scatter!(pC, [Float64(peaks[i][1])], [Float64(peaks[i][2])]; marker=:diamond, ms=6,
                     color=:white, msc=cols[i], msw=2, label="")
        end
    end

    # Bottom right: Mathews' stacked plot, with the washed-out amount above S
    pS = plot(xlims=tlims, ylims=ylims, framestyle=:box, xlabel="t", ylabel="amount",
              legend=:topright, legendfontsize=8, titlefontsize=10, grid=true,
              title=stack_title)
    lo = zeros(mf)
    for i in 1:n
        hi = lo .+ xf[i][1:mf]
        plot!(pS, tF[1:mf], hi; fillrange=lo, color=cols[i], fillalpha=0.75, lw=0.8,
              linecolor=:black, label="tank $i")
        lo = hi
    end
    plot!(pS, tF[1:mf], fill(10.0, mf); fillrange=lo, color=:gray60, fillalpha=0.6, lw=0,
          label="washed out")

    verbose && println("frame t = ", tstr(j), ": ", join(lines, " || "))
    plot(pT, pC, pS; layout=@layout([a{0.42h}; b c]), size=(1200, 820),
         left_margin=4Plots.mm, bottom_margin=4Plots.mm, background_color=:white)
end

anim = Animation()
for j in js
    frame_at(j; verbose=true)
    frame(anim)
    if j == last(js)
        for _ in 1:hold_end
            frame(anim)
        end
    end
end
gif(anim, joinpath(@__DIR__, gif_name); fps=8)
println("Saved: ", gif_name)
