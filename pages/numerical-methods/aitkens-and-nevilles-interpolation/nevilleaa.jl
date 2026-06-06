# nevilleaa.jl
# Neville's Algorithm animation: building successive polynomial interpolants for cos(x)
# Nodes at x = 0, π/4, π/2, 3π/4, π; reveals degree 0→4 interpolant one frame per degree
# Produces: nevilleaa.gif

using Plots
gr()

# --- Neville's algorithm: build full table P[i,j] over a grid of query points ---
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

# Nodes and function values
f(x) = cos(x)
xs   = [0.0, π/4, π/2, 3π/4, π]
ys   = f.(xs)

x_plot = collect(range(-0.1, π + 0.1, length=500))

# For each query point build the interpolant of given degree
function interp_degree(xq, xs, ys, deg)
    # Use first deg+1 nodes: xs[1..deg+1]
    xs_d = xs[1:deg + 1]
    ys_d = ys[1:deg + 1]
    P    = neville_table(xq, xs_d, ys_d)
    return P[1, deg + 1]
end

anim = @animate for deg in 0:4
    P_vals = [interp_degree(xq, xs, ys, deg) for xq in x_plot]

    plot(size=(700, 500),
         xlims=(-0.1, π + 0.1), ylims=(-1.4, 1.4),
         xlabel="x", ylabel="y",
         title="Neville's Algorithm for cos(x) — degree $deg  ($(deg+1) node$(deg==0 ? "" : "s"))",
         legend=:topright, grid=true, framestyle=:box,
         background_color=:white)

    plot!(x_plot, f.(x_plot); color=:blue, lw=2, label="f(x) = cos(x)")
    plot!(x_plot, P_vals;     color=:red,  lw=2, linestyle=:dash,
          label="P_{0,$(deg)}(x)")
    scatter!(xs[1:deg + 1], ys[1:deg + 1]; color=:black, ms=6, label="nodes used")
end

gif(anim, joinpath(@__DIR__, "nevilleaa.gif"); fps=1)
println("Saved: nevilleaa.gif")
