# compartmentbb.jl
# Compartment Model animation: Mathews' Example 2, the closed three-tank loop
# V = (40, 20, 40), r = 20, X(0) = (10, 0, 0), growing in time on 0 <= t <= 12.5.
# Mathews' interval is 0 <= t <= 5; the clock runs on to t = 12.5 so that every
# tank crosses its equilibrium value twice.
# The solution is built by the eigenvalue method of the page: the eigenvector
# (2, 1, 2) of the eigenvalue 0 and the real and imaginary parts U, Z of
# e^{(-1 + i/2) t} W, W = a + i b, with the constants from
# c_1 V_1 + c_2 a + c_3 b = X_0 solved in exact rational arithmetic, evaluated
# in 256-bit arithmetic.
# Top: the tanks in their loop, widths proportional to their volumes and a
# common height, so the shaded height is the concentration x_i/V_i and the
# shaded area is proportional to the amount x_i; the dashed line is the common
# equilibrium concentration 10/100.
# Bottom left: x_1, x_2, x_3 (red, blue, green, the colours of Mathews'
# Example 1, since his plots of this example are lost) and their sum S in the
# window [0, 12.5] x [0, 10.5], with the equilibrium values 4, 2, 4 dashed.
# Bottom right (new): the distance |x_i - equilibrium| on a log scale, solid
# while x_i is above its equilibrium value and dashed while below, with the
# envelopes 2 sqrt(10) e^{-t} (tanks 1, 2) and 4 sqrt(5) e^{-t} (tank 3). At an
# equilibrium crossing the distance is 0 and the curve leaves the panel bottom.
# Produces: compartmentbb.gif

using Plots
using Printf
gr()

# Significant-figure label: never rounds a nonzero value to 0.0, never prints -0.0
um(s) = replace(s, "-" => "−")
fmt(x) = x == 0 ? "0" : um(@sprintf("%.4g", Float64(x)))
tstr(j) = string(j ÷ 10, ".", j % 10)                # t = j/10 exactly

setprecision(BigFloat, 256)
const Q = Rational{BigInt}

# --- Parameters (Mathews' Example 2) ---
gif_name = "compartmentbb.gif"
V     = Q[40, 20, 40]
r     = Q(20)
X0    = Q[10, 0, 0]
js    = 0:125                                  # frame times t = j/10
nsub  = 10                                     # curve samples per 0.1 of t
tmath = 5                                      # end of Mathews' interval
tlims = (0.0, 12.5)
ylims = (0.0, 10.5)                            # S = 10 stays visible below the frame edge
dlims = (1e-6, 30.0)                           # log panel
cols  = [RGB(1, 0, 0), RGB(0, 0, 1), RGB(0, 0.55, 0)]   # red, blue, green (darkened)
magenta = RGB(1, 0, 1)
holds = Dict(0 => 6, 50 => 10, 125 => 14)       # extra frames at t = 0, 5, 12.5
n = 3
sub = ["₁", "₂", "₃"]

