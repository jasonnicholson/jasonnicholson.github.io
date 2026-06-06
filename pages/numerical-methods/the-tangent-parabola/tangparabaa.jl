# tangparabaa.jl
# Tangent Parabola animation: secant parabola of f(x) = cos(x) centered at x₀ = π/4
# As h → 0, the secant parabola (Newton polynomial through x₀-h, x₀, x₀+h) converges
# to the tangent parabola (degree-2 Taylor polynomial at x₀)
# Produces: tangparabaa.gif

using Plots
gr()

f(x)   = cos(x)
df(x)  = -sin(x)
d2f(x) = -cos(x)

x0  = π / 4
x_plot = collect(range(x0 - 1.5, x0 + 1.5, length=500))

# Second-order Taylor polynomial (tangent parabola) at x0
T2(x) = f(x0) + df(x0) * (x - x0) + 0.5 * d2f(x0) * (x - x0)^2

# Newton polynomial through three points x0-h, x0, x0+h
function newton_parabola(x, h)
    x1, x2, x3 = x0 - h, x0, x0 + h
    y1, y2, y3 = f(x1), f(x2), f(x3)
    # Divided differences
    d01 = (y2 - y1) / (x2 - x1)
    d12 = (y3 - y2) / (x3 - x2)
    d012 = (d12 - d01) / (x3 - x1)
    # Newton polynomial: P(x) = y1 + d01*(x-x1) + d012*(x-x1)*(x-x2)
    return y1 + d01 * (x - x1) + d012 * (x - x1) * (x - x2)
end

# h values: from 1.0 down to near 0 (log-spaced), then hold the tangent parabola
h_vals_log = exp.(range(log(1.0), log(0.01), length=18))
h_vals     = vcat(h_vals_log, fill(0.0, 5))   # last 5 frames show true tangent parabola

T2_vals    = T2.(x_plot)

anim = @animate for h in h_vals
    h_lbl = round(h, digits=3)
    if h > 1e-6
        P_vals = [newton_parabola(xq, h) for xq in x_plot]
        ttl    = "Secant Parabola → Tangent Parabola  (h = $h_lbl)"
        p_lbl  = "Secant parabola  (h = $h_lbl)"
        p_clr  = :tomato
    else
        P_vals = T2_vals
        ttl    = "Tangent Parabola (T₂ — Taylor degree 2 at x₀)"
        p_lbl  = "Tangent parabola T₂(x)"
        p_clr  = :darkgreen
    end

    plot(size=(700, 500),
         xlims=(x0 - 1.5, x0 + 1.5), ylims=(-0.5, 1.3),
         xlabel="x", ylabel="y",
         title=ttl,
         legend=:topright, grid=true, framestyle=:box,
         background_color=:white)

    plot!(x_plot, f.(x_plot);  color=:blue, lw=2, label="f(x) = cos(x)")
    plot!(x_plot, P_vals;      color=p_clr, lw=2, linestyle=:dash, label=p_lbl)
    plot!(x_plot, T2_vals;     color=:darkgreen, lw=1.5, linestyle=:dot,
          label="Tangent parabola T₂(x)")

    if h > 1e-6
        x1, x2, x3 = x0 - h, x0, x0 + h
        scatter!([x1, x2, x3], [f(x1), f(x2), f(x3)];
                 color=:tomato, ms=6, label="3 nodes")
    end
    vline!([x0]; color=:gray, lw=1, linestyle=:dash, label="x₀")
end

gif(anim, joinpath(@__DIR__, "tangparabaa.gif"); fps=4)
println("Saved: tangparabaa.gif")
