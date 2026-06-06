# secantmethodee.jl
# Secant Method animation: NON Convergence — Diverging to Infinity
# f(x) = x * exp(-x), p0=1.5, p1=2.0, n=16
# Root at x=0; method diverges with these starting points
# Produces: secantmethodee.gif

using Plots
gr()

# --- Parameters ---
f(x) = x * exp(-x)
p0   = 1.5
p1   = 2.0
n_iters = 16

xlims = (0.0, 10.1)
ylims = (0.0, 0.4)

title_str = "Secant Method: f(x) = x e⁻ˣ  (diverges)"

# --- Pre-compute iterates ---
ps = Vector{Float64}(undef, n_iters + 2)
ps[1] = p0
ps[2] = p1
n_valid = 1  # index of last valid (non-diverged) iterate
for i in 2:n_iters+1
    denom = f(ps[i]) - f(ps[i-1])
    if abs(denom) < 1e-14
        # Denominator ~0: method breaks down
        for j in (i+1):(n_iters+2)
            ps[j] = ps[i]
        end
        n_valid = i
        break
    end
    ps[i+1] = ps[i] - f(ps[i]) * (ps[i] - ps[i-1]) / denom
    n_valid = i + 1
    if abs(ps[i+1]) > 1e6 || isnan(ps[i+1]) || isinf(ps[i+1])
        # Diverged; fill remaining with large value
        for j in (i+2):(n_iters+2)
            ps[j] = ps[i+1]
        end
        break
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

    pa = ps[frame]
    pb = ps[frame+1]

    pa_vis = isfinite(pa) && xlims[1] <= pa <= xlims[2]
    pb_vis = isfinite(pb) && xlims[1] <= pb <= xlims[2]

    if frame > 1
        hist_valid = [p for p in ps[1:frame] if isfinite(p) && xlims[1] <= p <= xlims[2]]
        if !isempty(hist_valid)
            scatter!(hist_valid, f.(hist_valid);
                     color=:gray, ms=4, label="", markerstrokewidth=0)
        end
    end

    if pa_vis && pb_vis
        fa = f(pa)
        fb = f(pb)
        denom = fb - fa
        if abs(denom) > 1e-14
            slope = denom / (pb - pa)
            seg = clip_line(pa, fa, slope, xlims[1], xlims[2], ylims[1], ylims[2])
            if seg !== nothing
                plot!([seg[1], seg[3]], [seg[2], seg[4]];
                      color=:steelblue, lw=1.5, label="secant line")
            end

            pc = ps[frame+2]
            if isfinite(pc) && xlims[1] <= pc <= xlims[2]
                plot!([pc, pc], [0.0, clamp(f(pc), ylims[1], ylims[2])];
                      color=:steelblue, lw=1, ls=:dash, label="")
                scatter!([pc], [0.0]; color=:red, ms=8, marker=:diamond,
                         label="p$(frame+1) = $(round(pc; digits=3))")
            elseif isfinite(pc)
                annotate!(xlims[2]*0.5, ylims[2]*0.85,
                          text("p$(frame+1) → $(round(pc; digits=1)) (off chart)", :red, 9))
                scatter!([xlims[2]], [0.0]; color=:red, ms=8, marker=:diamond,
                         label="p$(frame+1) → ∞")
            end
        end
        scatter!([pa], [fa]; color=:blue, ms=6, label="p$(frame-1)")
        scatter!([pb], [fb]; color=:darkblue, ms=6, label="p$frame")
    elseif pa_vis
        fa = f(pa)
        scatter!([pa], [fa]; color=:blue, ms=6, label="p$(frame-1)")
        annotate!(xlims[2]*0.5, ylims[2]*0.85,
                  text("p$frame = $(round(pb; digits=1)) (diverged)", :red, 9))
    else
        annotate!(xlims[2]*0.5, ylims[2]*0.7,
                  text("Method diverged", :red, 12))
    end
end

gif(anim, joinpath(@__DIR__, "secantmethodee.gif"); fps=2)
println("Saved: secantmethodee.gif")
