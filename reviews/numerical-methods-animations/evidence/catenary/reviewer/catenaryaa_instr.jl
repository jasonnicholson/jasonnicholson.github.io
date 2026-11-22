# Instrumented copy of catenaryaa.jl: same arrays, no rendering
c_values = range(0.5, 4.0, length=25)
x = range(-4.0, 4.0, length=500)
println("nframes=", length(c_values), " x step=", step(x), " x has 0? ", any(==(0.0), x))
for (k,c) in enumerate(c_values)
    y_cat = c .* cosh.(x ./ c)
    y_par = x .^ 2 ./ (2c) .+ c
    cs = round(c, digits=2)
    i = argmin(y_cat)
    println(rpad(k,3), " c=", rpad(c,20), " title c=", rpad(cs,5), " ycat[end]=", round(y_cat[end],digits=4), " ypar[end]=", round(y_par[end],digits=4),
            " min ycat=", round(y_cat[i],digits=6), " at x=", round(x[i],digits=4), " min(cat-par)=", minimum(y_cat .- y_par))
end
