# tangparabaa.jl
# Tangent Parabola animation: secant parabola of f(x) = sin(x) centered at x₀ = 1
# (Mathews' running example, Figures 1–3 and Table 1 of the Tangent Parabola module)
# As h → 0, the secant parabola (Newton polynomial through x₀-h, x₀, x₀+h) converges
# to the tangent parabola (degree-2 Taylor polynomial at x₀)
# Produces: tangparabaa.gif

using Plots
gr()

f(x)   = sin(x)
df(x)  = cos(x)
d2f(x) = -sin(x)

x0  = 1.0
x_plot = collect(range(0, π, length=500))   # Mathews' plot window [0, π]

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

# h values: from 1.0 down to 0.01 (log-spaced, 17 values = 10^(-k/8), k = 0..16, so that
# Mathews' Figure 1 and Figure 2 step sizes h = 0.1 and h = 0.01 are frames), then hold the tangent parabola
h_vals_log = exp.(range(log(1.0), log(0.01), length=17))
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
        ttl    = "Tangent Parabola (T₂ — Taylor degree 2 at x₀)"
    end

    plot(size=(700, 500),
         xlims=(0, π), ylims=(-0.2, 1.15),
         xlabel="x", ylabel="y",
         title=ttl,
         legend=:bottom, grid=true, framestyle=:box,
         background_color=:white)

    plot!(x_plot, f.(x_plot);  color=:blue, lw=2, label="f(x) = sin(x)")
    # The hold frames (h = 0) have no secant parabola, so T₂ is drawn once, by the dotted line below
    h > 1e-6 && plot!(x_plot, P_vals; color=p_clr, lw=2, linestyle=:dash, label=p_lbl)
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
