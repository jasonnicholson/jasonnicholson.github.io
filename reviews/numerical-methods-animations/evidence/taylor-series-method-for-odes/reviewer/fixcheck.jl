# Max nodal error over [0,5] of the scripts' step functions for n = 40, 80
for f in ("taylorderivativeaa.jl", "taylorderivativebb.jl")
    s = read(joinpath(ARGS[1], f), String)
    include_string(Main, replace(split(s, "t0, y0")[1], "using Plots"=>"", "gr()"=>""))
end
for n in (40, 80)
    ref = parse.(Float64, readlines("ref_n$n.txt")); h = 5/n
    for (name, step) in (("order3", taylor3_step), ("order4", taylor4_step))
        y = 1.0; e = 0.0; et = 0.0
        for i in 1:n
            y = step((i-1)*h, y, h)
            if abs(y-ref[i+1]) > e; e = abs(y-ref[i+1]); et = i*h; end
        end
        println("n=$n $name max nodal err = $e at t=$et")
    end
end
