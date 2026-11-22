# leastsqpolyaa.jl
# Least Squares Polynomials animation: degree-2 fit construction
# Produces: leastsqpolyaa.gif


x_data = [-4.5, -3.2, -1.4, 0.8, 2.5, 4.1]
y_data = [0.7, 2.3, 3.8, 5.0, 5.5, 5.6]
coeffs = [4.67425137, 0.52860951, -0.07563441]

xlims = (-5.0, 4.5)
ylims = (0.0, 6.2)

poly_eval(x, c) = sum(c[i] * x^(i - 1) for i in eachindex(c))
partial_eval(x, c, k) = sum(c[i] * x^(i - 1) for i in 1:(k + 1))

xplot = range(xlims[1], xlims[2], length = 500)
y_full = [poly_eval(x, coeffs) for x in xplot]
final_rms = sqrt(sum((poly_eval(x_data[i], coeffs) - y_data[i])^2 for i in eachindex(x_data)) / length(x_data))


println("final_rms = ", final_rms, "  shown: ", round(final_rms; digits=5))
println("p(xplot) range: ", extrema(y_full), " ; plot ylims ", ylims)
for k in 0:2
    y_partial = [partial_eval(x, coeffs, k) for x in xplot]
    yhat_data = [partial_eval(x_data[i], coeffs, k) for i in eachindex(x_data)]
    rms_partial = sqrt(sum((yhat_data[i] - y_data[i])^2 for i in eachindex(x_data)) / length(x_data))
    println("k=",k," RMS(partial)=",rms_partial," shown ",round(rms_partial;digits=5)," partial range ",extrema(y_partial), " frac outside ylims ", count(v->v<ylims[1]||v>ylims[2], y_partial)/length(y_partial), " yhat ", round.(yhat_data;digits=3))
end
