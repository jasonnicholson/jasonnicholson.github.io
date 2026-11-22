# Step-halving order check using the scripts' own step functions (copied verbatim from the page scripts)
using Printf
for f in ("taylorderivativeaa.jl", "taylorderivativebb.jl")
    s = read(joinpath(ARGS[1], f), String)
    s = replace(split(s, "t0, y0")[1], "using Plots"=>"", "gr()"=>"")
    include_string(Main, s)
end
ref = Dict(2.0=>parse(Float64,ARGS[2]), 2.5=>parse(Float64,ARGS[3]), 5.0=>parse(Float64,ARGS[4]))
function run(step, T, n)
    h = T/n; t=0.0; y=1.0
    for i in 1:n; y = step(t, y, h); t = i*h; end
    y
end
for (name, step) in (("order3", taylor3_step), ("order4", taylor4_step))
    for T in (2.0, 2.5)
        prev = NaN
        for n in round(Int, T/0.25) .* (1,2,4,8,16)
            e = abs(run(step, T, n) - ref[T])
            @printf("%s T=%.1f h=%.6f err=%.3e ratio=%.2f\n", name, T, T/n, e, prev/e); prev = e
        end
    end
    for n in (20, 40, 80, 160, 320)
        y = try run(step, 5.0, n) catch err; string(typeof(err)) end
        println(name, " T=5 n=$n h=$(5/n) y(5)=", y, "  ref=", ref[5.0])
    end
end
