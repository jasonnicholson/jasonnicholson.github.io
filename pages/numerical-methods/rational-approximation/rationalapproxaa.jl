# rationalapproxaa.jl
# Rational Approximation animation in Mathews style for f(x)=exp(x) on [-1,1].
# Frames compare [2/2] rational approximations from:
#   (1) equally spaced interpolation nodes,
#   (2) Chebyshev interpolation nodes,
#   (3) the minimax relative-error approximant, computed by Remez exchange.
# Produces: rationalapproxaa.gif

using Plots
gr()

f(x) = exp(x)

# [2/2] rational form R(x) = (a0 + a1 x + a2 x^2) / (1 + b1 x + b2 x^2)
function eval_rational(c::Vector{Float64}, x::Float64)
    a0, a1, a2, b1, b2 = c
    den = 1 + b1 * x + b2 * x^2
    if abs(den) < 1e-10
        return sign(den) * 1e10
    end
    return (a0 + a1 * x + a2 * x^2) / den
end

function fit_rational_interp(xs::Vector{Float64}, ys::Vector{Float64})
    # Linear system from interpolation constraints
    # a0 + a1*x + a2*x^2 - y*(b1*x + b2*x^2) = y
    A = zeros(Float64, length(xs), 5)
    rhs = copy(ys)
    for (i, (x, y)) in enumerate(zip(xs, ys))
        A[i, 1] = 1.0
        A[i, 2] = x
        A[i, 3] = x^2
        A[i, 4] = -y * x
        A[i, 5] = -y * x^2
    end
    return A \ rhs
end

function max_relative_error(c::Vector{Float64}, xg::Vector{Float64}, fg::Vector{Float64})
    m = 0.0
    for (x, fx) in zip(xg, fg)
        r = eval_rational(c, x)
        if !isfinite(r)
            return 1e9
        end
        e = abs((fx - r) / fx)
        if !isfinite(e)
            return 1e9
        end
        m = max(m, e)
    end
    return m
end

relative_error(c::Vector{Float64}, x::Float64) = (f(x) - eval_rational(c, x)) / f(x)

# Remez step 1: at 6 reference points solve P(x_i) = f(x_i) (1 - s_i E) Q(x_i), s_i = (-1)^i,
# for (a0, a1, a2, b1, b2, E) by Newton's method (the system is bilinear in b and E).
function solve_reference(xr::Vector{Float64}, c::Vector{Float64}, E::Float64)
    u = vcat(c, E)
    for _ in 1:50
        F = zeros(Float64, 6)
        J = zeros(Float64, 6, 6)
        a0, a1, a2, b1, b2, Ev = u
        for (i, x) in enumerate(xr)
            y = f(x)
            s = iseven(i) ? 1.0 : -1.0
            Q = 1 + b1 * x + b2 * x^2
            w = y * (1 - s * Ev)
            F[i] = a0 + a1 * x + a2 * x^2 - w * Q
            J[i, :] = [1.0, x, x^2, -w * x, -w * x^2, y * s * Q]
        end
        du = J \ F
        u .-= du
        if maximum(abs.(du)) < 1e-15
            break
        end
    end
    return u[1:5], u[6]
end

# Remez step 2: new reference = the extremum of |relative error| on each interval of constant sign,
# located on a fine grid and refined by golden-section search.
function error_extrema(c::Vector{Float64}, xg::Vector{Float64})
    e = [relative_error(c, x) for x in xg]
    pts = Float64[]
    start = 1
    for k in 2:(length(e) + 1)
        if k > length(e) || e[k] * e[start] < 0
            seg = start:(k - 1)
            j = seg[argmax(abs.(e[seg]))]
            if j == 1 || j == length(xg)
                push!(pts, xg[j])
            else
                lo, hi = xg[j - 1], xg[j + 1]
                g = (sqrt(5) - 1) / 2
                for _ in 1:80
                    m1 = hi - g * (hi - lo)
                    m2 = lo + g * (hi - lo)
                    if abs(relative_error(c, m1)) > abs(relative_error(c, m2))
                        hi = m2
                    else
                        lo = m1
                    end
                end
                push!(pts, 0.5 * (lo + hi))
            end
            start = k
        end
    end
    return pts
