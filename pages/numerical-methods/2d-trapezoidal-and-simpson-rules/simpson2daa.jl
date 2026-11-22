# simpson2daa.jl
# 2D Simpson rule animation for f(x,y) = 8exp(-x^2 - y^4) on [0,1]x[0,1]
# Produces: simpson2daa.gif

using Plots

gr()

f(x, y) = 8 * exp(-(x^2) - (y^4))
true_val = 5.04756680717

xlims = (0.0, 1.0)
ylims = (0.0, 1.0)
zlims = (0.0, 8.4)  # the n=2 quadratic along x=0 peaks at about 8.30

# Even panel counts for Simpson in each direction, including legacy checkpoints.
n_seq = [2, 4, 6, 8, 10, 12, 16, 20]

function simpson2d(n)
    x = range(xlims[1], xlims[2], length=n + 1)
    y = range(ylims[1], ylims[2], length=n + 1)
    hx = (xlims[2] - xlims[1]) / n
    hy = (ylims[2] - ylims[1]) / n

    ax = ones(Float64, n + 1)
    ay = ones(Float64, n + 1)
    for i in 2:n
        # Array index i corresponds to node number (i-1) on [0,n].
        ax[i] = isodd(i - 1) ? 4.0 : 2.0
        ay[i] = isodd(i - 1) ? 4.0 : 2.0
    end

    s = 0.0
    for i in eachindex(x)
        for j in eachindex(y)
            s += ax[i] * ay[j] * f(x[i], y[j])
        end
    end

    return x, y, (hx * hy / 9.0) * s
end

# Piecewise-quadratic interpolant through nodes (t, v) on each pair of panels
# [t[k], t[k+2]], k = 1, 3, 5, ..., sampled at m points per panel.
function quadpieces(t, v; m=8)
    T = Float64[]; V = Float64[]
    for k in 1:2:(length(t) - 2)
        t0, t1, t2 = t[k], t[k+1], t[k+2]
        for s in range(t0, t2, length=2m + 1)[(k == 1 ? 1 : 2):end]
            push!(T, s)
            push!(V, v[k] * (s - t1) * (s - t2) / ((t0 - t1) * (t0 - t2)) +
                     v[k+1] * (s - t0) * (s - t2) / ((t1 - t0) * (t1 - t2)) +
                     v[k+2] * (s - t0) * (s - t1) / ((t2 - t0) * (t2 - t1)))
        end
    end
    return T, V
end

# Grid curves of the piecewise-biquadratic interpolant (whose integral is I_S):
# along every x = x_i and y = y_j it is the piecewise quadratic through the nodes.
function gridcurves(xg, yg)
    X = Float64[]; Y = Float64[]; Z = Float64[]
    for xi in xg
        T, V = quadpieces(yg, f.(xi, yg))
        append!(X, fill(xi, length(T)), [NaN]); append!(Y, T, [NaN]); append!(Z, V, [NaN])
    end
    for yj in yg
        T, V = quadpieces(xg, f.(xg, yj))
        append!(X, T, [NaN]); append!(Y, fill(yj, length(T)), [NaN]); append!(Z, V, [NaN])
    end
    return X, Y, Z
end

xf = range(xlims[1], xlims[2], length=90)
yf = range(ylims[1], ylims[2], length=90)
Zf = [f(x, y) for y in yf, x in xf]

anim = @animate for n in n_seq
    xg, yg, approx = simpson2d(n)
    err = abs(approx - true_val)

    plt = surface(xf, yf, Zf;
        size=(720, 520),
        xlims=xlims,
        ylims=ylims,
        zlims=zlims,
        c=:matter,
        alpha=0.82,
        colorbar=false,
        xlabel="x",
        ylabel="y",
        zlabel="z",
        camera=(44, 30),
        title="2D Simpson Rule on [0,1] x [0,1]\nmesh = $(n)x$(n),  I_S = $(round(approx; digits=9)),  |error| = $(round(err; digits=9))"
    )

    # Lines only (a :wireframe series is filled opaque by GR and hides the surface).
    X, Y, Z = gridcurves(xg, yg)
    plot!(plt, X, Y, Z;
        seriestype=:path3d,
        linecolor=:black,
        linewidth=1.05,
        label=""
    )
end

gif(anim, joinpath(@__DIR__, "simpson2daa.gif"); fps=2)
println("Saved: simpson2daa.gif")
