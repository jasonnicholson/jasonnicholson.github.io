# simplexcc.jl
# Linear Programming - Simplex Method animation: Mathews' Example 3, one feasible
# octagon and two objectives, side by side:
#   (a) maximize f = 10x + 10y,   (b) maximize f = 10x + 25y,
#   subject to -x + 2y <= 36, x + 6y <= 132, 3x + 5y <= 136, 5x + 3y <= 136,
#              6x + y <= 132, 2x - y <= 36, x, y >= 0.
# Each panel follows the simplex method from the origin along the edges of the
# octagon, with the level line through the current point in blue. Each pivot
# takes four frames: the vertex and its basis, the pivot choice (entering and
# leaving variable), and two points on the edge being followed. The pivots use
# exact rational arithmetic and Mathews' rules (most negative entry of the
# objective row, first column on a tie; minimum ratio over rows with a_ie > 0).
# Every panel title is printed (TITLE) for checking.
# Produces: simplexcc.gif

using Plots
using Printf
gr()

const Q = Rational{Int}

um(s) = replace(s, "-" => "−")
qstr(q::Q) = um(denominator(q) == 1 ? string(numerator(q)) :
                "$(numerator(q))/$(denominator(q))")
pt(p) = "(" * qstr(p[1]) * ", " * qstr(p[2]) * ")"

# --- Parameters (Mathews' Example 3) ---
gif_name = "simplexcc.gif"
A = Q[-1 2; 1 6; 3 5; 5 3; 6 1; 2 -1]
b = Q[36, 132, 136, 136, 132, 36]
cases = [(tag = "(a)", c = Q[10, 10], fstr = "f = 10x + 10y", cvals = 20:20:460,
          cstr = "f = 20, 40, …, 460"),
         (tag = "(b)", c = Q[10, 25], fstr = "f = 10x + 25y", cvals = 40:40:840,
          cstr = "f = 40, 80, …, 840")]
names = ["x", "y", "s₁", "s₂", "s₃", "s₄", "s₅", "s₆"]
xlims = (-0.6, 22.0)      # Mathews' window [0, 22]^2, widened by 0.6 on the left
ylims = (-0.6, 26.5)      # and below so that points and edges on the axes stay visible,
                          # and raised to 26.5 to make room for the legend above the region
n_move = 2                # in-between points per edge

m, n = size(A)
function eye(m)
    M = zeros(Q, m, m)
    for i in 1:m
        M[i, i] = 1
    end
    return M
end
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

