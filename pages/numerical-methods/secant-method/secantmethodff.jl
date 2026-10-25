# secantmethodff.jl
# Secant Method animation: Convergence
# f(x) = arctan(x), p0=1.60, p1=1.50, n=6
# Root at x=0; method converges directly
# Produces: secantmethodff.gif

using Plots
gr()

# --- Parameters ---
f(x) = atan(x)
p0   = 1.60
p1   = 1.50
n_iters = 6

xlims = (-3.0, 2.0)
ylims = (-1.25, 1.15)

title_str = "Secant Method: f(x) = arctan(x)"

# --- Pre-compute iterates ---
ps = Vector{Float64}(undef, n_iters + 2)
ps[1] = p0
ps[2] = p1
for i in 2:n_iters+1
    denom = f(ps[i]) - f(ps[i-1])
    if abs(denom) < 1e-14
        ps[i+1] = ps[i]
    else
        ps[i+1] = ps[i] - f(ps[i]) * (ps[i] - ps[i-1]) / denom
    end
end

# --- Backdrop ---
xplot = range(xlims[1], xlims[2], length=400)

# Clip an infinite line (passing through (px, py) with given slope) to the plot box.
function clip_line(px, py, slope, xl, xr, yb, yt)
    xlo, xhi = xl, xr
    if abs(slope) > 1e-14
        xa = px + (yb - py) / slope
        xb = px + (yt - py) / slope
        xlo = max(xlo, min(xa, xb))
        xhi = min(xhi, max(xa, xb))
    else
        (yb <= py <= yt) || return nothing
    end
    xlo > xhi && return nothing
    return (xlo, py + slope*(xlo - px), xhi, py + slope*(xhi - px))
end

# --- Animation ---
anim = @animate for frame in 1:n_iters
    plot(size=(600,600), xlims=xlims, ylims=ylims,
         xlabel="x", ylabel="y", title=title_str,
         legend=:topleft, grid=true, framestyle=:box,
         background_color=:white)

    hline!([0.0]; color=:black, lw=1, label="")
    plot!(xplot, f.(xplot); color=:magenta, lw=2, label="y = f(x)")

    if frame > 1
        hist_x = clamp.(ps[1:frame], xlims[1], xlims[2])
        hist_y = clamp.(f.(ps[1:frame]), ylims[1], ylims[2])
        scatter!(hist_x, hist_y; color=:gray, ms=4, label="", markerstrokewidth=0)
    end

    pa = ps[frame]
    pb = ps[frame+1]
    fa = f(pa)
    fb = f(pb)

    if abs(fb - fa) > 1e-14
        slope = (fb - fa) / (pb - pa)
        seg = clip_line(pa, fa, slope, xlims[1], xlims[2], ylims[1], ylims[2])
        if seg !== nothing
            plot!([seg[1], seg[3]], [seg[2], seg[4]]; color=:steelblue, lw=1.5, label="secant line")
        end

        pc = ps[frame+2]
        if xlims[1] <= pc <= xlims[2]
            plot!([pc, pc], [0.0, f(pc)];
                  color=:steelblue, lw=1, ls=:dash, label="")
            scatter!([pc], [0.0]; color=:red, ms=8, marker=:diamond,
                     label="p$(frame+1) = $(round(pc; digits=5))")
        end
    end

    scatter!([clamp(pa, xlims[1], xlims[2])], [clamp(fa, ylims[1], ylims[2])];
             color=:blue, ms=6, label="p$(frame-1)")
    scatter!([clamp(pb, xlims[1], xlims[2])], [clamp(fb, ylims[1], ylims[2])];
             color=:darkblue, ms=6, label="p$frame")
end

gif(anim, joinpath(@__DIR__, "secantmethodff.gif"); fps=2)
println("Saved: secantmethodff.gif")
