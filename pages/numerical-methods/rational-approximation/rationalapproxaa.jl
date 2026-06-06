# rationalapproxaa.jl
# Rational Approximation animation in Mathews style for f(x)=exp(x) on [-1,1].
# Frames compare [2/2] rational approximations from:
#   (1) equally spaced interpolation nodes,
#   (2) Chebyshev interpolation nodes,
#   (3) MinMax-style relative-error optimization.
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

function minmax_search(c0::Vector{Float64}, xg::Vector{Float64}, fg::Vector{Float64}; max_iters=220)
    c_best = copy(c0)
    f_best = max_relative_error(c_best, xg, fg)

    scales = max.(abs.(c0), 0.05)
    steps = 0.08 .* scales

    for _ in 1:max_iters
        improved = false
        for j in eachindex(c_best)
            for dir in (-1.0, 1.0)
                c_try = copy(c_best)
                c_try[j] += dir * steps[j]
                f_try = max_relative_error(c_try, xg, fg)
                if f_try < f_best
                    c_best = c_try
                    f_best = f_try
                    improved = true
                end
            end
        end
        if !improved
            steps .*= 0.72
            if maximum(steps) < 1e-8
                break
            end
        end
    end
    return c_best, f_best
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
c_mm, err_mm = minmax_search(c_ch, x_grid, f_grid)

methods = [
    ("Equally spaced nodes", c_eq, xs_eq, ys_eq),
    ("Chebyshev nodes", c_ch, xs_ch, ys_ch),
    ("MinMax relative-error search", c_mm, xs_ch, ys_ch),
]

println("Max relative error [equal]   = ", max_relative_error(c_eq, x_grid, f_grid))
println("Max relative error [cheby]   = ", max_relative_error(c_ch, x_grid, f_grid))
println("Max relative error [minmax]  = ", err_mm)

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
    scatter!(p1, xn, yn; color=:red, ms=4.5, label="nodes")

    p2 = plot(size=(760, 300), xlims=(a, b), ylims=(0.0, 0.01),
              xlabel="x", ylabel="|f-R|/|f|",
              title="Relative error over [-1,1]",
              legend=:topright, grid=true, framestyle=:box,
              background_color=:white)
    plot!(p2, x_plot, rel_plot; color=:purple, lw=2, label="relative error")

    plot(p1, p2; layout=(2, 1), size=(760, 760))
end

gif(anim, joinpath(@__DIR__, "rationalapproxaa.gif"); fps=1)
println("Saved: rationalapproxaa.gif")