# --- Eigenvalue method ---
k = r ./ V                                     # 1/2, 1, 1/2
A = Q[-k[1] 0 k[3]; k[1] -k[2] 0; 0 k[2] -k[3]]
V1 = Q[2, 1, 2]                                # eigenvalue 0
av = Q[-1, -1, 2]                              # W = a + i b, eigenvalue -1 + i/2
bv = Q[-1, 1, 0]
lam = Complex{Q}(-1, 1 // 2)
W = Complex{Q}.(av, bv)
println("A V1 = ", A * V1, ";  A W - lam W = ", A * W - lam * W)
@assert all(A * V1 .== 0) && all(A * W - lam * W .== 0)
c = [V1 av bv] \ X0                            # exact rational solve
println("c = ", c)
eq = c[1] .* V1                                # equilibrium: the e^{0 t} part
println("equilibrium = ", eq)
function X(t)
    e, cs, sn = exp(-t), cos(t / 2), sin(t / 2)
    U = e .* (av .* cs .- bv .* sn)
    Z = e .* (av .* sn .+ bv .* cs)
    c[1] .* V1 .+ c[2] .* U .+ c[3] .* Z
end
D(t) = X(t) .- eq                              # deviation from equilibrium
println("X(0) = ", X(BigFloat(0)))
let h = BigFloat(10)^-30
    res = maximum(maximum(abs.((X(t + h) - X(t - h)) / (2h) - BigFloat.(A) * X(t)))
                  for t in BigFloat.(0.5:0.5:12.5))
    println("max |X' - AX| (central difference, h = 1e-30) on t = 0.5:0.5:12.5: ", Float64(res))
end
env = [2sqrt(BigFloat(10)), 2sqrt(BigFloat(10)), 4sqrt(BigFloat(5))]  # |D_i| <= env_i e^{-t}

# --- Equilibrium crossings in (0, 12.5]: sign changes of D_i, refined by bisection ---
function crossings(i)
    out = BigFloat[]
    tg = BigFloat.(0:1//100:125//10)
    for m in 2:length(tg)-1
        a, b = tg[m], tg[m+1]
        if sign(D(a)[i]) != sign(D(b)[i])
            for _ in 1:300
                mid = (a + b) / 2
                sign(D(mid)[i]) == sign(D(a)[i]) ? (a = mid) : (b = mid)
            end
            push!(out, (a + b) / 2)
        end
    end
    out
end
cross = [crossings(i) for i in 1:n]
for i in 1:n
    println("tank $i crosses equilibrium at t = ", join([@sprintf("%.12g", Float64(t)) for t in cross[i]], ", "))
end

# --- Fine grid t = m/(10 nsub) ---
tf = [BigFloat(m) / (10nsub) for m in 0:Int(10nsub * tlims[2])]
Xf = [Float64.(X(t)) for t in tf]
Df = [D(t) for t in tf]
tF = Float64.(tf)
xf = [[Xf[m][i] for m in eachindex(tf)] for i in 1:n]
Sf = [sum(Xf[m]) for m in eachindex(tf)]
below = dlims[1] / (dlims[2] / dlims[1])       # drawn position at a crossing: one span below
println("largest |S(t) - 10| on the fine grid: ", maximum(abs.(sum.(X.(tf)) .- 10)))

# segments of |D_i| between crossings, up to grid index mf; style by sign
function dev_segments(i, mf, tnow)
    segs = Tuple{Vector{Float64}, Vector{Float64}, Bool}[]
    ts, ys = Float64[], Float64[]
    pos = Df[1][i] > 0
    cr = [tc for tc in cross[i] if tc <= tnow]
    ci = 1
    for m in 1:mf
        if ci <= length(cr) && tf[m] > cr[ci]
            push!(ts, Float64(cr[ci])); push!(ys, below)
            push!(segs, (ts, ys, pos))
            ts, ys = [Float64(cr[ci])], [below]
            pos = !pos
            ci += 1
        end
        push!(ts, tF[m]); push!(ys, max(Float64(abs(Df[m][i])), below))
    end
    push!(segs, (ts, ys, pos))
    segs
end

# --- Tank geometry ---
wsc   = 2.5                                    # drawn width per unit volume
gap   = 70.0
xL    = 90.0
lefts = Float64[]
let x = xL
    for i in 1:n
        push!(lefts, x); x += wsc * Float64(V[i]) + gap
    end
end
Wtot  = lefts[end] + wsc * Float64(V[end]) + 90
cref  = X0[1] / V[1]                           # full height = 10/40
ceq   = eq[1] / V[1]                           # common equilibrium concentration
@assert all(eq ./ V .== ceq)
rect(x0, x1, y0, y1) = Shape([x0, x1, x1, x0], [y0, y0, y1, y1])
ahead = arrow(:closed, :head, 0.6, 0.35)

function frame_at(j; verbose=false)
    t = BigFloat(j) / 10
    x = X(t)
    d = D(t)
    S = sum(x)
    mf = j * nsub + 1
    lines = String[]

    ttl = "Example 2, closed loop  V = (40, 20, 40),  r = 20,  X(0) = (10, 0, 0):   " *
          "t = $(tstr(j)),   S(t) = $(fmt(S)),   equilibrium (4, 2, 4)"
    push!(lines, ttl)
    pT = plot(xlims=(0, Wtot), ylims=(-1.18, 1.62), axis=false, ticks=false, grid=false,
              legend=false, title=ttl, titlefontsize=11)
    # return pipe from tank 3 back to tank 1, over the top
    R3 = lefts[3] + wsc * Float64(V[3])
    plot!(pT, [R3 + 4, R3 + 40, R3 + 40, xL - 40, xL - 40], [0.88, 0.88, 1.24, 1.24, 0.88];
          color=:gray30, lw=2, label="")
    plot!(pT, [xL - 40, xL - 4], [0.88, 0.88]; color=:gray30, lw=2, arrow=ahead, label="")
    annotate!(pT, (xL + R3) / 2, 1.12, text("the liquid leaving tank 3 returns to tank 1 (no fresh water)", 9, :gray20, :center))
    for i in 1:n
        L, R = lefts[i], lefts[i] + wsc * Float64(V[i])
        h = Float64(x[i] / V[i] / cref)
        plot!(pT, rect(L, R, 0, 1); color=RGB(0.93, 0.96, 1.0), linecolor=:black, lw=1.5)
        h > 0 && plot!(pT, rect(L, R, 0, h); color=cols[i], fillalpha=0.75, linealpha=0)
        plot!(pT, [L, R], fill(Float64(ceq / cref), 2); color=:black, ls=:dash, lw=1.2)
        plot!(pT, rect(L, R, 0, 1); fillalpha=0, linecolor=:black, lw=1.5)
        i < n && plot!(pT, [R + 4, lefts[i+1] - 4], [0.88, 0.88]; color=:gray30, lw=2,
                       arrow=ahead, label="")
        s1 = "tank $i, V$(sub[i]) = $(Int(V[i]))"
        s2 = "x$(sub[i]) = $(fmt(x[i]))"
        s3 = "x$(sub[i])/V$(sub[i]) = $(fmt(x[i] / V[i]))"
        s4 = d[i] > 0 ? "above equilibrium $(Int(eq[i]))" :
             d[i] < 0 ? "below equilibrium $(Int(eq[i]))" : "at equilibrium $(Int(eq[i]))"
        for (q, s) in enumerate((s1, s2, s3, s4))
            annotate!(pT, (L + R) / 2, -0.16 - 0.25(q - 1), text(s, 9, q == 2 ? cols[i] : :black, :center))
        end
        push!(lines, join((s1, s2, s3, s4), " | "))
    end
    annotate!(pT, 8, 1.52, text("shaded height = concentration xᵢ/Vᵢ (full = 10/40 = $(fmt(cref)));  " *
                               "widths ∝ Vᵢ, so shaded area ∝ amount xᵢ;  every pipe carries r = 20",
                               9, :gray20, :left))
    annotate!(pT, 8, 1.39, text("dashed line in each tank: the common equilibrium concentration " *
                               "10/100 = $(fmt(ceq))", 9, :gray20, :left))

    # Bottom left: amounts, sum, equilibrium values
    pC = plot(xlims=tlims, ylims=ylims, framestyle=:box, xlabel="t", ylabel="amount",
              legend=(0.5, 0.86), legendfontsize=8, titlefontsize=10, grid=true,
              title="amounts xᵢ(t), their sum S(t) and the equilibrium values (dashed)")
    vline!(pC, [tmath]; color=:gray50, ls=:dot, lw=1.5, label="t = 5, end of Mathews' interval")
    hline!(pC, [4.0]; color=:gray30, ls=:dash, lw=1, label="")
    hline!(pC, [2.0]; color=:gray30, ls=:dash, lw=1, label="")
    for i in 1:n
        plot!(pC, tF[1:mf], xf[i][1:mf]; color=cols[i], lw=2.2, label="x$(sub[i])(t)")
    end
    plot!(pC, tF[1:mf], Sf[1:mf]; color=magenta, lw=2.2, label="S(t) = x₁ + x₂ + x₃")
    for i in 1:n
        scatter!(pC, [tF[mf]], [Float64(x[i])]; color=cols[i], ms=5, msw=0, label="")
    end
    scatter!(pC, [tF[mf]], [Float64(S)]; color=magenta, ms=5, msw=0, label="")

    # Bottom right: distance from equilibrium, log scale
    dmax = maximum(abs.(d))
    dttl = "|xᵢ − equilibrium|, log scale:  largest now $(fmt(dmax))"
    push!(lines, dttl)
    pD = plot(xlims=tlims, ylims=dlims, yscale=:log10, framestyle=:box, xlabel="t",
              ylabel="|xᵢ(t) − equilibrium|", legend=:topright, legendfontsize=8,
              titlefontsize=10, grid=true, title=dttl,
              yticks=([1e-6, 1e-4, 1e-2, 1, 10], ["10⁻⁶", "10⁻⁴", "10⁻²", "1", "10"]))
    vline!(pD, [tmath]; color=:gray50, ls=:dot, lw=1.5, label="")
    tE = range(0, tlims[2], length=200)
    plot!(pD, tE, Float64(env[1]) .* exp.(-tE); color=:gray40, ls=:dot, lw=1.5,
          label="2√10 e⁻ᵗ  (tanks 1, 2)")
    plot!(pD, tE, Float64(env[3]) .* exp.(-tE); color=:black, ls=:dashdot, lw=1,
          label="4√5 e⁻ᵗ  (tank 3)")
    for i in 1:n
        plot!(pD, [NaN], [NaN]; color=cols[i], lw=2, label="tank $i: solid above, dashed below")
        for (ts, ys, pos) in dev_segments(i, mf, t)
            length(ts) >= 2 && plot!(pD, ts, ys; color=cols[i], lw=2, ls=pos ? :solid : :dash, label="")
        end
        abs(d[i]) > 0 && scatter!(pD, [tF[mf]], [Float64(abs(d[i]))]; color=cols[i], ms=5, msw=0, label="")
    end

    verbose && println("frame t = ", tstr(j), ": ", join(lines, " || "))
    plot(pT, pC, pD; layout=@layout([a{0.42h}; b c]), size=(1200, 820),
         left_margin=4Plots.mm, bottom_margin=4Plots.mm, background_color=:white)
end

anim = Animation()
for j in js
    frame_at(j; verbose=true)
    frame(anim)
    for _ in 1:get(holds, j, 0)
        frame(anim)
    end
end
gif(anim, joinpath(@__DIR__, gif_name); fps=10)
println("Saved: ", gif_name)