end

# Remez exchange for the minimax (equal-ripple) relative error, started from the Chebyshev extrema.
function remez_minimax(c0::Vector{Float64}, E0::Float64; max_iters=20)
    xr = [cos(pi * (5 - k) / 5) for k in 0:5]
    xfine = collect(range(-1.0, 1.0, length=20001))
    c, E = copy(c0), E0
    for it in 1:max_iters
        c, E = solve_reference(xr, c, E)
        xr_new = error_extrema(c, xfine)
        length(xr_new) == 6 || error("Remez: expected 6 alternation points, found $(length(xr_new))")
        xr = xr_new
        ev = abs.([relative_error(c, x) for x in xr])
        println("Remez iteration $it: |E| = $(abs(E)), ripple spread = $(maximum(ev) - minimum(ev))")
        if maximum(ev) - minimum(ev) < 1e-10 * maximum(ev)
            break
        end
    end
    return c, abs(E), xr
end

# Interval and node sets from Mathews-style examples
a, b = -1.0, 1.0
xs_eq = collect(range(a, b, length=5))
ys_eq = f.(xs_eq)

xs_ch = [0.5 * (a + b) + 0.5 * (b - a) * cos((2k - 1) * pi / 10) for k in 1:5]
sort!(xs_ch)
ys_ch = f.(xs_ch)

c_eq = fit_rational_interp(xs_eq, ys_eq)
c_ch = fit_rational_interp(xs_ch, ys_ch)

x_grid = collect(range(a, b, length=1201))
f_grid = f.(x_grid)
c_mm, E_mm, xr_mm = remez_minimax(c_ch, max_relative_error(c_ch, x_grid, f_grid))
err_mm = max_relative_error(c_mm, x_grid, f_grid)

methods = [
    ("Equally spaced nodes", c_eq, xs_eq, ys_eq),
    ("Chebyshev nodes", c_ch, xs_ch, ys_ch),
    ("Minimax (Remez)", c_mm, Float64[], Float64[]),
]

println("Max relative error [equal]   = ", max_relative_error(c_eq, x_grid, f_grid))
println("Max relative error [cheby]   = ", max_relative_error(c_ch, x_grid, f_grid))
println("Max relative error [minmax]  = ", err_mm)
println("Minimax level E = ", E_mm, " at alternation points ", xr_mm)

x_plot = collect(range(a, b, length=700))
f_plot = f.(x_plot)

anim = @animate for (label, c, xn, yn) in methods
    r_plot = [eval_rational(c, x) for x in x_plot]
    rel_plot = abs.((f_plot .- r_plot) ./ f_plot)
    max_rel = max_relative_error(c, x_grid, f_grid)

    p1 = plot(size=(760, 420), xlims=(a, b), ylims=(0.2, 3.0),
              xlabel="x", ylabel="y",
              title="Rational [2/2] for exp(x) on [-1,1] — " * label,
              legend=:topleft, grid=true, framestyle=:box,
              background_color=:white)
    plot!(p1, x_plot, f_plot; color=:blue, lw=2.2, label="f(x) = exp(x)")
    plot!(p1, x_plot, r_plot; color=:darkgreen, lw=2.2, linestyle=:dash,
          label="R(x), max rel err = $(round(max_rel; digits=7))")
    if !isempty(xn)  # minimax has no prescribed nodes: its five crossings of f come out of the exchange
        scatter!(p1, xn, yn; color=:red, ms=4.5, label="nodes")
    end

    p2 = plot(size=(760, 300), xlims=(a, b), ylims=(0.0, 2.0e-4),
              xlabel="x", ylabel="|f-R|/|f|",
              title="Relative error over [-1,1]",
              legend=:topright, grid=true, framestyle=:box,
              background_color=:white)
    plot!(p2, x_plot, rel_plot; color=:purple, lw=2, label="relative error")

    plot(p1, p2; layout=(2, 1), size=(760, 760))
end

gif(anim, joinpath(@__DIR__, "rationalapproxaa.gif"); fps=1)
println("Saved: rationalapproxaa.gif")
