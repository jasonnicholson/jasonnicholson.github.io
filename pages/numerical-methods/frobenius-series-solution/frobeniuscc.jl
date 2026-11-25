# frobeniuscc.jl
# Frobenius Series Solution animation: Mathews' Example 10, the fundamental
# vibrations u_n(t, r) = J0(lambda_n r) cos(lambda_n t) of a drum of radius 1
# for n = 1, 2, 3, where lambda_n is the n-th zero of J0.
# Top row: the surface z = u_n over the unit disk (Mathews draws it with
# ParametricPlot3D over 0 <= r <= 1, 0 <= theta <= 2 pi; GR draws surfaces on
# rectangular grids, so here it is a 201 x 201 grid on [-1, 1]^2 with the points
# outside the disk left out, which makes the drawn rim slightly ragged), with
# the nodal circles r = lambda_k / lambda_n (k < n) drawn in black and the rim
# r = 1 in gray. GR draws these lines over the surface, so their far halves
# stay visible even where the surface would hide them. Colour shows the
# displacement (pink up, cyan down, Mathews' colours for his cross-sections and
# disk diagrams). Mathews' box is [-1, 1] x [-1, 1] x [-0.45, 1], which holds
# the initial shapes only; over a period u_n reaches -1 at the centre, so the
# box here is [-1, 1] x [-1, 1] x [-1.05, 1.05].
# Bottom row: the cross-section through the centre, u_n on -1 <= x <= 1, with
# the envelope +-J0(lambda_n x) dashed and the nodes marked.
# Every column runs through one period 2 pi / lambda_n of its own mode, in 24
# equal phase steps lambda_n t = 0, pi/12, ..., 23 pi/12, so the three columns
# share the phase lambda_n t, not the time t.
# Produces: frobeniuscc.gif

using Plots
using Printf
using SpecialFunctions
gr()

# Significant-figure labels: never round a nonzero value to 0.0, never print -0.0
um(s) = replace(s, "-" => "−")
fmtv(x) = um(@sprintf("%#.4g", Float64(x)))                    # computed: 4 s.f.
sub(n) = join(Char(0x2080 + d) for d in reverse(digits(n)))   # 3 -> "₃"

setprecision(BigFloat, 256)

# --- Parameters (Mathews' Example 10) ---
gif_name = "frobeniuscc.gif"
modes    = 1:3
nphase   = 24                       # frames per period
zl       = (-1.05, 1.05)            # u reaches +-1 at the centre; kept off the edges
cl       = (-1.0, 1.0)              # colour range
pink, cyan = RGB(1.0, 0.41, 0.71), RGB(0.0, 0.75, 0.80)
cmap     = cgrad([cyan, RGB(0.93, 0.93, 0.93), pink])
title_str = "Vibrating drum (Mathews' Example 10):  normal modes uₙ(t, r) = J₀(λₙr) cos(λₙt),  " *
            "n = 1, 2, 3,  each over one period 2π/λₙ"

# --- Zeros of J0: Newton's method from k*pi (J0' = -J1), 256-bit ---
function j0zero(k)
    x = BigFloat(k) * BigFloat(π)
    for _ in 1:60
        dx = besselj0(x) / besselj1(x)
        x += dx
        abs(dx) < big"1e-70" && break
    end
    return x
end
lamb = [j0zero(k) for k in 1:last(modes)]
@assert issorted(lamb) && all(abs(besselj0(l)) < big"1e-60" for l in lamb)
@assert all((k - 1) * π < lamb[k] < k * π for k in eachindex(lamb))
lam    = Float64.(lamb)
period = [2 * Float64(BigFloat(π) / l) for l in lamb]
radii  = [[Float64(lamb[k] / lamb[n]) for k in 1:n-1] for n in modes]
for n in modes
    @printf("n = %d: lambda = %.6f  period = %.6f  nodal radii = %s\n", n, lam[n],
            period[n], join([@sprintf("%.6f", r) for r in radii[n]], ", "))
end

# --- Grid on [-1, 1]^2; points outside the drum (r > 1) are left out (NaN) ---
xg = range(-1, 1, length=201)
shape = [[hypot(x, y) <= 1 ? besselj0(lam[n] * hypot(x, y)) : NaN for y in xg, x in xg]
         for n in modes]                                   # J0(lambda_n r)
xc = range(-1, 1, length=801)
circ = range(0, 2π, length=181)

fracstr(j) = (r = j // nphase; "$(numerator(r))/$(denominator(r))")

function draw_frame(j)
    phi = 2π * j / nphase                         # phase lambda_n t
    c = cospi(2j / nphase)                        # cos(phi), exact at multiples of pi/2
    tops = []
    bots = []
    for n in modes
        Z = c .* shape[n]
        p3 = surface(xg, xg, Z; color=cmap, clims=cl, colorbar=false,
                     xlims=(-1, 1), ylims=(-1, 1), zlims=zl, camera=(30, 20),
                     xlabel="x", ylabel="y", zlabel="u", titlefontsize=10, legend=false)
        plot3d!(p3, cos.(circ), sin.(circ), zeros(length(circ)); color=:gray30, lw=1.5)
        for r in radii[n]
            plot3d!(p3, r .* cos.(circ), r .* sin.(circ), zeros(length(circ));
                    color=:black, lw=2.5)
        end
        title!(p3, "n = $n:  λ$(sub(n)) = $(fmtv(lam[n])),  period $(fmtv(period[n]))")
        push!(tops, p3)

        u = c .* besselj0.(lam[n] .* abs.(xc))
        env = besselj0.(lam[n] .* abs.(xc))
        p2 = plot(xlims=(-1, 1), ylims=zl, framestyle=:box, xlabel="x", ylabel="u",
                  legend=:bottomright, legendfontsize=7, titlefontsize=10, grid=true,
                  xticks=-1:0.5:1)
        hline!(p2, [0.0]; color=:black, lw=0.5, label="")
        plot!(p2, xc, env; color=:gray50, ls=:dash, lw=1, label="±J₀(λ$(sub(n))x)")
        plot!(p2, xc, -env; color=:gray50, ls=:dash, lw=1, label="")
        plot!(p2, xc, max.(u, 0); fillrange=0, fillalpha=0.3, fillcolor=pink, linealpha=0, label="")
        plot!(p2, xc, min.(u, 0); fillrange=0, fillalpha=0.3, fillcolor=cyan, linealpha=0, label="")
        plot!(p2, xc, [v >= 0 ? v : NaN for v in u]; color=pink, lw=2.5, label="")
        plot!(p2, xc, [v <= 0 ? v : NaN for v in u]; color=cyan, lw=2.5, label="")
        nodes = vcat(-1.0, -reverse(radii[n]), radii[n], 1.0)
        scatter!(p2, nodes, zeros(length(nodes)); color=:black, ms=4, label="nodes (at rest)")
        title!(p2, j == 0 ? "t = 0" : "t = $(fmtv(phi / lam[n]))   ($(fracstr(j)) of a period)")
        push!(bots, p2)
    end
    plot(tops..., bots...; layout=grid(2, 3, heights=[0.6, 0.4]), size=(1200, 760),
         plot_title=title_str, plot_titlefontsize=12, left_margin=3Plots.mm,
         bottom_margin=3Plots.mm, background_color=:white)
end

anim = Animation()
for j in 0:nphase-1
    draw_frame(j)
    frame(anim)
end
gif(anim, joinpath(@__DIR__, gif_name); fps=8)
println("Saved: ", gif_name)
