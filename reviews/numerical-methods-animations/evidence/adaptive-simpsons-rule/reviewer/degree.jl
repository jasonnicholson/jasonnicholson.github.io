# Degree-of-precision check of the script's simpson_nonuniform (copied verbatim) on its own node sets
src = read("../regen/adaptivesimpsonsaa.jl", String)
include_string(Main, src[findfirst("node_sets = [", src)[1]:findfirst("xlims", src)[1]-1])
include_string(Main, src[findfirst("function simpson_nonuniform", src)[1]:findfirst("anim =", src)[1]-1])
for (d, g, G) in [(3, x->x^3, x->x^4/4), (4, x->x^4, x->x^5/5)]
    global f = g
    for s in (1, 5, 15, 20)
        println("deg ", d, " set ", s, ": err = ", simpson_nonuniform(node_sets[s]) - (G(2.0)-G(0.0)))
    end
end
