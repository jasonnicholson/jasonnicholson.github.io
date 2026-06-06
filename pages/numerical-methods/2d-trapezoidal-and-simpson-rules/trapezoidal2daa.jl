# trapezoidal2daa.jl
# 2D Trapezoidal rule animation for f(x,y) = 8exp(-x^2 - y^4) on [0,1]x[0,1]
# Produces: trapezoidal2daa.gif

using Plots

gr()

f(x, y) = 8 * exp(-(x^2) - (y^4))
true_val = 5.04756680717

xlims = (0.0, 1.0)
ylims = (0.0, 1.0)
zlims = (0.0, 8.2)

# Include archived checkpoints at 10x10 and 20x20.
n_seq = [2, 4, 6, 8, 10, 12, 16, 20]

function trapezoid2d(n)
    x = range(xlims[1], xlims[2], length=n + 1)
    y = range(ylims[1], ylims[2], length=n + 1)
    hx = (xlims[2] - xlims[1]) / n
    hy = (ylims[2] - ylims[1]) / n

    wx = ones(Float64, n + 1)
    wy = ones(Float64, n + 1)
    wx[1] = 0.5
    wx[end] = 0.5
    wy[1] = 0.5
    wy[end] = 0.5

    s = 0.0
    for i in eachindex(x)
        for j in eachindex(y)
            s += wx[i] * wy[j] * f(x[i], y[j])
        end
    end

    return x, y, hx * hy * s
end

xf = range(xlims[1], xlims[2], length=90)
yf = range(ylims[1], ylims[2], length=90)
Zf = [f(x, y) for y in yf, x in xf]

anim = @animate for n in n_seq
    xg, yg, approx = trapezoid2d(n)
    Zg = [f(x, y) for y in yg, x in xg]
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
        title="2D Trapezoidal Rule on [0,1] x [0,1]\nmesh = $(n)x$(n),  I_T = $(round(approx; digits=9)),  |error| = $(round(err; digits=9))"
    )

    surface!(plt, xg, yg, Zg;
        st=:wireframe,
        linecolor=:black,
        linewidth=1.05,
        fillalpha=0.0,
        label=""
    )
end

gif(anim, joinpath(@__DIR__, "trapezoidal2daa.gif"); fps=2)
println("Saved: trapezoidal2daa.gif")
