# hermitepolybb.jl
# Hermite Polynomial animation: the four cubic Hermite basis functions H₀₀, H₁₀, H₀₁, H₁₁
# Builds up their weighted combination to form the cubic Hermite polynomial of Mathews' Example 1:
# p(1) = 2, p'(1) = 1, p(3) = 1, p'(3) = 2 on [1, 3] (so h = 2)
# Produces: hermitepolybb.gif

using Plots
gr()

H00(t) =  2t^3 - 3t^2 + 1
H10(t) =   t^3 - 2t^2 + t
H01(t) = -2t^3 + 3t^2
H11(t) =   t^3 - t^2

# Endpoint data (Mathews, Hermite Polynomial module, Example 1); no underlying f is given
a, b  = 1.0, 3.0
y0, y1   = 2.0, 1.0
dy0, dy1 = 1.0, 2.0
h = b - a

t_vals = range(0.0, 1.0, length=400)
x_vals = @. a + h * t_vals

term1 = @. y0    * H00(t_vals)
term2 = @. h * dy0 * H10(t_vals)
term3 = @. y1    * H01(t_vals)
term4 = @. h * dy1 * H11(t_vals)

# Frames: add one weighted basis term per frame and draw only the running sum
stages = [
    ("y₀ · H₀₀(t)", term1,                       :blue,   "y₀·H₀₀"),
    ("+ h·y₀' · H₁₀(t)", term1 .+ term2,         :red,    "…+h·y₀'·H₁₀"),
    ("+ y₁ · H₀₁(t)", term1 .+ term2 .+ term3,   :darkgreen, "…+y₁·H₀₁"),
    ("+ h·y₁' · H₁₁(t) = H(x)", term1 .+ term2 .+ term3 .+ term4, :orange, "H(x) complete"),
]

# Short segments of the prescribed tangent lines at the two endpoints
dx = 0.25
tan0_x = [a - dx, a + dx];  tan0_y = @. y0 + dy0 * (tan0_x - a)
tan1_x = [b - dx, b + dx];  tan1_y = @. y1 + dy1 * (tan1_x - b)

anim = @animate for (label, cumulative, clr, lbl) in stages
    plot(size=(700, 500),
         # x-limits a little beyond [1, 3] so both tangent segments show in full;
         # lower y-limit below 0 so the first two partial sums, which fall to 0 at x = 3, stay in view
         xlims=(a - 0.3, b + 0.3), ylims=(-0.2, 3.0),
         xlabel="x", ylabel="y",
         title="Hermite basis: $label",
         legend=:topright, grid=true, framestyle=:box,
         background_color=:white)

    plot!(tan0_x, tan0_y; color=:gray, lw=1.5, linestyle=:dot,
          label="prescribed slopes y₀' = 1, y₁' = 2")
    plot!(tan1_x, tan1_y; color=:gray, lw=1.5, linestyle=:dot, label="")
    plot!(collect(x_vals), cumulative; color=clr, lw=2.5, label=lbl)

    scatter!([a, b], [y0, y1]; color=:black, ms=7, label="endpoints (1, 2), (3, 1)")
end

gif(anim, joinpath(@__DIR__, "hermitepolybb.gif"); fps=1)
println("Saved: hermitepolybb.gif")
