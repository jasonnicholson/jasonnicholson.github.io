# mullersaa.jl
# Muller's Method animation: Example 1
# f(x) = x^3 - 3x + 2, double root at p=1
# Starting values: p0=2.2, p1=2.1, p2=2.0
# Produces: mullersaa.gif

using Plots
gr()

# --- Parameters ---
f(x) = x^3 - 3x + 2
p_init = [2.2, 2.1, 2.0]   # [p0, p1, p2]
n_iters = 8

xlims = (-2.5, 2.5)
ylims = (-8.0, 5.0)

title_str = "Muller's Method: f(x) = x³ - 3x + 2"

# --- Muller's method step ---
function muller_step(p0, p1, p2, f)
    f0, f1, f2 = f(p0), f(p1), f(p2)
    h0 = p1 - p0
    h1 = p2 - p1
    δ0 = (f1 - f0) / h0
    δ1 = (f2 - f1) / h1
    d = (δ1 - δ0) / (h1 + h0)
    b = δ1 + h1 * d
    D = sqrt(complex(b^2 - 4 * f2 * d))
    E = abs(b + D) >= abs(b - D) ? b + D : b - D
    return real(p2 - 2 * f2 / E)
end

# --- Lagrange parabola through 3 points ---
function lagrange_parabola(x, p0, p1, p2, f)
    f0, f1, f2 = f(p0), f(p1), f(p2)
    L0 = (x - p1) * (x - p2) / ((p0 - p1) * (p0 - p2))
    L1 = (x - p0) * (x - p2) / ((p1 - p0) * (p1 - p2))
    L2 = (x - p0) * (x - p1) / ((p2 - p0) * (p2 - p1))
    return f0 * L0 + f1 * L1 + f2 * L2
end

# --- Pre-compute all iterates ---
history = Vector{NTuple{3,Float64}}(undef, n_iters + 1)
history[1] = (p_init[1], p_init[2], p_init[3])
for i in 1:n_iters
    (q0, q1, q2) = history[i]
    q3 = muller_step(q0, q1, q2, f)
    history[i+1] = (q1, q2, q3)
end
using Printf
function muller_dbg(p0,p1,p2,f)
    f0, f1, f2 = f(p0), f(p1), f(p2)
    h0 = p1 - p0; h1 = p2 - p1
    δ0 = (f1 - f0) / h0; δ1 = (f2 - f1) / h1
    d = (δ1 - δ0) / (h1 + h0); b = δ1 + h1 * d
    disc = b^2 - 4 * f2 * d
    D = sqrt(complex(disc))
    E = abs(b + D) >= abs(b - D) ? b + D : b - D
    return p2 - 2 * f2 / E, disc
end
for i in 1:n_iters
    (q0,q1,q2) = history[i]
    z, disc = muller_dbg(q0,q1,q2,f)
    @printf("k=%d triple=(%.15g, %.15g, %.15g) disc=%.4e  complex_next=%.15g%+.3ei  stored=%.15g\n", i, q0,q1,q2, disc, real(z), imag(z), history[i+1][3])
end
println("final frame triple: ", history[end])
for k in 1:n_iters+1
  q2=history[k][3]; println("frame $k label p2 = ", round(q2; digits=5), "  f(p2)=", f(q2))
end
