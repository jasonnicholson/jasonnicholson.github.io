# catenaryaa.jl
# Catenary animation: y = c·cosh(x/c) for c sweeping from 0.5 to 4
# Also shows the parabolic approximation y = x²/(2c) + c (first two Maclaurin terms)
# Produces: catenaryaa.gif

using Plots
gr()

c_values = range(0.5, 4.0, length=25)
x = range(-4.0, 4.0, length=500)

anim = @animate for c in c_values
    y_cat = c .* cosh.(x ./ c)
    y_par = x .^ 2 ./ (2c) .+ c          # parabola: lowest two terms of Maclaurin series

    cs = round(c, digits=2)
    plot(size=(700, 500),
         xlims=(-4.0, 4.0), ylims=(0.0, 12.0),
         xlabel="x", ylabel="y",
         title="Catenary  y = c·cosh(x/c),  c = $cs",
         legend=:top, grid=true, framestyle=:box,
         background_color=:white)

    plot!(collect(x), y_cat; color=:steelblue, lw=2.5,
          label="y = c·cosh(x/c)  (catenary)")
    plot!(collect(x), y_par; color=:tomato,    lw=2, linestyle=:dash,
          label="y = x²/(2c) + c  (parabola)")
    scatter!([0.0], [c]; color=:black, ms=7, markershape=:diamond,
             label="lowest point (0, c)")
end

gif(anim, joinpath(@__DIR__, "catenaryaa.gif"); fps=5)
println("Saved: catenaryaa.gif")
