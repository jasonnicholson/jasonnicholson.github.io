# nevillebb.jl
# Neville's Algorithm animation: Mathews' Example 3, f(x) = e^x at the nodes x_i = 1 + i/4 (i = 0..5),
# evaluated at x̂ = 1.8; one frame per added node, P_{0,j} for j = 0→5, with P_{0,j}(1.8) marked and labelled
# Produces: nevillebb.gif

using Plots
using Printf
gr()

# --- Neville's algorithm: build full table P[i,j] at one query point ---
# P[i,i](x) = f(x_i)
# P[i,j](x) = [(x-x_i)*P[i+1,j] - (x-x_j)*P[i,j-1]] / (x_j - x_i)
function neville_table(xq, xs::Vector, ys::Vector)
    n = length(xs)
    P = zeros(n, n)
    for i in 1:n
        P[i, i] = ys[i]
    end
    for len in 2:n
        for i in 1:n - len + 1
            j = i + len - 1
            P[i, j] = ((xq - xs[i]) * P[i + 1, j] -
                       (xq - xs[j]) * P[i, j - 1]) / (xs[j] - xs[i])
        end
    end
    return P
end

# Nodes, function values and evaluation point (Mathews, Example 3)
f(x)  = exp(x)
xs    = [1.0 + i / 4 for i in 0:5]      # 1.0, 1.25, 1.5, 1.75, 2.0, 2.25
ys    = f.(xs)
x_hat = 1.8

x_plot = collect(range(0.95, 2.30, length=500))

# Interpolant on the first deg+1 nodes, evaluated at xq
function interp_degree(xq, xs, ys, deg)
    xs_d = xs[1:deg + 1]
    ys_d = ys[1:deg + 1]
    P    = neville_table(xq, xs_d, ys_d)
    return P[1, deg + 1]
end

anim = @animate for deg in 0:5
    P_vals = [interp_degree(xq, xs, ys, deg) for xq in x_plot]
    p_hat  = interp_degree(x_hat, xs, ys, deg)
    err    = f(x_hat) - p_hat

    title_str = "Neville's Algorithm for e^x — P_{0,$deg}, degree $deg ($(deg+1) node$(deg==0 ? "" : "s"))"

    plot(size=(700, 500),
         xlims=(0.95, 2.30), ylims=(2.0, 10.5), xticks=1.0:0.25:2.25,
         xlabel="x", ylabel="y",
         title=title_str, titlefontsize=12,
         legend=:topleft, grid=true, framestyle=:box,
         background_color=:white)

    plot!(x_plot, f.(x_plot); color=:blue, lw=2,
          label=@sprintf("f(x) = e^x,  f(1.8) = %.6f", f(x_hat)))
    plot!(x_plot, P_vals; color=:red, lw=2, linestyle=:dash,
          label="P_{0,$(deg)}(x)")
    scatter!(xs[1:deg + 1], ys[1:deg + 1]; color=:black, ms=6, label="nodes used")
    vline!([x_hat]; color=:gray, lw=1, linestyle=:dot, label="x̂ = 1.8")
    scatter!([x_hat], [p_hat]; color=:green, marker=:diamond, ms=7,
             label=@sprintf("P_{0,%d}(1.8) = %.6f,  f(1.8) − P_{0,%d}(1.8) = %.3g", deg, p_hat, deg, err))
end

gif(anim, joinpath(@__DIR__, "nevillebb.gif"); fps=1)
println("Saved: nevillebb.gif")
