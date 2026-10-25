# bsplinebb.jl
# B-Splines animation: the 7 cubic B-spline basis functions N_{i,4}(t) added one by one
# Shows the partition-of-unity property: sum of all basis functions = 1
# Produces: bsplinebb.gif

using Plots
gr()

# Cox–de Boor recursion
function bspline_basis(x, t_knots, i, k)
    if k == 1
        lo, hi = t_knots[i], t_knots[i + 1]
        return (lo <= x < hi) ? 1.0 : 0.0
    end
    denom1 = t_knots[i + k - 1] - t_knots[i]
    denom2 = t_knots[i + k]     - t_knots[i + 1]
    w1 = denom1 > 0 ? (x - t_knots[i])      / denom1 * bspline_basis(x, t_knots, i,     k - 1) : 0.0
    w2 = denom2 > 0 ? (t_knots[i + k] - x)  / denom2 * bspline_basis(x, t_knots, i + 1, k - 1) : 0.0
    return w1 + w2
end

k      = 4     # cubic
n_ctrl = 7
n_int  = n_ctrl - k      # 3 interior knots

t_knots = vcat(zeros(k),
               range(1.0, n_int, length=n_int),
               fill(Float64(n_int + 1), k))
t_min = t_knots[k]
t_max = t_knots[n_ctrl + 1]

t_vals = collect(range(t_min + 1e-9, t_max - 1e-9, length=500))

# Evaluate all basis functions on the parameter grid
basis = [Float64[bspline_basis(t, t_knots, i, k) for t in t_vals]
         for i in 1:n_ctrl]

colors_b = [:blue, :red, :darkgreen, :orange, :purple, :brown, :teal]

anim = @animate for m in 1:n_ctrl
    plot(size=(750, 500),
         xlims=(t_min, t_max), ylims=(-0.05, 1.25),
         xlabel="t (parameter)", ylabel="N_{i,4}(t)",
         title="Cubic B-Spline Basis Functions N₁,₄ … N_$m,₄",
         legend=:topright, grid=true, framestyle=:box,
         background_color=:white)

    cumsum_b = zeros(length(t_vals))
    for i in 1:m
        plot!(t_vals, basis[i]; color=colors_b[i], lw=2,
              label="N_$i,₄")
        cumsum_b .+= basis[i]
    end

    # Show running sum
    plot!(t_vals, cumsum_b; color=:black, lw=1.5, linestyle=:dash,
          label="sum (= 1 when all added)")
end

gif(anim, joinpath(@__DIR__, "bsplinebb.gif"); fps=1)
println("Saved: bsplinebb.gif")
