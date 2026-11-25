# simplexbb.jl
# Linear Programming - Simplex Method animation: Mathews' Example 2(a),
#   maximize f(x, y) = 10x + 20y
#   subject to 2x + y <= 30, x + 4y <= 64, 5x + 6y <= 110, x, y >= 0.
# Left: the feasible region with Mathews' level lines f = 20, 40, ..., 460 and the
# simplex path from the origin; the blue line is the level line through the current
# point. Right: the tableau, with the entering column, the ratios b_i / a_ie of the
# minimum-ratio test and the pivot row and element highlighted.
# Each pivot takes three frames (choose the pivot, move along the edge, the new
# tableau); the pivots use exact rational arithmetic. Every title and tableau is
# printed (TITLE, CELLS) for checking.
# Produces: simplexbb.gif

using Plots
using Printf
gr()

const Q = Rational{Int}

# Exact rational labels: 7/4, -1/4, 16 (never a decimal that rounds)
um(s) = replace(s, "-" => "−")
qstr(q::Q) = um(denominator(q) == 1 ? string(numerator(q)) :
                "$(numerator(q))/$(denominator(q))")
pt(p) = "(" * qstr(p[1]) * ", " * qstr(p[2]) * ")"

# --- Parameters (Mathews' Example 2(a)) ---
gif_name = "simplexbb.gif"
A = Q[2 1; 1 4; 5 6]
b = Q[30, 64, 110]
c = Q[10, 20]
names = ["x", "y", "s₁", "s₂", "s₃"]
edge_names = Dict(1 => "x = 0", 2 => "x + 4y = 64")   # edge followed by pivot k
edge_ok = Dict(1 => p -> p[1] == 0, 2 => p -> p[1] + 4p[2] == 64)
xlims = (-0.6, 16.5)      # Mathews' window [0, 16.5]^2, widened by 0.6 on the left
ylims = (-0.6, 16.5)      # and below so that points and edges on the axes stay visible
cvals = 20:20:460                                     # Mathews' level lines
n_move = 3                                            # in-between points per edge

# --- Simplex method on the tableau [A I b; -c' 0 0] (Mathews' rules) ---
m, n = size(A)
function I_(m)
    M = zeros(Q, m, m)
    for i in 1:m
        M[i, i] = 1
    end
    return M
