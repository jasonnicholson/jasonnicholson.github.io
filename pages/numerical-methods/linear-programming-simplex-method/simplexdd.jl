# simplexdd.jl
# Linear Programming - Simplex Method animation: Mathews' Example 5, three variables,
#   maximize f = 8x + 12y + 10z
#   subject to 6x + 15y + 20z <= 180, 6x + 30y + 10z <= 180, 12x + 15y + 10z <= 180,
#              x, y, z >= 0.
# The feasible region is a convex polyhedron. Its vertices are found exactly (every
# feasible intersection of three of the six bounding planes), its faces drawn
# translucent with their edges in dark green, and the simplex path from the origin is
# drawn in orange, one pivot at a time, while the view sways about the vertical
# axis between azimuths 25 and 45 degrees. Each pivot takes four frames: the
# vertex and its basis, the pivot choice, and two points on the edge followed.
# The pivots use exact rational arithmetic and Mathews' rules (most negative entry
# of the objective row; minimum ratio over rows with a_ie > 0). Every frame's title
# is printed (TITLE) for checking.
# Produces: simplexdd.gif

using Plots
using Printf
using LinearAlgebra
gr()

const Q = Rational{Int}

um(s) = replace(s, "-" => "−")
qstr(q::Q) = um(denominator(q) == 1 ? string(numerator(q)) :
                "$(numerator(q))/$(denominator(q))")
pt(p) = "(" * join(qstr.(p), ", ") * ")"

# --- Parameters (Mathews' Example 5) ---
gif_name = "simplexdd.gif"
A = Q[6 15 20; 6 30 10; 12 15 10]
b = Q[180, 180, 180]
c = Q[8, 12, 10]
fstr = "f = 8x + 12y + 10z"
names = ["x", "y", "z", "s₁", "s₂", "s₃"]
n_move = 2                          # in-between points per edge
n_hold = 12                         # frames at the optimum while the view turns
az_mid, az_amp, elev = 35.0, 10.0, 22.0   # camera: azimuth sway 35 -/+ 10 deg, elevation

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

