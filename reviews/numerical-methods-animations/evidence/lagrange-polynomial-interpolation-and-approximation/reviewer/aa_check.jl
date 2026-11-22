# Check lagrangeaa.jl's interpolants: node reproduction and agreement with BigFloat Lagrange.
f(x) = 1/(1-x)
node_xs = collect(range(-0.8, 0.8, length=10)); node_ys = f.(node_xs)
function lagrange_eval(x, xs, ys)
    r = zero(x)
    for i in eachindex(xs); li = one(x)
        for j in eachindex(xs); j == i && continue; li *= (x - xs[j]) / (xs[i] - xs[j]); end
        r += ys[i]*li; end
    r
end
setprecision(256)
for deg in 1:9
    xs = node_xs[1:deg+1]; ys = node_ys[1:deg+1]
    res = maximum(abs(lagrange_eval(x, xs, ys) - y) for (x,y) in zip(xs,ys))
    d = maximum(abs(lagrange_eval(x, xs, ys) - Float64(lagrange_eval(big(x), big.(xs), big.(ys)))) for x in range(-1.5,1.5,length=601))
    err = maximum(abs(lagrange_eval(x, xs, ys) - f(x)) for x in range(-0.8,0.8,length=601))
    println("deg $deg nodes $(round.(xs,digits=3)) nodeResid=$res maxDiffVsBig=$d maxErr[-0.8,0.8]=$err")
end
