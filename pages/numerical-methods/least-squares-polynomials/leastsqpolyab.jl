# leastsqpolyab.jl
# Least Squares Polynomials animation: degree-3 fit construction
# Produces: leastsqpolyab.gif

using Plots
gr()

x_data = [-4.5, -3.2, -1.4, 0.8, 2.5, 4.1]
y_data = [0.7, 2.3, 3.8, 5.0, 5.5, 5.6]
coeffs = [4.66862641, 0.48939249, -0.07423867, 0.00267659]

xlims = (-5.0, 4.5)
ylims = (0.0, 6.2)

poly_eval(x, c) = sum(c[i] * x^(i - 1) for i in eachindex(c))
partial_eval(x, c, k) = sum(c[i] * x^(i - 1) for i in 1:(k + 1))

xplot = range(xlims[1], xlims[2], length = 500)
y_full = [poly_eval(x, coeffs) for x in xplot]
final_rms = sqrt(sum((poly_eval(x_data[i], coeffs) - y_data[i])^2 for i in eachindex(x_data)) / length(x_data))

anim = @animate for k in 0:3
    y_partial = [partial_eval(x, coeffs, k) for x in xplot]
    yhat_data = [partial_eval(x_data[i], coeffs, k) for i in eachindex(x_data)]
    rms_partial = sqrt(sum((yhat_data[i] - y_data[i])^2 for i in eachindex(x_data)) / length(x_data))

    plot(size = (680, 440), xlims = xlims, ylims = ylims,
         xlabel = "x", ylabel = "y",
         title = "Least Squares Polynomial Fit: Degree 3 (terms through x^$(k))",
         legend = :bottomright, grid = true, framestyle = :box,
         background_color = :white)

    scatter!(x_data, y_data; color = :royalblue, ms = 5, label = "data points")
    plot!(xplot, y_full; color = :gray45, lw = 2, ls = :dash, label = "final p3(x)")
    plot!(xplot, y_partial; color = :mediumseagreen, lw = 2.5, label = "partial polynomial")

    for i in eachindex(x_data)
        plot!([x_data[i], x_data[i]], [y_data[i], yhat_data[i]];
              color = :orange3, alpha = 0.45, lw = 1.2, label = "")
    end

    annotate!(xlims[1] + 0.2, ylims[2] - 0.35, text("RMS(partial) = $(round(rms_partial; digits = 5))", 9, :black))
    annotate!(xlims[1] + 0.2, ylims[2] - 0.7, text("RMS(final) = $(round(final_rms; digits = 5))", 9, :black))
end

gif(anim, joinpath(@__DIR__, "leastsqpolyab.gif"); fps = 1)
println("Saved: leastsqpolyab.gif")
