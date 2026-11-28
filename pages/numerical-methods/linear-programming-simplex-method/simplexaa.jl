# simplexaa.jl
# Linear Programming - Simplex Method animation: Mathews' Example 1 (Ann and Carl),
# the graphical method. The feasible quadrilateral
#   80 <= 4x + 2y,  y <= x + 4,  x <= y + 8,  x + y <= 40,  x, y >= 0
# (the constraints of Mathews' Mathematica input) is swept by the level line
# f(x, y) = c as c increases, for the three objectives of Example 1:
#   (a) f = 15x + 17y,  (b) f = 17x + 15y,  (c) f = 16x + 16y.
# The part of the level line inside the region is drawn in orange. The line first
# touches the region at the vertex where f is smallest and last touches it where f
# is largest; in (c) the last contact is a whole edge. The values of c are 350,
# 375, ..., 700 together with the exact minimum and maximum of each objective.
# The intersection of each level line with the region is computed exactly in
# rational arithmetic. Every panel title and cut is printed (TITLE) for checking.
# Produces: simplexaa.gif

using Plots
using Printf
gr()

const Q = Rational{Int}

um(s) = replace(s, "-" => "−")
qstr(q::Q) = um(denominator(q) == 1 ? string(numerator(q)) :
                "$(numerator(q))/$(denominator(q))")
pt(p) = "(" * qstr(p[1]) * ", " * qstr(p[2]) * ")"

# --- Parameters (Mathews' Example 1) ---
gif_name = "simplexaa.gif"
A = Q[-4 -2; -1 1; 1 -1; 1 1; -1 0; 0 -1]       # A [x, y] <= b
b = Q[-80, 4, 8, 40, 0, 0]
region = Q[12 16; 16 8; 24 16; 18 22]             # vertices in order around R
objs = [(tag = "(a)", c = Q[15, 17], fstr = "f = 15x + 17y"),
        (tag = "(b)", c = Q[17, 15], fstr = "f = 17x + 15y"),
        (tag = "(c)", c = Q[16, 16], fstr = "f = 16x + 16y")]
xlims = (0.0, 25.0)                               # Mathews' window [0, 25]^2
ylims = (0.0, 25.0)
cvals = 50:50:700                                 # Mathews' level lines
nv = size(region, 1)
for i in 1:nv
    @assert all(A * region[i, :] .<= b)           # every vertex is feasible
    @assert count(A * region[i, :] .== b) == 2    # and lies on two constraint lines
end

# Intersection of the line f = c with R: walk the boundary, collect the points
# of each edge where f = c (exact). Returns the distinct points (0, 1 or 2).
function cut(cf, cv)
    pts = Vector{Vector{Q}}()
    for i in 1:nv
        p, q = region[i, :], region[mod1(i + 1, nv), :]
        fp, fq = cf' * p, cf' * q
        if fp == cv
            push!(pts, p)
        end
        if (fp - cv) * (fq - cv) < 0
            t = (cv - fp) / (fq - fp)
            push!(pts, p + t * (q - p))
        end
    end
    return unique(pts)
end

