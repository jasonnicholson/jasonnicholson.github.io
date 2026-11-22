# Render the n=2 trapezoid frame with and without the wireframe overlay; count coloured (non-grey) pixels.
using Plots; gr()
f(x, y) = 8 * exp(-(x^2) - (y^4))
xf = range(0, 1, length=90); yf = xf
Zf = [f(x, y) for y in yf, x in xf]
for (tag, wire) in [("surface_only", false), ("with_wireframe", true)], n in (2, 20)
    plt = surface(xf, yf, Zf; size=(720,520), zlims=(0,8.2), c=:matter, alpha=0.82, colorbar=false, camera=(44,30))
    if wire
        xg = range(0,1,length=n+1); Zg = [f(x,y) for y in xg, x in xg]
        surface!(plt, xg, xg, Zg; st=:wireframe, linecolor=:black, linewidth=1.05, fillalpha=0.0, label="")
    end
    savefig(plt, "occl_$(tag)_n$(n).png")
end
