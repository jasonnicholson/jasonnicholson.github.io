# leastsqpolyab.jl
# Least Squares Polynomials animation: degree-3 least-squares fit, drawn as partial sums
# Produces: leastsqpolyab.gif
#
# The coefficients are computed here by solving the normal equations (V'V) a = V'y.
# Frame k draws the partial sum a0 + a1 x + ... + ak x^k of these degree-3 coefficients.
# For k < 3 that curve is NOT the degree-k least-squares fit, and its RMS need not
# decrease as terms are added. The last frame (k = 3) is the full least-squares fit.

using Plots
using LinearAlgebra
using Printf
gr()

m = 3
x_data = [-4.5, -3.2, -1.4, 0.8, 2.5, 4.1]
y_data = [0.7, 2.3, 3.8, 5.0, 5.5, 5.6]
V = [x^j for x in x_data, j in 0:m]          # design (Vandermonde) matrix
coeffs = (V' * V) \ (V' * y_data)             # normal equations

xlims = (-5.0, 4.5)
ylims = (0.0, 6.2)

poly_eval(x, c) = sum(c[i] * x^(i - 1) for i in eachindex(c))
partial_eval(x, c, k) = sum(c[i] * x^(i - 1) for i in 1:(k + 1))
fmt_rms(r) = r >= 1e-4 ? @sprintf("%.5f", r) : @sprintf("%.2e", r)

xplot = range(xlims[1], xlims[2], length = 500)
y_full = [poly_eval(x, coeffs) for x in xplot]
final_rms = sqrt(sum((poly_eval(x_data[i], coeffs) - y_data[i])^2 for i in eachindex(x_data)) / length(x_data))

anim = @animate for k in 0:m
    y_partial = [partial_eval(x, coeffs, k) for x in xplot]
    yhat_data = [partial_eval(x_data[i], coeffs, k) for i in eachindex(x_data)]
    rms_partial = sqrt(sum((yhat_data[i] - y_data[i])^2 for i in eachindex(x_data)) / length(x_data))

    plot(size = (680, 440), xlims = xlims, ylims = ylims,
         xlabel = "x", ylabel = "y",
         title = "Degree-$(m) LS fit: partial sum through x^$(k)",
         legend = :bottomright, grid = true, framestyle = :box,
         background_color = :white)

    scatter!(x_data, y_data; color = :royalblue, ms = 5, label = "data points")
    plot!(xplot, y_full; color = :gray45, lw = 2, ls = :dash, label = "final p$(m)(x)")
    plot!(xplot, y_partial; color = :mediumseagreen, lw = 2.5, label = "partial sum through x^$(k)")

    for i in eachindex(x_data)
        plot!([x_data[i], x_data[i]], [y_data[i], yhat_data[i]];
              color = :orange3, alpha = 0.45, lw = 1.2, label = "")
    end

    annotate!(xlims[1] + 0.2, ylims[2] - 0.35, text("RMS(partial) = $(fmt_rms(rms_partial))", 9, :black, :left))
    annotate!(xlims[1] + 0.2, ylims[2] - 0.7, text("RMS(final) = $(fmt_rms(final_rms))", 9, :black, :left))
end

gif(anim, joinpath(@__DIR__, "leastsqpolyab.gif"); fps = 1)
println("Saved: leastsqpolyab.gif")