function simplex(c)
    T = [A eye(m) b; -c' zeros(Q, 1, m) zero(Q)]
    basis = collect(n+1:n+m)
    steps = []
    while true
        z = T[end, 1:end-1]
        minimum(z) >= 0 && break
        e = argmin(z)                   # most negative; first column on a tie
        tie = count(==(z[e]), z) > 1
        ratios = [T[i, e] > 0 ? T[i, end] / T[i, e] : nothing for i in 1:m]
        rmin = minimum(r for r in ratios if r !== nothing)
        @assert count(==(rmin), ratios) == 1 "tie in the ratio test"
        r = findfirst(==(rmin), ratios)
        push!(steps, (T = T, basis = copy(basis), e = e, tie = tie, r = r,
                      leave = basis[r], rmin = rmin))
        T = pivot(T, r, e)
        basis[r] = e
    end
    return steps, (T = T, basis = copy(basis))
end

# Name of the edge joining two adjacent vertices: the one constraint tight at both
rows = vcat([(A[i, :], b[i]) for i in 1:m], [(Q[-1, 0], zero(Q)), (Q[0, -1], zero(Q))])
function polystr(a, rhs)
    terms = String[]
    for (k, v) in zip(a, ["x", "y"])
        k == 0 && continue
        s = abs(k) == 1 ? v : string(abs(numerator(k))) * v
        push!(terms, isempty(terms) ? (k < 0 ? "-" * s : s) : (k < 0 ? " - " : " + ") * s)
    end
    return um(join(terms) * " = " * string(numerator(rhs)))
end
function edge_name(v0, v1)
    tight = [(a, r) for (a, r) in rows if a' * v0 == r && a' * v1 == r]
    @assert length(tight) == 1
    a, r = tight[1]
    if a[1] <= 0 && a[2] <= 0                         # print x >= 0 as "x = 0"
        a, r = -a, -r
    end
    return polystr(a, r)
end

runs = []
for cs in cases
    steps, final = simplex(cs.c)
    verts = [point(s.T, s.basis) for s in steps]
    push!(verts, point(final.T, final.basis))
    @printf("%s %s: %d pivots, path %s\n", cs.tag, cs.fstr, length(steps),
            join([pt(v) * " f=" * qstr(cs.c' * v) for v in verts], " -> "))
    push!(runs, (cs = cs, steps = steps, final = final, verts = verts))
end

# --- Feasible octagon (vertices in order, exact) ---
region = Q[0 0; 0 18; 6 21; 12 20; 17 17; 20 12; 21 6; 18 0]
for i in 1:size(region, 1)
    @assert all(A * region[i, :] .<= b)
end

basis_str(basis) = "{" * join(names[basis], ", ") * "}"

# Frame descriptions for one run: (point, path, title line 2)
function frame_list(run)
    cs, steps, verts = run.cs, run.steps, run.verts
    out = []
    path = [verts[1]]
    for (k, s) in enumerate(steps)
        v0, v1 = verts[k], verts[k+1]
        f0 = cs.c' * v0
        push!(out, (p = v0, path = copy(path),
                    l1 = "tableau $(k-1): " * pt(v0) * ", z = " * qstr(s.T[end, end]),
                    l2 = "basis " * basis_str(s.basis)))
        @assert s.T[end, end] == f0
        push!(out, (p = v0, path = copy(path),
                    l1 = "pivot $k: " * names[s.e] * " enters (" * qstr(s.T[end, s.e]) *
                         (s.tie ? ", a tie: first column" : "") * ")",
                    l2 = names[s.leave] * " leaves (min ratio " * qstr(s.rmin) * ")"))
        en = edge_name(v0, v1)
        for j in 1:n_move
            p = v0 + (v1 - v0) * Q(j, n_move + 1)
            push!(out, (p = p, path = vcat(path, [p]),
                        l1 = "pivot $k: along " * en,
                        l2 = pt(p) * ", f = " * qstr(cs.c' * p)))
        end
        push!(path, v1)
    end
    vf = verts[end]
    push!(out, (p = vf, path = copy(path),
                l1 = "tableau $(length(steps)): optimum " * pt(vf) * ", z = " *
                     qstr(run.final.T[end, end]),
                l2 = "basis " * basis_str(run.final.basis)))
    @assert run.final.T[end, end] == cs.c' * vf
    @assert minimum(run.final.T[end, 1:end-1]) >= 0
    return out
end
lists = [frame_list(r) for r in runs]
nfr = maximum(length.(lists)) + 3                     # hold the last frame
for L in lists
    while length(L) < nfr
        push!(L, L[end])
    end
end

function panel(run, fr)
    cs = run.cs
    println("TITLE: ", cs.tag, " | ", fr.l1, " | ", fr.l2)
    p = plot(xlims=xlims, ylims=ylims, aspect_ratio=:equal, framestyle=:box,
             xlabel="x", ylabel="y", title=cs.tag * " " * cs.fstr * ": " * fr.l1 * "\n" * fr.l2,
             titlefontsize=10, legend=:topright, legendfontsize=8, grid=false,
             xticks=0:5:20, yticks=0:5:20)
    plot!(p, Shape(Float64.(region[:, 1]), Float64.(region[:, 2]));
          color=:honeydew, linecolor=:green, lw=2, label="feasible region")
    xs = range(xlims..., length=2)
    c1, c2 = Float64.(cs.c)
    for (k, cv) in enumerate(cs.cvals)
        plot!(p, xs, (cv .- c1 .* xs) ./ c2; color=:cyan, lw=0.8, alpha=0.8,
              label=k == 1 ? cs.cstr : "")
    end
    fcur = cs.c' * fr.p
    plot!(p, xs, (Float64(fcur) .- c1 .* xs) ./ c2; color=:blue, lw=2,
          label="f = " * qstr(fcur) * " (current)")
    if length(fr.path) > 1
        plot!(p, Float64.(first.(fr.path)), Float64.(last.(fr.path)); color=:darkorange,
              lw=4, label="simplex path")
    end
    scatter!(p, Float64.(region[:, 1]), Float64.(region[:, 2]); color=:black, ms=4,
             label="")
    scatter!(p, [Float64(fr.p[1])], [Float64(fr.p[2])]; color=:red, ms=7,
             label=pt(fr.p))
    return p
end

anim = Animation()
for i in 1:nfr
    plt = plot(panel(runs[1], lists[1][i]), panel(runs[2], lists[2][i]);
               layout=(1, 2), size=(1200, 640),
               plot_title="Simplex method (Mathews' Example 3): one region, two objectives",
               plot_titlefontsize=12, background_color=:white, left_margin=3Plots.mm,
               bottom_margin=3Plots.mm, top_margin=4Plots.mm)
    frame(anim, plt)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=1)
println("Saved: $gif_name ($nfr frames)")
