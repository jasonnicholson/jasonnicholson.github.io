# rationalapproxaa.jl
# Rational Approximation animation: diagonal Padé [n/n] vs Taylor T_{2n} for eˣ on [-6, 6]
# n increases from 1 to 4; shows how Padé stays accurate further from x=0
# Produces: rationalapproxaa.gif

using Plots
gr()

# Diagonal Padé [n/n] coefficients for eˣ
# P_n(x) and Q_n(x) with Q_n(0)=1, Q_n(-x)=P_n(-x)/eˣ (symmetry)
# Pre-computed exact coefficients:
pade_coeffs = Dict(
    1 => (p=[1.0, 0.5],            q=[1.0, -0.5]),
    2 => (p=[1.0, 0.5, 1/12],      q=[1.0, -0.5, 1/12]),
    3 => (p=[1.0, 0.5, 1/10, 1/120],   q=[1.0, -0.5, 1/10, -1/120]),
    4 => (p=[1.0, 0.5, 3/28, 1/84, 1/1680],
           q=[1.0, -0.5, 3/28, -1/84, 1/1680]),
)

# Taylor coefficients of eˣ up to degree 2n
function taylor_ex(x, deg)
    s = 0.0
    xk = 1.0
    fk = 1.0
    for k in 0:deg
        s  += xk / fk
        xk *= x
        fk *= (k + 1)
    end
    return s
end

function polyval(c, x)
    # c[1] + c[2]*x + c[3]*x^2 + ...
    n   = length(c)
    val = c[n]
    for i in (n - 1):-1:1
        val = val * x + c[i]
    end
    return val
end

f(x) = exp(x)

x_plot = collect(range(-6.0, 6.0, length=600))
fx     = f.(x_plot)

n_orders = [1, 2, 3, 4]

anim = @animate for n in n_orders
    pc = pade_coeffs[n]
    # Evaluate Padé
    Pade_vals = [polyval(pc.p, x) / polyval(pc.q, x) for x in x_plot]
    # Evaluate Taylor T_{2n}
    Taylor_vals = [taylor_ex(x, 2n) for x in x_plot]

    # Clip for display
    Pade_vals   = clamp.(Pade_vals,   -5.0, 30.0)
    Taylor_vals = clamp.(Taylor_vals, -5.0, 30.0)

    plot(size=(750, 500),
         xlims=(-6.0, 6.0), ylims=(-5.0, 25.0),
         xlabel="x", ylabel="y",
         title="Rational (Padé [$(n)/$(n)]) vs Polynomial (Taylor T_{$(2n)}) for eˣ",
         legend=:topleft, grid=true, framestyle=:box,
         background_color=:white)

    plot!(x_plot, fx;           color=:blue,     lw=2,   label="eˣ (true)")
    plot!(x_plot, Taylor_vals;  color=:tomato,   lw=2, linestyle=:dash,
          label="Taylor T_{$(2n)}(x)")
    plot!(x_plot, Pade_vals;    color=:darkgreen, lw=2, linestyle=:solid,
          label="Padé [$(n)/$(n)](x)")
end

gif(anim, joinpath(@__DIR__, "rationalapproxaa.gif"); fps=1)
println("Saved: rationalapproxaa.gif")