end
T = [A I_(m) b; -c' zeros(Q, 1, m) zero(Q)]
basis = collect(n+1:n+m)

function pivot(T, r, e)
    T = copy(T)
    T[r, :] = T[r, :] / T[r, e]
    for i in axes(T, 1)
        i == r && continue
        T[i, :] = T[i, :] - T[i, e] * T[r, :]
    end
    return T
end
point(T, basis) = [let k = findfirst(==(j), basis); k === nothing ? zero(Q) : T[k, end] end
                   for j in 1:n]

steps = []   # (tableau, basis, entering, ratios, pivot row) before each pivot
while true
    z = T[end, 1:end-1]
    minimum(z) >= 0 && break
    e = argmin(z)                       # most negative; first index on a tie
    @assert count(==(z[e]), z) == 1 "tie for the entering variable"
    ratios = [T[i, e] > 0 ? T[i, end] / T[i, e] : nothing for i in 1:m]
    rmin = minimum(r for r in ratios if r !== nothing)
    @assert count(==(rmin), ratios) == 1 "tie in the ratio test"
    r = findfirst(==(rmin), ratios)
    push!(steps, (T = T, basis = copy(basis), e = e, ratios = ratios, r = r))
    global T = pivot(T, r, e)
    basis[r] = e
end
final = (T = T, basis = copy(basis))
verts = [point(s.T, s.basis) for s in steps]
push!(verts, point(final.T, final.basis))
for (k, v) in enumerate(verts)
    @printf("vertex %d: %s  f = %s\n", k - 1, pt(v), qstr(c' * v))
end

# --- Feasible region (vertices in order, exact) ---
region = Q[0 0; 0 16; 4 15; 10 10; 15 0]
for i in 1:size(region, 1)
    @assert all(A * region[i, :] .<= b)
end

# --- Drawing ---
fval(p) = c' * p
function region_panel(cur, path, zcur, title_str)
    println("TITLE L: ", title_str)
    p = plot(xlims=xlims, ylims=ylims, aspect_ratio=:equal, framestyle=:box,
             xlabel="x", ylabel="y", title=title_str, titlefontsize=10,
             legend=:topright, legendfontsize=8, grid=false,
             xticks=0:5:15, yticks=0:5:15)
    plot!(p, Shape(Float64.(region[:, 1]), Float64.(region[:, 2]));
          color=:honeydew, linecolor=:green, lw=2, label="feasible region")
    xs = range(xlims..., length=2)
    for (k, cv) in enumerate(cvals)
        plot!(p, xs, (cv .- 10 .* xs) ./ 20; color=:cyan, lw=0.8, alpha=0.8,
              label=k == 1 ? "f = 20, 40, …, 460" : "")
    end
    plot!(p, xs, (Float64(zcur) .- 10 .* xs) ./ 20; color=:blue, lw=2,
          label="f = " * qstr(zcur) * " (current)")
    if length(path) > 1
        plot!(p, Float64.(first.(path)), Float64.(last.(path)); color=:darkorange,
              lw=4, label="simplex path")
    end
    scatter!(p, Float64.(region[:, 1]), Float64.(region[:, 2]); color=:black, ms=4,
             label="")
    scatter!(p, [Float64(cur[1])], [Float64(cur[2])]; color=:red, ms=7,
             label=pt(cur))
    return p
end

function tableau_panel(T, basis; e=nothing, ratios=nothing, r=nothing, title_str="")
    println("TITLE R: ", title_str)
    println("CELLS: ", join([join(qstr.(T[i, :]), " ") for i in axes(T, 1)], " ; "),
            " | basis ", join(names[basis], " "),
            ratios === nothing ? "" :
            " | ratios " * join([x === nothing ? "-" : qstr(x) for x in ratios], " ") *
            " | e " * names[e] * " r " * string(r))
    p = plot(xlims=(0, 8.6), ylims=(-0.6, m + 1.6), framestyle=:none, grid=false,
             legend=false, title=title_str, titlefontsize=10)
    ncol = n + m + 1
    xcol(j) = 1.2 + j                 # column j = 1..ncol; ratio column ncol + 1
    yrow(i) = m + 1 - i               # rows 1..m, objective row m + 1 at y = 0
    rect(x0, x1, y0, y1, col) = plot!(p, Shape([x0, x1, x1, x0], [y0, y0, y1, y1]);
                                     color=col, linealpha=0, label="")
    e === nothing || rect(xcol(e) - 0.5, xcol(e) + 0.5, -0.5, m + 1.5, :lightblue)
    r === nothing || rect(0.1, xcol(ncol + 1) + 0.5, yrow(r) - 0.5, yrow(r) + 0.5,
                          RGB(1.0, 0.85, 0.6))
    if e !== nothing && r !== nothing
        plot!(p, Shape([xcol(e) - 0.5, xcol(e) + 0.5, xcol(e) + 0.5, xcol(e) - 0.5],
                       [yrow(r) - 0.5, yrow(r) - 0.5, yrow(r) + 0.5, yrow(r) + 0.5]);
              color=RGB(1.0, 0.6, 0.3), linecolor=:red, lw=2, label="")
    end
    plot!(p, [0.1, xcol(ncol + 1) + 0.5], [0.5, 0.5]; color=:black, lw=1)
    plot!(p, [xcol(ncol) - 0.5, xcol(ncol) - 0.5], [-0.5, m + 1.5]; color=:black, lw=1)
    hdr = vcat(names, ["b"])
    for j in 1:ncol
        annotate!(p, xcol(j), m + 1, text(hdr[j], 11, :center))
    end
    ratios === nothing || annotate!(p, xcol(ncol + 1), m + 1, text("bᵢ/aᵢₑ", 10, :center))
    for i in 1:m+1
        lab = i <= m ? names[basis[i]] : "z"
        annotate!(p, 0.6, yrow(i), text(lab, 11, :center))
        for j in 1:ncol
            annotate!(p, xcol(j), yrow(i), text(qstr(T[i, j]), 11, :center))
        end
        if ratios !== nothing && i <= m
            annotate!(p, xcol(ncol + 1), yrow(i),
                      text(ratios[i] === nothing ? "—" : qstr(ratios[i]), 11, :center))
        end
    end
    return p
end

compose(pl, pr, sup) = plot(pl, pr; layout=grid(1, 2, widths=[0.45, 0.55]),
                          size=(1200, 560), plot_title=sup, plot_titlefontsize=12,
                          background_color=:white, left_margin=3Plots.mm,
                          bottom_margin=3Plots.mm)
sup = "Simplex method (Mathews' Example 2(a)): maximize f = 10x + 20y"
basis_str(basis) = "{" * join(names[basis], ", ") * "}"

frames = []
path = [verts[1]]
for (k, s) in enumerate(steps)
    v0, v1 = verts[k], verts[k+1]
    @assert edge_ok[k](v0) && edge_ok[k](v1) "edge name of pivot $k"
    z0 = fval(v0)
    # 1. tableau k-1 at its vertex
    push!(frames, (region_panel(v0, path, z0,
                       k == 1 ? "start at the origin, f = 0" :
                                "vertex " * pt(v0) * ", f = " * qstr(z0)),
                   tableau_panel(s.T, s.basis;
                       title_str="tableau $(k-1): basis " * basis_str(s.basis) *
                                 ", z = " * qstr(s.T[end, end]))))
    # 2. the pivot choice
    push!(frames, (region_panel(v0, path, z0,
                       "vertex " * pt(v0) * ", f = " * qstr(z0)),
                   tableau_panel(s.T, s.basis; e=s.e, ratios=s.ratios, r=s.r,
                       title_str="pivot $k: " * names[s.e] * " enters (" *
                                 qstr(s.T[end, s.e]) * "), min ratio " *
                                 qstr(s.ratios[s.r]) * " in row of " *
                                 names[s.basis[s.r]] * ", which leaves; pivot " *
                                 qstr(s.T[s.r, s.e]))))
    # 3. move along the edge
    for j in 1:n_move
        p = v0 + (v1 - v0) * Q(j, n_move + 1)
        push!(frames, (region_panel(p, vcat(path, [p]), fval(p),
                           "along the edge " * edge_names[k] * ": " * pt(p) *
                           ", f = " * qstr(fval(p))),
                       tableau_panel(s.T, s.basis; e=s.e, ratios=s.ratios, r=s.r,
                           title_str="pivot $k: " * names[s.e] * " increases from 0 to " *
                                     qstr(s.ratios[s.r]) * ", " * names[s.basis[s.r]] *
                                     " falls to 0")))
    end
    push!(path, v1)
end
# final tableau, held
vf = verts[end]
for _ in 1:4
    push!(frames, (region_panel(vf, path, fval(vf),
                       "optimum " * pt(vf) * ", f = " * qstr(fval(vf))),
                   tableau_panel(final.T, final.basis;
                       title_str="tableau $(length(steps)): basis " *
                                 basis_str(final.basis) * ", z = " *
                                 qstr(final.T[end, end]) *
                                 "; no negative entry in row z: optimal")))
end
@assert minimum(final.T[end, 1:end-1]) >= 0

anim = Animation()
for (pl, pr) in frames
    frame(anim, compose(pl, pr, sup))
end
gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: $gif_name ($(length(frames)) frames)")