info = []
for o in objs
    fv = [o.c' * region[i, :] for i in 1:nv]
    fmin, fmax = minimum(fv), maximum(fv)
    argsmin = [region[i, :] for i in 1:nv if fv[i] == fmin]
    argsmax = [region[i, :] for i in 1:nv if fv[i] == fmax]
    @printf("%s %s: vertex values %s; min %s at %s, max %s at %s\n", o.tag, o.fstr,
            join(qstr.(fv), ", "), qstr(fmin), join(pt.(argsmin), " "), qstr(fmax),
            join(pt.(argsmax), " "))
    push!(info, (fmin = fmin, fmax = fmax, argsmin = argsmin, argsmax = argsmax))
end

csweep = sort(unique(vcat(Q.(350:25:700), [i.fmin for i in info], [i.fmax for i in info])))
println("c values: ", join(qstr.(csweep), ", "))

function describe(k, cv, pts)
    I = info[k]
    if isempty(pts)
        return cv < I.fmin ? "c = $(qstr(cv)) < $(qstr(I.fmin)) = min f: misses R" :
                             "c = $(qstr(cv)) > $(qstr(I.fmax)) = max f: misses R"
    elseif length(pts) == 1
        @assert cv == I.fmin || cv == I.fmax
        return "c = $(qstr(cv)) = " * (cv == I.fmin ? "min" : "max") *
               " f: touches R only at " * pt(pts[1])
    elseif cv == I.fmax
        return "c = $(qstr(cv)) = max f: meets R along the edge\n" *
               pt(pts[1]) * " to " * pt(pts[2])
    else
        @assert I.fmin < cv < I.fmax
        return "c = $(qstr(cv)): crosses R"
    end
end

function panel(k, cv)
    o, I = objs[k], info[k]
    pts = cut(o.c, cv)
    desc = describe(k, cv, pts)
    println("TITLE: ", o.tag, " | ", replace(desc, "\n" => " "), " | cut ",
            join(pt.(pts), " "))
    occursin("\n", desc) || (desc = desc * "\n ")
    p = plot(xlims=xlims, ylims=ylims, aspect_ratio=:equal, framestyle=:box,
             xlabel="x (Ann's hours)", ylabel="y (Carl's hours)",
             title=o.tag * " " * o.fstr * "\n" * desc, titlefontsize=10,
             legend=:topleft, legendfontsize=8, grid=false,
             xticks=0:5:25, yticks=0:5:25)
    plot!(p, Shape(Float64.(region[:, 1]), Float64.(region[:, 2]));
          color=:honeydew, linecolor=:green, lw=2, label="feasible region R")
    xs = range(xlims..., length=2)
    c1, c2 = Float64.(o.c)
    for (j, c0) in enumerate(cvals)
        plot!(p, xs, (c0 .- c1 .* xs) ./ c2; color=:cyan, lw=0.8, alpha=0.7,
              label=j == 1 ? "f = 50, 100, …, 700" : "")
    end
    if cv >= I.fmax          # Mathews' blue line through the maximum
        plot!(p, xs, (Float64(I.fmax) .- c1 .* xs) ./ c2; color=:blue, lw=2,
              label="f = $(qstr(I.fmax)) = max")
    end
    if cv != I.fmax
        plot!(p, xs, (Float64(cv) .- c1 .* xs) ./ c2; color=:gray30, lw=1.5,
              ls=:dash, label="f = c, c = $(qstr(cv))")
    end
    if length(pts) == 2
        plot!(p, Float64.(first.(pts)), Float64.(last.(pts)); color=:darkorange, lw=5,
              label="f = c inside R")
    end
    scatter!(p, Float64.(region[:, 1]), Float64.(region[:, 2]); color=:red, ms=5,
             label="vertices")
    if length(pts) == 1
        scatter!(p, [Float64(pts[1][1])], [Float64(pts[1][2])]; color=:darkorange,
                 ms=9, markerstrokecolor=:black, label=pt(pts[1]))
    end
    # gradient direction (Mathews: "the furthest point in the direction of ∇f")
    g = Float64.(o.c) ./ hypot(Float64.(o.c)...) .* 5
    plot!(p, [3.0, 3.0 + g[1]], [3.0, 3.0 + g[2]]; arrow=true, color=:purple, lw=2,
          label="∇f = (" * qstr(o.c[1]) * ", " * qstr(o.c[2]) * ")")
    return p
end

anim = Animation()
for cv in csweep
    plt = plot(panel(1, cv), panel(2, cv), panel(3, cv); layout=(1, 3),
               size=(1500, 600), background_color=:white,
               plot_title="Linear programming, graphical method (Mathews' Example 1): " *
                          "sweeping the level line f = c across R",
               plot_titlefontsize=12, left_margin=8Plots.mm, bottom_margin=4Plots.mm,
               top_margin=4Plots.mm)
    frame(anim, plt)
    # pause on the minima and maxima
    if any(cv == I.fmin || cv == I.fmax for I in info) || cv == csweep[end]
        frame(anim, plt)
    end
end
gif(anim, joinpath(@__DIR__, gif_name); fps=2)
println("Saved: $gif_name")
