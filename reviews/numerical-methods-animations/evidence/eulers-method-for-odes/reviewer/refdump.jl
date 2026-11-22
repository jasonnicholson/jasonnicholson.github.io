f(t, y) = 1 - t * cbrt(y)
include_string(Main, join(readlines("/home/jason/workspaces/jasonnicholson.github.io/pages/numerical-methods/eulers-method-for-odes/eulersmethodaa.jl")[10:27], "\n"))
ts, ys = rk4_reference(f, 0.0, 5.0, 1.0, 1e-4)
open("ref_dump.txt","w") do io; for k in 1:1000:length(ts); println(io, repr(ts[k]), " ", repr(ys[k])); end; println(io, repr(ts[end]), " ", repr(ys[end])); end
