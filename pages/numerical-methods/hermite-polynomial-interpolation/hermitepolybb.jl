# hermitepolybb.jl
# Hermite Polynomial animation: the four cubic Hermite basis functions H₀₀, H₁₀, H₀₁, H₁₁
# Builds up their weighted combination to form the Hermite interpolant of eˣ on [0, 1]
# Produces: hermitepolybb.gif

using Plots
gr()

H00(t) =  2t^3 - 3t^2 + 1
H10(t) =   t^3 - 2t^2 + t
H01(t) = -2t^3 + 3t^2
H11(t) =   t^3 - t^2

f(x)  = exp(x)
df(x) = exp(x)

a, b  = 0.0, 1.0
y0, y1   = f(a),  f(b)
dy0, dy1 = df(a), df(b)
h = b - a

t_vals = range(0.0, 1.0, length=400)
x_vals = @. a + h * t_vals

term1 = @. y0    * H00(t_vals)
term2 = @. h * dy0 * H10(t_vals)
term3 = @. y1    * H01(t_vals)
term4 = @. h * dy1 * H11(t_vals)

# Frames: show basis functions one at a time, then cumulative sum
stages = [
    ("y₀ · H₀₀(t)", term1,                       :blue,   "y₀·H₀₀"),
    ("+ h·y₀' · H₁₀(t)", term1 .+ term2,         :red,    "…+h·y₀'·H₁₀"),
    ("+ y₁ · H₀₁(t)", term1 .+ term2 .+ term3,   :darkgreen, "…+y₁·H₀₁"),
    ("+ h·y₁' · H₁₁(t) = H(x)", term1 .+ term2 .+ term3 .+ term4, :orange, "H(x) complete"),
]

anim = @animate for (label, cumulative, clr, lbl) in stages
    plot(size=(700, 500),
         xlims=(a, b), ylims=(0.8, 3.0),
         xlabel="x", ylabel="y",
         title="Hermite basis: $label",
         legend=:topleft, grid=true, framestyle=:box,
         background_color=:white)

    plot!(collect(x_vals), f.(x_vals); color=:gray, lw=1.5,
          linestyle=:dot, label="f(x) = eˣ")
    plot!(collect(x_vals), cumulative; color=clr, lw=2.5, label=lbl)

    # Endpoint markers with slope arrows
    scatter!([a, b], [y0, y1]; color=:black, ms=7, label="endpoints")
end

gif(anim, joinpath(@__DIR__, "hermitepolybb.gif"); fps=1)
println("Saved: hermitepolybb.gif")
