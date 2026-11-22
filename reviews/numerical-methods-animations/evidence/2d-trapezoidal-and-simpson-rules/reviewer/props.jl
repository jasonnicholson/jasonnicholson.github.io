# Run the scripts' own trapezoid2d / simpson2d with f replaced by monomials.
P = "/home/jason/workspaces/jasonnicholson.github.io/pages/numerical-methods/2d-trapezoidal-and-simpson-rules"
for (s, fn) in [("trapezoidal2daa.jl", :trapezoid2d), ("simpson2daa.jl", :simpson2d)]
    src = join(readlines(joinpath(P, s))[1:41], "\n")
    src = replace(src, "using Plots" => "", "gr()" => "", "f(x, y) = 8 * exp(-(x^2) - (y^4))" => "")
    for (name, g, ex) in [("1",(x,y)->1.0,1.0), ("x*y",(x,y)->x*y,1/4), ("x^2",(x,y)->x^2,1/3), ("x^3*y^3",(x,y)->x^3*y^3,1/16), ("x^2*y^3",(x,y)->x^2*y^3,1/12), ("x^4",(x,y)->x^4,1/5), ("y^4",(x,y)->y^4,1/5)]
        m = Module()
        Core.eval(m, :(f(x,y) = $g(x,y)))
        Base.include_string(m, src)
        for n in (2,4)
            v = Core.eval(m, :($fn($n)[3]))
            println(rpad(s,20), " n=$n  ", rpad(name,8), " err = ", v - ex)
        end
    end
end