# --- Simplex method ---
T = [A eye(m) b; -c' zeros(Q, 1, m) zero(Q)]
basis = collect(n+1:n+m)
steps = []
while true
    z = T[end, 1:end-1]
    minimum(z) >= 0 && break
    e = argmin(z)
    @assert count(==(z[e]), z) == 1 "tie for the entering variable"
    ratios = [T[i, e] > 0 ? T[i, end] / T[i, e] : nothing for i in 1:m]
    rmin = minimum(r for r in ratios if r !== nothing)
    @assert count(==(rmin), ratios) == 1 "tie in the ratio test"
    r = findfirst(==(rmin), ratios)
    push!(steps, (T = T, basis = copy(basis), e = e, r = r, leave = basis[r], rmin = rmin))
    global T = pivot(T, r, e)
    basis[r] = e
end
final = (T = T, basis = copy(basis))
verts = [point(s.T, s.basis) for s in steps]
push!(verts, point(final.T, final.basis))
@assert minimum(final.T[end, 1:end-1]) >= 0
println("path: ", join([pt(v) * " f=" * qstr(c' * v) for v in verts], " -> "))

# --- The polyhedron: exact vertices, faces, edges ---
planes = vcat([(A[i, :], b[i]) for i in 1:m],
              [(Q[-1, 0, 0], zero(Q)), (Q[0, -1, 0], zero(Q)), (Q[0, 0, -1], zero(Q))])
feasible(p) = all(a' * p <= r for (a, r) in planes)
V = Vector{Vector{Q}}()
for i in 1:6, j in i+1:6, k in j+1:6
    M = vcat(planes[i][1]', planes[j][1]', planes[k][1]')
    det(Float64.(M)) == 0 && continue
    p = M \ Q[planes[i][2], planes[j][2], planes[k][2]]
    feasible(p) && !(p in V) && push!(V, p)
end
println("polyhedron: $(length(V)) vertices: ", join(pt.(V), " "))
for v in verts
    @assert v in V "simplex vertex $(pt(v)) is not a vertex of the polyhedron"
end
faces = []
for (a, r) in planes
    idx = [i for (i, v) in enumerate(V) if a' * v == r]
    length(idx) < 3 && continue
    P = [Float64.(V[i]) for i in idx]
    ctr = sum(P) / length(P)
    nrm = normalize(Float64.(a))
    u = normalize(P[1] - ctr)
    w = cross(nrm, u)
    ord = sortperm([atan(dot(p - ctr, w), dot(p - ctr, u)) for p in P])
    push!(faces, idx[ord])
end
println("faces: $(length(faces))")
edges = Set{Tuple{Int,Int}}()
for f in faces, i in eachindex(f)
    a, b2 = f[i], f[mod1(i + 1, length(f))]
    push!(edges, (min(a, b2), max(a, b2)))
end
println("edges: $(length(edges)) (Euler V - E + F = $(length(V) - length(edges) + length(faces)))")
tri = (Int[], Int[], Int[])                      # fan triangulation, 0-based
for f in faces, i in 2:length(f)-1
    push!(tri[1], f[1] - 1); push!(tri[2], f[i] - 1); push!(tri[3], f[i+1] - 1)
end
VX = [Float64(v[1]) for v in V]; VY = [Float64(v[2]) for v in V]; VZ = [Float64(v[3]) for v in V]

# --- Frames ---
basis_str(bs) = "{" * join(names[bs], ", ") * "}"
nonbasic(bs) = [j for j in 1:n+m if !(j in bs)]
fr = []
path = [verts[1]]
for (k, s) in enumerate(steps)
    v0, v1 = verts[k], verts[k+1]
    @assert s.T[end, end] == c' * v0
    push!(fr, (p = v0, path = copy(path),
               l = "tableau $(k-1): vertex " * pt(v0) * ", z = " * qstr(s.T[end, end]) *
                   ", basis " * basis_str(s.basis)))
    push!(fr, (p = v0, path = copy(path),
               l = "pivot $k: " * names[s.e] * " enters (" * qstr(s.T[end, s.e]) * "), " *
                   names[s.leave] * " leaves (min ratio " * qstr(s.rmin) * ")"))
    stay = [names[j] for j in nonbasic(s.basis) if j != s.e]
    for j in 1:n_move
        p = v0 + (v1 - v0) * Q(j, n_move + 1)
        push!(fr, (p = p, path = vcat(path, [p]),
                   l = "pivot $k: along the edge " * join(stay, " = ") * " = 0: " * pt(p) *
                       ", f = " * qstr(c' * p)))
    end
    push!(path, v1)
end
vf = verts[end]
@assert final.T[end, end] == c' * vf
for _ in 1:n_hold
    push!(fr, (p = vf, path = copy(path),
               l = "tableau $(length(steps)): optimum " * pt(vf) * ", z = " *
                   qstr(final.T[end, end]) * ", basis " * basis_str(final.basis)))
end

f3(v) = Float64.(v)
anim = Animation()
for (i, F) in enumerate(fr)
    az = az_mid - az_amp * cospi(2 * (i - 1) / length(fr))
    println("TITLE: ", F.l)
    p = mesh3d(VX, VY, VZ; connections=tri, color=:palegreen, alpha=0.35, linealpha=0,
               label="", camera=(az, elev), xlims=(0, 16), ylims=(0, 7), zlims=(0, 10),
               xlabel="x", ylabel="y", zlabel="z", size=(900, 700),
               title="Simplex method in three variables (Mathews' Example 5): maximize " *
                     fstr * "\n" * F.l, titlefontsize=11, legend=:topright,
               legendfontsize=8, background_color=:white)
    for (a, b2) in edges
        plot!(p, VX[[a, b2]], VY[[a, b2]], VZ[[a, b2]]; color=:darkgreen, lw=1.2, label="")
    end
    scatter!(p, VX, VY, VZ; color=:black, ms=3, label="vertices of the region")
    if length(F.path) > 1
        P = f3.(F.path)
        plot!(p, first.(P), getindex.(P, 2), last.(P); color=:darkorange, lw=5,
              label="simplex path")
    end
    q = f3(F.p)
    scatter!(p, [q[1]], [q[2]], [q[3]]; color=:red, ms=7, label=pt(F.p))
    frame(anim, p)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=2)
println("Saved: $gif_name ($(length(fr)) frames)")
